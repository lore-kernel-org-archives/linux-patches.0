Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9A870812;
	Mon,  6 Jan 2025 15:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177570; cv=none; b=e19lW45eQyW0VHNjSS0efXtgWDCTVmTmbBJEZAo94SOjNYxcNSMIado6Hjdo7avv/MU7YjXCcnax8JXYbhq2ie1cAji0qp91ev7wWpS+irbcMZ1e93rCwKJg1MJxekDzAjC/e08AAsIEarqQ58uLhlHe8xy1LfdMjxj/jLDMz9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177570; c=relaxed/simple;
	bh=b0bLlwiBV33GccsJWimv82VGqDN+Bnw9fjhHysg9Gyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z9HHWBxTcIplCsz2vhSiC142kozY/A3GpmR2MQnYzwlIT9EUYXEczKaYVZILWcIAaTBXY0AyGqIYZfzThYmLhkfbgcbDZ0Dg7/5AcOtUAOEHH7QmQO9forwAR9iMNrRNPPNjsDwY5twr1uMm6cdaCP+xiyV9146x+1380Ucfe24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M6YcRu8S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M6YcRu8S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE59C4CED2;
	Mon,  6 Jan 2025 15:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177569;
	bh=b0bLlwiBV33GccsJWimv82VGqDN+Bnw9fjhHysg9Gyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M6YcRu8SO6ZtEfP+6a7ps0+uW5DiIS9vQvJ08znyXymkXXXSYwaV6QwEr9Ceefntr
	 f2kZ2qvqhhobrxUCv4/plpZvuLkpT6uazshc9dCta9A8EusKVeHeG/MmCDfkfUx9LT
	 LnunEUG/wl97bbuCoc1+Rb4Ksqt9zTgdI5raL1WE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pascal Hambourg <pascal@plouf.fr.eu.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 207/222] sky2: Add device ID 11ab:4373 for Marvell 88E8075
Date: Mon,  6 Jan 2025 16:16:51 +0100
Message-ID: <20250106151158.602539209@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pascal Hambourg <pascal@plouf.fr.eu.org>

commit 03c8d0af2e409e15c16130b185e12b5efba0a6b9 upstream.

A Marvell 88E8075 ethernet controller has this device ID instead of
11ab:4370 and works fine with the sky2 driver.

Signed-off-by: Pascal Hambourg <pascal@plouf.fr.eu.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/10165a62-99fb-4be6-8c64-84afd6234085@plouf.fr.eu.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/sky2.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -129,6 +129,7 @@ static const struct pci_device_id sky2_i
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0x436C) }, /* 88E8072 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0x436D) }, /* 88E8055 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0x4370) }, /* 88E8075 */
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0x4373) }, /* 88E8075 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0x4380) }, /* 88E8057 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0x4381) }, /* 88E8059 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0x4382) }, /* 88E8079 */


