Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F017A69E00;
	Wed, 21 Feb 2024 14:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525511; cv=none; b=LfyuruswCSa35XRBVJ64jNpT4X/6HG3DeEt/77KDwIirddPBYfsuKEFQlkqKcL+q+srRYkMdgLEJAOc0wdd+SHmKx4b7EDtCqhdVlpfdLz+fR2xai17tp6iBDBdRAyVKfRl8s/KG2JaCVPbe526Cs8Ar8OViJrERZ/8/Eu6cCrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525511; c=relaxed/simple;
	bh=TUVNUJIiNBtMN/2dc7TvB5Z5fdRcPMzIOle+jC/XPsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bR5ABYwqgaWxW5snumfttY34BhEKID0obXt3+Ba+FpOMCM/q0tPbwTNcT7hlJCOA6dE2zuJ/ENh0/olW/GS0053VJbu6Z0RPks5XYaEITGVD7WtCmCHS8VS9B1TYXZ0w8dJs9NWxZb9m5KbGpt/Jes1qqbNQVLVduJlbgE7uXvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gAaPyIn1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gAaPyIn1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00536C43390;
	Wed, 21 Feb 2024 14:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525510;
	bh=TUVNUJIiNBtMN/2dc7TvB5Z5fdRcPMzIOle+jC/XPsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gAaPyIn1vd31xj7Nx1ST14XkD6cR2alMhLV941pqA/vOsoAKznYpMIYfB7YHt6vu1
	 pKEukv1JoZyOq95AL0yQ2Ktty7m4ZdH4POsRzDIClA5tQDn0oi7bXjhvixdQWSxlS1
	 ZhSv36VmMQOw0zLt1Us2+FWr16LNr7BjVxryNIq8=
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
Subject: [PATCH 5.4 178/267] phy: renesas: rcar-gen3-usb2: Fix returning wrong error code
Date: Wed, 21 Feb 2024 14:08:39 +0100
Message-ID: <20240221125945.722934382@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index cfb98bba7715..ddc41db1f65a 100644
--- a/drivers/phy/renesas/phy-rcar-gen3-usb2.c
+++ b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
@@ -631,8 +631,6 @@ static int rcar_gen3_phy_usb2_probe(struct platform_device *pdev)
 	channel->irq = platform_get_irq_optional(pdev, 0);
 	channel->dr_mode = rcar_gen3_get_dr_mode(dev->of_node);
 	if (channel->dr_mode != USB_DR_MODE_UNKNOWN) {
-		int ret;
-
 		channel->is_otg_channel = true;
 		channel->uses_otg_pins = !of_property_read_bool(dev->of_node,
 							"renesas,no-otg-pins");
@@ -691,8 +689,6 @@ static int rcar_gen3_phy_usb2_probe(struct platform_device *pdev)
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



