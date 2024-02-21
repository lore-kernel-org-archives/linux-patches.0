Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9130D7D3EE;
	Wed, 21 Feb 2024 14:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524545; cv=none; b=DhMDYv5vmu7PSgOa1gIKTVTLNaPcWFdRM2Gqa7yWt3RhJiimJsbHw8IzQspSCYNnz8gFGA1fK+nKoQxumLHPIiXspipWa8KAhwKL/feGh2iAD2RNYIvmZ8LqmRDsD8+2z6AcRhw3z6N+FgbS2vjs2obNIcNXW2a8Xm3MDFWdxiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524545; c=relaxed/simple;
	bh=Rf72TaY46BLiDnafzPknUCbPWK6GCbs6ZKr/LRi6/+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hBUBWMnPn5kOshjshAHYA546fDgegQL+4pdQTuIWiYp2H/gEgyfnjrb2yZZ8hvpmlBMppxzc//Qfk4ghJxOgjCNBTDw64JqORdi5BlKu2vEPR6gN7WlZOsCfh2qQ9Cqa/N6pOP5ARX2qUSehifNQStpC0+p/HKXkPhGXN9HTGHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JxCL8J7K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JxCL8J7K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2AE4C433C7;
	Wed, 21 Feb 2024 14:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524545;
	bh=Rf72TaY46BLiDnafzPknUCbPWK6GCbs6ZKr/LRi6/+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JxCL8J7KXeI2RPWOJkAOukN4VSiKl+kSEfOJeFRwSx+V5z86SfUS0ASKig/PjhvDI
	 TLi8DGEzUTj/EnAANCpP+EdBoA6nwh0F4lipq9LxZI3wMBFz7xuLfyPolFNChLQ89B
	 XtxAF0ili70QDDg1a01fzYlkd7AD+6u5pGP+4VcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 250/379] phy: renesas: rcar-gen3-usb2: Fix returning wrong error code
Date: Wed, 21 Feb 2024 14:07:09 +0100
Message-ID: <20240221130002.304154894@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit 249abaf3bf0dd07f5ddebbb2fe2e8f4d675f074e ]

Even if device_create_file() returns error code,
rcar_gen3_phy_usb2_probe() will return zero because the "ret" is
variable shadowing.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202312161021.gOLDl48K-lkp@intel.com/
Fixes: 441a681b8843 ("phy: rcar-gen3-usb2: fix implementation for runtime PM")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20240105093703.3359949-1-yoshihiro.shimoda.uh@renesas.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/renesas/phy-rcar-gen3-usb2.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/phy/renesas/phy-rcar-gen3-usb2.c b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
index 2cb949f931b6..c0802152f30b 100644
--- a/drivers/phy/renesas/phy-rcar-gen3-usb2.c
+++ b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
@@ -633,8 +633,6 @@ static int rcar_gen3_phy_usb2_probe(struct platform_device *pdev)
 	channel->irq = platform_get_irq_optional(pdev, 0);
 	channel->dr_mode = rcar_gen3_get_dr_mode(dev->of_node);
 	if (channel->dr_mode != USB_DR_MODE_UNKNOWN) {
-		int ret;
-
 		channel->is_otg_channel = true;
 		channel->uses_otg_pins = !of_property_read_bool(dev->of_node,
 							"renesas,no-otg-pins");
@@ -693,8 +691,6 @@ static int rcar_gen3_phy_usb2_probe(struct platform_device *pdev)
 		ret = PTR_ERR(provider);
 		goto error;
 	} else if (channel->is_otg_channel) {
-		int ret;
-
 		ret = device_create_file(dev, &dev_attr_role);
 		if (ret < 0)
 			goto error;
-- 
2.43.0



