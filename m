Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD665FF07;
	Tue, 13 Feb 2024 17:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845040; cv=none; b=ZajGwDJ+Kyg0J0IdRDkKoRd9EoY7Vj8ngLZ7QyEQPeGUEn8kkGmcGzEQ9BEgs35ibOMENhG4gux9iMlxm6qPzPxpkLd6lpfT3Y5J5ee4pAowIoD/ZqAtuBqNs5uMFoWnMHOXeFvRZIlVPRlOLODr4/gkrVxAGloxYtXbipLQa+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845040; c=relaxed/simple;
	bh=7uNpw8bvpXsphonMicvUMR8rFrYIvLvZAhO09/Vmi84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DQFf7Jw0iL75UVgJKjT1VSF/sRH8JjQWn8aRHGGAiig6oCBS5m4TXAWIGSdeNalrXLufv9FXC4bgAzPeu4/u5F82z1vUbRLVbA5ZiYtTCoVqzEdNyE0+MF6uV5qmrPXsqNi4r27L+WSH3SIAnesVbtOwB5ibF2LlDDSqCD8/ICk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rVK3G9vp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rVK3G9vp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 516FFC43390;
	Tue, 13 Feb 2024 17:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845039;
	bh=7uNpw8bvpXsphonMicvUMR8rFrYIvLvZAhO09/Vmi84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rVK3G9vpL4pzIyYfwC1zLT6ihbOf24wMayu3X8HySh1qjdohCqhtLRhtQQH5Q5ah2
	 tf8oMqHTaE0loGYCWfXshTD60ExoZhIssga/Q8HrGntV2DqndZgX9jMAnNory7Rn5L
	 O8s7w5Lo7s403syuKwZV/JDgm3NwR+fUVssuLerw=
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
Subject: [PATCH 6.1 06/64] phy: renesas: rcar-gen3-usb2: Fix returning wrong error code
Date: Tue, 13 Feb 2024 18:20:52 +0100
Message-ID: <20240213171844.927393909@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171844.702064831@linuxfoundation.org>
References: <20240213171844.702064831@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9de617ca9daa..7e61c6b278a7 100644
--- a/drivers/phy/renesas/phy-rcar-gen3-usb2.c
+++ b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
@@ -675,8 +675,6 @@ static int rcar_gen3_phy_usb2_probe(struct platform_device *pdev)
 	channel->irq = platform_get_irq_optional(pdev, 0);
 	channel->dr_mode = rcar_gen3_get_dr_mode(dev->of_node);
 	if (channel->dr_mode != USB_DR_MODE_UNKNOWN) {
-		int ret;
-
 		channel->is_otg_channel = true;
 		channel->uses_otg_pins = !of_property_read_bool(dev->of_node,
 							"renesas,no-otg-pins");
@@ -740,8 +738,6 @@ static int rcar_gen3_phy_usb2_probe(struct platform_device *pdev)
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



