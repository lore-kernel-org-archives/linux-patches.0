Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD035384;
	Thu, 13 Jun 2024 12:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282928; cv=none; b=ZirjjJcVm1Vvgl3TTmBmz7KUC3mZtxpa8qXlrJ9BMzhdzsNzPQ0ONel6Seq/qLGiHpTrowxEIwKGsqP0OPH8riqLAt8n0IJP18nXt3IipzvSxt8YYKlxLJz0EUprI4t4we/KI/W+VEsYBrKszzPxp+DYIQIPJX+OCrQzFb8zrnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282928; c=relaxed/simple;
	bh=YzuD2rePSrty7/fT4moEsCsfyziLntqby8q9FtzFBOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FtfVZJXZQLHuPC0Yo9q1ZNxwDXYlz8iowoltJyBk/n6zQSeP4/W9jYnDlJ6/rnwDha4oUz2Tds0tpqZ3tFusJR2xklYOKcQcVUDVQzepb387LQSmC6w0nJUtgGm015YWZjgZ2LIeg4STEoDTytE+QSpJhDW2Hw43hbvO4JCEykU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=agDG5SR+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="agDG5SR+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34885C2BBFC;
	Thu, 13 Jun 2024 12:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282928;
	bh=YzuD2rePSrty7/fT4moEsCsfyziLntqby8q9FtzFBOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=agDG5SR+OnZUakJELzENG824aMsV+xYklcHS1xxdB/mYLftMtjUc3LlYdujt0RFjc
	 SfAsVROGmaLzUmM6Dsk3zUBMCmygsWR4OeXHQBJfgFkbUc74HLPOtkA6hdGy+Nhcsj
	 Ey0laJO4wFW9phdxuil/x2Vc+cGlU643o2wwZax4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy@kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.1 40/85] mmc: sdhci-acpi: Sort DMI quirks alphabetically
Date: Thu, 13 Jun 2024 13:35:38 +0200
Message-ID: <20240613113215.693852736@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113214.134806994@linuxfoundation.org>
References: <20240613113214.134806994@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


