Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5EADBA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:07:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B9A8C433D2;
	Tue,  7 Mar 2023 17:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678208841;
	bh=MbPX3zIMr+E7/SMstMu02mPLHQmSIzsNCCmSL5U8ZKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aniVsIvbGpv1T6FmTUpPS8d5WLH055Bj6Htfo196OBwt2pnPvEbTHnIsxTJCAAgqG
	 5sVuspbyurNe+1snjjfauIFuYAhAxi3nQPYo+BM9xKwIzuga4poQ/rEcBz0llqx/nB
	 0d8R+ap2/FPeefKSmjnP6GO7fo7Y1HVhGeXEfSKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH 6.2 0008/1001] ata: ahci: Revert "ata: ahci: Add Tiger Lake UP{3,4} AHCI controller"
Date: Tue,  7 Mar 2023 17:46:20 +0100
Message-Id: <20230307170022.499864318@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

commit 6210038aeaf49c395c2da57572246d93ec67f6d4 upstream.

Commit 104ff59af73a ("ata: ahci: Add Tiger Lake UP{3,4} AHCI
controller") enabled low power mode for the Tiger Lake AHIC adapter in
the author system but created regressions for others. Revert this patch
for now until a better solution is found to make this adapter
eco-friendly.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=217114
CC: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/ahci.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -421,7 +421,6 @@ static const struct pci_device_id ahci_p
 	{ PCI_VDEVICE(INTEL, 0x34d3), board_ahci_low_power }, /* Ice Lake LP AHCI */
 	{ PCI_VDEVICE(INTEL, 0x02d3), board_ahci_low_power }, /* Comet Lake PCH-U AHCI */
 	{ PCI_VDEVICE(INTEL, 0x02d7), board_ahci_low_power }, /* Comet Lake PCH RAID */
-	{ PCI_VDEVICE(INTEL, 0xa0d3), board_ahci_low_power }, /* Tiger Lake UP{3,4} AHCI */
 
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,


