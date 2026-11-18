Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026891;
	b=z0v4PJvimTap7/sINllWccyI0seg2KlZ3LGbiedzXF2E1v3M2tMSPAHAaGzRGVOqszib
	 wULV2S2WLLymvZjdm8iQQkmHf8WOkRXZ1gn1YyWSz+fnyBeTnUK5m5XhxEE5aY75hZpMB
	 bpzUHpxlKKrPdTHYdnzVUPo3Xqt2eoDRF+ASd7sh7Eak1Ue3x6pZ+6x3kjnHGxm2Ewq30
	 EuB4d38lkdpWX4Dcud9FPCyDJsfODbAANa//UnxwMRz7GgIvRdo2Rdz3RJscdWduw/oz6
	 mPq5oXFcWlOOuswboa9h9PgAEw2xpbwFgOnbufYi4BEFUlKaNUtXR9xnHlot9slT1nA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026891;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rlW4hhjCDf3IcDzFdnOBzlb8KukiowVwNsRoD0QiNHM=;
	b=rr47Q4247HL+ecISJpcvCY3O9NyJyA5QD49Nu5wtLR/7ZxiGBLHE3P4xtt9KpTjngapv
	 Xf3WhtU8rMpdtPfaVeHWzpI+EE4iMZZVlNcpEGJzFkNOmcF7p9IO7AHvlNgTFUpu1bKSg
	 Y4GYJu803yyJ6Tb1dv/NPpo32U/iK0QOyGTC9PKH/wKIsjVOXwPzU00p2Y8xjl/1sKflh
	 CN8v7jZRkvQwKXNE1J/w9mMllCGJIaHtGwYIj518YekcATuRH2sUr851IvMuumQuD5DOX
	 VMYKCCNXmVQhERVZqS+9s78sm1eHXDFtej0a9qsqiGoLKAlfqoJnNGI4GpwjoXHrGHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MFmObuUt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF33606A325;
	Wed, 18 Nov 2026 18:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MFmObuUt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B7951F000C6;
	Wed, 18 Nov 2026 18:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026891;
	bh=rlW4hhjCDf3IcDzFdnOBzlb8KukiowVwNsRoD0QiNHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MFmObuUtcYZrdmW6mqn5R9H+AsoSlnx0y6cgH71Ue+XwOaeiMNNKfd8MYb9T6H0Ax
	 m4OLS7ZSww+r4j0dPxFS75j8xiEQYro7e1jcXZVOdhvzT5z/DIkWpzF9jJGTMkPqGr
	 lKNskn+tz2cgCyj9LCNpGUuYK3Any3+ruP1gJgiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	zhoumin <teczm@foxmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1594/2151] ata: ahci: preserve preset port masks
Date: Wed, 18 Nov 2026 15:55:29 +0100
Message-ID: <20261118150219.945811694@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: zhoumin <teczm@foxmail.com>

[ Upstream commit 014c29a8e3bdcaad8c6fdfcf1af2fdbbab3fc323 ]

ahci_get_port_mask() returns zero for absent or unmatched parameters,
overwriting the mask set by the Marvell PATA quirk.

Update the mask in place only when parsing a global value or a matching
device entry. Leave the mask unchanged on parsing errors.

Fixes: 70c1595c181c ("ata: ahci: Allow ignoring the external/hotplug capability of ports")
Suggested-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: zhoumin <teczm@foxmail.com>
Link: https://lore.kernel.org/r/tencent_26064A115A53E4C6D00433C89E1894E2D808@qq.com
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/ahci.c | 31 +++++++++++--------------------
 1 file changed, 11 insertions(+), 20 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index d287c84ce80e0..8c3d54caa5857 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -714,34 +714,27 @@ MODULE_PARM_DESC(mask_port_ext,
 		 "where <pci_dev> is the PCI ID of an AHCI controller in the "
 		 "form \"domain:bus:dev.func\"");
 
-static u32 ahci_port_mask(struct device *dev, char *mask_s)
+static void ahci_port_mask(struct device *dev, char *mask_s, u32 *mask)
 {
-	unsigned int mask;
-
-	if (kstrtouint(mask_s, 0, &mask)) {
+	if (kstrtou32(mask_s, 0, mask))
 		dev_err(dev, "Invalid port map mask\n");
-		return 0;
-	}
-
-	return mask;
 }
 
-static u32 ahci_get_port_mask(struct device *dev, char *mask_p)
+static void ahci_get_port_mask(struct device *dev, char *mask_p, u32 *mask)
 {
 	char *param, *end, *str, *mask_s;
 	char *name;
-	u32 mask = 0;
 
 	if (!mask_p || !strlen(mask_p))
-		return 0;
+		return;
 
 	str = kstrdup(mask_p, GFP_KERNEL);
 	if (!str)
-		return 0;
+		return;
 
 	/* Handle single mask case */
 	if (!strchr(str, '=')) {
-		mask = ahci_port_mask(dev, str);
+		ahci_port_mask(dev, str, mask);
 		goto free;
 	}
 
@@ -776,13 +769,11 @@ static u32 ahci_get_port_mask(struct device *dev, char *mask_p)
 			param++;
 		}
 
-		mask = ahci_port_mask(dev, mask_s);
+		ahci_port_mask(dev, mask_s, mask);
 	}
 
 free:
 	kfree(str);
-
-	return mask;
 }
 
 static void ahci_pci_save_initial_config(struct pci_dev *pdev,
@@ -808,10 +799,10 @@ static void ahci_pci_save_initial_config(struct pci_dev *pdev,
 	}
 
 	/* Handle port map masks passed as module parameter. */
-	hpriv->mask_port_map =
-		ahci_get_port_mask(&pdev->dev, ahci_mask_port_map);
-	hpriv->mask_port_ext =
-		ahci_get_port_mask(&pdev->dev, ahci_mask_port_ext);
+	ahci_get_port_mask(&pdev->dev, ahci_mask_port_map,
+			   &hpriv->mask_port_map);
+	ahci_get_port_mask(&pdev->dev, ahci_mask_port_ext,
+			   &hpriv->mask_port_ext);
 
 	ahci_save_initial_config(&pdev->dev, hpriv);
 }
-- 
2.53.0



