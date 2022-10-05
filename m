Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A6C633
	for <patches@lists.linux.dev>; Thu,  6 Oct 2022 02:55:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A641DC433D6
	for <patches@lists.linux.dev>; Thu,  6 Oct 2022 02:55:57 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="SvDIC00E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1665024956;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2Uw2fujBlzDNZqwuoh34rFItEGOZGCdqRJ97sSVe7tk=;
	b=SvDIC00ETtqzEhKOZapgDjmV3F99img3YyvxshKNL1wKtk+drqrHLhcgHQSrVbl/PM1BVA
	Ur9KFhPA7WsSQaZIjDqDneBfSjrbFZLYrnmELk0CfW6HK5SPbs2soURv0JgmMNX38ZUmOB
	FMtxHfB+9BMZ9FS2yAaY3/AsWH3Uomg=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 4e73b20d (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
	for <patches@lists.linux.dev>;
	Thu, 6 Oct 2022 02:55:56 +0000 (UTC)
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
Subject: [PATCH v1 4/5] treewide: use get_random_bytes when possible
Date: Wed,  5 Oct 2022 23:48:43 +0200
Message-Id: <20221005214844.2699-5-Jason@zx2c4.com>
In-Reply-To: <20221005214844.2699-1-Jason@zx2c4.com>
References: <20221005214844.2699-1-Jason@zx2c4.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The prandom_bytes() function has been a deprecated inline wrapper around
get_random_bytes() for several releases now, and compiles down to the
exact same code. Replace the deprecated wrapper with a direct call to
the real function.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 arch/powerpc/crypto/crc-vpmsum_test.c       |  2 +-
 block/blk-crypto-fallback.c                 |  2 +-
 crypto/async_tx/raid6test.c                 |  2 +-
 drivers/dma/dmatest.c                       |  2 +-
 drivers/mtd/nand/raw/nandsim.c              |  2 +-
 drivers/mtd/tests/mtd_nandecctest.c         |  2 +-
 drivers/mtd/tests/speedtest.c               |  2 +-
 drivers/mtd/tests/stresstest.c              |  2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c   |  2 +-
 drivers/net/ethernet/rocker/rocker_main.c   |  2 +-
 drivers/net/wireguard/selftest/allowedips.c | 12 ++++++------
 fs/ubifs/debug.c                            |  2 +-
 kernel/kcsan/selftest.c                     |  2 +-
 lib/random32.c                              |  2 +-
 lib/test_objagg.c                           |  2 +-
 lib/uuid.c                                  |  2 +-
 net/ipv4/route.c                            |  2 +-
 net/mac80211/rc80211_minstrel_ht.c          |  2 +-
 net/sched/sch_pie.c                         |  2 +-
 19 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/arch/powerpc/crypto/crc-vpmsum_test.c b/arch/powerpc/crypto/crc-vpmsum_test.c
index c1c1ef9457fb..273c527868db 100644
--- a/arch/powerpc/crypto/crc-vpmsum_test.c
+++ b/arch/powerpc/crypto/crc-vpmsum_test.c
@@ -82,7 +82,7 @@ static int __init crc_test_init(void)
 
 			if (len <= offset)
 				continue;
-			prandom_bytes(data, len);
+			get_random_bytes(data, len);
 			len -= offset;
 
 			crypto_shash_update(crct10dif_shash, data+offset, len);
diff --git a/block/blk-crypto-fallback.c b/block/blk-crypto-fallback.c
index 621abd1b0e4d..ad9844c5b40c 100644
--- a/block/blk-crypto-fallback.c
+++ b/block/blk-crypto-fallback.c
@@ -539,7 +539,7 @@ static int blk_crypto_fallback_init(void)
 	if (blk_crypto_fallback_inited)
 		return 0;
 
-	prandom_bytes(blank_key, BLK_CRYPTO_MAX_KEY_SIZE);
+	get_random_bytes(blank_key, BLK_CRYPTO_MAX_KEY_SIZE);
 
 	err = bioset_init(&crypto_bio_split, 64, 0, 0);
 	if (err)
diff --git a/crypto/async_tx/raid6test.c b/crypto/async_tx/raid6test.c
index c9d218e53bcb..f74505f2baf0 100644
--- a/crypto/async_tx/raid6test.c
+++ b/crypto/async_tx/raid6test.c
@@ -37,7 +37,7 @@ static void makedata(int disks)
 	int i;
 
 	for (i = 0; i < disks; i++) {
-		prandom_bytes(page_address(data[i]), PAGE_SIZE);
+		get_random_bytes(page_address(data[i]), PAGE_SIZE);
 		dataptrs[i] = data[i];
 		dataoffs[i] = 0;
 	}
diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index 9fe2ae794316..ffe621695e47 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -312,7 +312,7 @@ static unsigned long dmatest_random(void)
 {
 	unsigned long buf;
 
-	prandom_bytes(&buf, sizeof(buf));
+	get_random_bytes(&buf, sizeof(buf));
 	return buf;
 }
 
diff --git a/drivers/mtd/nand/raw/nandsim.c b/drivers/mtd/nand/raw/nandsim.c
index 4bdaf4aa7007..c941a5a41ea6 100644
--- a/drivers/mtd/nand/raw/nandsim.c
+++ b/drivers/mtd/nand/raw/nandsim.c
@@ -1393,7 +1393,7 @@ static int ns_do_read_error(struct nandsim *ns, int num)
 	unsigned int page_no = ns->regs.row;
 
 	if (ns_read_error(page_no)) {
-		prandom_bytes(ns->buf.byte, num);
+		get_random_bytes(ns->buf.byte, num);
 		NS_WARN("simulating read error in page %u\n", page_no);
 		return 1;
 	}
diff --git a/drivers/mtd/tests/mtd_nandecctest.c b/drivers/mtd/tests/mtd_nandecctest.c
index 1c7201b0f372..440988562cfd 100644
--- a/drivers/mtd/tests/mtd_nandecctest.c
+++ b/drivers/mtd/tests/mtd_nandecctest.c
@@ -266,7 +266,7 @@ static int nand_ecc_test_run(const size_t size)
 		goto error;
 	}
 
-	prandom_bytes(correct_data, size);
+	get_random_bytes(correct_data, size);
 	ecc_sw_hamming_calculate(correct_data, size, correct_ecc, sm_order);
 	for (i = 0; i < ARRAY_SIZE(nand_ecc_test); i++) {
 		nand_ecc_test[i].prepare(error_data, error_ecc,
diff --git a/drivers/mtd/tests/speedtest.c b/drivers/mtd/tests/speedtest.c
index c9ec7086bfa1..075bce32caa5 100644
--- a/drivers/mtd/tests/speedtest.c
+++ b/drivers/mtd/tests/speedtest.c
@@ -223,7 +223,7 @@ static int __init mtd_speedtest_init(void)
 	if (!iobuf)
 		goto out;
 
-	prandom_bytes(iobuf, mtd->erasesize);
+	get_random_bytes(iobuf, mtd->erasesize);
 
 	bbt = kzalloc(ebcnt, GFP_KERNEL);
 	if (!bbt)
diff --git a/drivers/mtd/tests/stresstest.c b/drivers/mtd/tests/stresstest.c
index d2faaca7f19d..75b6ddc5dc4d 100644
--- a/drivers/mtd/tests/stresstest.c
+++ b/drivers/mtd/tests/stresstest.c
@@ -183,7 +183,7 @@ static int __init mtd_stresstest_init(void)
 		goto out;
 	for (i = 0; i < ebcnt; i++)
 		offsets[i] = mtd->erasesize;
-	prandom_bytes(writebuf, bufsize);
+	get_random_bytes(writebuf, bufsize);
 
 	bbt = kzalloc(ebcnt, GFP_KERNEL);
 	if (!bbt)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 96da0ba3d507..354953df46a1 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -3874,7 +3874,7 @@ static void bnxt_init_vnics(struct bnxt *bp)
 
 		if (bp->vnic_info[i].rss_hash_key) {
 			if (i == 0)
-				prandom_bytes(vnic->rss_hash_key,
+				get_random_bytes(vnic->rss_hash_key,
 					      HW_HASH_KEY_SIZE);
 			else
 				memcpy(vnic->rss_hash_key,
diff --git a/drivers/net/ethernet/rocker/rocker_main.c b/drivers/net/ethernet/rocker/rocker_main.c
index 8c3bbafabb07..cd4488efe0a4 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -224,7 +224,7 @@ static int rocker_dma_test_offset(const struct rocker *rocker,
 	if (err)
 		goto unmap;
 
-	prandom_bytes(buf, ROCKER_TEST_DMA_BUF_SIZE);
+	get_random_bytes(buf, ROCKER_TEST_DMA_BUF_SIZE);
 	for (i = 0; i < ROCKER_TEST_DMA_BUF_SIZE; i++)
 		expect[i] = ~buf[i];
 	err = rocker_dma_test_one(rocker, wait, ROCKER_TEST_DMA_CTRL_INVERT,
diff --git a/drivers/net/wireguard/selftest/allowedips.c b/drivers/net/wireguard/selftest/allowedips.c
index dd897c0740a2..19eac00b2381 100644
--- a/drivers/net/wireguard/selftest/allowedips.c
+++ b/drivers/net/wireguard/selftest/allowedips.c
@@ -284,7 +284,7 @@ static __init bool randomized_test(void)
 	mutex_lock(&mutex);
 
 	for (i = 0; i < NUM_RAND_ROUTES; ++i) {
-		prandom_bytes(ip, 4);
+		get_random_bytes(ip, 4);
 		cidr = prandom_u32_max(32) + 1;
 		peer = peers[prandom_u32_max(NUM_PEERS)];
 		if (wg_allowedips_insert_v4(&t, (struct in_addr *)ip, cidr,
@@ -299,7 +299,7 @@ static __init bool randomized_test(void)
 		}
 		for (j = 0; j < NUM_MUTATED_ROUTES; ++j) {
 			memcpy(mutated, ip, 4);
-			prandom_bytes(mutate_mask, 4);
+			get_random_bytes(mutate_mask, 4);
 			mutate_amount = prandom_u32_max(32);
 			for (k = 0; k < mutate_amount / 8; ++k)
 				mutate_mask[k] = 0xff;
@@ -328,7 +328,7 @@ static __init bool randomized_test(void)
 	}
 
 	for (i = 0; i < NUM_RAND_ROUTES; ++i) {
-		prandom_bytes(ip, 16);
+		get_random_bytes(ip, 16);
 		cidr = prandom_u32_max(128) + 1;
 		peer = peers[prandom_u32_max(NUM_PEERS)];
 		if (wg_allowedips_insert_v6(&t, (struct in6_addr *)ip, cidr,
@@ -343,7 +343,7 @@ static __init bool randomized_test(void)
 		}
 		for (j = 0; j < NUM_MUTATED_ROUTES; ++j) {
 			memcpy(mutated, ip, 16);
-			prandom_bytes(mutate_mask, 16);
+			get_random_bytes(mutate_mask, 16);
 			mutate_amount = prandom_u32_max(128);
 			for (k = 0; k < mutate_amount / 8; ++k)
 				mutate_mask[k] = 0xff;
@@ -381,13 +381,13 @@ static __init bool randomized_test(void)
 
 	for (j = 0;; ++j) {
 		for (i = 0; i < NUM_QUERIES; ++i) {
-			prandom_bytes(ip, 4);
+			get_random_bytes(ip, 4);
 			if (lookup(t.root4, 32, ip) != horrible_allowedips_lookup_v4(&h, (struct in_addr *)ip)) {
 				horrible_allowedips_lookup_v4(&h, (struct in_addr *)ip);
 				pr_err("allowedips random v4 self-test: FAIL\n");
 				goto free;
 			}
-			prandom_bytes(ip, 16);
+			get_random_bytes(ip, 16);
 			if (lookup(t.root6, 128, ip) != horrible_allowedips_lookup_v6(&h, (struct in6_addr *)ip)) {
 				pr_err("allowedips random v6 self-test: FAIL\n");
 				goto free;
diff --git a/fs/ubifs/debug.c b/fs/ubifs/debug.c
index f4d3b568aa64..3f128b9fdfbb 100644
--- a/fs/ubifs/debug.c
+++ b/fs/ubifs/debug.c
@@ -2581,7 +2581,7 @@ static int corrupt_data(const struct ubifs_info *c, const void *buf,
 	if (ffs)
 		memset(p + from, 0xFF, to - from);
 	else
-		prandom_bytes(p + from, to - from);
+		get_random_bytes(p + from, to - from);
 
 	return to;
 }
diff --git a/kernel/kcsan/selftest.c b/kernel/kcsan/selftest.c
index 58b94deae5c0..00cdf8fa5693 100644
--- a/kernel/kcsan/selftest.c
+++ b/kernel/kcsan/selftest.c
@@ -46,7 +46,7 @@ static bool __init test_encode_decode(void)
 		unsigned long addr;
 		size_t verif_size;
 
-		prandom_bytes(&addr, sizeof(addr));
+		get_random_bytes(&addr, sizeof(addr));
 		if (addr < PAGE_SIZE)
 			addr = PAGE_SIZE;
 
diff --git a/lib/random32.c b/lib/random32.c
index d4f19e1a69d4..32060b852668 100644
--- a/lib/random32.c
+++ b/lib/random32.c
@@ -69,7 +69,7 @@ EXPORT_SYMBOL(prandom_u32_state);
  *	@bytes: the requested number of bytes
  *
  *	This is used for pseudo-randomness with no outside seeding.
- *	For more random results, use prandom_bytes().
+ *	For more random results, use get_random_bytes().
  */
 void prandom_bytes_state(struct rnd_state *state, void *buf, size_t bytes)
 {
diff --git a/lib/test_objagg.c b/lib/test_objagg.c
index da137939a410..c0c957c50635 100644
--- a/lib/test_objagg.c
+++ b/lib/test_objagg.c
@@ -157,7 +157,7 @@ static int test_nodelta_obj_get(struct world *world, struct objagg *objagg,
 	int err;
 
 	if (should_create_root)
-		prandom_bytes(world->next_root_buf,
+		get_random_bytes(world->next_root_buf,
 			      sizeof(world->next_root_buf));
 
 	objagg_obj = world_obj_get(world, objagg, key_id);
diff --git a/lib/uuid.c b/lib/uuid.c
index 562d53977cab..e309b4c5be3d 100644
--- a/lib/uuid.c
+++ b/lib/uuid.c
@@ -52,7 +52,7 @@ EXPORT_SYMBOL(generate_random_guid);
 
 static void __uuid_gen_common(__u8 b[16])
 {
-	prandom_bytes(b, 16);
+	get_random_bytes(b, 16);
 	/* reversion 0b10 */
 	b[8] = (b[8] & 0x3F) | 0x80;
 }
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 795cbe1de912..c3fd6c62897d 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -3719,7 +3719,7 @@ int __init ip_rt_init(void)
 
 	ip_idents = idents_hash;
 
-	prandom_bytes(ip_idents, (ip_idents_mask + 1) * sizeof(*ip_idents));
+	get_random_bytes(ip_idents, (ip_idents_mask + 1) * sizeof(*ip_idents));
 
 	ip_tstamps = idents_hash + (ip_idents_mask + 1) * sizeof(*ip_idents);
 
diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 5f27e6746762..39fb4e2d141a 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -2033,7 +2033,7 @@ static void __init init_sample_table(void)
 
 	memset(sample_table, 0xff, sizeof(sample_table));
 	for (col = 0; col < SAMPLE_COLUMNS; col++) {
-		prandom_bytes(rnd, sizeof(rnd));
+		get_random_bytes(rnd, sizeof(rnd));
 		for (i = 0; i < MCS_GROUP_RATES; i++) {
 			new_idx = (i + rnd[i]) % MCS_GROUP_RATES;
 			while (sample_table[col][new_idx] != 0xff)
diff --git a/net/sched/sch_pie.c b/net/sched/sch_pie.c
index 5a457ff61acd..66b2b23e8cd1 100644
--- a/net/sched/sch_pie.c
+++ b/net/sched/sch_pie.c
@@ -72,7 +72,7 @@ bool pie_drop_early(struct Qdisc *sch, struct pie_params *params,
 	if (vars->accu_prob >= (MAX_PROB / 2) * 17)
 		return true;
 
-	prandom_bytes(&rnd, 8);
+	get_random_bytes(&rnd, 8);
 	if ((rnd >> BITS_PER_BYTE) < local_prob) {
 		vars->accu_prob = 0;
 		return true;
-- 
2.37.3

