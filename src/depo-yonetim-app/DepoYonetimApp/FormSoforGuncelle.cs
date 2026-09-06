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
    public partial class FormSoforGuncelle : Form
    {
        SqlConnection baglanti = new SqlConnection("Data Source=.;Initial Catalog = Grup26; Integrated Security= True");
        public FormSoforGuncelle()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            baglanti.Open();
            SqlCommand komut = new SqlCommand("select * from TabloSofor where EhliyetNo=@s1", baglanti);
            komut.Parameters.AddWithValue("@s1", textBox1.Text);
            SqlDataReader guncel = komut.ExecuteReader();
            if (guncel.Read())
            {
                textBox2.Text = guncel["SoforAdSoyad"].ToString();
                textBox3.Text = guncel["LisansSinifi"].ToString();
                comboBox1.Text = guncel["MusaitlikDurumu"].ToString();
                textBox4.Text = guncel["FirmaAracID"].ToString();
            }
            else
            {
                MessageBox.Show("Bu ehliyet nosuna sahip bir şoför yok.");
            }
            baglanti.Close();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            baglanti.Open();
            SqlCommand komut = new SqlCommand("update TabloSofor set SoforAdSoyad=@s2,LisansSinifi=@s3,MusaitlikDurumu=@s4,FirmaAracID=@s5 where EhliyetNo=@s1", baglanti);
            komut.Parameters.AddWithValue("@s2", textBox2.Text);
            komut.Parameters.AddWithValue("@s3", textBox3.Text);
            komut.Parameters.AddWithValue("@s4", comboBox1.Text);
            komut.Parameters.AddWithValue("@s5", textBox4.Text);
            komut.Parameters.AddWithValue("@s1", textBox1.Text);
            komut.ExecuteNonQuery();
            baglanti.Close();
            MessageBox.Show("Şoförün bilgileri başarıyla güncellenmistir.");
            this.Close();
        }
    }
}
