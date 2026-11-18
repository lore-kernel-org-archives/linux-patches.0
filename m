Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058756;
	b=4RoTiWQvcu2SciKphI6iKE+ftp9H0BMoKltckjC0MmzVdk3K7K5Tva31OoBm2IUseqi0
	 f3fOd1RgXpDDTo9khNmumrADM1oD2AKwt7XvSbqrohMA6IOdUegb4ywmAg0BkYP7cNTkW
	 81LMkbmw7A298sDjldFRX+7Q+fsn/tl8tZaSWMoGjO1ebScxWXZ0hbIWDDyRRvy151eAo
	 qT6smFoEvIGTxdSFCgbc8CXFznEVyL9TMRB6T0HaijW9FvtEs1h15Se6HWxe0kiQ1SyXZ
	 VSe131Dqov/HNv3ImLumAU9IFoyIsH/0B/kwL71HnIzbzLXEg0N8fwx8fhvPY2wiELw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058756;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U5zSxwFTjV86E/zG+l3lk/GKM3YpUJBomLryQMf7I+Y=;
	b=UbK/oHdteNTklsC0dTzlTx2sjtANO77Z5QOl4dbTPCYHfMXMRBffhRn95c3zDo+ctEVj
	 uaGmu7o/EYshoZ6n4aWZeag2CJ4jVbk4PYPw/HNdH9iBnW5FF8SUQcfsv23BRQjLr9mpN
	 xR0SkRsChVugoK0a3/yCEXzQJZu8mo24Yl3LzDwejnoPdc2JKDk1CLVo+zVcJE+RgMSvM
	 sefUe/2Bo2G6WOffA3FbTtrIzq7ycvT0f87IdOcu4X7mqHd1RCTfOHGv4VVI+9vTUGP3R
	 0ZS5AkVm0hf7UYc5okWIwEBjxoMbkKV3JINfvXLcLhOuIyJIITCxQoFe/hpMBouwk1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="F9zg/Ejx";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E28BA606A33B;
	Thu, 19 Nov 2026 03:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F9zg/Ejx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 484EC1F000C5;
	Thu, 19 Nov 2026 03:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058755;
	bh=U5zSxwFTjV86E/zG+l3lk/GKM3YpUJBomLryQMf7I+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F9zg/EjxmsRIIfuY7N3Aaz5LEMomRmlzUtXxGVqZ+7kQKlz5S5SCQQYUOPUlnS6Bm
	 CaaM84t0Xkw7WAkXH6bkHNc7h6iPmakcTtKlc9QkNM0izJy2T6xDNqUczXiuf0uwiq
	 r8CnpCSsGbEe/VhokrkqF7Cty46GKl1DZgKirw/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Andrea Parri <parri.andrea@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0599/1848] nvmet-fc: only send read data for successful commands
Date: Wed, 18 Nov 2026 15:43:57 +0100
Message-ID: <20261118145940.425117063@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Parri <parri.andrea@gmail.com>

[ Upstream commit 94f93c61b1a5dd08d011be58172ce4392b849008 ]

When a read command completes with an error,
__nvmet_fc_fcp_nvme_cmd_done() still pushes the whole data buffer to
the host before the response. nvmet_fc_alloc_tgt_pgs() allocates that
buffer with sgl_alloc() and no __GFP_ZERO, and a command rejected by
nvmet_check_transfer_len() leaves it untouched, so the host receives
stale target memory.

The buffer is as large as the data length in the command IU, so the
amount of stale memory returned is up to the host.

The tcp and rdma targets send data only when cqe->status is zero (see
nvmet_tcp_need_data_out() and nvmet_rdma_need_data_out()), so no nvmet
command can rely on returning data with an error status. Do the same
for fc. The ERSP then reports a transferred length of fod->offset,
which is 0, matching what nvme_fc_fcpio_done() checks on the host.

Tested over nvme-fcloop: a failed read command no longer transfers
data and still completes with its error status, and successful reads
are unaffected.

Fixes: c53432030d86 ("nvme-fabrics: Add target support for FC transport")
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/fc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/target/fc.c b/drivers/nvme/target/fc.c
index 34402de61cad5..57ad6031cde91 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -2451,11 +2451,11 @@ __nvmet_fc_fcp_nvme_cmd_done(struct nvmet_fc_tgtport *tgtport,
 	} else {
 
 		/*
-		 * try to push the data even if the SQE status is non-zero.
-		 * There may be a status where data still was intended to
-		 * be moved
+		 * A failed command may not have filled its read buffer, so
+		 * only push data for success, as the tcp and rdma targets do.
 		 */
-		if ((fod->io_dir == NVMET_FCP_READ) && (fod->data_sg_cnt)) {
+		if (fod->io_dir == NVMET_FCP_READ && fod->data_sg_cnt &&
+		    !cqe->status) {
 			/* push the data over before sending rsp */
 			nvmet_fc_transfer_fcp_data(tgtport, fod,
 						NVMET_FCOP_READDATA);
-- 
2.53.0



