Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF25215764;
	Thu, 12 Dec 2024 15:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018462; cv=none; b=qy4C4WAm6oVEtDX/tHLxFzZcuwJz9pN/a2+trUMlK+zwtourPFrCdXoa2YpxOJJRjCOBG+EpN4pejAS/rJPLeW4HxEeQJAPbDCwA7oYXZ4yoTmMOEqu68cfbwaHDenAfxqfm6nKcS1h4IuCGbOsCs1fyzN40/xC+uPluV1GKpeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018462; c=relaxed/simple;
	bh=035heQSHLEs19YIPOxOEqLupQsZpIrjOpcfW1W+vKnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g9HqwTzqQD+fBcf9UTA8oZxVYP2pUdE7fVdKZr/e9JY8sC2AW9J7Ei0PvFY16Er95X0flHrhst4i+Qir3hWzvS0BvKlf5si8i52N1n9xUyBadHZUw+JDHRCTI51tLPTIUnWOk2VLurcJVHPOYy7YrBV4KaTkHqz2pq3G8rOYT0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GC/53cF+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GC/53cF+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93348C4CECE;
	Thu, 12 Dec 2024 15:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018462;
	bh=035heQSHLEs19YIPOxOEqLupQsZpIrjOpcfW1W+vKnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GC/53cF+uEHcqUJ/l5WEFwKv+FA3EXq4iCjGt36KsvI7us9PvRKX4ucW/AqoMI+9m
	 AmFoRDi3f9Xhs4N7WPhLe2y7LuBIEuJUVLH+YRneZ5jw/QMVEW+7wILHsnGW7EI6kf
	 YRCgJc4YsBdTNDDUAoS7DdcOZPB6p/tfwkSsJBEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 300/356] ACPI: x86: Clean up Asus entries in acpi_quirk_skip_dmi_ids[]
Date: Thu, 12 Dec 2024 16:00:19 +0100
Message-ID: <20241212144256.417303791@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5fa37e4fecc55..fdfc88e09986e 100644
--- a/drivers/acpi/x86/utils.c
+++ b/drivers/acpi/x86/utils.c
@@ -288,6 +288,7 @@ static const struct dmi_system_id acpi_quirk_skip_dmi_ids[] = {
 	/*
 	 * 2. Devices which also have the skip i2c/serdev quirks and which
 	 *    need the x86-android-tablets module to properly work.
+	 *    Sorted alphabetically.
 	 */
 #if IS_ENABLED(CONFIG_X86_ANDROID_TABLETS)
 	{
@@ -313,6 +314,7 @@ static const struct dmi_system_id acpi_quirk_skip_dmi_ids[] = {
 					ACPI_QUIRK_SKIP_GPIO_EVENT_HANDLERS),
 	},
 	{
+		/* Asus ME176C tablet */
 		.matches = {
 			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
 			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "ME176C"),
@@ -323,23 +325,24 @@ static const struct dmi_system_id acpi_quirk_skip_dmi_ids[] = {
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



