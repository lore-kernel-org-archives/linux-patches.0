Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B43E24113C;
	Tue, 29 Apr 2025 16:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945248; cv=none; b=Wd+gCd8czBQ/i2eY8xqugu5QwpfFJKYTAZabenXvNIiwc1v8LwV0GCWlyVhM2Tn106MKePKFceYpnCFkh6rCcQkmaeBSLQz9sd7bNU819x/YYX8t2Ly7RyAWcTZzXXM8o1jG0MMi/EuuMxuF5/58bB+w/AlreJmrzBZna0Bd8k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945248; c=relaxed/simple;
	bh=W6zBwJrZByKaG7TFeIwKaS9XBUkQ3m0jHL03dDiabk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qoop/nndf7IZxollLRc1b4D0dWKrvZGfok964X+2/QeaZn2tJ6aJckm6FY7PqQCgE3BoXMPwM7aBwsQNVJTHpEsn/MnwpZahrAD5Il43m4m2z3dY8KFBefXxyLXF4iC+yPxqW2C1NfNeI/lb/HREsambsJApb6HrxYpIGWCVLDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rMBwj2iJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rMBwj2iJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A87D5C4CEED;
	Tue, 29 Apr 2025 16:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945248;
	bh=W6zBwJrZByKaG7TFeIwKaS9XBUkQ3m0jHL03dDiabk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rMBwj2iJeoMxwaTHf0fG3uVCa6tyYLJ02MYEimzHGBJusWKxrgvHlD89KDJWpr4X2
	 3eGfaxSpA7oUsID+4pGG3+2kVbUM/0dW0UYlqO503yV/3lVxKbWbRBRFZglvPYBlY8
	 XTRtmxFaRiRjZYVAq9r238GC6NQCj+JGfgJAmZqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Kral <d.kral@proxmox.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 022/179] ahci: add PCI ID for Marvell 88SE9215 SATA Controller
Date: Tue, 29 Apr 2025 18:39:23 +0200
Message-ID: <20250429161050.309552963@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Kral <d.kral@proxmox.com>

[ Upstream commit 885251dc35767b1c992f6909532ca366c830814a ]

Add support for Marvell Technology Group Ltd. 88SE9215 SATA 6 Gb/s
controller, which is e.g. used in the DAWICONTROL DC-614e RAID bus
controller and was not automatically recognized before.

Tested with a DAWICONTROL DC-614e RAID bus controller.

Signed-off-by: Daniel Kral <d.kral@proxmox.com>
Link: https://lore.kernel.org/r/20250304092030.37108-1-d.kral@proxmox.com
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/ahci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 2d2a070c1efcb..3c8fa08f5d970 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -558,6 +558,8 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	  .driver_data = board_ahci_yes_fbs },
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x91a3),
 	  .driver_data = board_ahci_yes_fbs },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x9215),
+	  .driver_data = board_ahci_yes_fbs },
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x9230),
 	  .driver_data = board_ahci_yes_fbs },
 	{ PCI_DEVICE(PCI_VENDOR_ID_TTI, 0x0642), /* highpoint rocketraid 642L */
-- 
2.39.5



