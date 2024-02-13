Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4DB5FF1E;
	Tue, 13 Feb 2024 17:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845674; cv=none; b=NJrXwnKzs2Jcm4o70BoeL+ItDI52ac2HFy/9DB0DV+EmH6qNJ9DvQXolLAQeJtvjJnl5a2/mEoDhKISpA4LePZwkl5bznTpcANiQadppHG3P8R3zWNrNDwB/cSqKTpawxO8QdiCc2XX4diA039Dl1dKkLZTIXeQaH4xxIoIB1cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845674; c=relaxed/simple;
	bh=LT8ivqJ3leH3LCQaD0NIX1nsrprmlYAKV6x6TfhJp0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ha05S9zRazYeO+vh8PBUNy8CJwCE1PlbYwKhy+fJvo5MANJ/aMNDiyRLpMsLklFGsigY9JTuGVDqcGAqbFyD/Lvov3aB0SZcM5Zsv+77T3CVwZZxCPg5Sn8pYueh+eplkmmRgVew7EUgyT20s32umOwhaw/Gg1juzG5BKeaqSBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aZBLQuhI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aZBLQuhI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94293C433C7;
	Tue, 13 Feb 2024 17:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845674;
	bh=LT8ivqJ3leH3LCQaD0NIX1nsrprmlYAKV6x6TfhJp0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aZBLQuhI7Z+zhsceW7szo+JM016uWkeFFiRx8McUy3OxYtgFSHanuerkmjJO8h3H5
	 iK1sJTmzRWpeqy5S2alz1TEHwvqd8yzvkOxQ6UbImAYYisZk9yC77A8nVeJ5HyHQpn
	 ocs7Fcpcc1s8vMhV1ypuHJa9+v82ITwRI2nL0LmI=
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
Subject: [PATCH 6.7 008/124] phy: renesas: rcar-gen3-usb2: Fix returning wrong error code
Date: Tue, 13 Feb 2024 18:20:30 +0100
Message-ID: <20240213171853.973961686@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index e53eace7c91e..6387c0d34c55 100644
--- a/drivers/phy/renesas/phy-rcar-gen3-usb2.c
+++ b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
@@ -673,8 +673,6 @@ static int rcar_gen3_phy_usb2_probe(struct platform_device *pdev)
 	channel->irq = platform_get_irq_optional(pdev, 0);
 	channel->dr_mode = rcar_gen3_get_dr_mode(dev->of_node);
 	if (channel->dr_mode != USB_DR_MODE_UNKNOWN) {
-		int ret;
-
 		channel->is_otg_channel = true;
 		channel->uses_otg_pins = !of_property_read_bool(dev->of_node,
 							"renesas,no-otg-pins");
@@ -738,8 +736,6 @@ static int rcar_gen3_phy_usb2_probe(struct platform_device *pdev)
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



