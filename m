Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352BA27FD7A;
	Wed, 23 Apr 2025 15:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420538; cv=none; b=VIOcHO/6edqmgcTISN26KxsSklXyJurvksVTnYkbly8Gd70wTQj55/4E4WkinpD/NkJGelHWbsSs4AlwmYt929D9UJkev4EbQbEV2T6IPMrqzMjF4pwGWBG9Cc0oz2NgjqzXUbMU58YohRYBAczoqiStVjb5IbAPQfnVeNYcNMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420538; c=relaxed/simple;
	bh=qI/oikYJ5Y4y7+d6/wkKDbiC3kgC/oGZx34Idmgrrkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hBswBY5ByTzz8FSdhf6v931nI2GBC1zxyj9GMplJDIz3ouPCMKMJzJT6x/U4voQGq3V/W/w7PIVFfptE6UAs8izCnxmKgPTG4VlYYv+/KY41rZu//8bX0gWPwcSVcSh5ldR9yMV549xmzWltcqhtem2h+QV1pJRjEjGvnyWxAeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ufwye7UT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ufwye7UT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56DFEC4CEE2;
	Wed, 23 Apr 2025 15:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420537;
	bh=qI/oikYJ5Y4y7+d6/wkKDbiC3kgC/oGZx34Idmgrrkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ufwye7UTSozM93s4ZyzHnNTmDa0mSnuzVhfjSXj3upbvxmXPb6qA7oOTa9gb4v56Y
	 MNHFgB/7ttctb/x3/oDQo5LnNLmgUMEbi0YwwfZNV43plrDKZ/3dx29/lkxUUn/A8s
	 noO8dg7kLzAvNyLKpjIc5W0VdD3UrXzdOjqbreF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Wyatt <fewtarius@steamfork.org>,
	John Edwards <uejji@uejji.net>,
	Paco Avelar <pacoavelar@hotmail.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 058/291] drm: panel-orientation-quirks: Add new quirk for GPD Win 2
Date: Wed, 23 Apr 2025 16:40:47 +0200
Message-ID: <20250423142626.750172697@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Wyatt <fewtarius@steamfork.org>

[ Upstream commit a860eb9c6ba6cdbf32e3e01a606556e5a90a2931 ]

Some GPD Win 2 units shipped with the correct DMI strings.

Add a DMI match to correctly rotate the panel on these units.

Signed-off-by: Andrew Wyatt <fewtarius@steamfork.org>
Signed-off-by: John Edwards <uejji@uejji.net>
Tested-by: Paco Avelar <pacoavelar@hotmail.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20250213222455.93533-5-uejji@uejji.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel_orientation_quirks.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index 702246ee7ced2..12d547f093bd2 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -339,6 +339,12 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_EXACT_MATCH(DMI_BOARD_NAME, "Default string"),
 		},
 		.driver_data = (void *)&gpd_win2,
+	}, {	/* GPD Win 2 (correct DMI strings) */
+		.matches = {
+		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "GPD"),
+		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "WIN2")
+		},
+		.driver_data = (void *)&lcd720x1280_rightside_up,
 	}, {	/* GPD Win 3 */
 		.matches = {
 		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "GPD"),
-- 
2.39.5



