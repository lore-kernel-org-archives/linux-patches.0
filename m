Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7D11C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:46:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B884C433D2;
	Wed, 28 Dec 2022 16:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245976;
	bh=0Dowszw+M3xbVXpxd9r+vcp2wE7GhUHIdP1j3o9nBQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uk4xGhZPnYCH6lTXr/0p/U019r6zumZWYZNS6Hy9wcAtnJYxnW7YWIKtAC2/mxAcn
	 X4YamSxvBchion8dArrJWhLgVFSYYo8NuUOOi9lL4r/w8sw8bh8qiSI5Wi2hl70ozr
	 vMnw3AbxA5Trwuqzw1xL13YBO49EeyK1Alx2xph0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Joosten <stefan@atcomputing.nl>,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0956/1146] ACPI: video: Add force_native quirk for Sony Vaio VPCY11S1E
Date: Wed, 28 Dec 2022 15:41:35 +0100
Message-Id: <20221228144356.287119083@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

[ Upstream commit f5a6ff923d4a1d639da36228d00e95ff67d417f0 ]

The Sony Vaio VPCY11S1E advertises both native and ACPI video backlight
control interfaces, but only the native interface works and the default
heuristics end up picking ACPI video on this model.

Add a video_detect_force_native DMI quirk for this.

Reported-by: Stefan Joosten <stefan@atcomputing.nl>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 8e8b435b4c8c..ffa19d418847 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -619,6 +619,14 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "VPCEH3U1E"),
 		},
 	},
+	{
+	 .callback = video_detect_force_native,
+	 /* Sony Vaio VPCY11S1E */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "VPCY11S1E"),
+		},
+	},
 
 	/*
 	 * These Toshibas have a broken acpi-video interface for brightness
-- 
2.35.1



