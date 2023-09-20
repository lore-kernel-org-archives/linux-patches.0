Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C82630FA4
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4769C433C8;
	Wed, 20 Sep 2023 12:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212413;
	bh=KL8r667rBqvavNCD0GIsBviHw3b6APZk72qFv4zPxWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x46PjZ4TbeKzaL+U2ZFCnH+0h65qs4nglpg7bQV+HS+HvMoTFVqQ00GZO4/EvAID/
	 81eZo9t8c3Fw01MO6ZOchyEk1Kf3ZwMzko+WFA7SciaT8JdVHFnYftMD6DwhnNtaT2
	 WzYgUu4uXNS1nEzo78NxPYYVjxnnlUY0ZO3zF6+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 240/273] ACPI: video: Add backlight=native DMI quirk for Lenovo Ideapad Z470
Date: Wed, 20 Sep 2023 13:31:20 +0200
Message-ID: <20230920112853.758160088@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby (SUSE) <jirislaby@kernel.org>

[ Upstream commit 96b709be183c56293933ef45b8b75f8af268c6de ]

The Lenovo Ideapad Z470 predates Windows 8, so it defaults to using
acpi_video for backlight control. But this is not functional on this
model.

Add a DMI quirk to use the native backlight interface which works.

Link: https://bugzilla.suse.com/show_bug.cgi?id=1208724
Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index b4f16073ef432..866bc20c82397 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -294,6 +294,15 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_BOARD_NAME, "Lenovo IdeaPad S405"),
 		},
 	},
+	{
+	 /* https://bugzilla.suse.com/show_bug.cgi?id=1208724 */
+	 .callback = video_detect_force_native,
+	 /* Lenovo Ideapad Z470 */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		DMI_MATCH(DMI_PRODUCT_VERSION, "IdeaPad Z470"),
+		},
+	},
 	{
 	 /* https://bugzilla.redhat.com/show_bug.cgi?id=1187004 */
 	 .callback = video_detect_force_native,
-- 
2.40.1



