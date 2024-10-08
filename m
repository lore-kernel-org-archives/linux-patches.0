Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36BFF1DE2AE;
	Tue,  8 Oct 2024 12:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390153; cv=none; b=albuIJr8YMTvhB12qdu2rTBeLGeb3xwdsKfv3T4E3TuG8sY9y06j0Dt+tduicHmYXz4fLPLu/xJZFIVf12ZOHo+PinbQEJLm3ZDngs605v1x4scz3ImtpsIOeYb+TGdOLWfLclrv33cIH88FhJR8xoO9PFs3HeoaKbIw1BnLAZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390153; c=relaxed/simple;
	bh=mejW5D+UN42s+qnjx+R20RQ2Y8g+J0raN+95QOQk9/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=klvV5lO58fK7LK0dL59r+Kge4TTq3RnLmnEyhusEbKA599bmyJ1QFSodDZSLADLUQ7+svJdSIBofCDVyi16+uR0xW255UyIE2q8ZhUgULOSTe887RCni+RBl8SD1ZGrEZxIL6L1XEpR1UWZKuGeYSXf6Fd5Mdzg01aP5XQWgfMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tLLgGXOy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tLLgGXOy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF05C4CEC7;
	Tue,  8 Oct 2024 12:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390153;
	bh=mejW5D+UN42s+qnjx+R20RQ2Y8g+J0raN+95QOQk9/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tLLgGXOybSEUAsVH61Y4QgYY0MlP2Y3DUFXl/sYaNetfLUlTrm3QS5u7lNydpa9vA
	 hdUzjSIWUHqVmrUjMQoczijDXhaZvcTTDmktUyzGdRRs6AqLwsBOcuzPn1uJy4zeME
	 0zHaiEbPIXNhFNtfyAFCGXJu2fA320MKZ7KYvGvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ckath <ckath@yandex.ru>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 207/482] platform/x86: touchscreen_dmi: add nanote-next quirk
Date: Tue,  8 Oct 2024 14:04:30 +0200
Message-ID: <20241008115656.456512076@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ckath <ckath@yandex.ru>

[ Upstream commit c11619af35bae5884029bd14170c3e4b55ddf6f3 ]

Add touschscreen info for the nanote next (UMPC-03-SR).

After checking with multiple owners the DMI info really is this generic.

Signed-off-by: Ckath <ckath@yandex.ru>
Link: https://lore.kernel.org/r/e8dda83a-10ae-42cf-a061-5d29be0d193a@yandex.ru
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/touchscreen_dmi.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/platform/x86/touchscreen_dmi.c b/drivers/platform/x86/touchscreen_dmi.c
index f74af0a689f20..0a39f68c641d1 100644
--- a/drivers/platform/x86/touchscreen_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -840,6 +840,21 @@ static const struct ts_dmi_data rwc_nanote_p8_data = {
 	.properties = rwc_nanote_p8_props,
 };
 
+static const struct property_entry rwc_nanote_next_props[] = {
+	PROPERTY_ENTRY_U32("touchscreen-min-x", 5),
+	PROPERTY_ENTRY_U32("touchscreen-min-y", 5),
+	PROPERTY_ENTRY_U32("touchscreen-size-x", 1785),
+	PROPERTY_ENTRY_U32("touchscreen-size-y", 1145),
+	PROPERTY_ENTRY_BOOL("touchscreen-inverted-y"),
+	PROPERTY_ENTRY_STRING("firmware-name", "gsl1680-rwc-nanote-next.fw"),
+	{ }
+};
+
+static const struct ts_dmi_data rwc_nanote_next_data = {
+	.acpi_name = "MSSL1680:00",
+	.properties = rwc_nanote_next_props,
+};
+
 static const struct property_entry schneider_sct101ctm_props[] = {
 	PROPERTY_ENTRY_U32("touchscreen-size-x", 1715),
 	PROPERTY_ENTRY_U32("touchscreen-size-y", 1140),
@@ -1589,6 +1604,17 @@ const struct dmi_system_id touchscreen_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_SKU, "0001")
 		},
 	},
+	{
+		/* RWC NANOTE NEXT */
+		.driver_data = (void *)&rwc_nanote_next_data,
+		.matches = {
+			DMI_MATCH(DMI_PRODUCT_NAME, "To be filled by O.E.M."),
+			DMI_MATCH(DMI_BOARD_NAME, "To be filled by O.E.M."),
+			DMI_MATCH(DMI_BOARD_VENDOR, "To be filled by O.E.M."),
+			/* Above matches are too generic, add bios-version match */
+			DMI_MATCH(DMI_BIOS_VERSION, "S8A70R100-V005"),
+		},
+	},
 	{
 		/* Schneider SCT101CTM */
 		.driver_data = (void *)&schneider_sct101ctm_data,
-- 
2.43.0



