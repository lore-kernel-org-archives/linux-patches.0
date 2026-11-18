Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057405;
	b=VKUJfZtTCn4pVx09o+L08tTSz2A2aDShe/qYqeE+KyNwWLiFRK6oPhqyeaU3wO7X5eUy
	 WgdkKbdww1AfCMWldJTMrnZWPMN+ahzSCvKau5x8tlIsczrxx5sCOkRX5Nl5/I57j8DXC
	 3wdkLde1+8z64hFKYR6HxzlbbEeMyIagVw6Dg/V+HXr4qmUl6sOaX+tLuxg4ShyYdAhxZ
	 zcRze7zVH5TEkjDcQ3UgptVwgWs4KCZsskp1CY9X46ivEN+tnOISohfd895s0W6B1wd3j
	 69rVAWEKfnFClK5zn7kqu7TJ2bnE8wnoWpjT/daEY1CyM/HUyLW5rVmhluFzffFt24Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057405;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lQs5bYnnAp3DhiXYZbQ25zPrG2gEwtlXCzhyEn//eoY=;
	b=JXcOIWs9VjTCqAON9Yo0lxOw2+xBHt1NxBtzVGVibq1SEcPRio5B0xd8wQVddHs8fmIE
	 CDg3eV0YnME6cRHAAqFWgCUH/MyrdNM8vT0AjMRKJfFVIaIg93zZP+S40DllEJUjZN0Bb
	 zcOSgfiwjzUwFBYLYr2rD2AgNe5Ba+/Kr7HXcsO5Skc2ilXk1u8ds7yT14C9VinP+4RMT
	 YVKAYEV4aedvFa1DeZVJm3xPWV9KhdcjfH91P3WQ3EnTV+mX13jcl2NyyPnLgQLElo+bt
	 1jEk35DjxMYKL76jiKBOX0vonzf6b8ytlNvlmNn/s9wMvG9Bda7QbE5OGbQ5adtnJJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JstKbGGj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79AE6606A325;
	Thu, 19 Nov 2026 03:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JstKbGGj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A8DD1F000C4;
	Thu, 19 Nov 2026 03:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057405;
	bh=lQs5bYnnAp3DhiXYZbQ25zPrG2gEwtlXCzhyEn//eoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JstKbGGjPV9VvDtU0KDooZSbZg7DlcqiFXN4MY6FoXt1PzVKCy2UKR0mh+WuZXC21
	 cEb1pGBUqEPhC6iZdMUokDPdghb9B1cHSIIPgBTYcsGGybzKBfCVulfmb/LQBFeG3J
	 jh0wt9lZsCoH8HUM3jfONzaDvpFHLpyO+xrzBSmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxing Hu <gahing@gahingwoo.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0119/1848] iommu/rockchip: Clear stale page faults before enabling stall
Date: Wed, 18 Nov 2026 15:35:57 +0100
Message-ID: <20261118145915.951619252@linuxfoundation.org>
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
index b6a656260dea0..d7ce44e4106f8 100644
--- a/drivers/iommu/rockchip-iommu.c
+++ b/drivers/iommu/rockchip-iommu.c
@@ -360,6 +360,19 @@ static int rk_iommu_enable_stall(struct rk_iommu *iommu)
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



