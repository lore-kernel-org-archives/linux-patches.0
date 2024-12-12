Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533E62080FC;
	Thu, 12 Dec 2024 15:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016657; cv=none; b=WdYXRyvxWCCnFOhcV9hbAe2o6/wRnUKv65BUnFDLTGLF0Bpchh0Ca3eWiAojsdsH4QvaE89uj8ha1TuH26SiQO+lkqc0hPbOVJh6LnA5vzBKCkS6fmwDnxJrJtvBYRR9QbAMA0hGXroefC5zhPN2GxZABCrxrAxsfRKQQXd7L7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016657; c=relaxed/simple;
	bh=dH7xXv+KisDS2w839YHhehU89fHzY4jzerA0d0yZRpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pt5xG7naks5Udg4/gBkkVFWxL+BTOC0oKq+C3LRiZKvfoUUZoqT+FWqVsY57tEwAW0i88U2gVezYdp6QMgHWan8J0j209i1z3OyZ+sQkxTWWRw1YSr5jLt26KF42Ncp1nz22gFBU0GGfRZ2tNVZ0Hms6c9ayHAWQDAJVnHJwDfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UaKEPrzZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UaKEPrzZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55966C4CECE;
	Thu, 12 Dec 2024 15:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016656;
	bh=dH7xXv+KisDS2w839YHhehU89fHzY4jzerA0d0yZRpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UaKEPrzZ/WyTTs7K3NRjZnjCrz3QX8T1R2ovxDQO6Wm8t6PlVEoXYu5fDU1iKAao1
	 cznqTHRBammhfgIRyM3Zi8POPz+PVKhcXd7jNAwLVV5NVt2Tl/9cb5TJL9OGDh4k1O
	 4TRgtsi1vIeoifYDbwMGQjSCD2L3yU+aunRlCBrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Denose <jdenose@google.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 230/466] ACPI: video: force native for Apple MacbookPro11,2 and Air7,2
Date: Thu, 12 Dec 2024 15:56:39 +0100
Message-ID: <20241212144315.860337184@linuxfoundation.org>
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

From: Jonathan Denose <jdenose@google.com>

[ Upstream commit 295991836b23c12ddb447f7f583a17fd3616ad7d ]

There is a bug in the Macbook Pro 11,2 and Air 7,2 firmware similar to
what is described in:

commit 7dc918daaf29 ("ACPI: video: force native for Apple MacbookPro9,2")

This bug causes their backlights not to come back after resume.

Add DMI quirks to select the working native Intel firmware interface
such that the backlght comes back on after resume.

Signed-off-by: Jonathan Denose <jdenose@google.com>
Link: https://patch.msgid.link/20241112222516.1.I7fa78e6acbbed56ed5677f5e2dacc098a269d955@changeid
[ rjw: Changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 015bd8e66c1cf..d507d5e084354 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -549,6 +549,14 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "iMac12,2"),
 		},
 	},
+	{
+	 .callback = video_detect_force_native,
+	 /* Apple MacBook Air 7,2 */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir7,2"),
+		},
+	},
 	{
 	 .callback = video_detect_force_native,
 	 /* Apple MacBook Air 9,1 */
@@ -565,6 +573,14 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro9,2"),
 		},
 	},
+	{
+	 .callback = video_detect_force_native,
+	 /* Apple MacBook Pro 11,2 */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro11,2"),
+		},
+	},
 	{
 	 /* https://bugzilla.redhat.com/show_bug.cgi?id=1217249 */
 	 .callback = video_detect_force_native,
-- 
2.43.0



