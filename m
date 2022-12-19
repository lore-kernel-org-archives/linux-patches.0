Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0096FB9
	for <patches@lists.linux.dev>; Mon, 19 Dec 2022 19:24:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD9BC433EF;
	Mon, 19 Dec 2022 19:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1671477851;
	bh=vYKeTppjGl837v9HY6B7ZCuKfbLO4QPiHSBQ2EWEIeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L7nBnhbp0RsIRxLU49FToLIvL6/DnSGb5CSO5R3RhsKz+YqLEmOYVqDViFL6zdWyj
	 eZ7mFjy+qDkDSwElOQmxGQgwyrUC4cDyfGIxwMzAc0trns8YDfYV0mHwSxdEWEGYWx
	 99t793PU3ve736eZ3MTTRWgmX64QLtqkS89X/M1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Shruthi Sanil <shruthi.sanil@intel.com>
Subject: [PATCH 6.1 22/25] usb: dwc3: pci: Update PCIe device ID for USB3 controller on CPU sub-system for Raptor Lake
Date: Mon, 19 Dec 2022 20:23:01 +0100
Message-Id: <20221219182944.333617395@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221219182943.395169070@linuxfoundation.org>
References: <20221219182943.395169070@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shruthi Sanil <shruthi.sanil@intel.com>

commit f05f80f217bf52443a2582bca19fd78188333f25 upstream.

The device ID 0xa70e is defined for the USB3 device controller in the CPU
sub-system of Raptor Lake platform. Hence updating the ID accordingly.

Fixes: bad0d1d726ac ("usb: dwc3: pci: Add support for Intel Raptor Lake")
Cc: stable <stable@kernel.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Shruthi Sanil <shruthi.sanil@intel.com>
Link: https://lore.kernel.org/r/20221125105327.27945-1-shruthi.sanil@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -45,7 +45,7 @@
 #define PCI_DEVICE_ID_INTEL_ADLN		0x465e
 #define PCI_DEVICE_ID_INTEL_ADLN_PCH		0x54ee
 #define PCI_DEVICE_ID_INTEL_ADLS		0x7ae1
-#define PCI_DEVICE_ID_INTEL_RPL			0x460e
+#define PCI_DEVICE_ID_INTEL_RPL			0xa70e
 #define PCI_DEVICE_ID_INTEL_RPLS		0x7a61
 #define PCI_DEVICE_ID_INTEL_MTLP		0x7ec1
 #define PCI_DEVICE_ID_INTEL_MTL			0x7e7e


