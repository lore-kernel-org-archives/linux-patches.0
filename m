Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053405;
	b=Z+zulzvwqrdeGFtFfDv03OaLpc68iWDgg42smAdQ87CycDNTh3ZxiphjVFhxZT4CrQOj
	 i/85p38/+VuzZyrxzVmjA/Tmb8pctt0QqpM99OTUAvNMWBRvTmh0ZGBCccTmKsCMinAZL
	 POntMeZzVkbPBH867XAk7p5RWfh+CJqdmUmJJnT103rn03Vv3GK9Q23kLqTR9W9m8QSOn
	 0/XLHHSVYJAlqLrymDQEWzvReK13hLtUlP2WzyTUTVTqxEU5zcbsNTv4BKjTxjr+Wga2V
	 g2AaMmEHGvyjO5vZzdWWrDEGj3LEmXYjlv1LcmA0ERzr0pM6R8XbSM/Xvx+MxcMeXDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053405;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/Nqclar7jWeNz7yrnjfqHtXybZ+spiKRlNp6EoiaxMM=;
	b=cnATx/Drrz+fITkCpqwyuI8I6ZkFTmS7JKqWXX0zPHMV1IgeTlQEMd0AfMpRuobMqO0+
	 2V6qhXPcgrZ3WGAd/krZguteRiOE91gASvi3LC3s8k2b+yBIzmWWOR4AD/kcfD1rKwe1l
	 0xUr+NEwothdJUxgf85FgZ/+d1O8CVXSGPr0rHSS+WR8FwGIUmXvUi4bQYPMVZ1yem5Hz
	 11ox9k58jxPPArrHJuTQmgRjTrAhBKq/2vMuEMB+WuvRw1QcF5w9dCDaqnXxHclj/ItUv
	 8fa0QQAMH7FC3SSa28ZgOX+EKbMKc/0PqPOT/gxA0Eo9hxb4aimuSjoEURID2I6gfEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=puD9hZki;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF06606A31C;
	Thu, 19 Nov 2026 01:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=puD9hZki
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48E371F000C4;
	Thu, 19 Nov 2026 01:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053404;
	bh=/Nqclar7jWeNz7yrnjfqHtXybZ+spiKRlNp6EoiaxMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=puD9hZkiRxcoca2ZjZGtx6Kyhs27p/tRNYww+XkbPXGrOSaT4y/DQL9iv7/dwuRok
	 gYC+RBoVpCB/BFY4miURJwMEJs0G8Dj4W0EpeNX8sGfUX5V2KyR5xQ8VwK6WKCmPdT
	 EtdtRyEeWzq2YPFa0fY4CEnZ02eGsHKXb844zhAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ewan D. Milne" <emilne@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0909/2214] nvmet: dont return memory contents beyond valid data when reading ANA log page
Date: Wed, 18 Nov 2026 15:43:05 +0100
Message-ID: <20261118150048.695098442@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ewan D. Milne <emilne@redhat.com>

[ Upstream commit 29b8758b4700357909f06705a0c48c7a60c556d5 ]

The host side does not know how much valid data will be returned by the target
so it will typically provide a buffer larger than the amount of valid data in
the ANA log page.  The memory allocation used by the target does not guarantee
that prior kernel memory contents will not be returned past the end of the valid
page data.  Fix this to ensure that the SGL is zeroed before copying the data.

Fixes: 72efd25dcf4f ("nvmet: add minimal ANA support")
Cc: stable@vger.kernel.org
Signed-off-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/admin-cmd.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
index 270ba1fa23cc8..7c1fc6310599b 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -280,6 +280,15 @@ static void nvmet_execute_get_log_page_ana(struct nvmet_req *req)
 	u16 ngrps = 0;
 	u16 status;
 
+	/*
+	 * The header and one descriptor per enabled group are the only bytes
+	 * written below; zero the whole transfer first so the unwritten tail
+	 * does not leak stale kernel memory to the host.
+	 */
+	status = nvmet_zero_sgl(req, 0, req->transfer_len);
+	if (status)
+		goto out;
+
 	status = NVME_SC_INTERNAL;
 	desc = kmalloc(sizeof(struct nvme_ana_group_desc) +
 			NVMET_MAX_NAMESPACES * sizeof(__le32), GFP_KERNEL);
-- 
2.53.0



