Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC27209693;
	Thu, 12 Dec 2024 15:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017175; cv=none; b=TSpYB/WttNgnDvBBaru1rxMVs9hGzPT+isP28pdu4JcZujmfbwsJ85VpHpdvUA4SJUHR3r92wlb/xpK53y1n7BUEmFE6vgnsJrsFc0FCQWpPeefou8MihAd91ZNGNymmVkP6zmhBb9GeAoi9l9p00r/M0bmqo+mm30VVvm70tmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017175; c=relaxed/simple;
	bh=RowwPHW47Z+ZuWlh8+YnKab9s+qOqL75ZMZf1EmYh1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hsljln2KT5h1ftgmMWi+sEF3k5eAIGNdJggSbBYBNaJCNZIjMtO29m6q6Il0tw6EZDfaEmKLhYq2/qSLdqU4OywD+MzMTx8fAvmNv68mx1C9se9Ggq/YmPh6EXVngMjhxu6INgDjM0MfOS+hhUUcBd/95OhvHxTPNoO0lE/Cr9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PWfCUcek; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PWfCUcek"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9642EC4CECE;
	Thu, 12 Dec 2024 15:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017175;
	bh=RowwPHW47Z+ZuWlh8+YnKab9s+qOqL75ZMZf1EmYh1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PWfCUcekmNUgMlobI73VVL0ZWrKkLMvp3UzQIz7q6IaG50IhrLZkhkYIOxP9yWnSa
	 RUp1b9H4FLOqy+qFzGOp4pIqocvHHhnDC85KEdChTZOByuao/C2bwe43ne8DimnJ3c
	 xKX3I2d6CJ0xTc9OsnoisdaxBsVc8KHkXPbpjWuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 404/466] ACPI: x86: Clean up Asus entries in acpi_quirk_skip_dmi_ids[]
Date: Thu, 12 Dec 2024 15:59:33 +0100
Message-ID: <20241212144322.714487909@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit bd8aa15848f5f21951cd0b0d01510b3ad1f777d4 ]

The Asus entries in the acpi_quirk_skip_dmi_ids[] table are the only
entries without a comment which model they apply to. Add these comments.

The Asus TF103C entry also is in the wrong place for what is supposed to
be an alphabetically sorted list. Move it up so that the list is properly
sorted and add a comment that the list is alphabetically sorted.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patch.msgid.link/20241116095825.11660-2-hdegoede@redhat.com
[ rjw: Changelog and subject edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/x86/utils.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/x86/utils.c b/drivers/acpi/x86/utils.c
index 1bb425b78032a..cb45ef5240dab 100644
--- a/drivers/acpi/x86/utils.c
+++ b/drivers/acpi/x86/utils.c
@@ -296,6 +296,7 @@ static const struct dmi_system_id acpi_quirk_skip_dmi_ids[] = {
 	/*
 	 * 2. Devices which also have the skip i2c/serdev quirks and which
 	 *    need the x86-android-tablets module to properly work.
+	 *    Sorted alphabetically.
 	 */
 #if IS_ENABLED(CONFIG_X86_ANDROID_TABLETS)
 	{
@@ -321,6 +322,7 @@ static const struct dmi_system_id acpi_quirk_skip_dmi_ids[] = {
 					ACPI_QUIRK_SKIP_GPIO_EVENT_HANDLERS),
 	},
 	{
+		/* Asus ME176C tablet */
 		.matches = {
 			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
 			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "ME176C"),
@@ -331,23 +333,24 @@ static const struct dmi_system_id acpi_quirk_skip_dmi_ids[] = {
 					ACPI_QUIRK_SKIP_GPIO_EVENT_HANDLERS),
 	},
 	{
-		/* Lenovo Yoga Book X90F/L */
+		/* Asus TF103C transformer 2-in-1 */
 		.matches = {
-			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Intel Corporation"),
-			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "CHERRYVIEW D1 PLATFORM"),
-			DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "YETI-11"),
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TF103C"),
 		},
 		.driver_data = (void *)(ACPI_QUIRK_SKIP_I2C_CLIENTS |
-					ACPI_QUIRK_UART1_SKIP |
 					ACPI_QUIRK_SKIP_ACPI_AC_AND_BATTERY |
 					ACPI_QUIRK_SKIP_GPIO_EVENT_HANDLERS),
 	},
 	{
+		/* Lenovo Yoga Book X90F/L */
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "TF103C"),
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Intel Corporation"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "CHERRYVIEW D1 PLATFORM"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "YETI-11"),
 		},
 		.driver_data = (void *)(ACPI_QUIRK_SKIP_I2C_CLIENTS |
+					ACPI_QUIRK_UART1_SKIP |
 					ACPI_QUIRK_SKIP_ACPI_AC_AND_BATTERY |
 					ACPI_QUIRK_SKIP_GPIO_EVENT_HANDLERS),
 	},
-- 
2.43.0



