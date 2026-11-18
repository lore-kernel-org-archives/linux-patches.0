Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061001;
	b=ZbRzhiKQhyXysoeSjcfXupG53CWVyLto7efznT9hPDysrB/GcP03ZZaGWx9X7YaiJr3k
	 tG7rkh1w+DbcpOJ//Od7Mr/ope3aHLi3FwFWn/v6ESGIJtjfh/zHnRip6WxWSmrfJ6W2H
	 vpWa2aaOAgWTTmBw7fY4TjiuOYNjjx+5wJOxM8L4jLhJYrhRMpa9h9lx5UkN08X+0uB4F
	 GPKKsioZgLbgTrMf9b0BgQlBeKn3/zHBaqC8ljAQu9uWNviv8p40B+41ppUfy7x4VETzX
	 PAJ6GFF28qss5TKfC/dF6waNGjBp1Ed47jSbx/WKM+/aarrieqslPL1Euh3Aj7B4awQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061001;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SCT/ZiGAIuu+/DEZpDWxD51xtOUBeTGitpWM8LcAkLY=;
	b=alAm4pk4bvLJf9B+HZ+TEdUyt1N5QVQWAffegIrfLdYLGp4Fw3PLpWGZxdo1aB7Mpo8U
	 8y6UzYhSgh95GRd9S5Nrf/m5T3fNyMurmsGA7dvshZ2StiRIyS7P10a3XTNItUuQc+/TH
	 3K4LFCL/SHLgyxcq6xjKUF4j2OcfrQVtkRQoDzVm88sq04EkuSFq04SB0G196HdrytWBE
	 xYAEJ/Gxo5ZQ38UMLl73hmeJsQ/HSw61jSknHikfky4IQ3QBlW3TjiYQIwf1ECmfs2pMz
	 mTfVKdh4ItyHoN+TaVg+LWcU6Nbe8Cea5FCkBhfAayu3RtYcGBKwaz95KNPrZwgpETA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cLIkltWP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D97F606A325;
	Thu, 19 Nov 2026 04:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cLIkltWP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C7051F000C5;
	Thu, 19 Nov 2026 04:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061000;
	bh=SCT/ZiGAIuu+/DEZpDWxD51xtOUBeTGitpWM8LcAkLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cLIkltWPodX8mzblhf9nhPvb63IT5aN6Ps/L45YoGTlV6/mj17khx3WHkvDufoLXh
	 aqpWDDA4qlEg7Qpr1Hf/H0k6eODZXKoqJv8cUCUT0UDvjHq2NHRDxBhLSX2fmfyi7M
	 wXCK7ZdFilbp6Z2eSf/0WiEDC6/JpgZ3pm71iaqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1398/1848] RDMA/bnxt_re: Detect wrong sge_len passed for inline
Date: Wed, 18 Nov 2026 15:57:16 +0100
Message-ID: <20261118150018.035619475@linuxfoundation.org>
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

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit 81551ece0864c346080d241719d458c93f0e7fc9 ]

Avoid handling wrong sge_len by adding extra check
to see if the passed length is more than the inline
size supported.

Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 822610f87c135..9454829290b62 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -2515,8 +2515,9 @@ static int bnxt_re_copy_inline_data(struct bnxt_re_dev *rdev,
 				wr->sg_list[i].addr;
 		sge_len = wr->sg_list[i].length;
 
-		if ((sge_len + wqe->inline_len) >
-		    BNXT_QPLIB_SWQE_MAX_INLINE_LENGTH) {
+		if (sge_len > BNXT_QPLIB_SWQE_MAX_INLINE_LENGTH ||
+		    ((sge_len + wqe->inline_len) >
+		    BNXT_QPLIB_SWQE_MAX_INLINE_LENGTH)) {
 			ibdev_err(&rdev->ibdev,
 				  "Inline data size requested > supported value");
 			return -EINVAL;
-- 
2.53.0



