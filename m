Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E3852CCC0;
	Tue, 27 May 2025 16:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364561; cv=none; b=hhLdQrQ+5kr+GTakuPxVfk52TrsLcV9NERGGnwczp08NcZZWhowdASALtsmwyk5TgF1JLYqxqhtyaB7quIb/05IP0sgdEqrqcpdbqG1Hlga/fmqeLmt+2c5QFXVaHC37rYl5PqgXkVYCTEtpPDvVtFkyGesrQZjr6JwOcbzn3CQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364561; c=relaxed/simple;
	bh=/zipwWjcwQ2YU2al8+t7HYOQrt/Fvhl6yxabTfFYYPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VQv9wj039RdAnO0zXd2c28rUk+Sc4xj3BJu9tvP286yNeATKdOkpV45Ss9DTEcaVfECqJOjsoqdvmPsw0DSWpqTKxNhzw8ckOw0EtHu4iTlDGMiAHEBXaSbNIMIGLjfwFVoE5yjqJ4TyLcrIV2UcgRhkuflWzRwJXHAjzBgRtOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vgic7DVa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vgic7DVa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2728C4CEE9;
	Tue, 27 May 2025 16:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364561;
	bh=/zipwWjcwQ2YU2al8+t7HYOQrt/Fvhl6yxabTfFYYPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vgic7DVav5ligRcfeT9EPjG02oeiHQOyyDde2BLYgtXTfEZILKGSjiLVGELNMtL2W
	 zOrvucUpdIXbwj2aibjMS2YqObJaXcrxf8uFn+/HxWGxwGmk6BDMOODriqI8rdyJLD
	 FB3+uvg77BempTFb5Q4mLsBoWzL3Wbx3WAchGBmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans-Frieder Vogt <hfdevel@gmx.net>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 078/626] net: tn40xx: add pci-id of the aqr105-based Tehuti TN4010 cards
Date: Tue, 27 May 2025 18:19:31 +0200
Message-ID: <20250527162448.217541261@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Hans-Frieder Vogt <hfdevel@gmx.net>

[ Upstream commit 53377b5c2952097527b01ce2f1d9a9332f042f70 ]

Add the PCI-ID of the AQR105-based Tehuti TN4010 cards to allow loading
of the tn40xx driver on these cards. Here, I chose the detailed definition
with the subvendor ID similar to the QT2025 cards with the PCI-ID
TEHUTI:0x4022, because there is a card with an AQ2104 hiding amongst the
AQR105 cards, and they all come with the same PCI-ID (TEHUTI:0x4025). But
the AQ2104 is currently not supported.

Signed-off-by: Hans-Frieder Vogt <hfdevel@gmx.net>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250322-tn9510-v3a-v7-7-672a9a3d8628@gmx.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/tehuti/tn40.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/tehuti/tn40.c b/drivers/net/ethernet/tehuti/tn40.c
index 259bdac24cf21..a6965258441c4 100644
--- a/drivers/net/ethernet/tehuti/tn40.c
+++ b/drivers/net/ethernet/tehuti/tn40.c
@@ -1832,6 +1832,10 @@ static const struct pci_device_id tn40_id_table[] = {
 			 PCI_VENDOR_ID_ASUSTEK, 0x8709) },
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_TEHUTI, 0x4022,
 			 PCI_VENDOR_ID_EDIMAX, 0x8103) },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_TEHUTI, PCI_DEVICE_ID_TEHUTI_TN9510,
+			 PCI_VENDOR_ID_TEHUTI, 0x3015) },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_TEHUTI, PCI_DEVICE_ID_TEHUTI_TN9510,
+			 PCI_VENDOR_ID_EDIMAX, 0x8102) },
 	{ }
 };
 
-- 
2.39.5



