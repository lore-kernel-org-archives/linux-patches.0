Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC9D15ACF
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:01:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2281C433C7;
	Tue, 25 Jul 2023 11:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282907;
	bh=sy63P02sZU6SzI5g3cL9VAzERnqpwmcYTtrC3e9CIEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ReOr2q95FVDoVEOH4+SLYt3G/SbxrZ18rrQ58PvDeQEfzD4pspbThiBxGwZmtCgeg
	 KtOgQx9a+v3sCaV4dFtEX7DHICCuhzvCWq6WLZLgyNPrFyzYtsnmsxntlIUnL4OL9V
	 WwXRBDWjFCntYTaMuS9bfPDrmyJ/cNKn5tefPCxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	raycekarneal <raycekarneal@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 062/183] ACPI: video: Add backlight=native DMI quirk for Dell Studio 1569
Date: Tue, 25 Jul 2023 12:44:50 +0200
Message-ID: <20230725104510.200635770@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104507.756981058@linuxfoundation.org>
References: <20230725104507.756981058@linuxfoundation.org>
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

[ Upstream commit 23d28cc0444be3f694eb986cd653b6888b78431d ]

The Dell Studio 1569 predates Windows 8, so it defaults to using
acpi_video# for backlight control, but this is non functional on
this model.

Add a DMI quirk to use the native intel_backlight interface which
does work properly.

Reported-by: raycekarneal <raycekarneal@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -512,6 +512,14 @@ static const struct dmi_system_id video_
 	},
 	{
 	 .callback = video_detect_force_native,
+	 /* Dell Studio 1569 */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "Studio 1569"),
+		},
+	},
+	{
+	 .callback = video_detect_force_native,
 	 /* Acer Aspire 3830TG */
 	 .matches = {
 		DMI_MATCH(DMI_SYS_VENDOR, "Acer"),


