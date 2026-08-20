Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1E83C07A;
	Thu, 20 Aug 2026 15:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238655; cv=none; b=MTub2BYnC2Ncs2KeDO8oWRYUOZzKLMfssANnv4tFoq708Et4CFNjMNYgEUJrksilNvSl05c8EGQQ8vSUX34rY+WZSYbh2AOqfl2vVGbIkSfdyZvuWLY65LctGA/kPVdsSPAWA2d5X3fk5EUTBdyGqbAhrCbmDgauTJewsybUT7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238655; c=relaxed/simple;
	bh=Bv6ghL7kEpW2L2ZQSUv8Lv7KXcmUbADSeNSOGKTj7Hs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QIsxWJcWbJzeYp3EQ+JH62ZYS7Cv3JZIC/d5+3PqpGximgLtpu/SnlmBGboGl0lFShWrE5L7479/2fnQhhsbdagPRKaJQmWZHLxv1mCFC0PkXSvHf6Vx8abJJgk4f6IwMUgrfMOoUpzNkKHQCjWfeSKxSR8DG2G7TID/7jP9iF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N68oIKKs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N68oIKKs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8D111F000E9;
	Thu, 20 Aug 2026 15:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238654;
	bh=4k71GJ0DClpJBq/djNIOcMUlSRrIG6rxmV/YpxxjsE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N68oIKKs56AW2GPxQ80BT7kvsFMvh94S3t3iiw1+5tCFnEZHAn+KOA8ILi2Yl9eKd
	 MlG/GG0Yby1rwmfXNwtVMoAZ1YtKlVRMVH9yPFPRTwVDV7VIh+Gcb0OHUKQj33ZiZu
	 AMDw5bSCBJU4gfIe/dpR/MTj5l401DJuPMrOdSIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nareshkumar Gollakoti <naresh.kumar.g@intel.com>,
	Vinay Belgaumkar <vinay.belgaumkar@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 222/228] drm/xe: Set GT rp min frequency as 1.2GHz default for BMG/CRI
Date: Thu, 20 Aug 2026 16:56:04 +0200
Message-ID: <20260820145251.817849956@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nareshkumar Gollakoti <naresh.kumar.g@intel.com>

[ Upstream commit d0672008cde3a8616c517d53d657300dce3c36a7 ]

 While previously applied only to both tiles GT0(Graphics) and Media(GT1)
 the BMG G21(Battle image) platform via workaround Wa_14022085890,
 this 1.2 GHz minimum is now the default for GT0(Graphics) tile
 of BMG and CRI platforms.

 Setting this frequency floor(1.2GHz) default is critical in multi GPU
 environment for supporting effective Peer-to-Peer(P2P) transactions.

v2:
- Fix Indentation(Thomas)
- Add comment about power impact(Stuart)

v3:(Thomas/Ankur/Matt Roper)
- Add setting frequency to only GT0(Graphics) Tile of BMG/CRI

v4:(Stuart)
- Move WA check to pc_needs_min_freq_change function

Signed-off-by: Nareshkumar Gollakoti <naresh.kumar.g@intel.com>
Reviewed-by: Vinay Belgaumkar <vinay.belgaumkar@intel.com>
Link: https://patch.msgid.link/20260326063407.985568-4-naresh.kumar.g@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Stable-dep-of: 5cf82c8cec90 ("drm/xe: Fix a bug in pc_adjust_freq_bounds()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_pc.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_guc_pc.c b/drivers/gpu/drm/xe/xe_guc_pc.c
index bb8c4e7934926..7ecd91ad6192d 100644
--- a/drivers/gpu/drm/xe/xe_guc_pc.c
+++ b/drivers/gpu/drm/xe/xe_guc_pc.c
@@ -890,9 +890,26 @@ void xe_guc_pc_init_early(struct xe_guc_pc *pc)
 	pc_init_fused_rp_values(pc);
 }
 
+static bool pc_needs_min_freq_change(struct xe_guc_pc *pc)
+{
+	struct xe_device *xe = pc_to_xe(pc);
+	struct xe_gt *gt = pc_to_gt(pc);
+
+	if (XE_DEVICE_WA(xe, 14022085890))
+		return true;
+
+	if (xe_gt_is_media_type(gt))
+		return false;
+
+	if (xe->info.platform == XE_BATTLEMAGE ||
+	    xe->info.platform == XE_CRESCENTISLAND)
+		return true;
+
+	return false;
+}
+
 static int pc_adjust_freq_bounds(struct xe_guc_pc *pc)
 {
-	struct xe_tile *tile = gt_to_tile(pc_to_gt(pc));
 	int ret;
 
 	lockdep_assert_held(&pc->freq_lock);
@@ -919,7 +936,18 @@ static int pc_adjust_freq_bounds(struct xe_guc_pc *pc)
 	if (pc_get_min_freq(pc) > pc->rp0_freq)
 		ret = pc_set_min_freq(pc, pc->rp0_freq);
 
-	if (XE_DEVICE_WA(tile_to_xe(tile), 14022085890))
+	/*
+	 * Setting GT RP min frequency to 1.2GHz by default for
+	 * GT0(Graphics) Tile of BMG and CRI.
+	 *
+	 * While BMG G21 WA will apply min frequency for
+	 * both GT0(Graphics) and GT1(Media) Tile.
+	 *
+	 * This is an active frequency, so if the device is idle
+	 * we aren't expecting high power output across board
+	 *
+	 */
+	if (pc_needs_min_freq_change(pc))
 		ret = pc_set_min_freq(pc, max(BMG_MIN_FREQ, pc_get_min_freq(pc)));
 
 out:
-- 
2.53.0



