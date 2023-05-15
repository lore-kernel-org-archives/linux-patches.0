Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F33FBE7
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:46:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D66C433D2;
	Mon, 15 May 2023 16:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169184;
	bh=1+ek0pwc4M/7kpXzv5zWbQ0/4c81qnRBOxqrN7QvPKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ea30PpbKgAiLYDDRD3Wmqy025nK1XLoWmebL1Omf6F6/cTeWxXOiiFsPfBpuNR7/y
	 BPEVmB+0PZiThJRjev02D/L7x1Q/YIe9+btoH3HnrCZUYcmcmA4GcueQ93Vj9nMV+P
	 yE1VDvb4kvvttY9lt7zdsl4lu1uPmtr8sZxjxg0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Avdeev <jamesstoun@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 4.19 170/191] platform/x86: touchscreen_dmi: Add info for the Dexp Ursus KX210i
Date: Mon, 15 May 2023 18:26:47 +0200
Message-Id: <20230515161713.605714471@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161707.203549282@linuxfoundation.org>
References: <20230515161707.203549282@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andrey Avdeev <jamesstoun@gmail.com>

commit 4b65f95c87c35699bc6ad540d6b9dd7f950d0924 upstream.

Add touchscreen info for the Dexp Ursus KX210i

Signed-off-by: Andrey Avdeev <jamesstoun@gmail.com>
Link: https://lore.kernel.org/r/ZE4gRgzRQCjXFYD0@avdeevavpc
Cc: stable@vger.kernel.org
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/touchscreen_dmi.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/drivers/platform/x86/touchscreen_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -147,6 +147,22 @@ static const struct ts_dmi_data dexp_urs
 	.properties	= dexp_ursus_7w_props,
 };
 
+static const struct property_entry dexp_ursus_kx210i_props[] = {
+	PROPERTY_ENTRY_U32("touchscreen-min-x", 5),
+	PROPERTY_ENTRY_U32("touchscreen-min-y",  2),
+	PROPERTY_ENTRY_U32("touchscreen-size-x", 1720),
+	PROPERTY_ENTRY_U32("touchscreen-size-y", 1137),
+	PROPERTY_ENTRY_STRING("firmware-name", "gsl1680-dexp-ursus-kx210i.fw"),
+	PROPERTY_ENTRY_U32("silead,max-fingers", 10),
+	PROPERTY_ENTRY_BOOL("silead,home-button"),
+	{ }
+};
+
+static const struct ts_dmi_data dexp_ursus_kx210i_data = {
+	.acpi_name	= "MSSL1680:00",
+	.properties	= dexp_ursus_kx210i_props,
+};
+
 static const struct property_entry digma_citi_e200_props[] = {
 	PROPERTY_ENTRY_U32("touchscreen-size-x", 1980),
 	PROPERTY_ENTRY_U32("touchscreen-size-y", 1500),
@@ -503,6 +519,14 @@ static const struct dmi_system_id touchs
 		},
 	},
 	{
+		/* DEXP Ursus KX210i */
+		.driver_data = (void *)&dexp_ursus_kx210i_data,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "INSYDE Corp."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "S107I"),
+		},
+	},
+	{
 		/* Digma Citi E200 */
 		.driver_data = (void *)&digma_citi_e200_data,
 		.matches = {


