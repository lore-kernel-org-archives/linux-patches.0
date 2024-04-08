Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ADD27F474;
	Mon,  8 Apr 2024 14:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712585084; cv=none; b=Ut0xYl+23YZKHDzJX05U25M/vWvw/W/Z2TuOy9aZTAutbOrrtMKmaJF2TxJO3P67SJp4tiqhihmpgffxxPiPD9ig4DQNhehP6j/ME41d2E3YgE8ITKBZMwiDGSLCmIJmAIhxiOjVk8pQkah+q37NnAOPL5fD65nrvNo2J76Uyfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712585084; c=relaxed/simple;
	bh=OjQ/tsNgPBWm67L2u9zaWTXe0UFFWh0GSVWTR51jPtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aasBLe/a7fET7iJb9KIiiSGBeYSr3cnfOLyR7rTHgcWh9qhOMHI+TG/SOFXAaxttQWcPaWHig2g0ktUQZEH7QG9oeHzh26gM9DnqLfjTg6v+b2oI8cC6sl4acekM6LBHc0w+RjNl/ck0EzBbc46REFUW6kf9KQh7MBAa69oi9vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BI2WB9w9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BI2WB9w9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E669C433F1;
	Mon,  8 Apr 2024 14:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712585084;
	bh=OjQ/tsNgPBWm67L2u9zaWTXe0UFFWh0GSVWTR51jPtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BI2WB9w9Mp3BpJrRnMKOsbv17l6IGmeP8Hgp45mOOMe5NWAjeihzbHJtGor7f7tGc
	 V/PmcKNZKPqmoBczj+escu1cvUHxLeKmc/EPoD8pduHUfgXGA5aeQwI2bzrZoX1hP8
	 pq1p4ZNRn3GrsoCrE4D/+yLRHNaTZhPRBp1iDfLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	stable <stable@kernel.org>,
	Sean Anderson <sean.anderson@seco.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 658/690] Revert "usb: phy: generic: Get the vbus supply"
Date: Mon,  8 Apr 2024 14:58:44 +0200
Message-ID: <20240408125423.506459406@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit fdada0db0b2ae2addef4ccafe50937874dbeeebe ]

This reverts commit 75fd6485cccef269ac9eb3b71cf56753341195ef.
This patch was applied twice by accident, causing probe failures.
Revert the accident.

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Fixes: 75fd6485ccce ("usb: phy: generic: Get the vbus supply")
Cc: stable <stable@kernel.org>
Reviewed-by: Sean Anderson <sean.anderson@seco.com>
Link: https://lore.kernel.org/r/20240314092628.1869414-1-alexander.stein@ew.tq-group.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/phy/phy-generic.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/usb/phy/phy-generic.c b/drivers/usb/phy/phy-generic.c
index 34b9f81401871..661a229c105dd 100644
--- a/drivers/usb/phy/phy-generic.c
+++ b/drivers/usb/phy/phy-generic.c
@@ -268,13 +268,6 @@ int usb_phy_gen_create_phy(struct device *dev, struct usb_phy_generic *nop)
 			return -EPROBE_DEFER;
 	}
 
-	nop->vbus_draw = devm_regulator_get_exclusive(dev, "vbus");
-	if (PTR_ERR(nop->vbus_draw) == -ENODEV)
-		nop->vbus_draw = NULL;
-	if (IS_ERR(nop->vbus_draw))
-		return dev_err_probe(dev, PTR_ERR(nop->vbus_draw),
-				     "could not get vbus regulator\n");
-
 	nop->dev		= dev;
 	nop->phy.dev		= nop->dev;
 	nop->phy.label		= "nop-xceiv";
-- 
2.43.0



