Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611C5143861;
	Thu, 13 Jun 2024 12:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281548; cv=none; b=lAwx27XQhOyhHWWbHJyfWtgwMFlxr0wxH/I7Rt8cMWguRPN4OcSWBPwEMBML8qVcZslFRqup9alZicEFmyt1QLwHKhgP5Ni90rKckF86pt/OCYFVJ6SSowhnSBnMN3VBJ76emGbt2U5a64/68QH1kx/4OMUsmqunuj46XChAv4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281548; c=relaxed/simple;
	bh=yj2R76RxeUNM3r4jGNr7BGUrcBSM5d2RETgLcpSMDVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LH/ZNH5oZCQfZOdaMIRcZZw0qEWPriXddwEbkr8qoz5Ez2zGBRe2/5hGUwoVhvmlr+I08rdR2BxK4Z+dy90Ay7BQUuNjywA5uRp07ITmQ7W53/N2DLL5Q0udhxFzuT2vOY/glIcCQNPBHvCE9HukSNIwTVnIe7azOhU20VaPuaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ncfLtyht; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ncfLtyht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9AFEC2BBFC;
	Thu, 13 Jun 2024 12:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281548;
	bh=yj2R76RxeUNM3r4jGNr7BGUrcBSM5d2RETgLcpSMDVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ncfLtyht3ki2bfLhfQai4Tvv3jMUvlDP7ZAUn3Ads+lRT47/RU4hs0NjWDkl8FNJZ
	 cNjgLZYBWGcHxvqcBZIxLz8J00BSVd8Mhnizp105sqU8m5Rgu5GsFQ1YqbmOBc1Eb6
	 6lP4MOhVK1bTjNVlI1+ImAgtPvTXkV7SZLmlV7pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy@kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 291/317] mmc: sdhci-acpi: Sort DMI quirks alphabetically
Date: Thu, 13 Jun 2024 13:35:09 +0200
Message-ID: <20240613113258.809260975@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit a92a73b1d9249d155412d8ac237142fa716803ea upstream.

Sort the DMI quirks alphabetically.

Reviewed-by: Andy Shevchenko <andy@kernel.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240410191639.526324-4-hdegoede@redhat.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-acpi.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

--- a/drivers/mmc/host/sdhci-acpi.c
+++ b/drivers/mmc/host/sdhci-acpi.c
@@ -761,9 +761,22 @@ static const struct acpi_device_id sdhci
 };
 MODULE_DEVICE_TABLE(acpi, sdhci_acpi_ids);
 
+/* Please keep this list sorted alphabetically */
 static const struct dmi_system_id sdhci_acpi_quirks[] = {
 	{
 		/*
+		 * The Acer Aspire Switch 10 (SW5-012) microSD slot always
+		 * reports the card being write-protected even though microSD
+		 * cards do not have a write-protect switch at all.
+		 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire SW5-012"),
+		},
+		.driver_data = (void *)DMI_QUIRK_SD_NO_WRITE_PROTECT,
+	},
+	{
+		/*
 		 * The Lenovo Miix 320-10ICR has a bug in the _PS0 method of
 		 * the SHC1 ACPI device, this bug causes it to reprogram the
 		 * wrong LDO (DLDO3) to 1.8V if 1.8V modes are used and the
@@ -778,18 +791,6 @@ static const struct dmi_system_id sdhci_
 	},
 	{
 		/*
-		 * The Acer Aspire Switch 10 (SW5-012) microSD slot always
-		 * reports the card being write-protected even though microSD
-		 * cards do not have a write-protect switch at all.
-		 */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire SW5-012"),
-		},
-		.driver_data = (void *)DMI_QUIRK_SD_NO_WRITE_PROTECT,
-	},
-	{
-		/*
 		 * The Toshiba WT8-B's microSD slot always reports the card being
 		 * write-protected.
 		 */


