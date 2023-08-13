Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BEA89443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:24:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11115C433C9;
	Sun, 13 Aug 2023 21:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691961884;
	bh=b74PVG4SS8F2AaJ1+5HPkOwJMi+XXhoMwtfwCyHol/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TsuK8lwTIljz+kx3EEu9tJ4dMZdPZhiZtiMof3AeI8DGupk8PhRRPRHV/hYOlOl98
	 t5FjCC1wry1oVsbQq3vRKsg68qVHN369OjN4ZbPeNtwbss3WI9DLmMOmQPyb5ke6lM
	 SSKZO7lb5LndPiPb3HXmzVHwSGgrOb21/+xQiwew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.4 026/206] ACPI: resource: Add IRQ override quirk for PCSpecialist Elimina Pro 16 M
Date: Sun, 13 Aug 2023 23:16:36 +0200
Message-ID: <20230813211725.744793799@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans de Goede <hdegoede@redhat.com>

commit 56fec0051a69ace182ca3fba47be9c13038b4e3f upstream.

The PCSpecialist Elimina Pro 16 M laptop model is a Zen laptop which
needs to use the MADT IRQ settings override and which does not have
an INT_SRC_OVR entry for IRQ 1 in its MADT.

So this model needs a DMI quirk to enable the MADT IRQ settings override
to fix its keyboard not working.

Fixes: a9c4a912b7dc ("ACPI: resource: Remove "Zen" specific match and quirks")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217394#c18
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/resource.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index 8e32dd5776f5..a4d9f149b48d 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -498,6 +498,17 @@ static const struct dmi_system_id maingear_laptop[] = {
 	{ }
 };
 
+static const struct dmi_system_id pcspecialist_laptop[] = {
+	{
+		.ident = "PCSpecialist Elimina Pro 16 M",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "PCSpecialist"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Elimina Pro 16 M"),
+		},
+	},
+	{ }
+};
+
 static const struct dmi_system_id lg_laptop[] = {
 	{
 		.ident = "LG Electronics 17U70P",
@@ -523,6 +534,7 @@ static const struct irq_override_cmp override_table[] = {
 	{ asus_laptop, 1, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0, false },
 	{ tongfang_gm_rg, 1, ACPI_EDGE_SENSITIVE, ACPI_ACTIVE_LOW, 1, true },
 	{ maingear_laptop, 1, ACPI_EDGE_SENSITIVE, ACPI_ACTIVE_LOW, 1, true },
+	{ pcspecialist_laptop, 1, ACPI_EDGE_SENSITIVE, ACPI_ACTIVE_LOW, 1, true },
 	{ lg_laptop, 1, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0, false },
 };
 
-- 
2.41.0



