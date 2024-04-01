Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0EA8F5C;
	Mon,  1 Apr 2024 16:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987827; cv=none; b=k7X5PQz70FHC+A7xmHTjaMYurTAguN2qYg9tpMLlxVRAb8FhRrhbQDShhh+HbhicTfeFJCo74qdyCfpr8BUVSgfp4u/e1ZMUnXTw8mDKvVEcvM+fcQjxIb9QUH3PKdlfCVWU7D8eVDfPfig00v39vQoRKAwfGj7zjgEL28kJpCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987827; c=relaxed/simple;
	bh=/wpbOoJm7fhymXUryNsmmfZcX/h+xa7xduKzkSVJ43U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P23Kz9ijYeXaQyz6+B/sK028XtTxDKJ6/Y83+FeBbTxvVuyw28OqBILVulDYKUJd9QOlHGIn0Yn4JoI3f5SIw71GlpTKeEtIFpeunk5K+fELd1d3Jerqr5Z6GufVluS+EzeWwX0yzPuirDl8HYwyqJm1KHOvlbVikqvGX748kGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W9GWMTjd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W9GWMTjd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4608C433C7;
	Mon,  1 Apr 2024 16:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987827;
	bh=/wpbOoJm7fhymXUryNsmmfZcX/h+xa7xduKzkSVJ43U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W9GWMTjd4Y9rTzgj/+s30Xp1uz+Ofy9EKFDknz0QaMxBUUVdtISY4bhUn9I8rY6S2
	 F59z7kfUSgztmHCte/8WCPIBNcshd5FECv7bW5YXq41cmWYV4PDPRcLlpRKIoalayX
	 dAhfxdIglGlpRjQkWTSkZNma0HO0w/SwBpe2sEUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.8 392/399] usb: dwc3: pci: Drop duplicate ID
Date: Mon,  1 Apr 2024 17:45:58 +0200
Message-ID: <20240401152600.869739539@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

commit f121531703ae442edc1dde4b56803680628bc5b7 upstream.

Intel Arrow Lake CPU uses the Meteor Lake ID with this
controller (the controller that's part of the Intel Arrow
Lake chipset (PCH) does still have unique PCI ID).

Fixes: de4b5b28c87c ("usb: dwc3: pci: add support for the Intel Arrow Lake-H")
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20240312115008.1748637-1-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-pci.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -51,7 +51,6 @@
 #define PCI_DEVICE_ID_INTEL_MTLP		0x7ec1
 #define PCI_DEVICE_ID_INTEL_MTLS		0x7f6f
 #define PCI_DEVICE_ID_INTEL_MTL			0x7e7e
-#define PCI_DEVICE_ID_INTEL_ARLH		0x7ec1
 #define PCI_DEVICE_ID_INTEL_ARLH_PCH		0x777e
 #define PCI_DEVICE_ID_INTEL_TGL			0x9a15
 #define PCI_DEVICE_ID_AMD_MR			0x163a
@@ -423,7 +422,6 @@ static const struct pci_device_id dwc3_p
 	{ PCI_DEVICE_DATA(INTEL, MTLP, &dwc3_pci_intel_swnode) },
 	{ PCI_DEVICE_DATA(INTEL, MTL, &dwc3_pci_intel_swnode) },
 	{ PCI_DEVICE_DATA(INTEL, MTLS, &dwc3_pci_intel_swnode) },
-	{ PCI_DEVICE_DATA(INTEL, ARLH, &dwc3_pci_intel_swnode) },
 	{ PCI_DEVICE_DATA(INTEL, ARLH_PCH, &dwc3_pci_intel_swnode) },
 	{ PCI_DEVICE_DATA(INTEL, TGL, &dwc3_pci_intel_swnode) },
 


