Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08357149DF4;
	Thu, 11 Apr 2024 10:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832085; cv=none; b=JYvpGZYE+BMDcVntwv1T8LDKXIA8lDR0wF+NH5bFcrtYDMOUePXo2goUIUI3gMc3G/Lobs+q0mrTY8R7YOvZjlDySeXFyyYaaQBefRzt8PIPxBGy/TN0Dcmm+L1/MU07hfl8+nLCEkiXo7NRyzEUDHEtvXURAIy9Cd7+XAE3ybo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832085; c=relaxed/simple;
	bh=jOI4XuK3ZPRNdqnXz9jGtV+sGT8zrjh2to8/tUyqihk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BRrgUGmNjKXNwx3/zH7FNiFIT/yfZV4BdpBhD4dTfz6Deht/fDct9U8CSPikM7Ggyg7OwZN/uyS4pXs/CvQvVsMi8VQd1qK6TMoqjWxJ4twl7zlBuVcQMhX+ihe20Mkn3T2odIGe7jdmNoz3QRatdP//ghnT6LKdQJMVDcYJ128=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=apD5CxRO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="apD5CxRO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 821F4C43394;
	Thu, 11 Apr 2024 10:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832084;
	bh=jOI4XuK3ZPRNdqnXz9jGtV+sGT8zrjh2to8/tUyqihk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=apD5CxROfNhOWpbRGhUCjzcxTQMotn0y6xv2AFvyxoR73Q8iFKTm2O6Ai7GqntKyt
	 BhZcfWxWbTcrSXIa6YSx31VLFBeJ7ru47N1JGNOUc9iEyZvr1hz/dqH/jwenZr2rz0
	 pPFBM2iTpfiCXAFaahDFfRY+3+sBWS0lgou4w/Sw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	stable <stable@kernel.org>,
	Sean Anderson <sean.anderson@seco.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 223/294] Revert "usb: phy: generic: Get the vbus supply"
Date: Thu, 11 Apr 2024 11:56:26 +0200
Message-ID: <20240411095442.304946705@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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



