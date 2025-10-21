Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C9DF274B2E;
	Tue, 21 Oct 2025 19:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076639; cv=none; b=rtltIeX6CVS7VqM9ryDcFbzUb85XcGvjgz/Tr4Giz9f2igbiaVuyQhk6dEfBu6C2UWF7TueU+9mI4xjOP8evb5T3l6ojHFo2HeamZLQe7KqW9SE6f/MfOhgjTrFqFblOi1yndqZzhIJxnq8YrSUztmNr+fRlREdHs2QZIy93mgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076639; c=relaxed/simple;
	bh=ALHH4l/Dq5vDThnp3rB+HhbB05y9zty6VXYahHNEcUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fpL8vHUkacYdkV0FzA7MchY1y7ZAU4czaR3XUXDOmMqyZLj/p58LG2HhXtP9wDkB1PX8qE846oHlouwFlDSMjwq6lMIu/7lR0fIWM5+722ixzCGL+TVe51H9bi22k/zVbXwQy5zeGfn7wCcfTVMwyaDEH6uQ0oZk6l1eOeo54b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tkf6YXgf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tkf6YXgf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A0C1C4CEF1;
	Tue, 21 Oct 2025 19:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076638;
	bh=ALHH4l/Dq5vDThnp3rB+HhbB05y9zty6VXYahHNEcUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tkf6YXgfJc8fKUUzGeGt1DLIMfhaHW6vEXchhRMiebBpPlahSeGPLK31j8XDqS1ro
	 ysUkIyjLaxLRI4q1u1NEBkNyzoXXYfg+EiXbGNeCfG0zpLD98AmzL7BAAzbwVJQF8Y
	 IpLI09vkg5AtwOh8Osd3NSxEWJdAfw9ELOSmgw/U=
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
Subject: [PATCH 6.6 095/105] PCI: Add PCI_VDEVICE_SUB helper macro
Date: Tue, 21 Oct 2025 21:51:44 +0200
Message-ID: <20251021195023.907502378@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
References: <20251021195021.492915002@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1035,6 +1035,20 @@ static inline struct pci_driver *to_pci_
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


