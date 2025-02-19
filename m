Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2DB1B85EC;
	Wed, 19 Feb 2025 09:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957561; cv=none; b=ivlmy8LzP6RtSSF/CUSdyK+SZ6QgTh3uIsFy//RMAREi/nyvnkwCChS+5LQ7bR56vphbQ15vKaT2OKP9At/qwep3MFyQTfRXlZqEfUtyKT8wX+kUTTnUe/azx7oGYWhkDg9uHIocCw2NmcZ9PrUcw5hDE0mFdUffc63mhSVU0U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957561; c=relaxed/simple;
	bh=HIhhsoySFB9biqRCOvRmF5qujoWsY3PAzpBgWeZqt0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r5n7kw5Jhq2XGor+JdkbZutcil22hYcktZrkXWe329v84oD8dPhks3rm8EllANVsFuwCfc1KakR+NC1zL2Zb12IsO8MlPVQQMqTBRbcqIrwiS4G/sHOLrFQ0cT3VPr5TqGEfcIAe8/U9dGugv1mhMjqB1uf85ugkrun34yZpbos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iAUND1/I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iAUND1/I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4E62C4CEE6;
	Wed, 19 Feb 2025 09:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957561;
	bh=HIhhsoySFB9biqRCOvRmF5qujoWsY3PAzpBgWeZqt0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iAUND1/IDBf2AlJAmH3Av2kaPTRk6KuJg8778/bIorX+1juiDlRsfbztsIkME3ieE
	 MBfNH5kAv6NItSejw+yzuXHr+WAqh13Cs80cNHUTyln2JEpKZ6T6SfcvYV0dw8fszd
	 wgq4FrR5Mm0vXYQwVNCXjszgjozTd8HNCMmxXq1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaqing Zhao <jiaqing.zhao@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Tomita Moeko <tomitamoeko@gmail.com>
Subject: [PATCH 6.1 569/578] can: ems_pci: move ASIX AX99100 ids to pci_ids.h
Date: Wed, 19 Feb 2025 09:29:33 +0100
Message-ID: <20250219082715.340206159@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1754,6 +1754,10 @@
 #define PCI_SUBDEVICE_ID_AT_2700FX	0x2701
 #define PCI_SUBDEVICE_ID_AT_2701FX	0x2703
 
+#define PCI_VENDOR_ID_ASIX		0x125b
+#define PCI_DEVICE_ID_ASIX_AX99100	0x9100
+#define PCI_DEVICE_ID_ASIX_AX99100_LB	0x9110
+
 #define PCI_VENDOR_ID_ESS		0x125d
 #define PCI_DEVICE_ID_ESS_ESS1968	0x1968
 #define PCI_DEVICE_ID_ESS_ESS1978	0x1978


