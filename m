Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B066918FDC3;
	Wed,  3 Jul 2024 11:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004462; cv=none; b=K1PxgAV2zSd99RJFi/AavgsZliREFa7iBbIlEjFln1/twOfZVG+pTw13teQ/lhQyp1S2ds+Xuacja+UNjM8aaePTF5fqvC+CJG/l9lf/JPhcP2nmrTnIRYpP8ZCFGBfMLJPpLJwmaVxuDMxoSujsmNH12XMG+J+Pb9CxDtMpRr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004462; c=relaxed/simple;
	bh=J/t+ta8KCb0EKEAnFpn1v7lhj+4R8DstDcQ1zfc8uAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kbbn0MPK5qGVqWvdv/291LW+Tcg0f6xqKhFyDiyGw+625T4JxNLHawTYR2ZlLoN7RPwQVFA9LF+8UP5/OieUuSOoXCULEeXMCZHyO7YEwCGUaPu+X4AJ4Av+u0v0GLsF9eda3y7b23xQhXOFb997hVeAEGCACOGWnuHI/WIxAug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lODvFNyb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lODvFNyb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF967C2BD10;
	Wed,  3 Jul 2024 11:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004462;
	bh=J/t+ta8KCb0EKEAnFpn1v7lhj+4R8DstDcQ1zfc8uAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lODvFNyb1rYkL4xstRfbqu9vIXVvdOv3U+4X2fFm6G5LKPOXporMfi/R3idaWLNAC
	 +B0WVb1QjQgmIqsblN6UmTv/yQe8DE5DL9v8kRk1YyqxzEkWGpsThsSQvTCArsT82C
	 utH9Kwx7vOIh2sUf5pJ+mNqKZRjlGls3+pF4006E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuangyi Chiang <ki.chiang65@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.10 048/290] xhci: Apply reset resume quirk to Etron EJ188 xHCI host
Date: Wed,  3 Jul 2024 12:37:09 +0200
Message-ID: <20240703102906.017788575@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

From: Kuangyi Chiang <ki.chiang65@gmail.com>

commit 17bd54555c2aaecfdb38e2734149f684a73fa584 upstream.

As described in commit c877b3b2ad5c ("xhci: Add reset on resume quirk for
asrock p67 host"), EJ188 have the same issue as EJ168, where completely
dies on resume. So apply XHCI_RESET_ON_RESUME quirk to EJ188 as well.

Cc: stable@vger.kernel.org
Signed-off-by: Kuangyi Chiang <ki.chiang65@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20240611120610.3264502-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -35,6 +35,7 @@
 
 #define PCI_VENDOR_ID_ETRON		0x1b6f
 #define PCI_DEVICE_ID_EJ168		0x7023
+#define PCI_DEVICE_ID_EJ188		0x7052
 
 #define PCI_DEVICE_ID_INTEL_LYNXPOINT_XHCI	0x8c31
 #define PCI_DEVICE_ID_INTEL_LYNXPOINT_LP_XHCI	0x9c31
@@ -270,6 +271,10 @@ static void xhci_pci_quirks(struct devic
 		xhci->quirks |= XHCI_TRUST_TX_LENGTH;
 		xhci->quirks |= XHCI_BROKEN_STREAMS;
 	}
+	if (pdev->vendor == PCI_VENDOR_ID_ETRON &&
+			pdev->device == PCI_DEVICE_ID_EJ188)
+		xhci->quirks |= XHCI_RESET_ON_RESUME;
+
 	if (pdev->vendor == PCI_VENDOR_ID_RENESAS &&
 	    pdev->device == 0x0014) {
 		xhci->quirks |= XHCI_TRUST_TX_LENGTH;


