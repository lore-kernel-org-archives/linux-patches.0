Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7E333EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 15:57:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 839F2C433F1;
	Mon, 16 Jan 2023 15:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884620;
	bh=REm43g9/hhxTTixIY3YK/AGtqEdZNUCXFeFsyxNv7iQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cif2kwv5uI0Y21NSG424WqNofHaUmMpB1pu1weALE82klhMAWwTjNBpzdoWKr3j60
	 bVUnspIG16KgM21XCO3zqkyndjwrBPhLfsUbCg4mY6iX9WXk+5xBzRFbx6fZIqYmqs
	 3OFgM/VYH86CzAuT+5Hi71+BKvyRJjrzzG0DPreQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.1 045/183] ACPI: video: Allow selecting NVidia-WMI-EC or Apple GMUX backlight from the cmdline
Date: Mon, 16 Jan 2023 16:49:28 +0100
Message-Id: <20230116154805.278150158@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

commit 420a1116aef0e8e12c305508f45ce73e5ae30a09 upstream.

The patches adding NVidia-WMI-EC and Apple GMUX backlight detection
support to acpi_video_get_backlight_type(), forgot to update
acpi_video_parse_cmdline() to allow manually selecting these from
the commandline.

Add support for these to acpi_video_parse_cmdline().

Fixes: fe7aebb40d42 ("ACPI: video: Add Nvidia WMI EC brightness control detection (v3)")
Fixes: 21245df307cb ("ACPI: video: Add Apple GMUX brightness control detection")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/video_detect.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 1b78c7434492..8a541efc5675 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -50,6 +50,10 @@ static void acpi_video_parse_cmdline(void)
 		acpi_backlight_cmdline = acpi_backlight_video;
 	if (!strcmp("native", acpi_video_backlight_string))
 		acpi_backlight_cmdline = acpi_backlight_native;
+	if (!strcmp("nvidia_wmi_ec", acpi_video_backlight_string))
+		acpi_backlight_cmdline = acpi_backlight_nvidia_wmi_ec;
+	if (!strcmp("apple_gmux", acpi_video_backlight_string))
+		acpi_backlight_cmdline = acpi_backlight_apple_gmux;
 	if (!strcmp("none", acpi_video_backlight_string))
 		acpi_backlight_cmdline = acpi_backlight_none;
 }
-- 
2.39.0



