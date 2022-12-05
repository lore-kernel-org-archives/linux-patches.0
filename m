Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947DB15C82
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:19:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1757EC433D6;
	Mon,  5 Dec 2022 19:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670267948;
	bh=/6xSMD6UHdU98GX4NucIayPDS4nBVFCfSm/TkkM5y+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iZ4v8YevP0AkOTZiFB6CNfdc7Tn0QvyvagkTf+hyeBhDs8vSYOHzzwUg9mESYQNmP
	 jgtGI41BTnYFMKtKpElv7SXrUhkb9aW4EimCg+9Om+yzbQQ14Am7oKgFGHE3/Bq04U
	 Dk1JgwM+UV0zlAMftpYIGwJtStYDVsAb1e8JuB/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rudolf Polzer <rpolzer@google.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Simon Ser <contact@emersion.fr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 005/105] drm: panel-orientation-quirks: Add quirk for Acer Switch V 10 (SW5-017)
Date: Mon,  5 Dec 2022 20:08:37 +0100
Message-Id: <20221205190803.300219033@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.124472741@linuxfoundation.org>
References: <20221205190803.124472741@linuxfoundation.org>
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
index bea1d3e7e964..7a2a148b8ec6 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -95,6 +95,12 @@ static const struct dmi_system_id orientation_data[] = {
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



