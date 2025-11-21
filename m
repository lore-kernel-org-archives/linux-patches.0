Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014AE3321D9;
	Fri, 21 Nov 2025 13:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763730934; cv=none; b=C0uN4Qnh8SSJnpc/0/zfcgfLvC1uP+FuTQG7dwsKA2pNcRGbWOFJDvJAmP28Tr5Yd4LaeEjRHPfk4wmHaCdL6EODOGFAOGtqJlypFR0qTEXq1bIBTzQjYQXdP1CXDKxlHtnnGs/E1AhhaXYrhqAfXchtXyzTmZEus9txqVToAuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763730934; c=relaxed/simple;
	bh=tPexeb7t2x0D/LGFt4OeB7Vy4FxzhM9g3q37FhxfWPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fnw/a7wPjAQhfmw1IkZMYwi0ZnevqVW+jI4c3smHXgUeb1bU+4rb7SvPdAtIJX62TyBV8nJ6XeuY2mWDwPUvIy14QeqnbIz7jwQctFIUmhuo945gOftodBhwHjf+VkLhC1y1h4nTDpoG7VtohYHRKhMWpzlIrAPNoYxyVhFLMrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f3eAi6O0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f3eAi6O0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 279C2C4CEF1;
	Fri, 21 Nov 2025 13:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763730933;
	bh=tPexeb7t2x0D/LGFt4OeB7Vy4FxzhM9g3q37FhxfWPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f3eAi6O0g6HqHJRkVniA1YVf/gsr1z8IC/fFkROhlahgCgWTwUzj/s/R6q/IX2g3w
	 0G6Cqg+dYBEZDEP8YhVqIxbzRTZbDmS9twzXD/VHWwTVfzbzZ5nb/yibZXyl83CIIx
	 JKDOw4SMVwAAK07qYYYhvUWJjodxTBGhwxBgtS4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhishek Tamboli <abhishektamboli9@gmail.com>,
	Even Xu <even.xu@intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 032/247] HID: intel-thc-hid: intel-quickspi: Add ARL PCI Device Ids
Date: Fri, 21 Nov 2025 14:09:39 +0100
Message-ID: <20251121130155.757206294@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abhishek Tamboli <abhishektamboli9@gmail.com>

[ Upstream commit 50f1f782f8d621a90108340c632bcb6ab4307d2e ]

Add the missing PCI ID for the quickspi device used on
the Lenovo Yoga Pro 9i 16IAH10.

Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=220567

Signed-off-by: Abhishek Tamboli <abhishektamboli9@gmail.com>
Reviewed-by: Even Xu <even.xu@intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/intel-thc-hid/intel-quickspi/pci-quickspi.c | 6 ++++++
 drivers/hid/intel-thc-hid/intel-quickspi/quickspi-dev.h | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/drivers/hid/intel-thc-hid/intel-quickspi/pci-quickspi.c b/drivers/hid/intel-thc-hid/intel-quickspi/pci-quickspi.c
index 84314989dc534..14cabd5dc6ddb 100644
--- a/drivers/hid/intel-thc-hid/intel-quickspi/pci-quickspi.c
+++ b/drivers/hid/intel-thc-hid/intel-quickspi/pci-quickspi.c
@@ -33,6 +33,10 @@ struct quickspi_driver_data ptl = {
 	.max_packet_size_value = MAX_PACKET_SIZE_VALUE_LNL,
 };
 
+struct quickspi_driver_data arl = {
+	.max_packet_size_value = MAX_PACKET_SIZE_VALUE_MTL,
+};
+
 /* THC QuickSPI ACPI method to get device properties */
 /* HIDSPI Method: {6e2ac436-0fcf-41af-a265-b32a220dcfab} */
 static guid_t hidspi_guid =
@@ -978,6 +982,8 @@ static const struct pci_device_id quickspi_pci_tbl[] = {
 	{PCI_DEVICE_DATA(INTEL, THC_PTL_U_DEVICE_ID_SPI_PORT2, &ptl), },
 	{PCI_DEVICE_DATA(INTEL, THC_WCL_DEVICE_ID_SPI_PORT1, &ptl), },
 	{PCI_DEVICE_DATA(INTEL, THC_WCL_DEVICE_ID_SPI_PORT2, &ptl), },
+	{PCI_DEVICE_DATA(INTEL, THC_ARL_DEVICE_ID_SPI_PORT1, &arl), },
+	{PCI_DEVICE_DATA(INTEL, THC_ARL_DEVICE_ID_SPI_PORT2, &arl), },
 	{}
 };
 MODULE_DEVICE_TABLE(pci, quickspi_pci_tbl);
diff --git a/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-dev.h b/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-dev.h
index f3532d866749c..c30e1a42eb098 100644
--- a/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-dev.h
+++ b/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-dev.h
@@ -21,6 +21,8 @@
 #define PCI_DEVICE_ID_INTEL_THC_PTL_U_DEVICE_ID_SPI_PORT2	0xE44B
 #define PCI_DEVICE_ID_INTEL_THC_WCL_DEVICE_ID_SPI_PORT1 	0x4D49
 #define PCI_DEVICE_ID_INTEL_THC_WCL_DEVICE_ID_SPI_PORT2 	0x4D4B
+#define PCI_DEVICE_ID_INTEL_THC_ARL_DEVICE_ID_SPI_PORT1 	0x7749
+#define PCI_DEVICE_ID_INTEL_THC_ARL_DEVICE_ID_SPI_PORT2 	0x774B
 
 /* HIDSPI special ACPI parameters DSM methods */
 #define ACPI_QUICKSPI_REVISION_NUM			2
-- 
2.51.0



