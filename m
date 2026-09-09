Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813A3568FD3;
	Wed,  9 Sep 2026 14:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964043; cv=none; b=e1vGSxzvK1V9h/AR5C3/bQFVyAA6SoR55FoauvG4kYfIpTx1zTAFu3m6N/K/Ukhre96nekoz+tyKFxqwcgTmSYzK4Y/aRezBCEiyfvCCQlStt7yok4NtC6pDi1SzlkMnid4aUhB8K4OBi2dWWaR9nz8HvmC4f9B1BKSub4HIymQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964043; c=relaxed/simple;
	bh=vtCmM6RXVoEa5ZOg+PjPjcynUlH+6EzB9L2qVkd4/s4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DZXwB1i0eQqyoB0+Y7w9hFT03W/I07p0NlvgENHPWZSfJP4u+kjkMXPzNDa/y3YsLzZIqhprInBbyUUvS17h5irtGtlHPlUo6OB/AS8ub8IrM5Xk+OcyWUT13yjJbcFKXoh4qAEw2j1z8kYqVlsfFKfOZV0VmIVG9jsuF0/PcTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nr1WUEW2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nr1WUEW2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D47111F00A3A;
	Wed,  9 Sep 2026 14:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964042;
	bh=nrsfasDclWtYvaQq2DSksMKeWxB0gJA43RUI9/t+uLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nr1WUEW2s+WMQwjj/C4afcmLAaY6oXtyfF1gN4OrZFXDid5tTjkAgYdq4GDjfkmfp
	 fsBwNBVjAdD00AAPQAp1glCfNGtc73vDVyDCjK38w4I6aEXW1QOx4exVkhO559TlUE
	 XenPx09eEhfOAIqcu3eQ3keyiq8KzJnrcf30rG50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Hecht <mhecht73@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 6.18 288/583] media: i2c: alvium: Fix: Correct name of register in alvium_set_ctrl_auto_exposure
Date: Wed,  9 Sep 2026 15:39:33 +0200
Message-ID: <20260909134248.016400390@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


