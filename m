Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC96952F88;
	Mon, 11 Dec 2023 18:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hvZEib/5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60341C433C8;
	Mon, 11 Dec 2023 18:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320011;
	bh=LKHXXCH8pDV7ZKBXm2yXgEPBgHHeSrZjkjciznn6cGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hvZEib/5kxKCDU62eH2bAumwZ3x6VcCNzOMrF2anOf1Tr41D0u1GkzoVsoBbs/CST
	 22iMuH9ftW9h5Jhw8w/QJ3F64jQyMAxaI18WZ7m7jZ97xS3q8vhbJND4owi0kT8Eb2
	 OFI8hUmnSiEKr985x0PbrqMXR5jZ5AurFZSK/vho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.10 71/97] Revert "xhci: Loosen RPM as default policy to cover for AMD xHC 1.1"
Date: Mon, 11 Dec 2023 19:22:14 +0100
Message-ID: <20231211182022.830278521@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182019.802717483@linuxfoundation.org>
References: <20231211182019.802717483@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 24be0b3c40594a14b65141ced486ae327398faf8 upstream.

This reverts commit 4baf1218150985ee3ab0a27220456a1f027ea0ac.

Enabling runtime pm as default for all AMD xHC 1.1 controllers caused
regression. An initial attempt to fix those was done in commit a5d6264b638e
("xhci: Enable RPM on controllers that support low-power states") but new
issues are still seen.

Revert this to get those AMD xHC 1.1 systems working

This patch went to stable an needs to be reverted from there as well.

Fixes: 4baf12181509 ("xhci: Loosen RPM as default policy to cover for AMD xHC 1.1")
Link: https://lore.kernel.org/linux-usb/55c50bf5-bffb-454e-906e-4408c591cb63@molgen.mpg.de
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20231205090548.1377667-1-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -345,8 +345,6 @@ static void xhci_pci_quirks(struct devic
 	/* xHC spec requires PCI devices to support D3hot and D3cold */
 	if (xhci->hci_version >= 0x120)
 		xhci->quirks |= XHCI_DEFAULT_PM_RUNTIME_ALLOW;
-	else if (pdev->vendor == PCI_VENDOR_ID_AMD && xhci->hci_version >= 0x110)
-		xhci->quirks |= XHCI_DEFAULT_PM_RUNTIME_ALLOW;
 
 	if (xhci->quirks & XHCI_RESET_ON_RESUME)
 		xhci_dbg_trace(xhci, trace_xhci_dbg_quirks,


