Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB8B79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:44:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA173C433D6;
	Wed, 30 Nov 2022 18:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833895;
	bh=k8lrQeCvaTJykMFGCQm8vcB1H/Ui9AwSIVF6Zts0x1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uyqCzGMs3r9Bqx89t4VlA4TWQ7ESe857Ii7//679u1vK5TBYV5Gvt92zIEoLWBw6B
	 BeUiCWGXdE9+CxQoxpVU07Rpfva8DhzTGqAM+91SJoD9PknubrVO3pBz56FqGKllFL
	 twx9SA6Fqiw4z2QUPLHbKckvb1MPKr/WE+trBY1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Simon Ser <contact@emersion.fr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 026/289] drm: panel-orientation-quirks: Add quirk for Nanote UMPC-01
Date: Wed, 30 Nov 2022 19:20:11 +0100
Message-Id: <20221130180544.726589110@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 308451d9c7fece33d9551230cb8e5eb7f3914988 ]

The Nanote UMPC-01 is a mini laptop with a 1200x1920 portrait screen
mounted in a landscape oriented clamshell case. Add a quirk for this.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Simon Ser <contact@emersion.fr>
Link: https://patchwork.freedesktop.org/patch/msgid/20220919133258.711639-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel_orientation_quirks.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index 8a0c0e0bb5bd..f0f6fa306521 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -319,6 +319,12 @@ static const struct dmi_system_id orientation_data[] = {
 		 DMI_MATCH(DMI_BIOS_VERSION, "BLADE_21"),
 		},
 		.driver_data = (void *)&lcd1200x1920_rightside_up,
+	}, {	/* Nanote UMPC-01 */
+		.matches = {
+		 DMI_MATCH(DMI_SYS_VENDOR, "RWC CO.,LTD"),
+		 DMI_MATCH(DMI_PRODUCT_NAME, "UMPC-01"),
+		},
+		.driver_data = (void *)&lcd1200x1920_rightside_up,
 	}, {	/* OneGX1 Pro */
 		.matches = {
 		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "SYSTEM_MANUFACTURER"),
-- 
2.35.1



