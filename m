Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D16BA3F;
	Mon,  1 Apr 2024 16:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990555; cv=none; b=QOjzvUm9ob2iy+Un6Lkioii786v3lQq44SIJ0Vyp5hjdDk2wJzu7d2HTwy4aS/RYq3PKZ6jVdJFgRW3Nmbbq/6ZRdGkOKytIY21wWr8R91+qVDF0OjGRkUvftt9umsX/r0lW3mWyrmNP83cNyn/5nLetrnFZY977gjSdRgt24L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990555; c=relaxed/simple;
	bh=M3vuZicsw/Cajmh1PS+fD1j2dP0Fn2oKZgUZRnTOZmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CP1DCLCrqvKGA3BFgZImV5Fz81/LOaRXV+Lh6EHqxyH5msrasjgba9C8usMO7WzjvY2aTx6nfhxVVLdzIhksKkpJynxo5ow8JQMhUZOK68y3+l5tRiwRFDpCATNFFDO0x3BiCV4S9XRVRdXOfrLYHAa4kGCOWycNWREFGS1eIvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t1oPKY2R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t1oPKY2R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80DC6C433F1;
	Mon,  1 Apr 2024 16:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990554;
	bh=M3vuZicsw/Cajmh1PS+fD1j2dP0Fn2oKZgUZRnTOZmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t1oPKY2RDh2eR5pXqtbdCu+kusQb7oG7nuTJIHqm0rJuTUntZ3mU0AEdQzIZlPjF4
	 2xQJIOggqh+Hho2iXrMulosvv/9a5+UHj+6OcZnkqa/y72LCSE43XGNrR8FrtLtZ5y
	 yMLsTFl8d2ty3gFavZd0uW1z9LTlje1fOL3R3KK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.6 390/396] usb: dwc3: pci: Drop duplicate ID
Date: Mon,  1 Apr 2024 17:47:19 +0200
Message-ID: <20240401152559.539482171@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


