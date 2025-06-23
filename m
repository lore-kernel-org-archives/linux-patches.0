Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2572B16419;
	Mon, 23 Jun 2025 13:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685911; cv=none; b=JyA+pcWOLDZt5canvZDTjiuG7B6j2FxZpfTZrWa720tT3DlXCHpJYyv3Dd+e0czFLaqCxHmn10qOSfllUjBPrUHdTu2Ye66fqDSL/XsLr8TFO7XaTAsWqEdXz3KdXctKubeti8NyY5tpF9p7woNNV+jKctjBu8JTFwEu2wergNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685911; c=relaxed/simple;
	bh=h+JjM/rEjFVIdTsO9l/6WJMoMnUmL+V+rn+LtVrgNNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F++fm6VLwOx+nzaMzzT30I2XxSEkfnSiGRgLRAu0WMBB2IjmTf7U9Yw7GRib1NVGmt289cFyVkTU4hOvsIrLzZp3vtr9AR4XAZ9nt+pc8WKciIMV9sVbmYM1V0ih2mT6dJf8dti1hhhhizua6DyKQkfM42r3GSwaiiqeOmZBJG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WSx0CY9z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WSx0CY9z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A136C4CEEA;
	Mon, 23 Jun 2025 13:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685910;
	bh=h+JjM/rEjFVIdTsO9l/6WJMoMnUmL+V+rn+LtVrgNNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WSx0CY9zTKbOpOyb/469d+eqvxap33dkTylaQAwoQOvNAUYJ+La42gOgHo6693a19
	 51GiiN//EZBFaPepNLfWJwbS3q86tjUpWe+OX6+NJHNpeemeW8S0Leo+DUkP3f2i98
	 cN/NHrQgxkBMPfTlngqgIWyHsSYYwXAywGqAP22Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicki Pfau <vi@endrift.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 270/592] drm: panel-orientation-quirks: Add ZOTAC Gaming Zone
Date: Mon, 23 Jun 2025 15:03:48 +0200
Message-ID: <20250623130706.744866711@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vicki Pfau <vi@endrift.com>

[ Upstream commit 96c85e428ebaeacd2c640eba075479ab92072ccd ]

Add a panel orientation quirk for the ZOTAC Gaming Zone handheld gaming device.

Signed-off-by: Vicki Pfau <vi@endrift.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250313211643.860786-2-vi@endrift.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel_orientation_quirks.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index c554ad8f246b6..7ac0fd5391fea 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -517,6 +517,12 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "LTH17"),
 		},
 		.driver_data = (void *)&lcd800x1280_rightside_up,
+	}, {	/* ZOTAC Gaming Zone */
+		.matches = {
+		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "ZOTAC"),
+		  DMI_EXACT_MATCH(DMI_BOARD_NAME, "G0A1W"),
+		},
+		.driver_data = (void *)&lcd1080x1920_leftside_up,
 	}, {	/* One Mix 2S (generic strings, also match on bios date) */
 		.matches = {
 		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Default string"),
-- 
2.39.5



