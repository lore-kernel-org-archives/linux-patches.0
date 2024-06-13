Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7224143870;
	Thu, 13 Jun 2024 11:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279352; cv=none; b=DXuLkyzJ1/wTnCYAQAsUR0O2ZJ0e/awKMYtMNLAFlQAfKEmU3i+o4W2mzX4eb3QyWgJqNRddmqvdvkIaXJ8cUUY6gLeXNYIN4VV/kwEP77cu5stAafUPRkHYAVDAJtEA+UD1PY8Iy9f3OEM3ZJDEmmzbk922AGKovD8TeLfViAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279352; c=relaxed/simple;
	bh=erEH3TgBvlZc9CyL+3Tv0cKVJeBKarwyJkzh0aZGcx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=etS7W4MjZMC8eLzQ77SRwDHfAe+Hy11qcHpah47bKSYmlCcR2xl+1MdGw3wXuu/IZshF3ITjgTepoTq23SROyswdm+l9pkg81sYm/kCm4jYL70d+MBdm3tJ0M8LpQZBtMCfh2ReuJhhcputnWg9LVpHaFYzVHFO9OYMie/WigWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IE2Xzkhz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IE2Xzkhz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44396C2BBFC;
	Thu, 13 Jun 2024 11:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279351;
	bh=erEH3TgBvlZc9CyL+3Tv0cKVJeBKarwyJkzh0aZGcx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IE2XzkhzHGliBoTXCjodvkhZt1GbZGKBquUkfJ1276Rf1sKeNtCin5Y2uu/n1+p3E
	 8jSTvsZz3CKV/XYer9BIbf40qflwABGN64smNBtWpwhCVN5RcZoSXgKN5BuFnjgR8v
	 btosEonrTkJSL3q76xP8yylZiRtFlMy+j1SJ54G8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy@kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.9 046/157] mmc: sdhci-acpi: Sort DMI quirks alphabetically
Date: Thu, 13 Jun 2024 13:32:51 +0200
Message-ID: <20240613113229.207327712@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
@@ -719,9 +719,22 @@ static const struct acpi_device_id sdhci
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
@@ -736,18 +749,6 @@ static const struct dmi_system_id sdhci_
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


