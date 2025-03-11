Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36FDC25D904;
	Tue, 11 Mar 2025 15:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707176; cv=none; b=BsyvOjnqeHlvN5e9vxjgCL2asmKvGuvs94Gmg2QONLNHuQo2ervrmAEB40EmZtY/5t5QJvQ96i0w/9OH/+qtjmQXuGWPtFo+ftOnRFKEeotuywXQDaNDAduQQgAI8H7Pm8sVAlUQ3x5OZmXq5lK01xx1MfA6leFJVQGwStpydw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707176; c=relaxed/simple;
	bh=EtE/cxMDdlpA2jnXLIf8M5JaYGSqry1m8c7Hdc1DMqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=djlnK62fjDjPX2xH6BKPTBfpKCvn3m6NsJuIp7m2TcRjM1E6jwauOwQP8F1N2nytZEFPSYo78hL/3WiqfIZIOWWZhEyKPjyXhEcOOVcXGCn17bYtThevomHFKMIMrO9RDq7epVJYLvw5+a9s9ybTLmKdoxRUgXg0yfrLtcTq1xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K0QqcwHu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K0QqcwHu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1328C4CEE9;
	Tue, 11 Mar 2025 15:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707176;
	bh=EtE/cxMDdlpA2jnXLIf8M5JaYGSqry1m8c7Hdc1DMqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K0QqcwHuKAZNd0xLXKldxhudb2pq03ufYQWqJ+yeLEBi5V/R62YE67RAA29Rl1YD+
	 n/gTD1s5opivc/2BkUyTQ54mg1GpP3HqC/96J6RIpbVvC1Nu8y2i+HOl7iEJNNuNBh
	 vx5aulumIkscUN5+zWQYX8rAMFmMmUPtUV/OE8FE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaqing Zhao <jiaqing.zhao@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Tomita Moeko <tomitamoeko@gmail.com>
Subject: [PATCH 5.10 299/462] serial: 8250_pci: add support for ASIX AX99100
Date: Tue, 11 Mar 2025 15:59:25 +0100
Message-ID: <20250311145810.175385636@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiaqing Zhao <jiaqing.zhao@linux.intel.com>

commit 0b32216557ce3b2a468d1282d99b428bf72ff532 upstream.

Each of the 4 PCI functions on ASIX AX99100 PCIe to Multi I/O
Controller can be configured as a single-port serial port controller.
The subvendor id is 0x1000 when configured as serial port and MSI
interrupts are supported.

Signed-off-by: Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20230724083933.3173513-4-jiaqing.zhao@linux.intel.com
Signed-off-by: Tomita Moeko <tomitamoeko@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_pci.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -65,6 +65,8 @@ static const struct pci_device_id pci_us
 			 0xA000, 0x1000) },
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9922,
 			 0xA000, 0x1000) },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ASIX, PCI_DEVICE_ID_ASIX_AX99100,
+			 0xA000, 0x1000) },
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_HP_3PAR, PCI_DEVICE_ID_HPE_PCI_SERIAL,
 			 PCI_ANY_ID, PCI_ANY_ID) },
 	{ }
@@ -5785,6 +5787,14 @@ static const struct pci_device_id serial
 	{	PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9865,
 		0xA000, 0x3004,
 		0, 0, pbn_b0_bt_4_115200 },
+
+	/*
+	 * ASIX AX99100 PCIe to Multi I/O Controller
+	 */
+	{	PCI_VENDOR_ID_ASIX, PCI_DEVICE_ID_ASIX_AX99100,
+		0xA000, 0x1000,
+		0, 0, pbn_b0_1_115200 },
+
 	/* Intel CE4100 */
 	{	PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_CE4100_UART,
 		PCI_ANY_ID,  PCI_ANY_ID, 0, 0,


