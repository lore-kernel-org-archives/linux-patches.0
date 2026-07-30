Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214CD43B4B8;
	Thu, 30 Jul 2026 14:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421216; cv=none; b=AF7wHlQ3kktOWCQ1w+aBwggSmytdLWWoYQMMoNlfh3wVEY2lhsG4KVQKmc0kHsQuTxCRcqCWkp+CWeKdpbcQEBvMSqVkBceTRfENeETGfQ7NIsHTrdJaHBlsvbdyenwRV0N//yXN8CVqxHGeHzsmOSKfiwTrUW4wUofIcKYedi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421216; c=relaxed/simple;
	bh=lffVx+IrTIN9Nhsry01PYmahVdgNKdZuO1fulOkSj94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FwO816yTlSxgyu74DeygrhMFOsUm5dg+nNAkKun8OMyc4md9o2hu+LZjcbFb1MaZ8ZxsGZG1J7hygVvHnHaB5fSRwjhSOEZroMdL4ZD2KaO95M2YREVdj1aNR8psi/mFpz+yQeFxLt3QSsyqYqerU8laVtpl/SOEC5PEyeVLhH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QKZk5slw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QKZk5slw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D59E1F000E9;
	Thu, 30 Jul 2026 14:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421214;
	bh=VOaJXnvdDWYDmyfx9oNODL5K1PksvQvFSpX1MfZ5M/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QKZk5slwXh+ALiQByL0iGS1xKMAeRV82ST0nRei0EhGfgIXxS8jRyhWNKGYMlVkHU
	 eajI7OVGuLuMAD7veoxR6+eA3jskRRao3JYXon24IQzhLtkbcdC4yWaUai4sTKVzin
	 FGsL71VN7QihR7QFusVgolz8jm/I0XX6CMnQqqzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junzhong Pan <panjunzhong@linux.spacemit.com>,
	Yixun Lan <dlan@kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 029/744] reset: spacemit: k3: fix USB2 ahb reset
Date: Thu, 30 Jul 2026 16:05:02 +0200
Message-ID: <20260730141444.903396327@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yixun Lan <dlan@kernel.org>

[ Upstream commit 1ca22c6aa006b05143367268066fb74e32cfe66b ]

According to SpacemiT K3's updated docs, the USB2 ahb reset and USB2 bus
clock enable bit was wrongly swapped, the correct one should be:

Register : APMU_USB_CLK_RES_CTRL
bit[1]   : usb2_port_bus_clk_en
bit[0]   : usb2_port_ahb_rstn

Fixes: a0e0c2f8c5f3 ("reset: spacemit: k3: Decouple composite reset lines")
Reported-by: Junzhong Pan <panjunzhong@linux.spacemit.com>
Signed-off-by: Yixun Lan <dlan@kernel.org>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/reset/spacemit/reset-spacemit-k3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/reset/spacemit/reset-spacemit-k3.c b/drivers/reset/spacemit/reset-spacemit-k3.c
index 9841f5e057b2a0..2e87f320cf1184 100644
--- a/drivers/reset/spacemit/reset-spacemit-k3.c
+++ b/drivers/reset/spacemit/reset-spacemit-k3.c
@@ -112,7 +112,7 @@ static const struct ccu_reset_data k3_apmu_resets[] = {
 	[RESET_APMU_SDH0]	= RESET_DATA(APMU_SDH0_CLK_RES_CTRL,	0, BIT(1)),
 	[RESET_APMU_SDH1]	= RESET_DATA(APMU_SDH1_CLK_RES_CTRL,	0, BIT(1)),
 	[RESET_APMU_SDH2]	= RESET_DATA(APMU_SDH2_CLK_RES_CTRL,	0, BIT(1)),
-	[RESET_APMU_USB2_AHB]	= RESET_DATA(APMU_USB_CLK_RES_CTRL,	0, BIT(1)),
+	[RESET_APMU_USB2_AHB]	= RESET_DATA(APMU_USB_CLK_RES_CTRL,	0, BIT(0)),
 	[RESET_APMU_USB2_VCC]	= RESET_DATA(APMU_USB_CLK_RES_CTRL,	0, BIT(2)),
 	[RESET_APMU_USB2_PHY]	= RESET_DATA(APMU_USB_CLK_RES_CTRL,	0, BIT(3)),
 	[RESET_APMU_USB3_A_AHB]	= RESET_DATA(APMU_USB_CLK_RES_CTRL,	0, BIT(5)),
-- 
2.53.0



