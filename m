Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E8C2FD1DD;
	Tue, 30 Sep 2025 15:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245676; cv=none; b=Xh71WX/JGjIl34rGfOPNOECVlE4Wu1yCWnlfmAn59c6wGCdN3HfRPZs9tZVDuIC9grsMJhMSnJjslNWMKmdgYs2sUP86TIBfXFJoTy07xFVdqAwh9fG+JLaUjbpFKtZ2mVjCuNaljaYuX8T98swOTuQK4KbW3PtCyhLhoDGXbT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245676; c=relaxed/simple;
	bh=5H5OnDikkDQ2xb5SKy6oAPowDZp5rhABR8r6zmodoZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rCwcN0z2c+eNMMylW1EsA58s0ihllioxsKDH4T4oRox8vp1C0v70kVGlRK77E7uywgExTsGP3R439JTKQe7XqIHUiBVb/Ms3cDGywugRyrdKTDIETU/ar7GnNq0lEytxrd18VTi11mznWyV7z8MEWTEHWpmkEwoGwEZL5GDcO3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VMXcaYcv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VMXcaYcv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3AB7C4CEF0;
	Tue, 30 Sep 2025 15:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245676;
	bh=5H5OnDikkDQ2xb5SKy6oAPowDZp5rhABR8r6zmodoZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VMXcaYcv0Dt3Xe8U2X6N6iyYHLrL+aYKkaojSmmoFGbJnB9fzU0amneF0qw824sKS
	 lxLSPKLvSo2XhUgJhFyc/jUagajrvmj7tyj4EsRboIIw4jfcdIOcNG116E9oeNE/zQ
	 YKXy5pmvKv8rQuKD3SJKmLw4mhJAIWTliQdDJakk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	"Michael J. Ruhl" <michael.j.ruhl@intel.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 17/91] i2c: designware: Add quirk for Intel Xe
Date: Tue, 30 Sep 2025 16:47:16 +0200
Message-ID: <20250930143821.846364460@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.118938523@linuxfoundation.org>
References: <20250930143821.118938523@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

[ Upstream commit f6a8e9f3de4567c71ef9f5f13719df69a8b96081 ]

The regmap is coming from the parent also in case of Xe
GPUs. Reusing the Wangxun quirk for that.

Acked-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Co-developed-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20250701122252.2590230-3-heikki.krogerus@linux.intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
[Rodrigo fixed the co-developed tags while merging]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-designware-platdrv.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
index f3245a6856309..1ebcf5673a06b 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -168,7 +168,7 @@ static inline int dw_i2c_of_configure(struct platform_device *pdev)
 }
 #endif
 
-static int txgbe_i2c_request_regs(struct dw_i2c_dev *dev)
+static int dw_i2c_get_parent_regmap(struct dw_i2c_dev *dev)
 {
 	dev->map = dev_get_regmap(dev->dev->parent, NULL);
 	if (!dev->map)
@@ -190,12 +190,15 @@ static int dw_i2c_plat_request_regs(struct dw_i2c_dev *dev)
 	struct platform_device *pdev = to_platform_device(dev->dev);
 	int ret;
 
+	if (device_is_compatible(dev->dev, "intel,xe-i2c"))
+		return dw_i2c_get_parent_regmap(dev);
+
 	switch (dev->flags & MODEL_MASK) {
 	case MODEL_BAIKAL_BT1:
 		ret = bt1_i2c_request_regs(dev);
 		break;
 	case MODEL_WANGXUN_SP:
-		ret = txgbe_i2c_request_regs(dev);
+		ret = dw_i2c_get_parent_regmap(dev);
 		break;
 	default:
 		dev->base = devm_platform_ioremap_resource(pdev, 0);
-- 
2.51.0



