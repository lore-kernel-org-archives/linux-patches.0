Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A0D2F37;
	Tue,  8 Jul 2025 16:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993623; cv=none; b=ATJI08PJGZhGctMcRQMB8haCsNJLCAUnEYAONXPluygnA31h43g6CLTG2fwL4vd9oln260cgrEv/K55dbL9DkmVXHQ1AmuABZOrf8vQoVaZxl97WutfSDkHc0ODPSsswaYWr5FqINgdLB43fV/mqOJzYbHlbNdHHunWFxmGiq3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993623; c=relaxed/simple;
	bh=enYWOeOaAMgAlF5f16BHlPxogv/S33LQq65mKlXWlQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o6rRVpI3hsY72KpU3a4ZuRzrzmfLVp/RZ8wE9FbVVOYGHnr4kDPOCrtUE12KLE2xOh8PgqGE5NGDLhTUlzIP6oBRXwa2F797p5gjDuF+aQmh3RIZuszDvY9bWabFGD98Kw47ecMzG65LrqN1Ode46nbvhXYRwa7eCv8pjCUp3h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GUd1GnL7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GUd1GnL7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CF48C4CEED;
	Tue,  8 Jul 2025 16:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993623;
	bh=enYWOeOaAMgAlF5f16BHlPxogv/S33LQq65mKlXWlQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GUd1GnL7CAa+YhZMIjyd1+KyolejrnxGAfXbbIlB2xFKRtPIK0c0b4ix6TPoUE2i1
	 6IvQod0L0bgmIioFvBcFlDpYggbZy5KJymnSNzHC5tJoBsdhXDggNeE3McpPDlvvIx
	 //qnnPD9//SqiHJrydF2EDeznnLiFbo1CwfQ9mJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Roper <matthew.d.roper@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Vinay Belgaumkar <vinay.belgaumkar@intel.com>,
	Stuart Summers <stuart.summers@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 107/178] drm/xe/bmg: Update Wa_14022085890
Date: Tue,  8 Jul 2025 18:22:24 +0200
Message-ID: <20250708162239.427122791@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

From: Vinay Belgaumkar <vinay.belgaumkar@intel.com>

[ Upstream commit a5c7dcdd969f2248cc91d65e5ac852859fc8dac2 ]

Set GT min frequency to 1200Mhz once driver load is complete.

v2: Review comments (Rodrigo)
v3: Apply Wa earlier so user_req_min is not clobbered.
v4: Apply to all GTs (Lucas)

Cc: Matt Roper <matthew.d.roper@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Vinay Belgaumkar <vinay.belgaumkar@intel.com>
Reviewed-by: Stuart Summers <stuart.summers@intel.com>
Link: https://lore.kernel.org/r/20250612-wa-14022085890-v4-3-94ba5dcc1e30@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit bdde16c9ac5cb56ad2ee19792222fa1853577af7)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Stable-dep-of: 84c0b4a00610 ("drm/xe/bmg: Update Wa_22019338487")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_pc.c     | 5 +++++
 drivers/gpu/drm/xe/xe_wa_oob.rules | 4 ++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_guc_pc.c b/drivers/gpu/drm/xe/xe_guc_pc.c
index 23a4c525c03bf..28b97a2c14e3b 100644
--- a/drivers/gpu/drm/xe/xe_guc_pc.c
+++ b/drivers/gpu/drm/xe/xe_guc_pc.c
@@ -52,6 +52,7 @@
 
 #define LNL_MERT_FREQ_CAP	800
 #define BMG_MERT_FREQ_CAP	2133
+#define BMG_MIN_FREQ		1200
 
 #define SLPC_RESET_TIMEOUT_MS 5 /* roughly 5ms, but no need for precision */
 #define SLPC_RESET_EXTENDED_TIMEOUT_MS 1000 /* To be used only at pc_start */
@@ -817,6 +818,7 @@ void xe_guc_pc_init_early(struct xe_guc_pc *pc)
 
 static int pc_adjust_freq_bounds(struct xe_guc_pc *pc)
 {
+	struct xe_tile *tile = gt_to_tile(pc_to_gt(pc));
 	int ret;
 
 	lockdep_assert_held(&pc->freq_lock);
@@ -843,6 +845,9 @@ static int pc_adjust_freq_bounds(struct xe_guc_pc *pc)
 	if (pc_get_min_freq(pc) > pc->rp0_freq)
 		ret = pc_set_min_freq(pc, pc->rp0_freq);
 
+	if (XE_WA(tile->primary_gt, 14022085890))
+		ret = pc_set_min_freq(pc, max(BMG_MIN_FREQ, pc_get_min_freq(pc)));
+
 out:
 	return ret;
 }
diff --git a/drivers/gpu/drm/xe/xe_wa_oob.rules b/drivers/gpu/drm/xe/xe_wa_oob.rules
index 9efc5accd43d1..320766f6c5dff 100644
--- a/drivers/gpu/drm/xe/xe_wa_oob.rules
+++ b/drivers/gpu/drm/xe/xe_wa_oob.rules
@@ -59,3 +59,7 @@ no_media_l3	MEDIA_VERSION(3000)
 		MEDIA_VERSION_RANGE(1301, 3000)
 16026508708	GRAPHICS_VERSION_RANGE(1200, 3001)
 		MEDIA_VERSION_RANGE(1300, 3000)
+
+# SoC workaround - currently applies to all platforms with the following
+# primary GT GMDID
+14022085890	GRAPHICS_VERSION(2001)
-- 
2.39.5



