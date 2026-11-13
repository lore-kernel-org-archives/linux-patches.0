Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591056;
	b=Y0xkeEyVVt5yONiGjR55UDDkH+ORg2glMnYBFmAUdR3cy6HWNdWgNxHwkzBzOR04IYCJ
	 mOwIkmphlmeGTwWd4URI96zk2JNN9eRyG2xH2nkbG6iZbMxMShr1uo8Myz/pUVzNKdeVC
	 supPsUmwAyFQBnztjtzXUSdaaI7G/UZqCz/SbHhgAcfhEqXTcNZmJh1+u72n4f0iUV4L9
	 2pyt3p/xzFwp3jxxv3ggqBOn3iQODT/e9Gkx/zCk2xyuT8w8MntB4L8gRjsmqJDkkzN7v
	 yTk7iqugZ8kajE1KND6DjXlS4S4WdiHQKajqmNfIRhYjj70TOjxrFNFGCVa9DRmBFIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591056;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=K6eq0hSxy20ps9DvV9/eHosgkaYRFlTrVXS0dnHLhqs=;
	b=0yhqYkC0XtRNS3UGiiAJ5gyiY9aVtk6SwJ8ICs0u+hPv2a8aCIQ8VdPX4T7DJ+F1GHJl
	 orrvUBD6HBKF1gBClL6OSDvDEQMBoyEv5FSKc41WJRp0T3J3l4vbWcnGVGe/Qlf2hjpXy
	 v4XTrfwME6R6uSabucdpnpO0LpDl8D7K8JhPkY/XAe8zJ5yD8SXkLQop5L1HQDSMnCiL8
	 HvLDUF+CPwbBCLq8H3nKKqAZ5kIQfiH31v3/+bqGSWw3l8VqCICZIJx7EFhAPCZGZtF4N
	 +/McYXcMQ03UapglQgM3nTuQW0KTnJGtzMEtg4mVAHxAt7wvgIQeZxYyTVJ6W/OV7Yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wXrYFcT7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE71C606B82B;
	Fri, 13 Nov 2026 17:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wXrYFcT7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B29B1F000C4;
	Fri, 13 Nov 2026 17:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591056;
	bh=K6eq0hSxy20ps9DvV9/eHosgkaYRFlTrVXS0dnHLhqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wXrYFcT719zq7NQJKc/NRtsLWFZwASF9QE0bCBwmECOpdMzJUWCSpxWqkk/Sk3S5l
	 KF9VbXM03XnYvL32ct74eIkQOVlmFicb53nQrHurQQqH7Pdnyu9eXmhLfD1HvXuLdF
	 UGzpqq7nkGJPZUrY7zJjlpss+QFaEadt+RV/zz0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Mika Kahola <mika.kahola@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 218/670] drm/i915/psr: Dont clip plane state destination rectangle
Date: Fri, 13 Nov 2026 10:46:22 -0500
Message-ID: <20261113153819.290484765@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jouni Högander <jouni.hogander@intel.com>

[ Upstream commit e30830d21860fbf030ad162c3db4d1219477dfb5 ]

clip_area_update() uses drm_rect_intersect which modifies passed r1
rectangle. Early transport alignment passes the cursor uapi.dst rectangle
to clip_area_update, so the cursor uapi.dst is unintentionally modified by
drm_rect_intersect.

Fix this by using local copy in clip_area_update(). Also make the damage
and the display area const.

Fixes: 1bff93b8bc27 ("drm/i915/psr: Extend SU area to cover cursor fully if needed")
Cc: <stable@vger.kernel.org> # v6.9+
Assisted-by: GitHub-Copilot:claude-opus-5
Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: Mika Kahola <mika.kahola@intel.com>
Link: https://patch.msgid.link/20260929094434.77129-9-jouni.hogander@intel.com
(cherry picked from commit 8621f3bcea6b0a790a954ddf2e6514c20a24ac1a)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_psr.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_psr.c b/drivers/gpu/drm/i915/display/intel_psr.c
index df16587ea964c..97f82949a3a51 100644
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -2406,23 +2406,25 @@ static u32 psr2_pipe_srcsz_early_tpt_calc(struct intel_crtc_state *crtc_state,
 }
 
 static void clip_area_update(struct drm_rect *overlap_damage_area,
-			     struct drm_rect *damage_area,
-			     struct drm_rect *display_area)
+			     const struct drm_rect *damage_area,
+			     const struct drm_rect *display_area)
 {
-	if (!drm_rect_intersect(damage_area, display_area))
+	struct drm_rect inter = *damage_area;
+
+	if (!drm_rect_intersect(&inter, display_area))
 		return;
 
 	if (overlap_damage_area->y1 == -1) {
-		overlap_damage_area->y1 = damage_area->y1;
-		overlap_damage_area->y2 = damage_area->y2;
+		overlap_damage_area->y1 = inter.y1;
+		overlap_damage_area->y2 = inter.y2;
 		return;
 	}
 
-	if (damage_area->y1 < overlap_damage_area->y1)
-		overlap_damage_area->y1 = damage_area->y1;
+	if (inter.y1 < overlap_damage_area->y1)
+		overlap_damage_area->y1 = inter.y1;
 
-	if (damage_area->y2 > overlap_damage_area->y2)
-		overlap_damage_area->y2 = damage_area->y2;
+	if (inter.y2 > overlap_damage_area->y2)
+		overlap_damage_area->y2 = inter.y2;
 }
 
 static bool intel_psr2_sel_fetch_pipe_alignment(struct intel_crtc_state *crtc_state)
-- 
2.53.0



