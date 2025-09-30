Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB331EE02F;
	Tue, 30 Sep 2025 15:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244599; cv=none; b=f03bwKeOXtn7tVKjB8QX2mdtIS5Rh7KcTbKrVRFfQASXifJ2TlNhRLskDlpIh3hIkxigpqCAAut6aca3c3yte5nX1+pMdN2tkPI1DJIf6ozKgOmgKkb/yIdMuh4cWwkXJ8iW21ltI7p9LI8PWVnBP/CMRvPKuU1AjIoBODNdaq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244599; c=relaxed/simple;
	bh=EBOJzsAccVQlNz6HrERFVYkqzgXAdYgimiCP5woVZo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aM15GxVmKTJGrzyYS6Wgc3tnhun+EuTdHP3Qd8Y8OU9gU7f9qdTw7mJoX92UTwRI93uD6g9ulB2EfRP6jnNHzJx8rQK2zm+AIEEvq2QMcNTpHME0AId6AM5Yvhg/X2Se6GifX52gVhMbHeOhKQNi+e0sbmgsKYfMXopxl34rRPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oxmVYPea; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oxmVYPea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AFB2C116C6;
	Tue, 30 Sep 2025 15:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244598;
	bh=EBOJzsAccVQlNz6HrERFVYkqzgXAdYgimiCP5woVZo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oxmVYPeaRBoo4awnZi5opKc1guHvvheWTwE4bOuxz3S/ZZyoShMkh5LpiLpOx0i2I
	 vVmTa4y7/VVOkbZeLoXBYvj35FZ4NuLjWcWc4lrsUQJis5/LM1L9JWCjpixBPOIFSO
	 XkdxghiUo94dYhFRwbv3DHZSVGxo7+UWgN4P0W6k=
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
Subject: [PATCH 6.16 025/143] i2c: designware: Add quirk for Intel Xe
Date: Tue, 30 Sep 2025 16:45:49 +0200
Message-ID: <20250930143832.245046838@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 879719e91df2a..c1262df02cdb2 100644
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



