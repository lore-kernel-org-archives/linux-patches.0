Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033904;
	b=f5h4iCezDjA12l16WMvXiYC3sMHcE/ppa4oXBkpZP0pnJw+d2s39sJg43IQ+iY2skMan
	 c5Fxy5TZ7Gb+exs3Y/0KkhPzVKTRL7oQ4CQXAsoRr+nviJQ+FQ043DPrg/tfNwQDa/gq6
	 wVEgQC8clRPk4PKliBAkPR5nmSWE5lKH0nYMMaoqWfnJ15QqCfPuE8k0qd1UkevgjHWhG
	 WY3RgVaDd8ll90+yXao/ZoJZc6yXe+Os++ZBzCzekxftS6QNBL5xGtSsaLHh+qfsNFxwk
	 rlWO48P/G7/0x0ZyWyGU6n8BXKvQzxZs5e6hcr29WwsGeN4XwFP1oAYuyT3TRh+Un/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033904;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ot3j0FQC3kABIYPDMvfHXZxJYTE7b0MkETVVxy2Qrp8=;
	b=UBDIXYRZx3sYVzQHWkzL+l7bM3Y7jzglr+qV6AxFcxTL7epyc7Aa5OcvF5XxSpH/xIix
	 r9KiZrOEiE8AE9rAg2OuUFqle36hkz/XpRoEr0Qvj1kuZvtc37Xbp+M9ca683CwIs4LqL
	 r5HgxRDJV88HhdATGyttS2bmaPeWS2hXbtBHhJPEoHgP+DhQsWgKOuxgWT6x95nbyLWoZ
	 moa9Q0yq06dmu0Z4WAsd45YResFlsxuHGQPR+l2kvIk2eykCyaLFURJAQl/Vb6nqpCp0W
	 Z3Dx98B0ywmqScAuj5ppd1/l0e2CFuNW2Y7O2nRtoPA7D9Cc0ZJlPtBQV+e+L7veYGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hGnAiWFW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0529606A32A;
	Wed, 18 Nov 2026 20:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hGnAiWFW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B0E21F000C4;
	Wed, 18 Nov 2026 20:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033903;
	bh=Ot3j0FQC3kABIYPDMvfHXZxJYTE7b0MkETVVxy2Qrp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hGnAiWFWA89MNW1CfZmZGCIzkP60lPfo22gS94I/4YpBjDJYwsODxK8UuqFucnvHy
	 0WpsDt/FioN9P5QTbazyEO2Wm79zC8Gce401mti+lNeHECltxUNV/y7qwBudToeF+t
	 H+1GjwkW1UR9CoVmymZbchu5AV6QLyIaclDO8bHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxing Hu <gahing@gahingwoo.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0180/3318] iommu/rockchip: Clear stale page faults before enabling stall
Date: Wed, 18 Nov 2026 15:13:22 +0100
Message-ID: <20261118150320.116520811@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiaxing Hu <gahing@gahingwoo.com>

[ Upstream commit b10d5920cafa292ee3cab9c20f813da4fe4f00b8 ]

Boot firmware can leave an IOMMU bank in PAGE_FAULT_ACTIVE before the
driver has configured paging:

  PAGE_FAULT_ACTIVE=1  STALL_ACTIVE=0  IDLE=1

Such a bank ignores CMD_ENABLE_STALL and never reaches STALL_ACTIVE, so
rk_iommu_enable_stall()'s readx_poll_timeout() spins until it times out
(seen on the RK3576 NPU, whose MMUs share this poll across banks).

Rather than special-casing these banks in the stall path, acknowledge the
stale fault with CMD_PAGE_FAULT_DONE before enabling stall, so every bank
starts from a clean state and the normal stall sequence applies to all of
them.  Banks without a pending fault are untouched.

Signed-off-by: Jiaxing Hu <gahing@gahingwoo.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/rockchip-iommu.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/iommu/rockchip-iommu.c b/drivers/iommu/rockchip-iommu.c
index cdc5b7170b892..d4d988b2ed5b6 100644
--- a/drivers/iommu/rockchip-iommu.c
+++ b/drivers/iommu/rockchip-iommu.c
@@ -420,6 +420,19 @@ static int rk_iommu_enable_stall(struct rk_iommu *iommu)
 	if (!rk_iommu_is_paging_enabled(iommu))
 		return 0;
 
+	/*
+	 * Boot firmware can leave a bank in PAGE_FAULT_ACTIVE with no handler
+	 * (PAGE_FAULT_ACTIVE & !STALL_ACTIVE & IDLE).  Such a bank ignores
+	 * CMD_ENABLE_STALL and never reaches STALL_ACTIVE, timing out the poll
+	 * below.  Acknowledge any stale fault first so every bank starts clean.
+	 */
+	for (i = 0; i < iommu->num_mmu; i++) {
+		if (rk_iommu_read(iommu->bases[i], RK_MMU_STATUS) &
+		    RK_MMU_STATUS_PAGE_FAULT_ACTIVE)
+			writel(RK_MMU_CMD_PAGE_FAULT_DONE,
+			       iommu->bases[i] + RK_MMU_COMMAND);
+	}
+
 	rk_iommu_command(iommu, RK_MMU_CMD_ENABLE_STALL);
 
 	ret = readx_poll_timeout(rk_iommu_is_stall_active, iommu, val,
-- 
2.53.0



