Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064817;
	b=WQO6uXHMLzrrkWRmxSAreZG6gXM9I55aofIwONY2BAKCMhLSBm+ok8Cvczh5tRvEMI1i
	 4I63+ZvWyZ9Ne0iPi1TTBc25I7t5CXyuO/Uh8dtMNqN/cKlWa/5jj/YpcLzNLhBGdfJbx
	 5jFO6QFFaXiAQTIGJ/Ldzf1Gf60ZjdxqCIL5jX1JepELmYiZJotl1ZEiBJ21N60JzrucY
	 vzTTL9acF1J2QxoV/tfc+hQDdf8XwfbtSnljB0M4b84TSvIktlWj+2On+sieLQcIheunV
	 6dMeGCQNzHsmyxF8Cta5IyHmde1b/niqwQUYkQAQsp/Ayc5liyvzzIrLFOCeN8m6rcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064817;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U4OHWakrCB4HKye0i92gssJM/emZZCO6gIfwY4E+kfw=;
	b=RXwi/U6ECa6PGmeutOtyj6f7KiAULl1HnWpta2TzrOb1hPv+/lbmSYQWaacBZ54rH/vM
	 LGrl3cnemHjK1uTSnwtvS9/VD84fNnu1hZmdWx+qiqjsl+lBcL5Xj+4628SynvHcCww2X
	 uyr/4zT+M4o/5Y5mnfFC5XveUZQn3B78nJwND01Pc9LW0/mn29Pr1y6DFK/LgPM/+NxGR
	 M01kh+TSjACZ1x7DxmBr7Lp+BH57KVk0fKNA83bDLFGOOpeEt6EgrEsd/rfbsigPzCApM
	 gqfrgSb/JVMTLBtHLrgtWA36f1IObU1kqdToAK/ZzAE5RS3Lg49VkwF27QwLSl54JJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SyXDggxs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A3E606C03C;
	Sat,  7 Nov 2026 15:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SyXDggxs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 463101F0089F;
	Sat,  7 Nov 2026 15:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064816;
	bh=U4OHWakrCB4HKye0i92gssJM/emZZCO6gIfwY4E+kfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SyXDggxsYeiCXja4ihtGcrJznzlqt+YF09gIYEVUMvaOj7q0DkEp/dyY608Ndsex8
	 JNpIquVa96mATl3dx7O7gLpq4cwiEHXTSh214jn27N4S8UuoaM5aqHkslig0Vvzuhe
	 VrpjcQvMsOUOQ0R1v2IZBwXxY81HpnbWn2uhokx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragan Simic <dsimic@manjaro.org>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Geraldo Nascimento <geraldogabriel@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0715/1257] PCI: rockchip-ep: Do not attempt 5.0 GT/s retraining
Date: Sat,  7 Nov 2026 08:50:11 -0500
Message-ID: <20261107134959.007815791@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Geraldo Nascimento <geraldogabriel@gmail.com>

[ Upstream commit 7f173bfa6d42742de4ab647e001232c1165ab28e ]

Drop the 5.0 GT/s Link Speed retraining code block from Rockchip PCIe EP
driver. The reason is that Shawn Lin from Rockchip has reiterated that
there may be danger of "catastrophic failure" in using their PCIe with 5.0
GT/s speeds.

While Rockchip has done so informally without issuing a proper errata, and
the particulars are thus unknown, this may cause data loss or worse.

This change is corroborated by RK3399 official datasheet [1], which states
maximum link speed for this platform is 2.5 GT/s.

[1] https://opensource.rock-chips.com/images/d/d7/Rockchip_RK3399_Datasheet_V2.1-20200323.pdf

Fixes: bd6e61df4b2e ("PCI: rockchip-ep: Improve link training")
Reported-by: Dragan Simic <dsimic@manjaro.org>
Reported-by: Shawn Lin <shawn.lin@rock-chips.com>
Link: https://lore.kernel.org/all/ffd05070-9879-4468-94e3-b88968b4c21b@rock-chips.com/
Signed-off-by: Geraldo Nascimento <geraldogabriel@gmail.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Reviewed-by: Shawn Lin <shawn.lin@rock-chips.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/d994f8fb3481bbb8f3972f117334a6e8aea383fb.1781622998.git.geraldogabriel@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-rockchip-ep.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/pci/controller/pcie-rockchip-ep.c b/drivers/pci/controller/pcie-rockchip-ep.c
index 799461335762e..9ebc227a1ef84 100644
--- a/drivers/pci/controller/pcie-rockchip-ep.c
+++ b/drivers/pci/controller/pcie-rockchip-ep.c
@@ -553,19 +553,6 @@ static void rockchip_pcie_ep_link_training(struct work_struct *work)
 	if (ret)
 		goto again;
 
-	/*
-	 * Check the current speed: if gen2 speed was requested and we are not
-	 * at gen2 speed yet, retrain again for gen2.
-	 */
-	val = rockchip_pcie_read(rockchip, PCIE_CORE_CTRL);
-	if (!PCIE_LINK_IS_GEN2(val) && rockchip->link_gen == 2) {
-		/* Enable retrain for gen2 */
-		rockchip_pcie_ep_retrain_link(rockchip);
-		readl_poll_timeout(rockchip->apb_base + PCIE_CORE_CTRL,
-				   val, PCIE_LINK_IS_GEN2(val), 50,
-				   LINK_TRAIN_TIMEOUT);
-	}
-
 	/* Check again that the link is up */
 	if (!rockchip_pcie_ep_link_up(rockchip))
 		goto again;
-- 
2.53.0



