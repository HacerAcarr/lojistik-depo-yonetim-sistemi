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
    public partial class FormSoforleriListele : Form
    {
        SqlConnection baglanti = new SqlConnection("Data Source=.;Initial Catalog = Grup26; Integrated Security= True");
        public FormSoforleriListele()
        {
            InitializeComponent();
        }

        private void FormSoforleriListele_Load(object sender, EventArgs e)
        {
            baglanti.Open();
            SqlDataAdapter sofor = new SqlDataAdapter("select * from TabloSofor", baglanti);
            DataTable tablo = new DataTable();
            sofor.Fill(tablo);
            dataGridView1.DataSource = tablo;
            baglanti.Close();
        }
    }
}
