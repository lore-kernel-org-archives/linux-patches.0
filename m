Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048997;
	b=Oa4JD6yJfwN0MV4rnIwKlINUfKHXkwZz7Ssoo/uoysYahu2LwYPJy2EUc3Vm/vJBtN7z
	 zSj16eoq2pXnsjtDYrqVIopE2Cj8Ig0hTeAeRdXHzUYcSwQc+agfI19dDvGVNRvNEZrQw
	 8bBiO5jpOHhtFPkxVdO1+pL3Jrjt4ZxsbClfZxIXjb3mnX8q/tkC/NjjdlW9n6dm13rju
	 ZMERIbBm7+VM45YfGeDPxM7ymp7pVwVPcU/13TBZoDAWam7a18Yg64oSwNs4R14MjlFTL
	 cXzHuJ2ONcCam5RX8EUp4Hx/Y+6+iHBPzHJLFHS/zvqjG5R1zw9Bfk/d/yij+TuAJlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048997;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lfkF/EGQUnghWq6C1XacKyneUnauCv0qtTnVjquFD2A=;
	b=3XCb0AdE0hRiMILCwLYqoCQ5oVugsTwN58BdwhkiMHlSWclssCe1m/C6tUalS5wO9TZD
	 FEzMTYvwOvRbzit9Ynuiwct5ElC7etzpF7iW07/V5/lGHyecMd1F1zm7LyAJd22EudyQ/
	 0Cc2R5UMZtaEtI1qQpC9JhC0BBmzuQTeBqAOX4cyLIW32nc4bnyqREIcKaphC1Nlo9fL9
	 Xlv7C0YdHWmk0fw6fPmTRvEYt2JTQFLhvcEtwX1XR4+syig2gqxsWb/plNzcD/I3ZDGzA
	 EIJxh44jC5Cg5b7AD44hztCYRwpGfj+2IsmAmJj8KNuc6gwPsp4WSNpGZCs680C750Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eAkB8tF0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2BA606A32C;
	Thu, 19 Nov 2026 00:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eAkB8tF0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D211F000C5;
	Thu, 19 Nov 2026 00:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048997;
	bh=lfkF/EGQUnghWq6C1XacKyneUnauCv0qtTnVjquFD2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eAkB8tF0Cg3LUhSzHmTn+sq2NEhKHIT1hO7XEuUBw6U/S/YiQGorUdPyw7GiWc17M
	 uI5FANwKEaD105KAaJJ560mLRR6JH7r1BJYxxJPmG0oCg8G5yGS+BzyzCIZodwRcsg
	 HwuiABN6tNoH27kZJ6AKubNMTLZDkrE5Bx5ZoRKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akash Sukhavasi <akash.sukhavasi@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2195/2857] phy: HiSilicon: Fix error handling in hi3670_pcie_allclk_ctrl()
Date: Wed, 18 Nov 2026 15:53:49 +0100
Message-ID: <20261118150320.452023171@linuxfoundation.org>
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



