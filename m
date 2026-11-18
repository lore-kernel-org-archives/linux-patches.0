Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043400;
	b=QnBrqRFsVph8qo+KYlWyc3nTazXmkvTOxf+pTObzl2TkqwgwD4R5Stux4aOhPUegkH1w
	 7QSRdDqrpdE7d0pvnEef3GTsH30e5ygJVs3iHxXdisJLhxM72pYknc5Tb/dCCXwQabliK
	 e0YqkKzEIC0Ns2OUtWar11XTxMJos9oQX4dh7oA1wPOUUuP1R9K4lW1XA7Rgy3jutoyA1
	 KhGXYzDyGOFA3XRXoHfsoJcygOTXCoQS1jglDD3ODLRVaSsLwky+QBX/My2gF6fGTN2EN
	 BScfjU3M9Yi7EZshsR1k1f2ibbmQT3+jUT/rb4OeT8ECOsKCN22/bBCPLfOWh0Xc2/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043400;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wCSbXer5b/y/m8Imyl78A6i7/9UznLteK/1ZJ/jJz6w=;
	b=n+HKliuqXAkqdW9ZqrzZnYq8wkgYQQqr09tznKUmPFWabgy4Bjo7xpMQ/GX4bfrK2f4k
	 gYELY4cLfuFmXfQ+vSC61L87GGd5ajecb4W9RxP8GU//b1cOnGKPXhPVkDyY4n+/tco2b
	 wdYVK7PeBNsP9jZvv/HErccX/d2uaTmTTkq9naUv0Jqw7Df4QyqhnnGrAPsqeTzfENHPB
	 fJs/xPE6ed6w3Z30Gvcq4NoZFXZc9ua/x+K207GTHihWloMDGL4zQL3S1EjMY3TuImIFJ
	 NZjBOk93S531zjjTTmt6APG1C1jYdL5Fwvglk2gkhapcSghnzc2gF+KQYd+Wo3hoIrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JYAa0sJx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B28606A325;
	Wed, 18 Nov 2026 23:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JYAa0sJx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2E7A1F000C4;
	Wed, 18 Nov 2026 23:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043400;
	bh=wCSbXer5b/y/m8Imyl78A6i7/9UznLteK/1ZJ/jJz6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JYAa0sJxIEGeer0aXO6pEbKNegFRgtbvD9/jmcjlte3ZDJE/O9XADiZezJ+Lu6MwM
	 sVryoGoZLi+HeEAUMDTxiWYpRZBhIBnXpFXznvgoOtf0wP/rTnfdRJurl7iqI32ipc
	 ogf+bjReZcDYHn470mKW4wPnl8BmdWTH+SyTONf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxing Hu <gahing@gahingwoo.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0155/2857] iommu/rockchip: Clear stale page faults before enabling stall
Date: Wed, 18 Nov 2026 15:19:49 +0100
Message-ID: <20261118150206.929315989@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5ce951bbd69af..f7705f01638a1 100644
--- a/drivers/iommu/rockchip-iommu.c
+++ b/drivers/iommu/rockchip-iommu.c
@@ -418,6 +418,19 @@ static int rk_iommu_enable_stall(struct rk_iommu *iommu)
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



