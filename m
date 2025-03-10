Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFDAB2356AB;
	Mon, 10 Mar 2025 18:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630473; cv=none; b=b+CgiSQyjO6uC0Tnr2vGoo4b+pEwpAKa55U7C94U8ZOCqt6pd1fjtzBZD/eB2sUEtWNr2cBwGrEjpZv8j7T75El7ngH8/ruLehsOAC1ThLcw91XGW702Dmy9I9pIDk8Qvj6T69qvxf7/k3IRTGIUSFrCnDILNHasQ0mkuvahVLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630473; c=relaxed/simple;
	bh=R5qy/53bbF/5MX3H4JzvC+WFlzByXk8DLK/Vtpv19s0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CJUZUjzWihZPBLlr4/yHxE1fIFSBZo7csv1VsASGTrgLDe5zNNrWOZSVaN3iiE3ioG8/Nc8xlCNhQlUORuht6YSBfYAfz9q8vtLRp8XoUOrj4EiGN8bgb1NmqfCsAvrpy7jBQQIO5vJeJvAetxnpmF4JTMesr5Oe4azybmbVqFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J0NAcMYc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J0NAcMYc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEBE9C4CEE5;
	Mon, 10 Mar 2025 18:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630473;
	bh=R5qy/53bbF/5MX3H4JzvC+WFlzByXk8DLK/Vtpv19s0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J0NAcMYclREHy02aj3blJON7lIEG9b56hqKKPl4e/9ffWrIQDecABV7DlgR4SgxQE
	 OpB6znffiIDowSHNGPxjSGUgMW9e60cwH9sYUs0AOmNJt0JNip24XQwQKtqw4EWVEC
	 GopCbwLW0sY6OceydjeHVtRRJS0Nl62XCW4N7L9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaqing Zhao <jiaqing.zhao@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Tomita Moeko <tomitamoeko@gmail.com>
Subject: [PATCH 5.15 419/620] can: ems_pci: move ASIX AX99100 ids to pci_ids.h
Date: Mon, 10 Mar 2025 18:04:25 +0100
Message-ID: <20250310170602.127076655@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiaqing Zhao <jiaqing.zhao@linux.intel.com>

commit 3029ad91335353a70feb42acd24d580d70ab258b upstream.

Move PCI Vendor and Device ID of ASIX AX99100 PCIe to Multi I/O
Controller to pci_ids.h for its serial and parallel port driver
support in subsequent patches.

Signed-off-by: Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>
Link: https://lore.kernel.org/r/20230724083933.3173513-3-jiaqing.zhao@linux.intel.com
[Moeko: Drop changes in drivers/net/can/sja1000/ems_pci.c]
Signed-off-by: Tomita Moeko <tomitamoeko@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/pci_ids.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1743,6 +1743,10 @@
 #define PCI_SUBDEVICE_ID_AT_2700FX	0x2701
 #define PCI_SUBDEVICE_ID_AT_2701FX	0x2703
 
+#define PCI_VENDOR_ID_ASIX		0x125b
+#define PCI_DEVICE_ID_ASIX_AX99100	0x9100
+#define PCI_DEVICE_ID_ASIX_AX99100_LB	0x9110
+
 #define PCI_VENDOR_ID_ESS		0x125d
 #define PCI_DEVICE_ID_ESS_ESS1968	0x1968
 #define PCI_DEVICE_ID_ESS_ESS1978	0x1978


