Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020444;
	b=a0R8X/JzoEXfnXM7mtDtoXtmL1EfLkGCXGXjUdpLKLw5++yaJ3IhZk/oyjHSiihQMHAB
	 HIGXCpOpPxRI4FuPm81TQALJ0l/b9/LKam60dyAYCwUJPFqq93mH2xO7ZRmKkibqz3csV
	 W3hWvOaY3/Nv851qUCSXGvD1LmZXcYLST+euaec+NFzjq8ya4xTSFw4pK2B7iZO6b8WuK
	 zfYAKlHlS8PhbORj2V3Tm2J0RdyeoBM56e1B/gjD6vpHzPMPKBo9Aqrrcxn1sCr920kPR
	 MLl1DXg8IwuYnTidVvkqEpjT8dSautpBcc1BYGPjczxe2toGKw0fz+coLBFzTNBYepQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020444;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9nl2gGRzqKDvubJmR0dezlnKQywpqKFvB9PBd1HimPI=;
	b=4rbOPhMiDQQfBIywFkdeQSCSvhS/Jvz5Z4Ocj0lQSqmWB9HmuzxRGBfukEjwhijC7lFF
	 0dRg4CmIdCg4i5SZXp8Fmqs8xEVAp38akvVKvDKsXLXKCU0DEP8s8LGyMdcH51vFc9Umv
	 11yDotCYt3RJRhWp6Mh/L81E2LFndhwrwAm9ELyF5knvVDGjgWPJz7zK5hslbVAJ/7F7g
	 uukCvpMS6F+jlKQmNr0aOCMmGLc5V9DQTu7CedMbT9YoxivFZPDgIuI6LGr9U0IY4pAes
	 UApWrp2MY5874uYkWqSVnqQoDVsGf6/er6XBc0vt4epJ39irZ7deWyJmk/SuvJ+aENg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iyW2GB66;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB02606A334;
	Wed, 18 Nov 2026 16:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iyW2GB66
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0850F1F000C6;
	Wed, 18 Nov 2026 16:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020444;
	bh=9nl2gGRzqKDvubJmR0dezlnKQywpqKFvB9PBd1HimPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iyW2GB66Qz2gZG9lbZ+qQ0t458oPO534XtW0dISK2PpuuMF3z+IDNH4gcRrOkQAAt
	 mGgiXLEWKL1SXkVOKuX89ssoO1ZGL0LPS+Dq5n83GGqX7NF8uwFQ1hQe0tspaCg3g4
	 9KSdTt2Eqva+0u2m8/xyxnbVUeXOjeYEam3zb8OE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	zhoumin <teczm@foxmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1953/2651] ata: ahci: preserve preset port masks
Date: Wed, 18 Nov 2026 15:53:13 +0100
Message-ID: <20261118150356.872107004@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 9b8c0935001cb..fdce365969b4f 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1642,34 +1642,27 @@ MODULE_PARM_DESC(mask_port_ext,
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
 
@@ -1704,13 +1697,11 @@ static u32 ahci_get_port_mask(struct device *dev, char *mask_p)
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
@@ -1736,10 +1727,10 @@ static void ahci_pci_save_initial_config(struct pci_dev *pdev,
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



