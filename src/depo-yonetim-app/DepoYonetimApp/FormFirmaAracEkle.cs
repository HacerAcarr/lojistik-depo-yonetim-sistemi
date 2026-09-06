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
    public partial class FormFirmaAracEkle : Form
    {
        SqlConnection baglanti = new SqlConnection("Data Source=.;Initial Catalog = Grup26; Integrated Security= True");
        public FormFirmaAracEkle()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            baglanti.Open();
            SqlCommand komut = new SqlCommand("insert into TabloFirmaArac" +
                " (FirmaAracID,Plaka,AracModel,AracMarka) values (@a1,@a2,@a3,@a4)", baglanti);
            komut.Parameters.AddWithValue("@a1", textBox1.Text);
            komut.Parameters.AddWithValue("@a2", textBox2.Text);
            komut.Parameters.AddWithValue("@a3", textBox3.Text);
            komut.Parameters.AddWithValue("@a4", textBox4.Text);
            komut.ExecuteNonQuery();
            baglanti.Close();
            MessageBox.Show("Yeni firma aracı başarıyla eklendi.");
            this.Close();
        }
    }
}
