Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A3D274673;
	Sun,  1 Jun 2025 23:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748821261; cv=none; b=GTTQAhj2GJbgOQMG058r5IOLx7fwUU2iSW6xLuXb6ue8bnSNtdMQFABjXM4/m1JUsGI8OG8xm20DhH9mXmRliLWJ1WarTK3/Cj9nR6fucliJ9kFRI94qNA9ZzKztLlyi3XU4dgBNqkpDCv8p2jz6AKt6WED9dpOteazdwPb2IP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748821261; c=relaxed/simple;
	bh=wya/bQiyVLnmLH0DMDaG6zL4eFgtyW9lqzmnPj48u74=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F3BOMtEWo4cnteUeBhaRqZy3KSg11zG1yF49ksS8tumg26fKVS6jTRwHIqt0Qnra7UzJl4Vbm0H6Y3zJ9Xp0bBfNm+/E6vIz2PavnunCMSrNNuf6wNBRy6+E1OD54BFuflDEiLWk26yJC+Rg0FxOhEcEGJIaLh1xApf/1g+o4gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o3Jb1czW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o3Jb1czW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB4D3C4CEF2;
	Sun,  1 Jun 2025 23:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748821261;
	bh=wya/bQiyVLnmLH0DMDaG6zL4eFgtyW9lqzmnPj48u74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o3Jb1czWn5SG8yoGDLtzURZfdtidCqkezYewHBCMMArgKBK9Ve93P+sk2W2it8cGw
	 y2x8sslh0N+MoENjqu/84ioIO90X+27AicxxjnW55LDZZDtLh0wlEQxSn7Gzw4yl9I
	 a0uqQsSARBpHrxnDS83iubHyzXLyI3de+adjexlTVNRoNGczeOUFX2xjSq/S6i1vXe
	 9ojLia14i6mYNB7S+gq/Vp7E4MN/fUCxZZVy298+WPgMYyQ4IDAg45GJf3AcOqBKe3
	 jagnUVPYR/Oya+/mHLurHGITYkO+iNI7+9ijjaIcQMCM+xh5hkTQk5aQrseai6Ke0T
	 52zL5sMvhtqQw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Vicki Pfau <vi@endrift.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 18/58] drm: panel-orientation-quirks: Add ZOTAC Gaming Zone
Date: Sun,  1 Jun 2025 19:39:31 -0400
Message-Id: <20250601234012.3516352-18-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250601234012.3516352-1-sashal@kernel.org>
References: <20250601234012.3516352-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.140
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vicki Pfau <vi@endrift.com>

[ Upstream commit 96c85e428ebaeacd2c640eba075479ab92072ccd ]

Add a panel orientation quirk for the ZOTAC Gaming Zone handheld gaming device.

Signed-off-by: Vicki Pfau <vi@endrift.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250313211643.860786-2-vi@endrift.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees.
**Extensive Analysis:** **1. Pattern Matching with Historical Commits:**
The commit follows an identical pattern to all the similar commits
marked as "Backport Status: YES" in the reference examples: - GPD Win3
(YES): Added DMI quirk for handheld gaming device with specific
vendor/product matching - OrangePi Neo (YES): Added DMI quirk for gaming
handheld with same pattern - GPD Win Mini (YES): Added gaming device
quirk with identical structure - GPD Win Max (YES): Added gaming device
quirk following same format **2. Code Analysis:** The change is
extremely minimal and safe: ```c + }, { /bin /bin.usr-is-merged /boot
/dev /etc /home /init /lib /lib.usr-is-merged /lib64 /lost+found /media
/mnt /opt /proc /root /run /sbin /sbin.usr-is-merged /snap /srv /sys
/tmp /usr /var ZOTAC Gaming Zone model/ prompt/ src/ target/ + .matches
= { + DMI_EXACT_MATCH(DMI_SYS_VENDOR, "ZOTAC"), +
DMI_EXACT_MATCH(DMI_BOARD_NAME, "G0A1W"), + }, + .driver_data = (void
*)&lcd1080x1920_leftside_up, ``` This adds exactly 6 lines to the
`orientation_data[]` array in
`drivers/gpu/drm/drm_panel_orientation_quirks.c:500`. The change: - Uses
existing, well-tested infrastructure (`lcd1080x1920_leftside_up` data
structure already defined at line 120-124) - Employs standard DMI
matching with `DMI_EXACT_MATCH()` for precise device identification -
References an existing orientation configuration, introducing zero new
logic - Is completely isolated and cannot affect other devices due to
highly specific DMI matching **3. Bug Fix Nature:** This addresses a
real user-affecting bug - incorrect screen orientation on ZOTAC Gaming
Zone handhelds. Without this quirk: - The display appears rotated
incorrectly - Users experience poor usability with graphics rotated 90
degrees - Gaming on the device is significantly impacted **4. Risk
Assessment:** - **Minimal regression risk**: The DMI matching is highly
specific (`DMI_SYS_VENDOR="ZOTAC"` AND `DMI_BOARD_NAME="G0A1W"`) - **No
architectural changes**: Uses existing quirk framework - **No new
features**: Pure bug fix for hardware support - **Contained scope**:
Only affects this specific ZOTAC device model **5. Stable Tree
Compliance:** ✅ **Important bug fix**: Fixes screen orientation for
users ✅ **Small and contained**: 6-line addition using existing
infrastructure ✅ **No side effects**: Cannot impact other devices due to
specific DMI matching ✅ **No architectural changes**: Pure data addition
to existing quirk table ✅ **Critical subsystem**: Display orientation
affects basic usability ✅ **Follows established pattern**: Identical to
other gaming handheld quirks that were backported **6. Historical
Precedent:** All similar gaming handheld orientation quirks in the
reference examples were marked "Backport Status: YES", establishing
clear precedent that these types of device-specific orientation fixes
are appropriate for stable backporting. **7. User Impact:** Gaming
handhelds are consumer devices where display orientation directly
impacts usability. Users of ZOTAC Gaming Zone devices currently
experience a rotated display, making the device difficult or impossible
to use properly until this fix is applied. The commit perfectly matches
the stable kernel criteria: it's a small, important bug fix with minimal
risk that improves hardware support for end users.

 drivers/gpu/drm/drm_panel_orientation_quirks.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index 036b095c98882..c2a6b4495ae12 100644
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

