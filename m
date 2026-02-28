Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D6A2DE717
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301134; cv=none; b=K+hivw3cufWoeNXGZAmKKWJw91HGlPjEhO0thhvN3TDTrbzM28WLcal+yYUmb1KBgQRKV1RNK3XxMwq46jsuxLSR55dpx5xw5YTnUI/ELA3N8o9fLFg4yKIzxcKCRPJC/KuhQqLmfTUVtp4qwjqReJ6Iy95KZFbTFHfekQMVXRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301134; c=relaxed/simple;
	bh=9n/77D7SHGD+jZCD8YEk5TpknP8Mf7bg0I7zM6fLeSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eiX8Atecjnn+cL+vhGrdF8J7kiPBDLvoKxtc9952hltEmPlxsSyyxwvs1Oxwl1TP9NPWVllcurK+2M2ZoqsCagg2J+A5e+HQLrg4POX9Pm9DyxgXzKmXfVQHAih0uDRhENZwt5Qt5P2h0rgMm3SXEPVHpylA00MYJK0g9TU3mcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E/MRu7Tx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E/MRu7Tx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4886FC116D0;
	Sat, 28 Feb 2026 17:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301133;
	bh=9n/77D7SHGD+jZCD8YEk5TpknP8Mf7bg0I7zM6fLeSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E/MRu7Txde800Eiirup+7iQRcMbtezjBesme/JP73cHp6KDZwuZY5gClMqXc8IE/W
	 4QH5rTDpe8JCiOIIyz/42F7qC6vUafuyBrRi7LsByXyZ2luaZNsl4KK5XOQCezvZoM
	 5TCgVJarU2mO8SDxKCC09kKs8t337uwySzVDK1Gmhz3HMY3ph50xUGed1/pIJrCDUq
	 YEkF8gypzZCx7Y2l6hAXIow3Unqvr1ADPbY2zGk61Gsd4aUGpQL+2hYT3nEnGsp3MC
	 CRRAOwP6wve4/9+pwB9jYkCDc6Hah6jieesSKd1Xr2UTnbeCa0a39kj7Q0V/41YB2C
	 2L+RXQKv5KdZg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 293/752] PCI: Add ACS quirk for Qualcomm Hamoa & Glymur
Date: Sat, 28 Feb 2026 12:40:04 -0500
Message-ID: <20260228174750.1542406-293-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>

[ Upstream commit 44d2f70b1fd72c339c72983fcffa181beae3e113 ]

The Qualcomm Hamoa & Glymur Root Ports don't advertise an ACS capability,
but they do provide ACS-like features to disable peer transactions and
validate bus numbers in requests.

Add an ACS quirk for Hamoa & Glymur.

Signed-off-by: Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260109-acs_quirk-v1-1-82adf95a89ae@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index c38434d973cd2..62554152caf37 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5117,6 +5117,10 @@ static const struct pci_dev_acs_enabled {
 	{ PCI_VENDOR_ID_QCOM, 0x0401, pci_quirk_qcom_rp_acs },
 	/* QCOM SA8775P root port */
 	{ PCI_VENDOR_ID_QCOM, 0x0115, pci_quirk_qcom_rp_acs },
+	/* QCOM Hamoa root port */
+	{ PCI_VENDOR_ID_QCOM, 0x0111, pci_quirk_qcom_rp_acs },
+	/* QCOM Glymur root port */
+	{ PCI_VENDOR_ID_QCOM, 0x0120, pci_quirk_qcom_rp_acs },
 	/* HXT SD4800 root ports. The ACS design is same as QCOM QDF2xxx */
 	{ PCI_VENDOR_ID_HXT, 0x0401, pci_quirk_qcom_rp_acs },
 	/* Intel PCH root ports */
-- 
2.51.0

