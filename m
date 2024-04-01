Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6B32EB0B;
	Mon,  1 Apr 2024 16:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990424; cv=none; b=L2QQNNzL1SMi8FAZvCoG8w6qZ3giq5s7x7CzrS8NO5qJvcDY1yQuub4eMpwAYgESmtj57sJegp0pXuNcrPdsMIx+QUwFY3Aj7Jm8MG+4aWb2zVgHAVoAvbK8E6+mLhr74moIQHg2sCcSoHjLiiCVSuynn10jHBjCdQRkT4cCeTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990424; c=relaxed/simple;
	bh=yY4f1c2kTvnNooIeQA7hF6+bs/ktmmGbVmQqEjuSKcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JcfUYOvNu8ChrZBkQZ13o7hyFU6MwZJXj7sSuFUN+RslfZ2rc3QNCu2F4fqFiVa5VHma3Wk+zJm12sYmidvwb07sE2agASezL2FBj965wdulX5DJ3OJ3Ww5AYzJgYQrpPjqCvUnlM2DXFti5711+nk+Hu8adpAatgkdmNbGySpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h4VF0sj5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h4VF0sj5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B57BAC433C7;
	Mon,  1 Apr 2024 16:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990424;
	bh=yY4f1c2kTvnNooIeQA7hF6+bs/ktmmGbVmQqEjuSKcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h4VF0sj5Uk3T2g8VTn2TIhUARgSRI6HGBy7/6DxCUc3UX1QZcZFATFSo+DgmX553w
	 UsSbhJT68hZsxnuGV1RqrObQlyNJjf4Y3725C+DoA94OIb056MqdGbFQA/K+J95Hdn
	 A0XW2jh2wE5OfygFSJiQ4pY+O9zTstOn+4zTb6OM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	stable <stable@kernel.org>,
	Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH 6.6 349/396] Revert "usb: phy: generic: Get the vbus supply"
Date: Mon,  1 Apr 2024 17:46:38 +0200
Message-ID: <20240401152558.319659347@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

commit fdada0db0b2ae2addef4ccafe50937874dbeeebe upstream.

This reverts commit 75fd6485cccef269ac9eb3b71cf56753341195ef.
This patch was applied twice by accident, causing probe failures.
Revert the accident.

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Fixes: 75fd6485ccce ("usb: phy: generic: Get the vbus supply")
Cc: stable <stable@kernel.org>
Reviewed-by: Sean Anderson <sean.anderson@seco.com>
Link: https://lore.kernel.org/r/20240314092628.1869414-1-alexander.stein@ew.tq-group.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/phy/phy-generic.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/drivers/usb/phy/phy-generic.c
+++ b/drivers/usb/phy/phy-generic.c
@@ -268,13 +268,6 @@ int usb_phy_gen_create_phy(struct device
 		return dev_err_probe(dev, PTR_ERR(nop->vbus_draw),
 				     "could not get vbus regulator\n");
 
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


