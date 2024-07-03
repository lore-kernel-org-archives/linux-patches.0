Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECEA181B9A;
	Wed,  3 Jul 2024 11:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005523; cv=none; b=kkIsCq6EiS3pl47JoHgTTh32gu/aWr2Sg/YuX8KIvPZRSLoM85PfHkAKghHCWGAQNsw+agkvFlKnL1Uk6xJqqqucK4dDDYw+qE5N2tqu4tXggQLCF/doZRz6YxDMx9V11+NQGG5tyPkFGdDyki+vpf/FqzHotaORkMgw1OITS0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005523; c=relaxed/simple;
	bh=+R4bSm6t3WnrSHDiAI8K3HDiCVZ6324rSTejLVM3OVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qZwDuE5mhI5F2hj9xFAPRIRD9z01a2zSls7hxILe6Atee03VQPYPDxdd0MJifeT9CsPo/DOQB7Pxxa/9nFdbWu2JChqG+QLpIMMTztANBTUK2zhAT9Q3mdi7p661PPagI/5elIpxcNRCnMr+3xeciVEqCmkshDn6WZMrcUpGCo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XtXzs5uk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XtXzs5uk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 722F1C4AF0B;
	Wed,  3 Jul 2024 11:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005522;
	bh=+R4bSm6t3WnrSHDiAI8K3HDiCVZ6324rSTejLVM3OVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XtXzs5ukdvAQVgMSGLHcolTfzGgSNDXGMtOj18ZHMoNBkMafkpZMT0PX6aGaCZO36
	 3R+0PXm16z5R/3lVKt71JdXRtnDMIi706syghFlYY9Uaob8Mi+sSAwvHHdBKJhtjSX
	 wv9e+tQ8v4moblCj15ZkiquwqZCQpPLTv1IE1BHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuangyi Chiang <ki.chiang65@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.15 079/356] xhci: Apply reset resume quirk to Etron EJ188 xHCI host
Date: Wed,  3 Jul 2024 12:36:55 +0200
Message-ID: <20240703102916.093281136@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -36,6 +36,7 @@
 
 #define PCI_VENDOR_ID_ETRON		0x1b6f
 #define PCI_DEVICE_ID_EJ168		0x7023
+#define PCI_DEVICE_ID_EJ188		0x7052
 
 #define PCI_DEVICE_ID_INTEL_LYNXPOINT_XHCI	0x8c31
 #define PCI_DEVICE_ID_INTEL_LYNXPOINT_LP_XHCI	0x9c31
@@ -276,6 +277,10 @@ static void xhci_pci_quirks(struct devic
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


