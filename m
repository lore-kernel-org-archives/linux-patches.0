Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231FE79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:44:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D9D1C433C1;
	Wed, 30 Nov 2022 18:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833898;
	bh=crlVn6UUuZzHzKIKE7nBQg2KCq61S0dGC5C5q4gum0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FUbFfgM6M0LIYLi8UD9iCqC+3PzyiWqe/BgR6XHj1buJr2+zS2ECwZLpMb+TCDE2R
	 v6F/WnLbyN1Ci+C1aeRRF0v/E1gxa938vk/22hcfmWd1i8JPniMGgMde1BVCRQTeya
	 4OgecxmDfCQ/fuKvQ0grggfvSj3EWf+WwYWg4XEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rudolf Polzer <rpolzer@google.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Simon Ser <contact@emersion.fr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 027/289] drm: panel-orientation-quirks: Add quirk for Acer Switch V 10 (SW5-017)
Date: Wed, 30 Nov 2022 19:20:12 +0100
Message-Id: <20221130180544.749015423@linuxfoundation.org>
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

[ Upstream commit 653f2d94fcda200b02bd79cea2e0307b26c1b747 ]

Like the Acer Switch One 10 S1003, for which there already is a quirk,
the Acer Switch V 10 (SW5-017) has a 800x1280 portrait screen mounted
in the tablet part of a landscape oriented 2-in-1. Add a quirk for this.

Cc: Rudolf Polzer <rpolzer@google.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Simon Ser <contact@emersion.fr>
Link: https://patchwork.freedesktop.org/patch/msgid/20221106215052.66995-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel_orientation_quirks.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index f0f6fa306521..52d8800a8ab8 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -134,6 +134,12 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "One S1003"),
 		},
 		.driver_data = (void *)&lcd800x1280_rightside_up,
+	}, {	/* Acer Switch V 10 (SW5-017) */
+		.matches = {
+		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Acer"),
+		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "SW5-017"),
+		},
+		.driver_data = (void *)&lcd800x1280_rightside_up,
 	}, {	/* Anbernic Win600 */
 		.matches = {
 		  DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "Anbernic"),
-- 
2.35.1



