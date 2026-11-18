Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026943;
	b=ijd2qkrR6o6yl0DFaSO2LSg/p1H+/i1Cs9LXeEQO+SBSF5eGMf4nIthKW2wb0Bl28X7e
	 0S8tPvfDCPLME5TmUw9EgvChO208NxmbyyE1zdpWgUsbHCsZBIS10eFKLAnzcsqnLMb+0
	 pMCVGK5Jyhdy+ZUdQ9mUlrcqIJ6SsDE1wR/8wrYHbfina7fz0C2D+52Ob0R0+U0hNSMUg
	 nN4rJZzJxDvky1dAh/qind3VKmD0Xbgil4GfboToSm1ThRe4G6tvk8RvNq/kODnBFPxxf
	 1/sSczV1JKiZ6lFg5r9CrN8zOLZoVI+DyHRxwLSPIWhD+gu0Hadv4y3CfQf3+Izyuwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026943;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JBB2NVpa/MvuaAsA6BsK7chEGP0Rw4XbkEiL8S/Dnto=;
	b=sMFOaqK9vQ9KjxC1H5mrrSqVHRAtiBKh3ORvZ2fJ1vKfSOo408JNp/z3hF60R2zO5y3j
	 4oBO40yTQuTPZkBmLVFfMeBTjBVxURtQSCopmhmBtecbbvQV/zyR+pdnHfmHyI0DMFsaU
	 fzr8t5m7bCXOgsGAf8Zy/3A7K0T6O4gD5KFPhIyFKGuh4ZBbRrvV+dT0OHW/p9YBLyvxS
	 WJ/5M/thsU9l+eLTjraLN69oVLG39KMlHFM6PWHh5GWMGn0dodqbmkBeRKsoGO4expqKg
	 pE6CC0GZOvl/7AVY/zA06QySIjLA/n+C9ThLjNItfXwJ8Sx7fLy4DwtAw1LcYRMK+Kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="fYi33j6/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14B1606A320;
	Wed, 18 Nov 2026 18:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fYi33j6/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBAE91F000C4;
	Wed, 18 Nov 2026 18:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026943;
	bh=JBB2NVpa/MvuaAsA6BsK7chEGP0Rw4XbkEiL8S/Dnto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fYi33j6/kJKCsQ1CArH+xnyMVpMtjWggr7kug2lDhBskpb/JI0pfCTnsvqQNvoZyy
	 W8CZKk9zGL8fhbeAEzwif7PFkPNrAkdWHmJlVJW/6vByLhURhtTpQnk0B5ylWrW2bk
	 2BDSELJVaVqeXBDWZwb7NawUz0lykUEn/APiuCxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1615/2151] RDMA/irdma: Fix FRWR IRDMAQPSQ_PBLADDR field population
Date: Wed, 18 Nov 2026 15:55:50 +0100
Message-ID: <20261118150220.707837892@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Moroni <jmoroni@google.com>

[ Upstream commit 59df57262e6fa9e6f4aa76d6d324134777c702a0 ]

Previously, the IRDMAQPSQ_PBLADDR FRWR WQE field was being populated
using a mask that was right-shifted, whereas it should have been the
address being right-shifted.

This ended up working fine in many cases because the lowermost 12 bits
are always zero (the addresses are page aligned) and the uppermost 12
bits are usually zero too, but it could break for DMA addresses that
are wider than 52 bits.

Fix this by right-shifting the address instead of the mask, similar
to how it was done in the original i40iw driver.

Tested with NFS over RDMA with some added debug logs to ensure it
was hitting both the direct (single page) path as well as multi
page (< 512).

Fixes: 3f49d6842569 ("RDMA/irdma: Implement HW Admin Queue OPs")
Signed-off-by: Jacob Moroni <jmoroni@google.com>
Link: https://patch.msgid.link/20261015161756.3078300-1-jmoroni@google.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/ctrl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/ctrl.c b/drivers/infiniband/hw/irdma/ctrl.c
index 69ed8e47d81ae..7e56d5e618962 100644
--- a/drivers/infiniband/hw/irdma/ctrl.c
+++ b/drivers/infiniband/hw/irdma/ctrl.c
@@ -1729,7 +1729,7 @@ int irdma_sc_mr_fast_register(struct irdma_sc_qp *qp,
 			 info->first_pm_pbl_index >> 16);
 	set_64bit_val(wqe, 8,
 		      FIELD_PREP(IRDMAQPSQ_FIRSTPMPBLIDXHI, temp) |
-		      FIELD_PREP(IRDMAQPSQ_PBLADDR >> IRDMA_HW_PAGE_SHIFT, info->reg_addr_pa));
+		      FIELD_PREP(IRDMAQPSQ_PBLADDR, info->reg_addr_pa >> IRDMA_HW_PAGE_SHIFT));
 	set_64bit_val(wqe, 16,
 		      info->total_len |
 		      FIELD_PREP(IRDMAQPSQ_FIRSTPMPBLIDXLO, info->first_pm_pbl_index));
-- 
2.53.0



