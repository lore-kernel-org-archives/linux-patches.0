Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD8033EB1D;
	Tue, 26 Aug 2025 11:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207807; cv=none; b=YoDOr2TjF5IbNaRP8ZRmNkbvYs+lkH3iZAFpd9sku5ZG4l+tWqKCcXMYV7BKww6UW9IEL6MtLpFrI/jBJV23nH1RXlvPAu4j1vRXGMiL0rxvtdXNejXtH5ukfZMshE92Jr479zCOqnk+W/bVUlYMy585G0zSqiuxSfpoyCL+KjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207807; c=relaxed/simple;
	bh=xAb8dyxvbjvhsnI/NnFKlic1kbLrVryN6EdkBnfYkR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rpcBvq1e9m0D+wFNtOuTNr7eCLfNWocEOR9IsOLWhfP/D5XkkeZet+DHFzyQn4954WIqvUvhnO7oiZ++67b0hQ/AHrURL25BRvlfaH9Sfri6XaKIIJxkg2UN6lA/tMkyIawC3nH3LC8tyHSl5u63rDvx41whd4/gojGGDKhGT2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OtjXR+J0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OtjXR+J0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25B58C4CEF1;
	Tue, 26 Aug 2025 11:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207807;
	bh=xAb8dyxvbjvhsnI/NnFKlic1kbLrVryN6EdkBnfYkR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OtjXR+J03pOa7e+9Wm8PaELOr4DJfWqo5IxFVEE21dnATPVnpcy1USK1ps/UbiPY2
	 bpqhoS2bVnUQSOSueKOLe5Msj66FpPFUzGfOuGbrK8SekvPDLLrK81AaDynLt+oeTe
	 3fm8L1DGa3+N7V+GRmNQiXU7R/N/y4j2Nu2FfOUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.16 325/457] usb: dwc3: pci: add support for the Intel Wildcat Lake
Date: Tue, 26 Aug 2025 13:10:09 +0200
Message-ID: <20250826110945.380651964@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

commit 86f390ba59cd8d5755bafe2b163c3e6b89d6bbd9 upstream.

This patch adds the necessary PCI ID for Intel Wildcat Lake
devices.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20250812131101.2930199-1-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-pci.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -41,6 +41,7 @@
 #define PCI_DEVICE_ID_INTEL_TGPLP		0xa0ee
 #define PCI_DEVICE_ID_INTEL_TGPH		0x43ee
 #define PCI_DEVICE_ID_INTEL_JSP			0x4dee
+#define PCI_DEVICE_ID_INTEL_WCL			0x4d7e
 #define PCI_DEVICE_ID_INTEL_ADL			0x460e
 #define PCI_DEVICE_ID_INTEL_ADL_PCH		0x51ee
 #define PCI_DEVICE_ID_INTEL_ADLN		0x465e
@@ -431,6 +432,7 @@ static const struct pci_device_id dwc3_p
 	{ PCI_DEVICE_DATA(INTEL, TGPLP, &dwc3_pci_intel_swnode) },
 	{ PCI_DEVICE_DATA(INTEL, TGPH, &dwc3_pci_intel_swnode) },
 	{ PCI_DEVICE_DATA(INTEL, JSP, &dwc3_pci_intel_swnode) },
+	{ PCI_DEVICE_DATA(INTEL, WCL, &dwc3_pci_intel_swnode) },
 	{ PCI_DEVICE_DATA(INTEL, ADL, &dwc3_pci_intel_swnode) },
 	{ PCI_DEVICE_DATA(INTEL, ADL_PCH, &dwc3_pci_intel_swnode) },
 	{ PCI_DEVICE_DATA(INTEL, ADLN, &dwc3_pci_intel_swnode) },


