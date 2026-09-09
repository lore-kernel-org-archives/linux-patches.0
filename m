Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9080C55C1D6;
	Wed,  9 Sep 2026 14:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962643; cv=none; b=LISYGZZdzUi2JBn0naTcyXsNgGyP5OODLZil2XQVUju/rgo+4xJX/7rhU7VWMbszRRv90uw97p8RYrIHVGcawP58MzS9K3l0jMGmpOq/WIxSfGgBoRb/WXIP7JJ6kdyunGs3x+nAxXMx43gH1dOmi7O2GI7Y2FVsd+U8fmFzdqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962643; c=relaxed/simple;
	bh=6K0Gje235eaFk08v/g+fcCtrDT6ypbNoblngXiHgaqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PJK0UVZY42BeLPcUzuN1Zkdk+U40dJgoD8N353RPX+vq/HmpmvliyjiFY/PqT1ApvQ+eoOXSM5JuT9ihA5Ums1V98J0FAOtCs5jNfjdPQsGmajXb6vGMMqh75/qwbuEYGhrCPrRrRjICM2ABXuPNG2RlYR07usNj0FvG9YfvAh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ou2BDp1z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ou2BDp1z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D58C1F00A3A;
	Wed,  9 Sep 2026 14:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962642;
	bh=JsfZdNEEfS5XbuvqaglM63vce+1Nsk+QLFg3IgQJH8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ou2BDp1zMyU+aLTjrUaLr7ocHKz2xN0kWXUGSNpmkYFxq+sFOn/NX3ZPOpZ6hEk+4
	 6vb1Fg2QT4xJ+axSBztlh1h1EB5t7iL7LEdzoy7iCMNfpoH6Lb0Aze28nl7z8XxS9B
	 1q1LcIa97aFVrnhJnKBaPtT8W+rzRM5ZdWMlA908=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Hecht <mhecht73@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 7.2 362/556] media: i2c: alvium: Fix: Correct name of register in alvium_set_ctrl_auto_exposure
Date: Wed,  9 Sep 2026 15:40:42 +0200
Message-ID: <20260909134243.399830016@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Hecht <mhecht73@gmail.com>

commit 58ca8a0bff9e78841a39863474b96e59ef60da19 upstream.

Write value for auto-exposure into correct register REG_BCRM_EXPOSURE_AUTO_RW
instead of wrong register REG_BCRM_WHITE_BALANCE_AUTO_RW.

Fixes: 0a7af872915e ("media: i2c: Add support for alvium camera")
Cc: stable@vger.kernel.org
Signed-off-by: Martin Hecht <mhecht73@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/alvium-csi2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/i2c/alvium-csi2.c
+++ b/drivers/media/i2c/alvium-csi2.c
@@ -1290,7 +1290,7 @@ static int alvium_set_ctrl_auto_exposure
 	struct device *dev = &alvium->i2c_client->dev;
 	int ret;
 
-	ret = alvium_write_hshake(alvium, REG_BCRM_WHITE_BALANCE_AUTO_RW,
+	ret = alvium_write_hshake(alvium, REG_BCRM_EXPOSURE_AUTO_RW,
 				  on ? 0x02 : 0x00);
 	if (ret) {
 		dev_err(dev, "Fail to set autoexposure reg\n");


