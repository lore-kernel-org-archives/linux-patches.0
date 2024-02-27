Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5599113B2B4;
	Tue, 27 Feb 2024 14:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042446; cv=none; b=LAIJY22hEScEE9pNEcsxOHPh0JY3+h7raMx14G9Hdrr/4GdgWi1Gln8ov/Tz0s91EHtnjZlNwaspMOPMSS2Nlw9V1lpzMhfl2k5fRotIeaRx0Y4RlEKi171cthgEm1qEilIDOWXE/irfjIR+ah+Q4YJcFL92jozAH3De1B7KRmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042446; c=relaxed/simple;
	bh=9otMNLf3iwAWZzOb9Oylt8lhzEAifjkBjN5mAzNGi+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X2IJpJIdlW4MW7N0uFQR6KyHaQQDq/ANK/0/RiQK4QjXDsOplveuoCzWhdQTxykHIezjJp+BskNHmsyYEX31xc+v8J/K+7TVGj1+O9IHUZlBSqKzT2cAvS8akZpAOZhokjb5e5/rGGNGqZOgIycu/UgK8yD3IX7mz3TkFeJNTPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=riw6asm0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="riw6asm0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA6CC43390;
	Tue, 27 Feb 2024 14:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042446;
	bh=9otMNLf3iwAWZzOb9Oylt8lhzEAifjkBjN5mAzNGi+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=riw6asm08Avo1LsBDZA6GBbzfE8umkO9G/4W8ulAYiHx3oaDWx/q9BPBzueXQEe6O
	 E2w6zdlk9HojfWkZncqhCnwOp4dos29O+v6HBEDXlKy5kFV6FEKUHPQdAC9VH9/25M
	 iSRVpdFpoQ/Wh9rUca/05rKtFuSNWgd+RxmafD3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Szuying Chen <Chloe_Chen@asmedia.com.tw>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 6.6 298/299] ata: ahci: add identifiers for ASM2116 series adapters
Date: Tue, 27 Feb 2024 14:26:49 +0100
Message-ID: <20240227131635.254318868@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Szuying Chen <chensiying21@gmail.com>

commit 3bf6141060948e27b62b13beb216887f2e54591e upstream.

Add support for PCIe SATA adapter cards based on Asmedia 2116 controllers.
These cards can provide up to 10 SATA ports on PCIe card.

Signed-off-by: Szuying Chen <Chloe_Chen@asmedia.com.tw>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/ahci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -612,6 +612,11 @@ static const struct pci_device_id ahci_p
 	{ PCI_VDEVICE(ASMEDIA, 0x0621), board_ahci },   /* ASM1061R */
 	{ PCI_VDEVICE(ASMEDIA, 0x0622), board_ahci },   /* ASM1062R */
 	{ PCI_VDEVICE(ASMEDIA, 0x0624), board_ahci },   /* ASM1062+JMB575 */
+	{ PCI_VDEVICE(ASMEDIA, 0x1062), board_ahci },	/* ASM1062A */
+	{ PCI_VDEVICE(ASMEDIA, 0x1064), board_ahci },	/* ASM1064 */
+	{ PCI_VDEVICE(ASMEDIA, 0x1164), board_ahci },   /* ASM1164 */
+	{ PCI_VDEVICE(ASMEDIA, 0x1165), board_ahci },   /* ASM1165 */
+	{ PCI_VDEVICE(ASMEDIA, 0x1166), board_ahci },   /* ASM1166 */
 
 	/*
 	 * Samsung SSDs found on some macbooks.  NCQ times out if MSI is


