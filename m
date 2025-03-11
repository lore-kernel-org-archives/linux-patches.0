Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B5425DAFD;
	Tue, 11 Mar 2025 15:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705964; cv=none; b=OkrGUnxbyfUjOogSEtrSxco3XiLxAb+MDNJ+f9lwh2fV9i1distUZ/kE1vzO54FCRYBaLDXqFL2xEsBpJDY2aiZn0rKgPk6vre74fuWVdeayiWlYgxRaPrKbIuLcZ4MCD8Dy63VoKPnOVPkVS/Vz5EhdTDUkjWnpV9MAE3QaYlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705964; c=relaxed/simple;
	bh=MZSPod3JaRGWs9c+aFPNvyxiC3Gm2dP7NtBgbTZPTnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eKEzhnrc5SZfiXbEjwqMJp4O7er4/W68+Ox30XpLP6LT0M8lUXMvK+m2IROtvbj7a2M7us/J5xjqHSADoNKdYqe9u6GefXvtlxjOsf0UibAyctP50DRr2LYagTe8yAbiMCplGFSuQUHTYnnbd2wBaPOavZWCdVMXmDDVQIdhBUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YB5Onm2v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YB5Onm2v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0CF3C4CEE9;
	Tue, 11 Mar 2025 15:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705964;
	bh=MZSPod3JaRGWs9c+aFPNvyxiC3Gm2dP7NtBgbTZPTnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YB5Onm2vWkQu3ecGJHIpZvYhTAnai49weGT+7wTuL9fUCt7s6NBmrsLlg1hoUAxWW
	 tdtzZV8Au3qb25G9BVmIc/qKwc2gEn1+VAYW/cZTRIRhHJUenOXkK9IrWpW1d2VQD5
	 vJLRkUCaW21dx3WbEAU+LiMOCEaCHc6nEURnK1nI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaqing Zhao <jiaqing.zhao@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Tomita Moeko <tomitamoeko@gmail.com>
Subject: [PATCH 5.4 216/328] can: ems_pci: move ASIX AX99100 ids to pci_ids.h
Date: Tue, 11 Mar 2025 15:59:46 +0100
Message-ID: <20250311145723.488826111@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1764,6 +1764,10 @@
 #define PCI_SUBDEVICE_ID_AT_2700FX	0x2701
 #define PCI_SUBDEVICE_ID_AT_2701FX	0x2703
 
+#define PCI_VENDOR_ID_ASIX		0x125b
+#define PCI_DEVICE_ID_ASIX_AX99100	0x9100
+#define PCI_DEVICE_ID_ASIX_AX99100_LB	0x9110
+
 #define PCI_VENDOR_ID_ESS		0x125d
 #define PCI_DEVICE_ID_ESS_ESS1968	0x1968
 #define PCI_DEVICE_ID_ESS_ESS1978	0x1978


