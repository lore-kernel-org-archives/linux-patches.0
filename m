Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E35B846F;
	Tue, 30 Sep 2025 15:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244740; cv=none; b=RoEAxAdo1BnPRxaTq1UcC4/cViKYhN+nXjEbKCPwVds9gJnw0RthuqEj4/qqghnQ9GNnc2PUMlsXTB+Qx777DcgiEuHzmeP+hb/jLTBcs5BgbqVAt3AYCxM8cVx67brFpE7chQa9QPRTp1iu9T+wPyy7wqf8kSoPy30QwK/df5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244740; c=relaxed/simple;
	bh=BIINlTQkBbcPKl6I9/n82vQXcPqetTGstbxEIxDT/h8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gJosUAIewW0G3vz/uozGnnT/BK24Np+NAbplgphj0JI7AK72AyD8YgQEXlggIHhe4HmcwmlqVaR3x6kMgJbIgnpafxd0naj13QaJUI7UW3e0OyyYZUIRAMOPj0tloi8OvuVS8yQ1/7PgL2J1Tl+qHpKPOO+txzA8ZP1eGDgluWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=umSyHNAi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="umSyHNAi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E575EC4CEF0;
	Tue, 30 Sep 2025 15:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244740;
	bh=BIINlTQkBbcPKl6I9/n82vQXcPqetTGstbxEIxDT/h8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=umSyHNAiGOJDl/+d7V5e7VAObr73mgcYZDxFw5+IwRAvGUJpATWEjG9FouPSWEW6n
	 Z0VCzvWDfgyyt1bhBNTJzntOTuZTvrSfC27w3yFHWMJ0EjFFNGlHOE7LazxeoD5aa7
	 VbvC8ZEz7YdV+yCySNCGryDqqjV29VomIsEi1L+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xinpeng Sun <xinpeng.sun@intel.com>,
	Even Xu <even.xu@intel.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.16 100/143] HID: intel-thc-hid: intel-quickspi: Add WCL Device IDs
Date: Tue, 30 Sep 2025 16:47:04 +0200
Message-ID: <20250930143835.213271162@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xinpeng Sun <xinpeng.sun@intel.com>

commit cc54ed51c761728f6933cca889b684ed7fbaaf07 upstream.

Add THC SPI WildcatLake device IDs.

Signed-off-by: Xinpeng Sun <xinpeng.sun@intel.com>
Reviewed-by: Even Xu <even.xu@intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/intel-thc-hid/intel-quickspi/pci-quickspi.c |    2 ++
 drivers/hid/intel-thc-hid/intel-quickspi/quickspi-dev.h |    2 ++
 2 files changed, 4 insertions(+)

--- a/drivers/hid/intel-thc-hid/intel-quickspi/pci-quickspi.c
+++ b/drivers/hid/intel-thc-hid/intel-quickspi/pci-quickspi.c
@@ -961,6 +961,8 @@ static const struct pci_device_id quicks
 	{PCI_DEVICE_DATA(INTEL, THC_PTL_H_DEVICE_ID_SPI_PORT2, &ptl), },
 	{PCI_DEVICE_DATA(INTEL, THC_PTL_U_DEVICE_ID_SPI_PORT1, &ptl), },
 	{PCI_DEVICE_DATA(INTEL, THC_PTL_U_DEVICE_ID_SPI_PORT2, &ptl), },
+	{PCI_DEVICE_DATA(INTEL, THC_WCL_DEVICE_ID_SPI_PORT1, &ptl), },
+	{PCI_DEVICE_DATA(INTEL, THC_WCL_DEVICE_ID_SPI_PORT2, &ptl), },
 	{}
 };
 MODULE_DEVICE_TABLE(pci, quickspi_pci_tbl);
--- a/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-dev.h
+++ b/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-dev.h
@@ -19,6 +19,8 @@
 #define PCI_DEVICE_ID_INTEL_THC_PTL_H_DEVICE_ID_SPI_PORT2	0xE34B
 #define PCI_DEVICE_ID_INTEL_THC_PTL_U_DEVICE_ID_SPI_PORT1	0xE449
 #define PCI_DEVICE_ID_INTEL_THC_PTL_U_DEVICE_ID_SPI_PORT2	0xE44B
+#define PCI_DEVICE_ID_INTEL_THC_WCL_DEVICE_ID_SPI_PORT1 	0x4D49
+#define PCI_DEVICE_ID_INTEL_THC_WCL_DEVICE_ID_SPI_PORT2 	0x4D4B
 
 /* HIDSPI special ACPI parameters DSM methods */
 #define ACPI_QUICKSPI_REVISION_NUM			2


