Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E41A24113A;
	Tue, 29 Apr 2025 16:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945192; cv=none; b=I3r0Q43Fp6NfKt1R02W6Kwh2k+6DAx1bdo1qcwtePQt7xWqzgJKWMxUlCem8M3kLOKUQzxAwuTxiDWreK6qbNPJza76/q5hKm0L5jdrpd43HDal3Rh2/yNVoqCKb1u0tRsLtKt3YcjSIrl7sr5UQjHNKhgD/69AXzeuHxSWDMLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945192; c=relaxed/simple;
	bh=K8lnBzlNMmy8DlUrsAVJdMSb4FJWThlo304jD7nsJq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jne6MA3tI9BzwMsiaCWSjoRsTk67aPecmz5C+9JY+kDl6KLu1DaSxjdLQFiLiksqlJoI6W4Vw8u2LLt+zJDBg/yBsbmLAnuyBytps14wKcLwzA1iOXPY5JmY6VVKJCFDpoQ93WBRmroPIj8MrAG7lv38JbYXjWMIhuS2UQVUNJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XvuSlREF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XvuSlREF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F014DC4CEE3;
	Tue, 29 Apr 2025 16:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945192;
	bh=K8lnBzlNMmy8DlUrsAVJdMSb4FJWThlo304jD7nsJq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XvuSlREFm/L2oOtSm4gpmAA1B5ftGyC+zTsd43rLIbYtZ4HtsbqK2RwdI8yuHmvdN
	 qMTNS0mGVubjTSPWQw0bDRdhEvuXI3ch/aYjuoE/5PFGRc+UIGmI8ZO6mfhT61v4VF
	 wTstZHgYLMMFUA5r0egP1jL5N741kQfiQroHj++k=
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
Subject: [PATCH 5.4 032/179] drm: panel-orientation-quirks: Add new quirk for GPD Win 2
Date: Tue, 29 Apr 2025 18:39:33 +0200
Message-ID: <20250429161050.712296722@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 6bb8d4502ca8e..6fc9d638ccd23 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -235,6 +235,12 @@ static const struct dmi_system_id orientation_data[] = {
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



