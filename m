Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DAEA847A
	for <patches@lists.linux.dev>; Wed,  1 Mar 2023 18:13:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA41C4339B;
	Wed,  1 Mar 2023 18:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677694387;
	bh=5NAdFxwR50VXvOTQd5/tWgQsPobC2mLNwXKp53KNXWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cuqQRFPhGMw4X5iWz2CpLlz1SYF78t7JmtkGAqPLE2LZgWsuhH8/p+bZ1fcLiUOiD
	 y00J2XkwsBqIC+2ugWdgwT0/uzQjUPVrwR944EsKokobE/xsyI8toR6o1MTfTMezrV
	 ZiLxBtd9HN5Y94mrkGrQveWqNBzhyN/gerXGuEiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.1 30/42] usb: dwc3: pci: add support for the Intel Meteor Lake-M
Date: Wed,  1 Mar 2023 19:08:51 +0100
Message-Id: <20230301180658.404779637@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180657.003689969@linuxfoundation.org>
References: <20230301180657.003689969@linuxfoundation.org>
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

commit 8e5248c3a8778f3e394e9a19195bc7a48f567ca2 upstream.

This patch adds the necessary PCI IDs for Intel Meteor Lake-M
devices.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230215132711.35668-1-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-pci.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -47,6 +47,7 @@
 #define PCI_DEVICE_ID_INTEL_ADLS		0x7ae1
 #define PCI_DEVICE_ID_INTEL_RPL			0xa70e
 #define PCI_DEVICE_ID_INTEL_RPLS		0x7a61
+#define PCI_DEVICE_ID_INTEL_MTLM		0x7eb1
 #define PCI_DEVICE_ID_INTEL_MTLP		0x7ec1
 #define PCI_DEVICE_ID_INTEL_MTL			0x7e7e
 #define PCI_DEVICE_ID_INTEL_TGL			0x9a15
@@ -467,6 +468,9 @@ static const struct pci_device_id dwc3_p
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_RPLS),
 	  (kernel_ulong_t) &dwc3_pci_intel_swnode, },
 
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_MTLM),
+	  (kernel_ulong_t) &dwc3_pci_intel_swnode, },
+
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_MTLP),
 	  (kernel_ulong_t) &dwc3_pci_intel_swnode, },
 


