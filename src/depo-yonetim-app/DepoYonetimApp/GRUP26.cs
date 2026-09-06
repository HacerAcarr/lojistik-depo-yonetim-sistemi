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
    public partial class GRUP26 : Form
    {
        SqlConnection baglanti = new SqlConnection("Data Source=.;Initial Catalog = Grup26; Integrated Security= True");
        public GRUP26()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }

        private void yeniFirmaAraçEkleToolStripMenuItem_Click(object sender, EventArgs e)
        {
            FormFirmaAracEkle ekle = new FormFirmaAracEkle();
            ekle.Show();
        }

        private void firmaAraçSilToolStripMenuItem_Click(object sender, EventArgs e)
        {
            FormFirmaAracSil sil = new FormFirmaAracSil();
            sil.Show();
        }

        private void firmaAraçBilgileriniGüncelleToolStripMenuItem_Click(object sender, EventArgs e)
        {
            FormFirmAracGuncelle guncel = new FormFirmAracGuncelle();
            guncel.Show();
        }

        private void araçlarıListeleToolStripMenuItem_Click(object sender, EventArgs e)
        {
            FormFirmaAracListele liste = new FormFirmaAracListele();
            liste.Show();
        }

        private void yeToolStripMenuItem_Click(object sender, EventArgs e)
        {
            FormSoforEkle sekle = new FormSoforEkle();
            sekle.Show();
        }

        private void şoförSilToolStripMenuItem_Click(object sender, EventArgs e)
        {
            FormSoforSil ssil = new FormSoforSil();
            ssil.Show();
        }

        private void şoförleriListeleToolStripMenuItem_Click(object sender, EventArgs e)
        {
            FormSoforleriListele sliste = new FormSoforleriListele();
            sliste.Show();
        }

        private void şoförBilgileriGüncelleToolStripMenuItem_Click(object sender, EventArgs e)
        {
            FormSoforGuncelle sguncel = new FormSoforGuncelle();
            sguncel.Show();
        }

        private void label1_Click(object sender, EventArgs e)
        {
          
        }
    }
}

