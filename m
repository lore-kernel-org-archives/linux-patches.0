Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB31325481;
	Mon, 27 Oct 2025 19:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592499; cv=none; b=hJbZEyF5p4ZVJl5HiF+2bX/oO0zLSXprzuf9/BT9muq/P6IXq+xcUCw9jW5olX8W2u1jHpTa8kSFRSyqjtCupBJyCFPG0vI7oyspOaldwrbRpdsXcpzzVkQnYtsO5htffecXlg2Pwez4WR3Q9tl580WWezhLlWR9KXMjSRiM/Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592499; c=relaxed/simple;
	bh=J9fl33WFNFbsOGOlRwzwep3hluRryh8b6/eeZX1AgWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RZaZ5G0t3TJfKhuWU3budUwABJTKiBaHzn4Uwtk2DosfIbAR1WZVlPICmR9X+OYRDVd0dDqai5svWhhz3nBIt4z8cnsJLJ3fu1Bv6gAQGR5lQc0kqujc4qFCwxvv3Wp9N2J6KA9Sm7pFj6YujXQfHdC5GNzM2GLnmIqiyK6CYGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mmnWumBH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mmnWumBH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D89CC4CEF1;
	Mon, 27 Oct 2025 19:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592499;
	bh=J9fl33WFNFbsOGOlRwzwep3hluRryh8b6/eeZX1AgWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mmnWumBHmrgNQV+78kzNHpW73/13KiwYXXbaatahv9LwaBmzxYxZeo+Ns7Mq0Wg2E
	 q34hjtOrLmL7gGI1rS3jCtWDy/SZ5/uJlfZKxnlRdgDD+NL6DBdFc/vkc+vX4YNFwy
	 0iPyoQ1CyicFQ50T23KvRd+LN+HFfBnYaST9frZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Piotr Kwapulinski <piotr.kwapulinski@intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 143/157] PCI: Add PCI_VDEVICE_SUB helper macro
Date: Mon, 27 Oct 2025 19:36:44 +0100
Message-ID: <20251027183505.114545491@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Piotr Kwapulinski <piotr.kwapulinski@intel.com>

[ Upstream commit 208fff3f567e2a3c3e7e4788845e90245c3891b4 ]

PCI_VDEVICE_SUB generates the pci_device_id struct layout for
the specific PCI device/subdevice. Private data may follow the
output.

Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Piotr Kwapulinski <piotr.kwapulinski@intel.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: a7075f501bd3 ("ixgbevf: fix mailbox API compatibility by negotiating supported features")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/pci.h |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1027,6 +1027,20 @@ static inline struct pci_driver *to_pci_
 	.subvendor = PCI_ANY_ID, .subdevice = PCI_ANY_ID, 0, 0
 
 /**
+ * PCI_VDEVICE_SUB - describe a specific PCI device/subdevice in a short form
+ * @vend: the vendor name
+ * @dev: the 16 bit PCI Device ID
+ * @subvend: the 16 bit PCI Subvendor ID
+ * @subdev: the 16 bit PCI Subdevice ID
+ *
+ * Generate the pci_device_id struct layout for the specific PCI
+ * device/subdevice. Private data may follow the output.
+ */
+#define PCI_VDEVICE_SUB(vend, dev, subvend, subdev) \
+	.vendor = PCI_VENDOR_ID_##vend, .device = (dev), \
+	.subvendor = (subvend), .subdevice = (subdev), 0, 0
+
+/**
  * PCI_DEVICE_DATA - macro used to describe a specific PCI device in very short form
  * @vend: the vendor name (without PCI_VENDOR_ID_ prefix)
  * @dev: the device name (without PCI_DEVICE_ID_<vend>_ prefix)


