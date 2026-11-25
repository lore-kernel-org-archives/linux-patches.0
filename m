Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620432;
	b=3AGRCT8AeLEXR++KbCA3wa1cS4rTkN+Tmw0uFVPYRH5nRvpy7bvwfJJbubURYiK05k8s
	 7CC4OyN6xhPlhidF/bg043pM4u8aYW/ghX9O3nNUzIQalSJLKOA37nAnuzPluQBCs04V7
	 Sl5ee0PtwzLRmWGHuKTpY9pvUGo9k7Nygw8RpZSMmnYyt8tEpdSF1EiYfthfAY5cQ5x50
	 QkNGsrCf/4p/3/d1Cidz80pTNdW+C4HdCmQ5CVaNA/y6f4Vrs1oOKfkbAfiSl2X94s7KZ
	 Su3AbJiFGvc4+3TpA+PYUIUgCHFhXpjBhFj1zsKpwzVeFBeA0mqPFdTSekHbTrhHQiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620432;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E0Z7YpXKDFA1apx1Y/nvUfTp/09Q1En55X9FzTceU8w=;
	b=xZ1xqGmmnOloTM3yL66c8yeON/kHIFkIidBZQEn0H8CX/Jws5PeB117gJFyvUdzyo4ol
	 qPCByCxDVo3PRtwtkT+fpQ3GOCfCqsIoVMdiOT1beJkC2YW2+Ao5rMNS2xWuL9fX2jNjJ
	 1Qk0xDVIZt0WRcJ1dvBzaf0+mSf5NNeofaNxHGi3CwHPyb01FNw6+JLDllJTz6LitnLFT
	 4k6paupa1G4aYtjKNyWkS9XDV3KhZy+v09V4WNNynnkbaPssdbCpIzZr1mzlJTxIKtxnv
	 NA7NAE1AZR1dxopjFSMoGdb0uHaGQ722yJ9TooBXfCPdrudNtsTFHnG+sdl86l5heoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VZJRxXFj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCCB5606A31E;
	Wed, 25 Nov 2026 15:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VZJRxXFj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AC331F000C0;
	Wed, 25 Nov 2026 15:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620432;
	bh=E0Z7YpXKDFA1apx1Y/nvUfTp/09Q1En55X9FzTceU8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VZJRxXFjbFq+tHiqoCIxrwQwJacpNbIvakYa/oTPS+RQVCBLxsMQGdDXWJmDBoxFv
	 n6BJgGAbSKtF2zxpiWjvtvN4MUu9a/Ps89iOF3V+YSnHdrMPrN8zo8kCGePme8Ty0k
	 Gs0WNEQ8tQuvLzgE9jMef20PIhHwlDnwPWnbBDoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	McKenna Fan <blue_sun@tuta.io>,
	Quinn Schive <quinnschive@hotmail.com>,
	Bruno Filipe <bmilreu@gmail.com>,
	Maciej Zonski <me@zonni.pl>,
	Rishabh Jain <rishabh.jain1198@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 7.3 0915/1005] usb: pci-quirks: always assert xHCI OS ownership
Date: Wed, 25 Nov 2026 15:37:33 +0100
Message-ID: <20261125143843.126540111@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Rishabh Jain <rishabh.jain1198@gmail.com>

commit 5550405351199fe78f4a3cd606c07f5ad7220e1b upstream.

The xHCI ownership protocol requires the OS driver to assert the HC OS
Owned semaphore before using the host controller, then wait for HC BIOS
Owned to clear if firmware owns it.

quirk_usb_handoff_xhci() currently asserts OS Owned only when BIOS Owned
is already set. If firmware leaves BIOS Owned clear, Linux uses the xHC
while both ownership semaphores remain clear.

The timeout fallback also clears BIOS Owned using the original register
value, which can clear OS Owned at the same time.

On an AMD PROM21 xHCI controller (1022:43fc), this caused every S3
resume to terminate Controller Restore State with USBSTS 0x401. Linux
then reset the host controller, both root hubs and the USB Bluetooth
adapter.

The controller entered resume ready and halted with USBSTS 0x1.
Endpoint state, 100 ms save/restore delays, scratchpads, the DCBAA,
device contexts and command, event and transfer rings were verified not
to cause the restore error.

Across four S3 cycles, asserting only HC OS Owned changed USBLEGSUP from
0x00000801 to 0x01000801 and eliminated the restore failure. Testing
included the unmodified 7.1.8-ogc1.1.fc44.x86_64 distribution kernel
using a test module that set the HC OS Owned semaphore. The same test
was repeated after review with the same result. Clearing USBLEGCTLSTS
was independently verified to be unnecessary.

Always assert OS Owned for controllers using the standard xHCI handoff,
and leave the existing TI/Renesas forced handoff unchanged. Keep OS
Owned asserted after the standard handoff, including when forcing BIOS
Owned clear after a timeout, to prevent firmware from reclaiming the
controller during subsequent suspends.

Fixes: 66d4eadd8d06 ("USB: xhci: BIOS handoff and HW initialization.")
Cc: stable@vger.kernel.org
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Tested-by: McKenna Fan <blue_sun@tuta.io>
Tested-by: Quinn Schive <quinnschive@hotmail.com>
Tested-by: Bruno Filipe <bmilreu@gmail.com>
Tested-by: Maciej Zonski <me@zonni.pl>
Signed-off-by: Rishabh Jain <rishabh.jain1198@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://patch.msgid.link/20261105175106.241182-4-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/pci-quirks.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -1194,10 +1194,11 @@ static void quirk_usb_handoff_xhci(struc
 			 && pdev->device == 0x0014)) {
 		val = (val | XHCI_HC_OS_OWNED) & ~XHCI_HC_BIOS_OWNED;
 		writel(val, base + ext_cap_offset);
-	}
-
-	/* If the BIOS owns the HC, signal that the OS wants it, and wait */
-	if (val & XHCI_HC_BIOS_OWNED) {
+	} else {
+		/*
+		 * Perform the standard handoff and leave OS ownership set to
+		 * keep the BIOS at bay during subsequent suspends.
+		 */
 		writel(val | XHCI_HC_OS_OWNED, base + ext_cap_offset);
 
 		/* Wait for 1 second with 10 microsecond polling interval */
@@ -1209,7 +1210,9 @@ static void quirk_usb_handoff_xhci(struc
 			dev_warn(&pdev->dev,
 				 "xHCI BIOS handoff failed (BIOS bug ?) %08x\n",
 				 val);
-			writel(val & ~XHCI_HC_BIOS_OWNED, base + ext_cap_offset);
+			writel((val | XHCI_HC_OS_OWNED) &
+			       ~XHCI_HC_BIOS_OWNED,
+			       base + ext_cap_offset);
 		}
 	}
 


