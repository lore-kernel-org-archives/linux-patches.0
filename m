Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B145158540;
	Mon, 16 Sep 2024 12:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488228; cv=none; b=u3ShufsxbhZgZrSVTuGXoqkjlU9tIgmKzpPCpeqXnlFV8PaLEUcL1OmAsxJLdNTS4R/CwIoKZpV142kqyX+PM2DFlvuBBGwzv1bh9euPX51R6PeR8wWMUXlpjDFWm52T0mK3GuZpgwP/74sckxgssTQgr7UoKp8i7dAHR1G6T68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488228; c=relaxed/simple;
	bh=jrcAcQjjjRGXS9CaPdbE08P1KIG5afml9puwSAD6PF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GC/hfB8PlJfcZLYDAO08N5ysvXFe7IOlkRMq48Z/wy9/LbDjMJ5Ot46jrLleKgIJqixazFraUpWZbriiPMdKccwFvYBbEqhXk9inpVQbsjyQ2zBH2Psvj/Mt9Z0GV4pGgP0xnlixinivHPFRfnZB5fHaHhPxAtRkuDH8xo+jPA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Gd6g1A0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Gd6g1A0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D0C1C4CEC4;
	Mon, 16 Sep 2024 12:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488228;
	bh=jrcAcQjjjRGXS9CaPdbE08P1KIG5afml9puwSAD6PF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Gd6g1A0enTls+A9hWTg4Apk14Vd4CxiuU1CZNULfvSUVqJlqqJidF1gjZuM7Xcz/
	 3ltzDqcbFCkOEp9B8nEIUBh1pCee0tkUeUGLJToWjLlWFwnIpxliyXE8apDWmgo1L7
	 UeaE+wwbB5kTW7v+Cq8bseUMKkYKrsvUVktcVOPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bouke Sybren Haarsma <boukehaarsma23@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 012/121] drm: panel-orientation-quirks: Add quirk for Ayn Loki Max
Date: Mon, 16 Sep 2024 13:43:06 +0200
Message-ID: <20240916114229.326979930@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bouke Sybren Haarsma <boukehaarsma23@gmail.com>

[ Upstream commit 2c71c8459c8ca66bd8f597effaac892ee8448a9f ]

Add quirk orientation for Ayn Loki Max model.

This has been tested by JELOS team that uses their
own patched kernel for a while now and confirmed by
users in the ChimeraOS discord servers.

Signed-off-by: Bouke Sybren Haarsma <boukehaarsma23@gmail.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240728124731.168452-3-boukehaarsma23@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel_orientation_quirks.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index 40473c705562..70c9bd25f78d 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -208,6 +208,12 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_MATCH(DMI_BOARD_NAME, "KUN"),
 		},
 		.driver_data = (void *)&lcd1600x2560_rightside_up,
+	}, {    /* AYN Loki Max */
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "ayn"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Loki Max"),
+		},
+		.driver_data = (void *)&lcd1080x1920_leftside_up,
 	}, {	/* AYN Loki Zero */
 		.matches = {
 			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "ayn"),
-- 
2.43.0



