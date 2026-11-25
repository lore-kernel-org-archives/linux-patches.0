Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626122;
	b=a2iPivCUMrWmV/0WkwhPR2AU4ntvq5/LKpkJIW1wZERIbg+7JyTuelkCqfv6Rw7+wZoi
	 uQqGXwt+b+qQYvuf+FxOi3SQUDTAqWScXvZVf0Gs74RH2WhlKA8KbRQ6Gi4lu6chi/jvN
	 P0Mm2Jeg8PSPmIhZN0hrhHGm4l6dVYeFhbTlpwtYDllDfA5qMl09FyW5CEEP05F03ujBR
	 otTYUdd2X6n8u1fWhGP523LfmKVY6iDganGLvRY4JLne80j1ja7ey8B4lMge1cpB6QQKT
	 eUUh+fxzcyo5NEZVCKwxPT2ei/7fjzPwaXn3A63grdxnIAjFdIa3+K3TCZIGQjhHP2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626122;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6+fs2LzGWSlfADJXGieLPTzW+FV55d2kSNrf0ZWOaxU=;
	b=28uNq5jimyuaERxRvOPdx92fiIbObLOrmNohH4x8GySrbIHM3NcSgnRDqTTfo3I7nsGm
	 +QnIEAwy+bN11ipBE2a0lwvck888T13WjA3t1MIokZ9GozVvQ6ytwWdRTdDLefMsU/oqo
	 K1j3E42CTMkj0fDZF4W0PREc01xltKSSyrlixHAS6jk7bkBx9uiglbcq+JSRSya8lgbg3
	 lZVrjykXGPNEFdoS81kful7+W/ZIUnyEd2U1N4OD93AvYnpevgx8wfPYcMflMu6GVI5SV
	 e/pCdnattk2QYvhEyiXoWXHf9OhgWMviIYl1TahDXXUEEF5KCu1ovMhDy+pXrN4O4tQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ASZ2/vVn";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38931606A323;
	Wed, 25 Nov 2026 17:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ASZ2/vVn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F0841F000C6;
	Wed, 25 Nov 2026 17:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626122;
	bh=6+fs2LzGWSlfADJXGieLPTzW+FV55d2kSNrf0ZWOaxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ASZ2/vVn1B5TEFqbqszrBl/6NexOsMYiy5i/mSBNnziq3dgI+MeE+DUlZUe2SRUQn
	 UwYerVQ3RovFMzRf+/RYkVT8ymOTzjOG12IuD+3stXeWFcjXz5mlSoDF9VOGTW2vFn
	 3VIrWZCSwW6BBFlwcCQKpJXPfVz1Eyv2d1vRf1l4=
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
Subject: [PATCH 6.12 738/816] usb: pci-quirks: always assert xHCI OS ownership
Date: Wed, 25 Nov 2026 15:38:06 +0100
Message-ID: <20261125143906.262034983@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


