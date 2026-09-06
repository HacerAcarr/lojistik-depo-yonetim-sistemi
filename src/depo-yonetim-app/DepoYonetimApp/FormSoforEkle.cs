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
    public partial class FormSoforEkle : Form
    {
        SqlConnection baglanti = new SqlConnection("Data Source=.;Initial Catalog = Grup26; Integrated Security= True");
        public FormSoforEkle()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            baglanti.Open();
            SqlCommand komut = new SqlCommand("insert into TabloSofor " +
                "(EhliyetNo,SoforAdSoyad,LisansSinifi,MusaitlikDurumu,FirmaAracID) values (@s1,@s2,@s3,@s4,@s5)", baglanti);
            komut.Parameters.AddWithValue("@s1", textBox1.Text);
            komut.Parameters.AddWithValue("@s2", textBox2.Text);
            komut.Parameters.AddWithValue("@s3", textBox3.Text);
            komut.Parameters.AddWithValue("@s4", comboBox1.Text);
            komut.Parameters.AddWithValue("@s5", textBox4.Text);
            komut.ExecuteNonQuery();
            baglanti.Close();
            MessageBox.Show("Şoför sisteme başarıyla eklenmiştir.Şoförün durumu :" + comboBox1.Text + " bu şekildedir.");
            this.Close();
        }
    }
}
