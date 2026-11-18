Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018330;
	b=FYQGlvFL8GJDk+EM+HFjPjwwFnziAyWQEY45kTKB4IVgDI/LzQIDCyIijWDzXOZnR5u6
	 wu0HSaUtUhAvR8mw97Tu9GNphBmvwb+WY/2yKJV9eBudOJArVQ3QNI6h6OWBGi/wQNv6J
	 eRThOFfPUkz0mnNKvQ3Kni/BAPWP8dcDE5tA7LXd2cfcj6z/xDHb2IbunnHXRMX1yAtw9
	 Eue4yR7gyvPfz9s3hSGgrr8akXWONAnh3W3yg/1oSomLK0DmKjTPIUkM/jtNWGeXmBVY0
	 SW5wZzfapX5xV+cZliqcAeevVHZe1HPDjLYxz9ywyMiJvmbMbsMUq27RBdsfv4HCN7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018330;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sJfmzkL9jCrLDaB9B25wm/o7OpeldlpOxkeM/VmMNhM=;
	b=hdOZuEU1Hoh68C40TnLIY0BpRlgNgcppkDSkIHVqs0JKGpS1l78o4oBp3HOujoNzP7F6
	 1O8xsmEvefGV8PwtIS1PUpli2hb54WLKw+Ff2QvBjIK9onFPO54IoQzsIOMRpDRvYZe/O
	 EgKJgKxo+73ln+CqLONcCBAjcPd3OXJBTt6OFGS5Ig2MEqPExFJjqEGQUy7pg2F/bPq6u
	 qATBjnWGqtAU5bs6oLe1DQRkfnqwb3ucri+ouQkUs5Xce97ipr+vRWNx/azHChwcqXFuq
	 x6SFewf2Y3CwAo44hMoZJgIr+mdrcSRFvyQqmZGsydpFb7eb/k4LtEfq3+4tua+LRFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PMwlKAxC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA82606A31C;
	Wed, 18 Nov 2026 16:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PMwlKAxC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 958F31F000C6;
	Wed, 18 Nov 2026 16:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018330;
	bh=sJfmzkL9jCrLDaB9B25wm/o7OpeldlpOxkeM/VmMNhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PMwlKAxCW5Dg361zMpP8wcYWyhf9+ZoQsFwvITMdn7Ghxg2Hhp9HhbhAdwVwVZXQ/
	 zi1R4ib2EZaxCjH7ZvSt4+T+2pFZLpBalt2mmeLi3iHr8mCESUAr+vd982UyM0tC0e
	 gRWeFuM9Wf7U3BPKIE+OI0GgGhzsWgydH/1SiRVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akash Sukhavasi <akash.sukhavasi@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1202/2651] phy: HiSilicon: Fix error handling in hi3670_pcie_allclk_ctrl()
Date: Wed, 18 Nov 2026 15:40:42 +0100
Message-ID: <20261118150331.266574202@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 0b2dc590aa6f7..148763ed2c62a 100644
--- a/drivers/phy/hisilicon/phy-hi3670-pcie.c
+++ b/drivers/phy/hisilicon/phy-hi3670-pcie.c
@@ -480,7 +480,7 @@ static int hi3670_pcie_allclk_ctrl(struct hi3670_pcie_phy *phy, bool clk_on)
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



