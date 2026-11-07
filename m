Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060817;
	b=ZTt7Jpc0ghRil2RH92LAW5Td+gMAmDgZHu7nCal2hQQD1OnoM+b4q4Crma49iO6+BDSI
	 C8H/5BIoEOwN2Um2TpzE0Q+LwKsLd6UDIaf47lcKHSc8tmAyPYUwiUoemy29lksjgeizP
	 VvMMNVelPegDoSvuobZU/k7jrqwXJZPus/MUeF7iVJgEP/ZxBiFNYzRN8Le7+DyYK3hUO
	 +XJVc2Rodd9jVGNVJ3f06fZFUOnBEQbMxj4RKQ2QaQPG2nQXukj/3pxEsoOg8OafkpRDf
	 NYDJRwGLO5QsLytJff0TMonryCaIxyYWIr28GBGTjcc2JDRq+VJvI4AK54/VJlA8kFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060817;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d7DDuTEWx3HyiWTze2CbmpO7V8ovGR5whu1DZg2Ol68=;
	b=yw0iXhKLYJ20BSMjxGRUCa02GM0NF7suS7/9pzmtXVTI6M3Jm3MnTre+uEFy4DYR/tRT
	 OkObnN77WY120OL0SYBLV5qRcDpa/FOrrnTuDkoQRix4AYHhs72ZTfDhKhe54PeONBp0a
	 NrvFjDWlMbEARCt/2e34PwkdE89xm1oi4w7h/U8X05AGTqEw2lX2igMe70MhWBqBCS9ZI
	 xty262Ep7ZqBgl8ZaS2ZVGvysmiDL9k/wa2cATlOB5A01TmZSy1tvTkTHfI5KgFllRXBI
	 kYBZHb53BtxHhTqZ9R2iT41YjbMpaPcY+W/gyIHORavSZVrG89HfEd8Gw4XTVf6+NCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ckMDXK4i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050C4606A326;
	Sat,  7 Nov 2026 14:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ckMDXK4i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A327D1F0089F;
	Sat,  7 Nov 2026 14:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060816;
	bh=d7DDuTEWx3HyiWTze2CbmpO7V8ovGR5whu1DZg2Ol68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ckMDXK4i1fOxMtEp7TiEqW+rG6Wj9rGeKchkgAToqoXKI/3SYCoiOe+lrPHutbHjB
	 24W6g3bKKS0lCoGwzOIXuNJl6Q3Zzl8Csxek4FuJWKBnK94mHwC/ikCabRqOCCRGmD
	 B1z9rL1Rn3FDMyty2zM+TKYxc3wGGQgsaMjWEB1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxing Hu <gahing@gahingwoo.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0215/1536] iommu/rockchip: Clear stale page faults before enabling stall
Date: Sat,  7 Nov 2026 08:37:11 -0500
Message-ID: <20261107135003.693649110@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7edc913b267c6..7ba806828adc4 100644
--- a/drivers/iommu/rockchip-iommu.c
+++ b/drivers/iommu/rockchip-iommu.c
@@ -421,6 +421,19 @@ static int rk_iommu_enable_stall(struct rk_iommu *iommu)
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



