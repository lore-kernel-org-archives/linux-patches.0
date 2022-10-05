Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2759C633
	for <patches@lists.linux.dev>; Thu,  6 Oct 2022 02:55:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A87FFC433B5
	for <patches@lists.linux.dev>; Thu,  6 Oct 2022 02:55:53 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="oau6eGbO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1665024953;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BHxPzZbPZr1j2h7LFCj0OfovuxJhDALGxfZLeORAP2c=;
	b=oau6eGbOBXmJVmmkkpl9fedDSXe0l+Wo3YCdbrNBipYPp7i7elVxS20ZnziZee19VSeZ8e
	XclyiGyUd39WeqgGNyAwD7DhnJqHkV4Mm2AvXVFk7hvjmuOZaPU6hSAH1Xd5LpaYPQnHoX
	5rI8S6BFIoUUHxH9e3jlHSb+sw6+E8E=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 57dd4b99 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
	for <patches@lists.linux.dev>;
	Thu, 6 Oct 2022 02:55:53 +0000 (UTC)
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: linux-kernel@vger.kernel.org
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ajay Singh <ajay.kathat@microchip.com>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Amitkumar Karwar <amitkarwar@gmail.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	=?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
	Andreas Noever <andreas.noever@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Andy Gospodarek <andy@greyhouse.net>,
	Andy Lutomirski <luto@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Anna Schumaker <anna@kernel.org>,
	Arend van Spriel <aspriel@gmail.com>,
	Ayush Sawal <ayush.sawal@chelsio.com>,
	Borislav Petkov <bp@alien8.de>,
	Chao Yu <chao@kernel.org>,
	=?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
	Christoph Hellwig <hch@lst.de>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Chuck Lever <chuck.lever@oracle.com>,
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Ahern <dsahern@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Dick Kennedy <dick.kennedy@broadcom.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Florian Westphal <fw@strlen.de>,
	Franky Lin <franky.lin@broadcom.com>,
	Ganapathi Bhat <ganapathi017@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Gregory Greenman <gregory.greenman@intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Hannes Reinecke <hare@suse.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Hante Meuleman <hante.meuleman@broadcom.com>,
	Hao Luo <haoluo@google.com>,
	Haoyue Xu <xuhaoyue1@hisilicon.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	Hugh Dickins <hughd@google.com>,
	Igor Mitsyanko <imitsyanko@quantenna.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Jaehoon Chung <jh80.chung@samsung.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	"James E . J . Bottomley" <jejb@linux.ibm.com>,
	James Smart <james.smart@broadcom.com>,
	Jan Kara <jack@suse.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Jay Vosburgh <j.vosburgh@gmail.com>,
	Jean-Paul Roubelat <jpr@f6fbb.org>,
	Jeff Layton <jlayton@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Jiri Olsa <jolsa@kernel.org>,
	Jiri Pirko <jiri@resnulli.us>,
	Johannes Berg <johannes@sipsolutions.net>,
	John Fastabend <john.fastabend@gmail.com>,
	John Stultz <jstultz@google.com>,
	Jon Maloy <jmaloy@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Julian Anastasov <ja@ssi.bg>,
	KP Singh <kpsingh@kernel.org>,
	Kalle Valo <kvalo@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Keith Busch <kbusch@kernel.org>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	Leon Romanovsky <leon@kernel.org>,
	Manish Rangankar <mrangankar@marvell.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Marco Elver <elver@google.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	"Md . Haris Iqbal" <haris.iqbal@ionos.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michael Jamet <michael.jamet@intel.com>,
	Michal Januszewski <spock@gentoo.org>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	"Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
	Neil Horman <nhorman@tuxdriver.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Nilesh Javali <njavali@marvell.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Potnuri Bharat Teja <bharat@chelsio.com>,
	Pravin B Shelar <pshelar@ovn.org>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Richard Weinberger <richard@nod.at>,
	Rohit Maheshwari <rohitm@chelsio.com>,
	Russell King <linux@armlinux.org.uk>,
	Sagi Grimberg <sagi@grimberg.me>,
	Santosh Shilimkar <santosh.shilimkar@oracle.com>,
	Sergey Matyukevich <geomatsi@gmail.com>,
	Sharvari Harisangam <sharvari.harisangam@nxp.com>,
	Simon Horman <horms@verge.net.au>,
	Song Liu <song@kernel.org>,
	Stanislav Fomichev <sdf@google.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Stephen Hemminger <stephen@networkplumber.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Thomas Gleixner <tglx@linutronix.de>,
	Thomas Graf <tgraf@suug.ch>,
	Thomas Sailer <t.sailer@alumni.ethz.ch>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Varun Prakash <varun@chelsio.com>,
	Veaceslav Falico <vfalico@gmail.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
	Vinod Koul <vkoul@kernel.org>,
	Vlad Yasevich <vyasevich@gmail.com>,
	Wenpeng Liang <liangwenpeng@huawei.com>,
	Xinming Hu <huxinming820@gmail.com>,
	Xiubo Li <xiubli@redhat.com>,
	Yehezkel Bernat <YehezkelShB@gmail.com>,
	Ying Xue <ying.xue@windriver.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Yonghong Song <yhs@fb.com>,
	Yury Norov <yury.norov@gmail.com>,
	brcm80211-dev-list.pdl@broadcom.com,
	cake@lists.bufferbloat.net,
	ceph-devel@vger.kernel.org,
	coreteam@netfilter.org,
	dccp@vger.kernel.org,
	dev@openvswitch.org,
	dmaengine@vger.kernel.org,
	drbd-dev@lists.linbit.com,
	dri-devel@lists.freedesktop.org,
	kasan-dev@googlegroups.com,
	linux-actions@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-fbdev@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-hams@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org,
	linux-mmc@vger.kernel.org,
	linux-mtd@lists.infradead.org,
	linux-nfs@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-raid@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-sctp@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	lvs-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	rds-devel@oss.oracle.com,
	SHA-cyfmac-dev-list@infineon.com,
	target-devel@vger.kernel.org,
	tipc-discussion@lists.sourceforge.net
Subject: [PATCH v1 2/5] treewide: use get_random_{u8,u16}() when possible
Date: Wed,  5 Oct 2022 23:48:41 +0200
Message-Id: <20221005214844.2699-3-Jason@zx2c4.com>
In-Reply-To: <20221005214844.2699-1-Jason@zx2c4.com>
References: <20221005214844.2699-1-Jason@zx2c4.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rather than truncate a 32-bit value to a 16-bit value or an 8-bit value,
simply use the get_random_{u8,u16}() functions, which are faster than
wasting the additional bytes from a 32-bit value.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 crypto/testmgr.c                                          | 8 ++++----
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c             | 2 +-
 drivers/media/test-drivers/vivid/vivid-radio-rx.c         | 4 ++--
 .../net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c   | 2 +-
 drivers/net/hamradio/baycom_epp.c                         | 2 +-
 drivers/net/hamradio/hdlcdrv.c                            | 2 +-
 drivers/net/hamradio/yam.c                                | 2 +-
 drivers/net/wireguard/selftest/allowedips.c               | 4 ++--
 drivers/scsi/lpfc/lpfc_hbadisc.c                          | 6 +++---
 lib/test_vmalloc.c                                        | 2 +-
 net/dccp/ipv4.c                                           | 4 ++--
 net/ipv4/datagram.c                                       | 2 +-
 net/ipv4/ip_output.c                                      | 2 +-
 net/ipv4/tcp_ipv4.c                                       | 4 ++--
 net/mac80211/scan.c                                       | 2 +-
 net/netfilter/nf_nat_core.c                               | 4 ++--
 net/sched/sch_cake.c                                      | 6 +++---
 net/sched/sch_sfb.c                                       | 2 +-
 net/sctp/socket.c                                         | 2 +-
 19 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index be45217acde4..981c637fa2ed 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -927,7 +927,7 @@ static void generate_random_bytes(u8 *buf, size_t count)
 			b = 0xff;
 			break;
 		default:
-			b = (u8)prandom_u32();
+			b = get_random_u8();
 			break;
 		}
 		memset(buf, b, count);
@@ -935,8 +935,8 @@ static void generate_random_bytes(u8 *buf, size_t count)
 		break;
 	case 2:
 		/* Ascending or descending bytes, plus optional mutations */
-		increment = (u8)prandom_u32();
-		b = (u8)prandom_u32();
+		increment = get_random_u8();
+		b = get_random_u8();
 		for (i = 0; i < count; i++, b += increment)
 			buf[i] = b;
 		mutate_buffer(buf, count);
@@ -944,7 +944,7 @@ static void generate_random_bytes(u8 *buf, size_t count)
 	default:
 		/* Fully random bytes */
 		for (i = 0; i < count; i++)
-			buf[i] = (u8)prandom_u32();
+			buf[i] = get_random_u8();
 	}
 }
 
diff --git a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
index 9b7bcdce6e44..303d02b1d71c 100644
--- a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
+++ b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
@@ -870,7 +870,7 @@ static void precalculate_color(struct tpg_data *tpg, int k)
 		g = tpg_colors[col].g;
 		b = tpg_colors[col].b;
 	} else if (tpg->pattern == TPG_PAT_NOISE) {
-		r = g = b = prandom_u32_max(256);
+		r = g = b = get_random_u8();
 	} else if (k == TPG_COLOR_RANDOM) {
 		r = g = b = tpg->qual_offset + prandom_u32_max(196);
 	} else if (k >= TPG_COLOR_RAMP) {
diff --git a/drivers/media/test-drivers/vivid/vivid-radio-rx.c b/drivers/media/test-drivers/vivid/vivid-radio-rx.c
index 232cab508f48..8bd09589fb15 100644
--- a/drivers/media/test-drivers/vivid/vivid-radio-rx.c
+++ b/drivers/media/test-drivers/vivid/vivid-radio-rx.c
@@ -104,8 +104,8 @@ ssize_t vivid_radio_rx_read(struct file *file, char __user *buf,
 				break;
 			case 2:
 				rds.block |= V4L2_RDS_BLOCK_ERROR;
-				rds.lsb = prandom_u32_max(256);
-				rds.msb = prandom_u32_max(256);
+				rds.lsb = get_random_u8();
+				rds.msb = get_random_u8();
 				break;
 			case 3: /* Skip block altogether */
 				if (i)
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
index ddfe9208529a..ac452a0111a9 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
@@ -1467,7 +1467,7 @@ static void make_established(struct sock *sk, u32 snd_isn, unsigned int opt)
 	tp->write_seq = snd_isn;
 	tp->snd_nxt = snd_isn;
 	tp->snd_una = snd_isn;
-	inet_sk(sk)->inet_id = prandom_u32();
+	inet_sk(sk)->inet_id = get_random_u16();
 	assign_rxopt(sk, opt);
 
 	if (tp->rcv_wnd > (RCV_BUFSIZ_M << 10))
diff --git a/drivers/net/hamradio/baycom_epp.c b/drivers/net/hamradio/baycom_epp.c
index 7df78a721b04..791b4a53d69f 100644
--- a/drivers/net/hamradio/baycom_epp.c
+++ b/drivers/net/hamradio/baycom_epp.c
@@ -438,7 +438,7 @@ static int transmit(struct baycom_state *bc, int cnt, unsigned char stat)
 			if ((--bc->hdlctx.slotcnt) > 0)
 				return 0;
 			bc->hdlctx.slotcnt = bc->ch_params.slottime;
-			if (prandom_u32_max(256) > bc->ch_params.ppersist)
+			if (get_random_u8() > bc->ch_params.ppersist)
 				return 0;
 		}
 	}
diff --git a/drivers/net/hamradio/hdlcdrv.c b/drivers/net/hamradio/hdlcdrv.c
index 360d041a62c4..6c6f11d3d0aa 100644
--- a/drivers/net/hamradio/hdlcdrv.c
+++ b/drivers/net/hamradio/hdlcdrv.c
@@ -377,7 +377,7 @@ void hdlcdrv_arbitrate(struct net_device *dev, struct hdlcdrv_state *s)
 	if ((--s->hdlctx.slotcnt) > 0)
 		return;
 	s->hdlctx.slotcnt = s->ch_params.slottime;
-	if (prandom_u32_max(256) > s->ch_params.ppersist)
+	if (get_random_u8() > s->ch_params.ppersist)
 		return;
 	start_tx(dev, s);
 }
diff --git a/drivers/net/hamradio/yam.c b/drivers/net/hamradio/yam.c
index 97a6cc5c7ae8..2ed2f836f09a 100644
--- a/drivers/net/hamradio/yam.c
+++ b/drivers/net/hamradio/yam.c
@@ -626,7 +626,7 @@ static void yam_arbitrate(struct net_device *dev)
 	yp->slotcnt = yp->slot / 10;
 
 	/* is random > persist ? */
-	if (prandom_u32_max(256) > yp->pers)
+	if (get_random_u8() > yp->pers)
 		return;
 
 	yam_start_tx(dev, yp);
diff --git a/drivers/net/wireguard/selftest/allowedips.c b/drivers/net/wireguard/selftest/allowedips.c
index 41db10f9be49..dd897c0740a2 100644
--- a/drivers/net/wireguard/selftest/allowedips.c
+++ b/drivers/net/wireguard/selftest/allowedips.c
@@ -310,7 +310,7 @@ static __init bool randomized_test(void)
 			for (k = 0; k < 4; ++k)
 				mutated[k] = (mutated[k] & mutate_mask[k]) |
 					     (~mutate_mask[k] &
-					      prandom_u32_max(256));
+					      get_random_u8());
 			cidr = prandom_u32_max(32) + 1;
 			peer = peers[prandom_u32_max(NUM_PEERS)];
 			if (wg_allowedips_insert_v4(&t,
@@ -354,7 +354,7 @@ static __init bool randomized_test(void)
 			for (k = 0; k < 4; ++k)
 				mutated[k] = (mutated[k] & mutate_mask[k]) |
 					     (~mutate_mask[k] &
-					      prandom_u32_max(256));
+					      get_random_u8());
 			cidr = prandom_u32_max(128) + 1;
 			peer = peers[prandom_u32_max(NUM_PEERS)];
 			if (wg_allowedips_insert_v6(&t,
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 2645def612e6..26d1779cb570 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -2150,8 +2150,8 @@ lpfc_check_pending_fcoe_event(struct lpfc_hba *phba, uint8_t unreg_fcf)
  * This function makes an running random selection decision on FCF record to
  * use through a sequence of @fcf_cnt eligible FCF records with equal
  * probability. To perform integer manunipulation of random numbers with
- * size unit32_t, the lower 16 bits of the 32-bit random number returned
- * from prandom_u32() are taken as the random random number generated.
+ * size unit32_t, a 16-bit random number returned from get_random_u16() is
+ * taken as the random random number generated.
  *
  * Returns true when outcome is for the newly read FCF record should be
  * chosen; otherwise, return false when outcome is for keeping the previously
@@ -2163,7 +2163,7 @@ lpfc_sli4_new_fcf_random_select(struct lpfc_hba *phba, uint32_t fcf_cnt)
 	uint32_t rand_num;
 
 	/* Get 16-bit uniform random number */
-	rand_num = 0xFFFF & prandom_u32();
+	rand_num = get_random_u16();
 
 	/* Decision with probability 1/fcf_cnt */
 	if ((fcf_cnt * rand_num) < 0xFFFF)
diff --git a/lib/test_vmalloc.c b/lib/test_vmalloc.c
index 56ffaa8dd3f6..0131ed2cd1bd 100644
--- a/lib/test_vmalloc.c
+++ b/lib/test_vmalloc.c
@@ -80,7 +80,7 @@ static int random_size_align_alloc_test(void)
 	int i;
 
 	for (i = 0; i < test_loop_count; i++) {
-		rnd = prandom_u32();
+		rnd = get_random_u8();
 
 		/*
 		 * Maximum 1024 pages, if PAGE_SIZE is 4096.
diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index da6e3b20cd75..301799e7fa56 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -123,7 +123,7 @@ int dccp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 						    inet->inet_daddr,
 						    inet->inet_sport,
 						    inet->inet_dport);
-	inet->inet_id = prandom_u32();
+	inet->inet_id = get_random_u16();
 
 	err = dccp_connect(sk);
 	rt = NULL;
@@ -422,7 +422,7 @@ struct sock *dccp_v4_request_recv_sock(const struct sock *sk,
 	RCU_INIT_POINTER(newinet->inet_opt, rcu_dereference(ireq->ireq_opt));
 	newinet->mc_index  = inet_iif(skb);
 	newinet->mc_ttl	   = ip_hdr(skb)->ttl;
-	newinet->inet_id   = prandom_u32();
+	newinet->inet_id   = get_random_u16();
 
 	if (dst == NULL && (dst = inet_csk_route_child_sock(sk, newsk, req)) == NULL)
 		goto put_and_exit;
diff --git a/net/ipv4/datagram.c b/net/ipv4/datagram.c
index ffd57523331f..fefc5d855a66 100644
--- a/net/ipv4/datagram.c
+++ b/net/ipv4/datagram.c
@@ -71,7 +71,7 @@ int __ip4_datagram_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len
 	reuseport_has_conns(sk, true);
 	sk->sk_state = TCP_ESTABLISHED;
 	sk_set_txhash(sk);
-	inet->inet_id = prandom_u32();
+	inet->inet_id = get_random_u16();
 
 	sk_dst_set(sk, &rt->dst);
 	err = 0;
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 04e2034f2f8e..a4fbdbff14b3 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -172,7 +172,7 @@ int ip_build_and_send_pkt(struct sk_buff *skb, const struct sock *sk,
 		 * Avoid using the hashed IP ident generator.
 		 */
 		if (sk->sk_protocol == IPPROTO_TCP)
-			iph->id = (__force __be16)prandom_u32();
+			iph->id = (__force __be16)get_random_u16();
 		else
 			__ip_select_ident(net, iph, 1);
 	}
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 5b019ba2b9d2..747752980983 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -303,7 +303,7 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 						 inet->inet_daddr);
 	}
 
-	inet->inet_id = prandom_u32();
+	inet->inet_id = get_random_u16();
 
 	if (tcp_fastopen_defer_connect(sk, &err))
 		return err;
@@ -1523,7 +1523,7 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
 	inet_csk(newsk)->icsk_ext_hdr_len = 0;
 	if (inet_opt)
 		inet_csk(newsk)->icsk_ext_hdr_len = inet_opt->opt.optlen;
-	newinet->inet_id = prandom_u32();
+	newinet->inet_id = get_random_u16();
 
 	/* Set ToS of the new socket based upon the value of incoming SYN.
 	 * ECT bits are set later in tcp_init_transfer().
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index c4f2aeb31da3..6cab549cc421 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -641,7 +641,7 @@ static void ieee80211_send_scan_probe_req(struct ieee80211_sub_if_data *sdata,
 		if (flags & IEEE80211_PROBE_FLAG_RANDOM_SN) {
 			struct ieee80211_hdr *hdr = (void *)skb->data;
 			struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-			u16 sn = get_random_u32();
+			u16 sn = get_random_u16();
 
 			info->control.flags |= IEEE80211_TX_CTRL_NO_SEQNO;
 			hdr->seq_ctrl =
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 7981be526f26..57c7686ac485 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -468,7 +468,7 @@ static void nf_nat_l4proto_unique_tuple(struct nf_conntrack_tuple *tuple,
 	if (range->flags & NF_NAT_RANGE_PROTO_OFFSET)
 		off = (ntohs(*keyptr) - ntohs(range->base_proto.all));
 	else
-		off = prandom_u32();
+		off = get_random_u16();
 
 	attempts = range_size;
 	if (attempts > max_attempts)
@@ -490,7 +490,7 @@ static void nf_nat_l4proto_unique_tuple(struct nf_conntrack_tuple *tuple,
 	if (attempts >= range_size || attempts < 16)
 		return;
 	attempts /= 2;
-	off = prandom_u32();
+	off = get_random_u16();
 	goto another_round;
 }
 
diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index a43a58a73d09..637ef1757931 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -2092,11 +2092,11 @@ static struct sk_buff *cake_dequeue(struct Qdisc *sch)
 
 		WARN_ON(host_load > CAKE_QUEUES);
 
-		/* The shifted prandom_u32() is a way to apply dithering to
-		 * avoid accumulating roundoff errors
+		/* The get_random_u16() is a way to apply dithering to avoid
+		 * accumulating roundoff errors
 		 */
 		flow->deficit += (b->flow_quantum * quantum_div[host_load] +
-				  (prandom_u32() >> 16)) >> 16;
+				  get_random_u16()) >> 16;
 		list_move_tail(&flow->flowchain, &b->old_flows);
 
 		goto retry;
diff --git a/net/sched/sch_sfb.c b/net/sched/sch_sfb.c
index 2829455211f8..7eb70acb4d58 100644
--- a/net/sched/sch_sfb.c
+++ b/net/sched/sch_sfb.c
@@ -379,7 +379,7 @@ static int sfb_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		goto enqueue;
 	}
 
-	r = prandom_u32() & SFB_MAX_PROB;
+	r = get_random_u16() & SFB_MAX_PROB;
 
 	if (unlikely(r < p_min)) {
 		if (unlikely(p_min > SFB_MAX_PROB / 2)) {
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 1e354ba44960..83628c347744 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -9448,7 +9448,7 @@ void sctp_copy_sock(struct sock *newsk, struct sock *sk,
 	newinet->inet_rcv_saddr = inet->inet_rcv_saddr;
 	newinet->inet_dport = htons(asoc->peer.port);
 	newinet->pmtudisc = inet->pmtudisc;
-	newinet->inet_id = prandom_u32();
+	newinet->inet_id = get_random_u16();
 
 	newinet->uc_ttl = inet->uc_ttl;
 	newinet->mc_loop = 1;
-- 
2.37.3

