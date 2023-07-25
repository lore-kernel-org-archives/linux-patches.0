Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4451ED46
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:32:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55421C433C9;
	Tue, 25 Jul 2023 11:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284732;
	bh=/UcFnQMLm3Sh7lq0bGC4nPCrD+p8i7+GpFkpp5NCw5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MyCvJOVDCpH1dCIyaaA1khWIQUgRfXCp/Pfkhrn6W5iL5GzV32/fvq1PuLlAd6cFZ
	 v3LZJvxPy2oThTv8IhBEhpsJQungJvQv7KF+VJLITsf23oww1pIGBCiDRv8Jkc+5r6
	 DBjsCw2Qwy+X+6uFc9EXj1eS75nvluG4w7pY7G6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 461/509] ACPI: button: Add lid disable DMI quirk for Nextbook Ares 8A
Date: Tue, 25 Jul 2023 12:46:40 +0200
Message-ID: <20230725104614.863158873@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
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

[ Upstream commit 4fd5556608bfa9c2bf276fc115ef04288331aded ]

The LID0 device on the Nextbook Ares 8A tablet always reports lid
closed causing userspace to suspend the device as soon as booting
is complete.

Add a DMI quirk to disable the broken lid functionality.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/button.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
index 0d93a5ef4d071..4861aad1a9e93 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -82,6 +82,15 @@ static const struct dmi_system_id dmi_lid_quirks[] = {
 		},
 		.driver_data = (void *)(long)ACPI_BUTTON_LID_INIT_DISABLED,
 	},
+	{
+		/* Nextbook Ares 8A tablet, _LID device always reports lid closed */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Insyde"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "CherryTrail"),
+			DMI_MATCH(DMI_BIOS_VERSION, "M882"),
+		},
+		.driver_data = (void *)(long)ACPI_BUTTON_LID_INIT_DISABLED,
+	},
 	{
 		/*
 		 * Medion Akoya E2215T, notification of the LID device only
-- 
2.39.2



