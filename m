Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD93479C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:53:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4002FC433D6;
	Wed, 30 Nov 2022 18:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834410;
	bh=7yn0XnAhGf8Ubb6aC+5wEHmunbUp30xiiuy2rr4IAQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W/Z8BnPBfO1g1ONkbe/UOSZlEBv/M8o50AoUQjasF9cCr/Vpu00CGjldpx4kFH6Ov
	 z3LUn2pFojbyV4XxhRO0FxiSIaPUJYfFEPeRewbx45UrP3NjgIVVwcyrN8Tjm7v7Qe
	 6OxXd7G/ByKbbYamqViponaLt+yVSLfHzTXFODEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Lennard=20G=C3=A4her?= <gaeher@mpi-sws.org>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 244/289] platform/x86: thinkpad_acpi: Enable s2idle quirk for 21A1 machine type
Date: Wed, 30 Nov 2022 19:23:49 +0100
Message-Id: <20221130180549.641331401@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lennard Gäher <gaeher@mpi-sws.org>

[ Upstream commit 53e16a6e3e69425081f8352e13e9fd23bf1abfca ]

Previously, the s2idle quirk was only active for the 21A0 machine type
of the P14s Gen2a product. This also enables it for the second 21A1 type,
thus reducing wake-up times from s2idle.

Signed-off-by: Lennard Gäher <gaeher@mpi-sws.org>
Suggested-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2181
Link: https://lore.kernel.org/r/20221108072023.17069-1-gaeher@mpi-sws.org
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/thinkpad_acpi.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 353507d18e11..67dc335fca0c 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -4497,6 +4497,14 @@ static const struct dmi_system_id fwbug_list[] __initconst = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "21A0"),
 		}
 	},
+	{
+		.ident = "P14s Gen2 AMD",
+		.driver_data = &quirk_s2idle_bug,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21A1"),
+		}
+	},
 	{}
 };
 
-- 
2.35.1



