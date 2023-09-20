Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF7515AE7
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:21:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3400C433C8;
	Wed, 20 Sep 2023 12:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212460;
	bh=NfivgJP9PqPLEduQNwZPAusMx1L/Ytmkx7nc+UXs988=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h7odYjG1vLt1HLanZv1P9qVFtQdOOb12iZrlCNwjCXUgXH7klxVjwO9EfHxnzdmaC
	 sJTOJNJCWn9PXQ5MNd9lVF+Ao1ZChEubWooxtA9j00XTUNuC4ta87BaGlKQcPrEAmX
	 psNO1mGKlep275cqZnSK5O8XV4bqKxgbqcmvPaTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 10/83] ACPI: video: Add backlight=native DMI quirk for Apple iMac12,1 and iMac12,2
Date: Wed, 20 Sep 2023 13:31:00 +0200
Message-ID: <20230920112827.062829137@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112826.634178162@linuxfoundation.org>
References: <20230920112826.634178162@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 8cf04bb321f036dd2e523e993897e0789bd5265c ]

Linux defaults to picking the non-working ACPI video backlight interface
on the Apple iMac12,1 and iMac12,2.

Add a DMI quirk to pick the working native radeon_bl0 interface instead.

Link: https://gitlab.freedesktop.org/drm/amd/-/issues/1838
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2753
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 28e816be4753e..a5cb9e1d48bcc 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -357,6 +357,24 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "iMac11,3"),
 		},
 	},
+	{
+	 /* https://gitlab.freedesktop.org/drm/amd/-/issues/1838 */
+	 .callback = video_detect_force_native,
+	 /* Apple iMac12,1 */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "iMac12,1"),
+		},
+	},
+	{
+	 /* https://gitlab.freedesktop.org/drm/amd/-/issues/2753 */
+	 .callback = video_detect_force_native,
+	 /* Apple iMac12,2 */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "iMac12,2"),
+		},
+	},
 	{
 	 /* https://bugzilla.redhat.com/show_bug.cgi?id=1217249 */
 	 .callback = video_detect_force_native,
-- 
2.40.1



