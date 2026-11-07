Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063389;
	b=c6tp/3wHTE+QJb2rpuQRoXpgUYET9PFLCxH7kt+R3tf/T5DhmdP2ZITLkklNHT8RQY75
	 3tmXzJt3xV4LSMCjjqIZu8FOvem+5t2K7xJmERhlFKjLlSyJ/zhY93hC9H4pcI6nT9Xq/
	 PS0v04rUGGmlJYpqkSdOwVo8ds/lqneQOW8G53OtRnx0ksF8dR65KvY9ZCEUpj8XWQNrI
	 fGyC7Gnrq0VF9USJbRseX7ELAfmnkbjIiuDvFGE7xpsYpBkHPReMTYooYpg7d7b8iDGNX
	 YNaiSvCvGWx23vmIeOCRNALbSlg4YJABSHQAH8/Oh6YPA77ckFa0ZBS/qewNSOa9Gjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063389;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Oj5EmhKniG4v7pIH37zf8pzK3AV38ZNptF2hWXWyQ6E=;
	b=pBOTEhq6So6MlG5TnlnnSgrOHuJLyh5RhQZ+PTv41FNBtPHAYQ1e0uBEBa78peAJ7Phu
	 fUaDbpu7KFtpl+VJGwDMSRbmGU0fMb0fFcJJ81+cSa83lCP2HmMItVux4F7rX73+6zTG4
	 oANgp6e9zA8YdJ8vWEtTCex5UyGJaUvcd4YhD9CLGjlYpElMnFfXB9IS+fX9m5E886WCk
	 8sPL+JdoeI10T8PezE7TbgmH1a9YJR8hG8mM5mzBt8+GR7kfDWWBf52mUsbcmV3cl1Xwi
	 TFXA9an7rJyCQo8o5cF0E1YrD2Beif/RqCt1uaCtfWvWsd688MR9jYqJT0Ch5FRIilw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GB1B7bvc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2310F606D818;
	Sat,  7 Nov 2026 14:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GB1B7bvc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB02D1F0089F;
	Sat,  7 Nov 2026 14:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063389;
	bh=Oj5EmhKniG4v7pIH37zf8pzK3AV38ZNptF2hWXWyQ6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GB1B7bvcF4ZsR4g/pPi7IRPhc01hSTTDuK+gTjUXxDfiet3uF1Kwgbrv7GfNB510q
	 r0Ye37XVDAXUpdRpEZLvZB3N0MYVtmVPl9wsY6j126mwP+vm6TlOZ7D8Vuu+5Elhxs
	 EIfVk8O7EtPDt4pNf8vsOGfFJ9huavsQV5bQaIfY=
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
Subject: [PATCH 6.18 523/869] PCI: rockchip-ep: Do not attempt 5.0 GT/s retraining
Date: Sat,  7 Nov 2026 08:53:25 -0500
Message-ID: <20261107134911.240693726@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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



