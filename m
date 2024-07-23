Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F1613D600;
	Tue, 23 Jul 2024 18:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759548; cv=none; b=NY49W8FmPM6HRHvvMD/AgIXf8wbFSfL37MQ+tlfvgoeNzHD5z4AXoIaiF936vQyDMbbNHKyar0AL+M2wiStIGyxh/g6kt0LHGT9I0z89RgbEGdQoX8QJ2/hVf2niPe7fzB82Ds+aXqPRX32Xt2jYbQM27xY7IeczaBeSnV7RcxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759548; c=relaxed/simple;
	bh=NNGOolRMCoLA2TUQVRFTSR0phagT9PUkZKtgq8xHNqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OtDe1zzOCj5x2kQHkIKPiO8Cfo7Jo7XPgUrdKYdIeLX5zb/HbhXGyMmXyE+hwhj9cvCNXlKZPYaCMNm43dFj7/hUdSlaHIUwzpRxEYMFn4u/oNaQOEcMrKYAycu7dyCYA+hcdrU8b5WDZMxv761XPtWafjjGAjt4JRlP4R+use4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G9VizqDD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G9VizqDD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 462E8C4AF0A;
	Tue, 23 Jul 2024 18:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759548;
	bh=NNGOolRMCoLA2TUQVRFTSR0phagT9PUkZKtgq8xHNqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G9VizqDD6RwYdx+aGuVof0dII986LFjGfx0C+WSm7V6NFurXU8khcXGkuwiWOO6vm
	 bOmIsvPnuv3lHRUQXBA9iPpVgPuISNsEQKqK6RFAT5KErW/IN94NPzO52MNW84DaZa
	 h1WmT9tMeKMz82d4sYhXgJHlqbP/lxrmTp/YRW2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobias Jakobi <tjakobi@math.uni-bielefeld.de>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 047/129] drm: panel-orientation-quirks: Add quirk for Aya Neo KUN
Date: Tue, 23 Jul 2024 20:23:15 +0200
Message-ID: <20240723180406.606212247@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tobias Jakobi <tjakobi@math.uni-bielefeld.de>

[ Upstream commit f74fb5df429ebc6a614dc5aa9e44d7194d402e5a ]

Similar to the other Aya Neo devices this one features
again a portrait screen, here with a native resolution
of 1600x2560.

Signed-off-by: Tobias Jakobi <tjakobi@math.uni-bielefeld.de>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240310220401.895591-1-tjakobi@math.uni-bielefeld.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel_orientation_quirks.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index 426bbee2d9f5e..5db52d6c5c35c 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -202,6 +202,12 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_MATCH(DMI_BOARD_NAME, "NEXT"),
 		},
 		.driver_data = (void *)&lcd800x1280_rightside_up,
+	}, {	/* AYA NEO KUN */
+		.matches = {
+		  DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "AYANEO"),
+		  DMI_MATCH(DMI_BOARD_NAME, "KUN"),
+		},
+		.driver_data = (void *)&lcd1600x2560_rightside_up,
 	}, {	/* Chuwi HiBook (CWI514) */
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "Hampoo"),
-- 
2.43.0



