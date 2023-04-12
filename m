Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD122F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:49:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA198C4339B;
	Wed, 12 Apr 2023 08:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289350;
	bh=jt+VKwPlE5zDAyCCCYF9J1iVwPrU6UANaCUz928spFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BZeszJGG/BYq/dOL9OIyieZqgZ8tk45zSwjYhSq9wSNY+FXoDYTSDefyJfP6hkvYv
	 3VSDjITdcS7Cx/lt2WI5qYNZuP872MPF4Sfl0rr7iQaJiTWG8TbNAiG4G9UoR+x3Ns
	 LNSKcedVQfK+NDC6ej9aaM4jPbUiFqRfZ3YA2g6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.2 066/173] usb: dwc3: pci: add support for the Intel Meteor Lake-S
Date: Wed, 12 Apr 2023 10:33:12 +0200
Message-Id: <20230412082840.736720353@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

commit ec799c8a92e0be91e0940cc739a27f483242df65 upstream.

This patch adds the necessary PCI ID for Intel Meteor Lake-S
devices.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230330150224.89316-1-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-pci.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -49,6 +49,7 @@
 #define PCI_DEVICE_ID_INTEL_RPLS		0x7a61
 #define PCI_DEVICE_ID_INTEL_MTLM		0x7eb1
 #define PCI_DEVICE_ID_INTEL_MTLP		0x7ec1
+#define PCI_DEVICE_ID_INTEL_MTLS		0x7f6f
 #define PCI_DEVICE_ID_INTEL_MTL			0x7e7e
 #define PCI_DEVICE_ID_INTEL_TGL			0x9a15
 #define PCI_DEVICE_ID_AMD_MR			0x163a
@@ -474,6 +475,9 @@ static const struct pci_device_id dwc3_p
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_MTLP),
 	  (kernel_ulong_t) &dwc3_pci_intel_swnode, },
 
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_MTLS),
+	  (kernel_ulong_t) &dwc3_pci_intel_swnode, },
+
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_MTL),
 	  (kernel_ulong_t) &dwc3_pci_intel_swnode, },
 


