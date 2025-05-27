Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1042110E;
	Tue, 27 May 2025 17:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366504; cv=none; b=W/XvvI/Eao8krQ9n4REyT5pP8EYsL4OZm192YSF9s6U1VinTVL5PkACQpgUCyWmfGGe2jAhQjI67gX8ZddGvakm3NUnQ8huOBnEDaHpeO6owBq1Kjkug8tp10vqQ6Q8U+sTE+xfnVB0ku7n9Iw9l4c/o6zJm+vFDazgdzYflBBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366504; c=relaxed/simple;
	bh=zOTBekvK04Zq/0hz3r8uGR/rc2WinlrHKr2xlKls9vI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uj9ARHpw0I4ua/XvzlJZ09Z1IBV15gaoh2djk1aB+ZdYzwjBSU4EupKYyzljWEzM1hGErHt74wXpDJFVa3edvoXQVcgFEOwpNNmRHH7/2S6U6moAyZ86Le50iMXB1aSBX+GGjAO/xlAv2pnJEypLVicMPgQD+/WptDkMrzgm7DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BtwLMeRJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BtwLMeRJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE8B3C4CEE9;
	Tue, 27 May 2025 17:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366504;
	bh=zOTBekvK04Zq/0hz3r8uGR/rc2WinlrHKr2xlKls9vI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BtwLMeRJBjXcHFxcvNj8Kr+1faPIGa+JNtPZdV79pIKzYysgkF2xCr73mbfOxf9D9
	 W6o8+65BsA5GffqhR0WYzlydDcz1gTt3ynymX0dqiQt2LWgswjosUqFV5+6fF17ck4
	 1eLRqjd3HUwcdg+Z6Td8PFpFXI2LA0COjxgRCjow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans-Frieder Vogt <hfdevel@gmx.net>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 082/783] net: tn40xx: add pci-id of the aqr105-based Tehuti TN4010 cards
Date: Tue, 27 May 2025 18:17:59 +0200
Message-ID: <20250527162516.482396630@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



