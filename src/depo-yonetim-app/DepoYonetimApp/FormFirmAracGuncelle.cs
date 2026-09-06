using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SqlClient;

namespace GRUP26_GÖREV8
{
    public partial class FormFirmAracGuncelle : Form
    {
        SqlConnection baglanti = new SqlConnection("Data Source=.;Initial Catalog = Grup26; Integrated Security= True");
        public FormFirmAracGuncelle()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            baglanti.Open();
            SqlCommand komut = new SqlCommand("select * from TabloFirmaArac where FirmaAracID=@a1", baglanti);
            komut.Parameters.AddWithValue("@a1", textBox1.Text);
            SqlDataReader gor = komut.ExecuteReader();
            if(gor.Read())
            {
                textBox2.Text = gor["Plaka"].ToString();
                textBox3.Text = gor["AracModel"].ToString();
                textBox4.Text = gor["AracMarka"].ToString();
            }
            else
            {
                MessageBox.Show("Öyle bir aracın sistemde kaydı yok.");
            }
            baglanti.Close();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            baglanti.Open();
            SqlCommand komut = new SqlCommand("update TabloFirmaArac set Plaka=@a2,AracModel=@a3,AracMarka=@a4 where FirmaAracID=@a1", baglanti);
            komut.Parameters.AddWithValue("@a2", textBox2.Text);
            komut.Parameters.AddWithValue("@a3", textBox3.Text);
            komut.Parameters.AddWithValue("@a4", textBox4.Text);
            komut.Parameters.AddWithValue("@a1", textBox1.Text);
            komut.ExecuteNonQuery();
            baglanti.Close();
            MessageBox.Show("Firma Aracının bilgileri güncellendi.");
            this.Close();
        }
    }
}
