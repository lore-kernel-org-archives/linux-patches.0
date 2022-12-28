Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2121C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:48:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22C27C433D2;
	Wed, 28 Dec 2022 16:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672246101;
	bh=Nr7Czi64UOU5LI7QtmOhNRgux5NWwntjgCqwpLPPEEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C4h0cwdZTW6qRgaiPZm2FD8PXWWxdHoVQpxJO41ZjGYKPh6wKkBg7YXNwcr2npZdD
	 3SE0xsh/KfvNUxDUpUDT6rHN5PuTrtr/XWYV0HK7yjSiFO55ZdJCY21Gkzx1ItXGYl
	 NM5FQk1rBh71ljNcw39GaZJAcowkdS/27QqF5Nlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0963/1146] ACPI: x86: Add skip i2c clients quirk for Medion Lifetab S10346
Date: Wed, 28 Dec 2022 15:41:42 +0100
Message-Id: <20221228144356.478801122@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

[ Upstream commit ecc6aaabcedc276128315f57755364106017c606 ]

The Medion Lifetab S10346 is a x86 tablet which ships with Android x86 as
factory OS. The Android x86 kernel fork ignores I2C devices described in
the DSDT, except for the PMIC and Audio codecs.

As usual the Medion Lifetab S10346's DSDT contains a bunch of extra I2C
devices which are not actually there, causing various resource conflicts.
Add an ACPI_QUIRK_SKIP_I2C_CLIENTS quirk for the Medion Lifetab S10346 to
the acpi_quirk_skip_dmi_ids table to woraround this.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/x86/utils.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/acpi/x86/utils.c b/drivers/acpi/x86/utils.c
index 635de40b5822..4e816bb402f6 100644
--- a/drivers/acpi/x86/utils.c
+++ b/drivers/acpi/x86/utils.c
@@ -329,6 +329,17 @@ static const struct dmi_system_id acpi_quirk_skip_dmi_ids[] = {
 		.driver_data = (void *)(ACPI_QUIRK_SKIP_I2C_CLIENTS |
 					ACPI_QUIRK_SKIP_ACPI_AC_AND_BATTERY),
 	},
+	{
+		/* Medion Lifetab S10346 */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "AMI Corporation"),
+			DMI_MATCH(DMI_BOARD_NAME, "Aptio CRB"),
+			/* Way too generic, also match on BIOS data */
+			DMI_MATCH(DMI_BIOS_DATE, "10/22/2015"),
+		},
+		.driver_data = (void *)(ACPI_QUIRK_SKIP_I2C_CLIENTS |
+					ACPI_QUIRK_SKIP_ACPI_AC_AND_BATTERY),
+	},
 	{
 		/* Nextbook Ares 8 */
 		.matches = {
-- 
2.35.1



