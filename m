Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623565;
	b=NC9DVLN65oVbhn6IOaE1xPTmZB6p8k83VgcJDerc1IGW1nLyx4PjIs1e980QOEpN57d5
	 gSzgt3HbgJWQFVM2Mo/37EGAWiWhJMZqkQOhKq3Kdc9bzbvibRQPXi/MGfAhsqbThXjLt
	 2H+uNcoWq81Ghm1BosopEnHnj+uEinVJg9caPSHQmJOhftUQXflqM8I2W9iAMEZhDNnH3
	 Vuj0eRxy4zUUbOOdEjXz7TEpnGOJUWX8lSwFaUp4sCQqsUCirGdSTrEKt4whIxmJdMFew
	 zjXDoroEuGMIlyU3tJ58NYGGrI2ORGWTGUGks+RFaywx8wvkCX8ce/mWY/jZ247nxXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623565;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RXDqsDUEYr3Q+UoTJuOOT4jMTBKYAZKI+ugwDDaP40E=;
	b=ZFJKsFm5cBTnvHeJLGe3OXgwASXH2SL6AYZHyb/x/XQ2ZdcfJG1n0cBvG9L1KylK/16R
	 WDbejqcZfxxCmzApHg4qAJblhRQE74yXnWzwJnpTJL/OV6R69DnZtp/KsYZuByfdrdIcz
	 NgdVOGFqfJ7xBqtOUinhi1L8EGEvzvVbO7h4kAbT3Clzull0jGFucbRc7Xp5N/GS+bd39
	 grW7mrUZVSI8Jn39cG0pCBe0TF+nmOWYAb5X5s5k0d9GG+q9zqgAg7tJ75Sm2zSRPGQ4B
	 gIIakKuMTThSCC/yY5nhPZJUgBmLs+zUcLGRR917zmi3FAIPgKgTC/iGL/Xhd73kMsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lkCg9TJT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F32F606A31E;
	Wed, 25 Nov 2026 16:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lkCg9TJT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FFDB1F000C0;
	Wed, 25 Nov 2026 16:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623565;
	bh=RXDqsDUEYr3Q+UoTJuOOT4jMTBKYAZKI+ugwDDaP40E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lkCg9TJTAmhm3cNeJ5gO8hiFehxXm5TLAIH96kt6SGTfvGo4xPgrwAo8SZi5zSjoD
	 EJUgdmrQ+tPjtR83WLt0fHkRG/mi0iACKhAzqvIpehR2att0nrP14NKeRsiBuhstOt
	 tttlKn7M1FJpShmqQ2xXHrAUdlA96J136CrWUnFI=
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
Subject: [PATCH 6.18 901/990] usb: pci-quirks: always assert xHCI OS ownership
Date: Wed, 25 Nov 2026 15:37:48 +0100
Message-ID: <20261125143843.115952530@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


