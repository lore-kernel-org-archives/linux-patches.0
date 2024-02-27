Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48F113B293;
	Tue, 27 Feb 2024 13:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041118; cv=none; b=AkkGCMj1rkMDIyaJIoJhtHxWemsbpAA5A2bniDlBivI2wyjnSXYGxJnvbT2RmCnibPV8l7BorK3TEzQjArZpAWjJYCZSbZSVNhxmkRC+3RdSaa4OhclfOVMJ82gDd6txb5zuO93VriSU519e5KV4fmk/3fxNSVMMQgKVxEyAs1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041118; c=relaxed/simple;
	bh=PmJj2c01emL/kSPlzFkwk+Czo5FEzgEiWLMovnJINms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JnA6/946xenkBtrmNahSCqe8534ZSzTYa3caGbdOgpzCpUI6gl0QGGWn4aonK89cb4eCbBpcjG4xO5RPbBrz/QxqFlzQBDKEsJ5i4lv/P9O+dYRCnu8LoLMNz9IamYYW4PDMm5YFtk/R9H2bsJ02KM1/0kPh3qI1uDxBwMMf5WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uerLWqQv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uerLWqQv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CF31C43399;
	Tue, 27 Feb 2024 13:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041118;
	bh=PmJj2c01emL/kSPlzFkwk+Czo5FEzgEiWLMovnJINms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uerLWqQvNfJkrE0zihxN0A4e/ZFfMCGeeCVSyQ2EIwoq+oYCqq2ImfPTzroqpGE1Z
	 pi3VJb6h0FF0ENA0DmvqV+D4pgvg0H9kdwELvT36L2FB9fcrAdabVjIRAP03go3o5i
	 EA/u5cMvuWJ4C17/bz9C31+NBWqR3h7VPwo9gRVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lennert Buytenhek <kernel@wantstofly.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.7 227/334] ahci: Extend ASM1061 43-bit DMA address quirk to other ASM106x parts
Date: Tue, 27 Feb 2024 14:21:25 +0100
Message-ID: <20240227131638.116088405@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lennert Buytenhek <kernel@wantstofly.org>

commit 51af8f255bdaca6d501afc0d085b808f67b44d91 upstream.

ASMedia have confirmed that all ASM106x parts currently listed in
ahci_pci_tbl[] suffer from the 43-bit DMA address limitation that we ran
into on the ASM1061, and therefore, we need to apply the quirk added by
commit 20730e9b2778 ("ahci: add 43-bit DMA address quirk for ASMedia
ASM1061 controllers") to the other supported ASM106x parts as well.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-ide/ZbopwKZJAKQRA4Xv@x1-carbon/
Signed-off-by: Lennert Buytenhek <kernel@wantstofly.org>
[cassel: add link to ASMedia confirmation email]
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/ahci.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -606,13 +606,13 @@ static const struct pci_device_id ahci_p
 	{ PCI_VDEVICE(PROMISE, 0x3781), board_ahci },   /* FastTrak TX8660 ahci-mode */
 
 	/* ASMedia */
-	{ PCI_VDEVICE(ASMEDIA, 0x0601), board_ahci },	/* ASM1060 */
-	{ PCI_VDEVICE(ASMEDIA, 0x0602), board_ahci },	/* ASM1060 */
+	{ PCI_VDEVICE(ASMEDIA, 0x0601), board_ahci_43bit_dma },	/* ASM1060 */
+	{ PCI_VDEVICE(ASMEDIA, 0x0602), board_ahci_43bit_dma },	/* ASM1060 */
 	{ PCI_VDEVICE(ASMEDIA, 0x0611), board_ahci_43bit_dma },	/* ASM1061 */
 	{ PCI_VDEVICE(ASMEDIA, 0x0612), board_ahci_43bit_dma },	/* ASM1061/1062 */
-	{ PCI_VDEVICE(ASMEDIA, 0x0621), board_ahci },   /* ASM1061R */
-	{ PCI_VDEVICE(ASMEDIA, 0x0622), board_ahci },   /* ASM1062R */
-	{ PCI_VDEVICE(ASMEDIA, 0x0624), board_ahci },   /* ASM1062+JMB575 */
+	{ PCI_VDEVICE(ASMEDIA, 0x0621), board_ahci_43bit_dma },	/* ASM1061R */
+	{ PCI_VDEVICE(ASMEDIA, 0x0622), board_ahci_43bit_dma },	/* ASM1062R */
+	{ PCI_VDEVICE(ASMEDIA, 0x0624), board_ahci_43bit_dma },	/* ASM1062+JMB575 */
 	{ PCI_VDEVICE(ASMEDIA, 0x1062), board_ahci },	/* ASM1062A */
 	{ PCI_VDEVICE(ASMEDIA, 0x1064), board_ahci },	/* ASM1064 */
 	{ PCI_VDEVICE(ASMEDIA, 0x1164), board_ahci },   /* ASM1164 */


