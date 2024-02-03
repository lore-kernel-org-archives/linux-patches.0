Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D65C4171A4;
	Sat,  3 Feb 2024 04:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933891; cv=none; b=tJ/yEvyfLDRMVb6PLc5/9FHwEdKYwpw/25GllHXthNjx+eJujHXRH1GXxJM9811gTmU0s3RK5hxfYJHrVYUcdP+1/OvGryjZMa5JP3gGsxxk7VDuYm1xjm0mhU8eoe2O6OG2Icml1rK6pDfoD7W3Fj5MoapBIDwAIt0rCmxfm3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933891; c=relaxed/simple;
	bh=NFDEvtl0m2tedcqqEJmblTjJHKTluHTrSfyZv+l1Zz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fHDey537jrGkf2bv8mdkCkXMRD1hScfc/bXHX0IKHVH9hsi0zl0UUGyBXT0qsySU2aa5pu8TnzoRO0xTBHzW74KlItvisudsg0Ty5xzYckC+373BvT5TFdbjGYs51DRFoJMB5yP1g7hBM966eD563cKy1dyKXWSBMdKoprx6v1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kk6bkH4Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kk6bkH4Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D7FCC433C7;
	Sat,  3 Feb 2024 04:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933891;
	bh=NFDEvtl0m2tedcqqEJmblTjJHKTluHTrSfyZv+l1Zz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kk6bkH4ZK9peeTyzVnRPUQPxhSQdn3M8q24qm6TWp+HZmqlHdSu6h5Dr9jeabZ/Qv
	 c8nsLWsvsooXRed3nBgtUpfbT2PY1UlWgoDroOaFZcmfmmDwpnlbNHCgoYABlcY111
	 eEKJ8d9HeqzxzYT22SBfNxZlL7/N09GUKpyxNGoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 237/353] pinctrl: baytrail: Fix types of config value in byt_pin_config_set()
Date: Fri,  2 Feb 2024 20:05:55 -0800
Message-ID: <20240203035411.173560240@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 1a856a22e6036c5f0d6da7568b4550270f989038 ]

When unpacked, the config value is split to two of different types.
Fix the types accordingly.

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/intel/pinctrl-baytrail.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/intel/pinctrl-baytrail.c b/drivers/pinctrl/intel/pinctrl-baytrail.c
index 3cd0798ee631..f1af21dbd5fb 100644
--- a/drivers/pinctrl/intel/pinctrl-baytrail.c
+++ b/drivers/pinctrl/intel/pinctrl-baytrail.c
@@ -918,13 +918,14 @@ static int byt_pin_config_set(struct pinctrl_dev *pctl_dev,
 			      unsigned int num_configs)
 {
 	struct intel_pinctrl *vg = pinctrl_dev_get_drvdata(pctl_dev);
-	unsigned int param, arg;
 	void __iomem *conf_reg = byt_gpio_reg(vg, offset, BYT_CONF0_REG);
 	void __iomem *val_reg = byt_gpio_reg(vg, offset, BYT_VAL_REG);
 	void __iomem *db_reg = byt_gpio_reg(vg, offset, BYT_DEBOUNCE_REG);
 	u32 conf, val, db_pulse, debounce;
+	enum pin_config_param param;
 	unsigned long flags;
 	int i, ret = 0;
+	u32 arg;
 
 	raw_spin_lock_irqsave(&byt_lock, flags);
 
-- 
2.43.0



