Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92CF130E847;
	Sat, 30 May 2026 17:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161702; cv=none; b=WdebnypB5QPQ7tazrgzoSx6vZD8kTxf2GdNXR8S4S+SCkan0LpEAtKIAcNhsUADfRyv5s8WtWq62bonQm90CFFIVAacoPtBpd2Smub2d8xp/+8NJCxp6p5NgL+LFsKdibVtneJGb59YInQd3zo4w06mNnSVmfL7Tgvb4bcG02po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161702; c=relaxed/simple;
	bh=MlkNM0wwhQHVZsYyraD+dwiHZoauqyAip+Cfkg+Zh/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=emapJWfr4gb4PIpKdZQeK6U/uDuN6sui75SuExltAi8FVoOdwRqtoZemCDgD58wsUFqqlokU5E68OeaQM0dqZrvZbFdxVqP1jwTQYlA2e8L6MRgspiOVc+m/6wlkWrcUaPjgAWnqBUZ/WPi/T7fNAc/pM1YxJDV+rLFfJVNvezM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DgpGYGAN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DgpGYGAN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF18D1F00893;
	Sat, 30 May 2026 17:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161701;
	bh=7BInkI+tNlcPG4W6MIyM7ULrA4ZWbnR6MA+jmdyJ0Yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DgpGYGANrqSLBzdh37QMQbG5duGOcXPB+SjXd7LpsYft36mA924ppHSEIGBoBvYRt
	 ZDMEYk2Eim2Op0rq8I7crFPA536mm6qq89vZ1VoeXbq/7sa/TDqodFEF0rx5vjwskh
	 4zGGn3SYi7Bdntkw9cQm33Af9QDMAya6TLG/glz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Vinod Govindapillai <vinod.govindapillai@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 672/969] drm/i915/wm: Verify the correct plane DDB entry
Date: Sat, 30 May 2026 18:03:16 +0200
Message-ID: <20260530160319.048682592@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit a97c88a176b6b8d116f4d3f508f3bd02bc77b462 ]

Actually verify the DDB entry for the plane we're looking
at instead of always verifying the cursor DDB.

Fixes: 7d4561722c3b ("drm/i915: Tweak plane ddb allocation tracking")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patch.msgid.link/20260324134843.2364-5-ville.syrjala@linux.intel.com
Reviewed-by: Vinod Govindapillai <vinod.govindapillai@intel.com>
(cherry picked from commit f002f7c7439de18117a31ca84dc87a59719c3dd6)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/skl_watermark.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/skl_watermark.c b/drivers/gpu/drm/i915/display/skl_watermark.c
index 2a60aa3fedf82..965d8e762883f 100644
--- a/drivers/gpu/drm/i915/display/skl_watermark.c
+++ b/drivers/gpu/drm/i915/display/skl_watermark.c
@@ -3118,8 +3118,8 @@ void intel_wm_state_verify(struct intel_crtc *crtc,
 		}
 
 		/* DDB */
-		hw_ddb_entry = &hw->ddb[PLANE_CURSOR];
-		sw_ddb_entry = &new_crtc_state->wm.skl.plane_ddb[PLANE_CURSOR];
+		hw_ddb_entry = &hw->ddb[plane->id];
+		sw_ddb_entry = &new_crtc_state->wm.skl.plane_ddb[plane->id];
 
 		if (!skl_ddb_entry_equal(hw_ddb_entry, sw_ddb_entry)) {
 			drm_err(&i915->drm,
-- 
2.53.0



