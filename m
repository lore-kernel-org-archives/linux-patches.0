Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE49D1F3FED;
	Tue, 30 Sep 2025 15:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245999; cv=none; b=Jk1z9Rri9vfFRtDp+WYNyereVsRpUwsnS1Wb1bQmxaRjIv/2uUw/TUhq/1uokIrA6OU/LE2zHMAYJRr7T+d/3Lg4/gNSsxLhbeOcwvlUkyUebZMNhpY42hvfEnhhbaOcOoH8VZISfkFhXrBzx1UDj3pJqXwzLVFVjLaQYlwpGuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245999; c=relaxed/simple;
	bh=J3NuxUzIDu+RlU87PWWPTVXHKMdCKM8qt22PaUX2vO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mrt0sNkwMRZxG9ALGjSpABNqQnfLqzPHK7HWo3WWm3ze/VF5yGhsKcDiinNBUPEqNrGQwO3pemeZ+LqomcmIJG3fEI/hf6SViF6Y2psukFE+cAejkuqdQ3qiX0qyOVLlhQEEUvuBeDy07nGz1eqs5UZXsACqUAE6+YFMgPNANaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s3iJP0Il; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s3iJP0Il"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31611C4CEF0;
	Tue, 30 Sep 2025 15:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245999;
	bh=J3NuxUzIDu+RlU87PWWPTVXHKMdCKM8qt22PaUX2vO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s3iJP0IlDeuPZka+V6SLs5ky37UfadYutCMngW79TonT3cYc/Gp1Yod5E7VqZaVD+
	 O2ZYlA2FrBmMLKbWqoknN15fLKN7tfySt/0upAgIHX5L8255S72Bs3dZ+L+wQkAYVQ
	 qd6l9VR90dor6HwDYard5+IalEF/EvC7+lfRaGNk=
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
Subject: [PATCH 6.12 21/89] i2c: designware: Add quirk for Intel Xe
Date: Tue, 30 Sep 2025 16:47:35 +0200
Message-ID: <20250930143822.771030193@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
References: <20250930143821.852512002@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a3e86930bf418..ef9bed2f2dccb 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -101,7 +101,7 @@ static int bt1_i2c_request_regs(struct dw_i2c_dev *dev)
 }
 #endif
 
-static int txgbe_i2c_request_regs(struct dw_i2c_dev *dev)
+static int dw_i2c_get_parent_regmap(struct dw_i2c_dev *dev)
 {
 	dev->map = dev_get_regmap(dev->dev->parent, NULL);
 	if (!dev->map)
@@ -123,12 +123,15 @@ static int dw_i2c_plat_request_regs(struct dw_i2c_dev *dev)
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



