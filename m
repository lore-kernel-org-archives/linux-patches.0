Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F0D1D0DF2;
	Wed,  2 Oct 2024 13:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877393; cv=none; b=O0mlIz97SMK4ztphdcdUjYqFuCqqj0NaxWm0B2MFhhB28in4FIJ99x76f8vkTxskYu1p7QE1UgVWnS17ShmT7JAivyaG1ZW3w++Hiyto3zSezTRo/1ic0MHN7B867WAevb4t1yZHPZ//WFEnUd4BzdOAl4+E/hqjkocL1cNuLtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877393; c=relaxed/simple;
	bh=SS0WrtwyRv8DLAQT6OTT1RhU4jZxhhg2v7FqKOAlToA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cRttJ/HVsAskZIa0AU9J35+1RgVUqAZLtwPyDwBY0TGAcF79RhPGovB4TkfWv2NUxfYs2Uch7PNCWNDyVy+HDugfHHh+jROP4TkADc17H1pqUlZ1P3505oXtelUa7NLVd7nzuRpj627w2KS9LxEeYpoHnk4q3SZ8ZbVmSeoueBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sfxpfLbt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sfxpfLbt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59CB7C4CECD;
	Wed,  2 Oct 2024 13:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877393;
	bh=SS0WrtwyRv8DLAQT6OTT1RhU4jZxhhg2v7FqKOAlToA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sfxpfLbt8qXh1QD5P7SLTeIWoC7eTUBESwfI31RPgPrkOEKjvRIQH9liZI9r76hem
	 F6Wn6ikAZzSoGrHvUktElP+2WKqUeHdGHG9zDIPFISoyQ0hpLxWaRtDpraaT9MJZ4f
	 q1v0OJ6pcWvPCSKW9Q7b7PXmjPdzurIAmcba+cYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Orlando Chamberlain <orlandoch.dev@gmail.com>,
	Aditya Garg <gargaditya08@live.com>,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 035/634] ACPI: video: force native for some T2 macbooks
Date: Wed,  2 Oct 2024 14:52:15 +0200
Message-ID: <20241002125812.483620513@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

From: Orlando Chamberlain <orlandoch.dev@gmail.com>

[ Upstream commit d010a0282e045f02895f88299e5442506585b46c ]

The intel backlight is needed for these, previously users had nothing in
/sys/class/backlight.

Signed-off-by: Orlando Chamberlain <orlandoch.dev@gmail.com>
Signed-off-by: Aditya Garg <gargaditya08@live.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patch.msgid.link/3DA0EAE3-9EB7-492B-96FC-988503BBDCCC@live.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 7dc918daaf29 ("ACPI: video: force native for Apple MacbookPro9,2")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index ff6f260433a11..674b9db7a1ef8 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -541,6 +541,14 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "iMac12,2"),
 		},
 	},
+	{
+	 .callback = video_detect_force_native,
+	 /* Apple MacBook Air 9,1 */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir9,1"),
+		},
+	},
 	{
 	 /* https://bugzilla.redhat.com/show_bug.cgi?id=1217249 */
 	 .callback = video_detect_force_native,
@@ -550,6 +558,14 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro12,1"),
 		},
 	},
+	{
+	 .callback = video_detect_force_native,
+	 /* Apple MacBook Pro 16,2 */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro16,2"),
+		},
+	},
 	{
 	 .callback = video_detect_force_native,
 	 /* Dell Inspiron N4010 */
-- 
2.43.0



