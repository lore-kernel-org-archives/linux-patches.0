Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040649;
	b=FAhNikBMcSIkKDSPRIgKqd6POuBFHQXpQG9vyvDOKTTkNdliXq40cG1ef2Oru29me2CC
	 4Jr2I1HFyuQ9oBBF6NnvMxGaDr1Zu5rkQOiwVXeH2rpebHvKwFTTXrYBEevcrkW9zjfrz
	 WPLoHdsyn8NK0vVn+nZVMOComW8MSEjOrR0EOZFk52K5v5d4KdiYjljQsQEA50gZJg2LL
	 UIxXhiCtLeyH9e2bDzHoeNQtVgBzRzfFMxNl2vUWiGEKLYcweIK8/mtJTppWKQBr6+vD+
	 VQ+QqNP65bfTwlNTkGy7eyjMcqRMI4NdTuvWQd25/JmlOLE7mOuGzpz3JPAh8qXCCNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040649;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c5yCH+xYbKXDYymLhsvy0YycQJbGIQj9J9Z6PMxtZ3I=;
	b=l75oI6EMKl156lYiRlSw/r8Km6sMx/Xzk7Q/gd9W5Ry+Fk/m3m2Wx8lSVbyLNq37YObr
	 ldm/n4l1LXbPttHpPjGmpM0bIbtw84NWPK/tl9g1KeP5beguaktjHLueu9j5ma0Hq17qh
	 IJDZW9RpyEST90CX2BGkpGVofVEvHFSivP5E6YpH/zww3twrgdbjUUW4OPAXQ3PskMMDj
	 WGe/Hkx9nfiJNZTzaTxz8sPygTtP7GG4+vrSf2KiUCFDCiZ4Lo/JWflmLUWlZ99zTWKoB
	 TYNEooNrw3YsygZ3N0waNPL41GQeO6KWiCs5ypZ4UHZvRKh4wBCnvcAUvpfAxXlxN5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WOK18FBx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66986606A31C;
	Wed, 18 Nov 2026 22:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WOK18FBx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7DC61F000C4;
	Wed, 18 Nov 2026 22:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040649;
	bh=c5yCH+xYbKXDYymLhsvy0YycQJbGIQj9J9Z6PMxtZ3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WOK18FBx/GfS7wBOz7FFeAmP+gNRNEajV3opW3RiVJglzcS6A9Q44DfoUhdaOzs0I
	 dsz22r9uHBEQHyzJuwgdYdtav3e9MiLX5GpV3u5wCiS16XRNLA8DOnSCgOIOXMhwIJ
	 iFOuFhcBIVrjdAYl2+vCZxYLKxUE9gdNYILc71m0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akash Sukhavasi <akash.sukhavasi@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2531/3318] phy: HiSilicon: Fix error handling in hi3670_pcie_allclk_ctrl()
Date: Wed, 18 Nov 2026 15:52:33 +0100
Message-ID: <20261118150437.265333116@linuxfoundation.org>
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

From: Akash Sukhavasi <akash.sukhavasi@gmail.com>

[ Upstream commit 7540fc0a4f667b6773d10753a602a42a3113087b ]

When hi3670_pcie_pll_ctrl() fails, hi3670_pcie_allclk_ctrl() returns
-EINVAL directly, skipping the close_clocks cleanup path. This leaves
the PLL with its power-down bit cleared.

Use goto close_clocks instead, which disables the PLL and propagates
the original error code from hi3670_pcie_pll_ctrl().

Found while investigating a Smatch warning.

Fixes: 73075011ffff ("phy: HiSilicon: Add driver for Kirin 970 PCIe PHY")
Signed-off-by: Akash Sukhavasi <akash.sukhavasi@gmail.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260708-b4-hi3670-v1-1-f9236f3e585c@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/hisilicon/phy-hi3670-pcie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/hisilicon/phy-hi3670-pcie.c b/drivers/phy/hisilicon/phy-hi3670-pcie.c
index 6903148367dfc..e99ef06d41c81 100644
--- a/drivers/phy/hisilicon/phy-hi3670-pcie.c
+++ b/drivers/phy/hisilicon/phy-hi3670-pcie.c
@@ -476,7 +476,7 @@ static int hi3670_pcie_allclk_ctrl(struct hi3670_pcie_phy *phy, bool clk_on)
 	ret = hi3670_pcie_pll_ctrl(phy, true);
 	if (ret) {
 		dev_err(dev, "Failed to enable pll\n");
-		return -EINVAL;
+		goto close_clocks;
 	}
 	hi3670_pcie_hp_debounce_gt(phy, true);
 	hi3670_pcie_phyref_gt(phy, true);
-- 
2.53.0



