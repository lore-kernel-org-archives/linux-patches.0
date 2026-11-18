Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025192;
	b=d0aR3X4UYGoa+a4Mf9hMi2+Mj9NmnWBOvf7M3Lu629Q925P5Px3PGbzXmbJnLOffvW4A
	 RitUK6hL/PDo9tLtHJ2EdLsQObFgL6/217sBZOc8BGIAzkqhbP06fKgUAFWzFAcy+bp13
	 Rkj0Q4QEf3ceCW6viUzODicTyDvuPmuU6gJN1MUoNB37hXgJjMWKF13qDLAfDLbs1B1ox
	 FCVnWSAPfSN47tXqkqCjCJONlamhZx/bLf6lc7hFRftL8XzlYH54wi6wLvZ2ATSfEBnt/
	 3N2w7JPCymETgV0m/s3jThBnVg/VQxqnfbGG1d6aEUKRUc7vMH6LTLKlfl1VnYqYa9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025192;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZS10oDRrKjDfOWntWq+HnNH7ieRJIDsBICMWdKuNIBM=;
	b=qFVlwGJXQp05FGjzj0UTT0x7W+xtJsZ9xDdVh2gL7gN9lLQWrExjam1o4BZYi6PQ0vnK
	 jB/+zssTjuTSynlXN/8hti/rN/XFG89fZacHmc4dqmeMPJGMi+tdjBJLC1pWq4XJJjMaK
	 1ZEUbCb51tpAuAnDvu2joKx5VasYVzYEM2ZIj+3dhF8f3FD7hxAX3piuKA+Vs09ywfaUp
	 F5i4B0ObCYhw7DwxgIho+YNfDrHeGOoIbMrhyxSv9BK2ajicl0o5gj+/vFphRklzSZRNh
	 MzyrfFbw57rVQZh3X/kN1/cMBDf+NiOKvtGUB+aE9O5kc/Ek6Nz21Ywee8oscO83NAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wc2c4c4t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD65606A320;
	Wed, 18 Nov 2026 18:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wc2c4c4t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A771F000C4;
	Wed, 18 Nov 2026 18:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025191;
	bh=ZS10oDRrKjDfOWntWq+HnNH7ieRJIDsBICMWdKuNIBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wc2c4c4tCOwVv/iAHLPcf7Pv43i7NmvuCABwKhjwrkn26Z+SeMcu8nnc1qL4uO6eJ
	 pbQuHWxPxORUn0I/BgKCMCVNJYRnh40VjRXoFP4U0lGnF128vcEZNjas7J4tK6vCCP
	 a+H/sGnoV//48drsy5XkvXLjxhBz1doRSnSmW+MM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akash Sukhavasi <akash.sukhavasi@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0992/2151] phy: HiSilicon: Fix error handling in hi3670_pcie_allclk_ctrl()
Date: Wed, 18 Nov 2026 15:45:27 +0100
Message-ID: <20261118150158.590172975@linuxfoundation.org>
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
index 35e6342797947..acbe370ac2ea3 100644
--- a/drivers/phy/hisilicon/phy-hi3670-pcie.c
+++ b/drivers/phy/hisilicon/phy-hi3670-pcie.c
@@ -481,7 +481,7 @@ static int hi3670_pcie_allclk_ctrl(struct hi3670_pcie_phy *phy, bool clk_on)
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



