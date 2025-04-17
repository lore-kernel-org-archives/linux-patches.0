Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1831D07BA;
	Thu, 17 Apr 2025 18:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915491; cv=none; b=lVNQ4Ejnm7H+8NUY6l0k8O68MayNca0SRI9NKZIeuHByKbwkbFxyKV9+bIVzNMNrLahavy9RWVM6qEvZsss5MvxwLoq6OnlQ7+HCE9IoT9vPkdvwgPu233tqy8JpOerdLAmIhqrTy1bK5wjZLnxKrldfqKO/a702klcikG51GRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915491; c=relaxed/simple;
	bh=R4HztuqWS2E70tfHESD/fBT511NEWFg8LSqwD/Xmqhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BvTGe4HYo6uKCMHK5MeQDwNhdzwA8NyGyjMSLXPIrKyuMJKo0YNvKweH+XFSOhAkWZ88qxm58EjVUjVj5rRzeoYsMX9aOoEtOtgTyJ66b7RcmW8wqZhiFtVjFeQ7C7ZvzFocANDI0SmRs7kmKI3rQuWLLomzdh/yMUHr7dv+X3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vcjrbrsa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vcjrbrsa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDDF9C4CEE4;
	Thu, 17 Apr 2025 18:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915491;
	bh=R4HztuqWS2E70tfHESD/fBT511NEWFg8LSqwD/Xmqhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VcjrbrsalgkShIXeoRrm5/iQ//KPdkamlfz3rPmRhlhbe8TrVTKJGU+9VCsPct+f4
	 fRmc645HbsPxRNFwPp6g1kXtlg5xG4hAdmpa+AavSwkd6UHDcGjwSRC2WWkc+3Y7eO
	 ROi71i5CoZQvvZ9njuhBQJIhTQUA594t/Fk6MhpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Gustavo Sousa <gustavo.sousa@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 144/393] drm/xe/xelp: Move Wa_16011163337 from tunings to workarounds
Date: Thu, 17 Apr 2025 19:49:13 +0200
Message-ID: <20250417175113.376967388@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>

[ Upstream commit d9b5d83c5a4d720af6ddbefe2825c78f0325a3fd ]

Workaround database specifies 16011163337 as a workaround so lets move it
there.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Cc: Gustavo Sousa <gustavo.sousa@intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250227101304.46660-3-tvrtko.ursulin@igalia.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_tuning.c | 8 --------
 drivers/gpu/drm/xe/xe_wa.c     | 7 +++++++
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_tuning.c b/drivers/gpu/drm/xe/xe_tuning.c
index 0d5e04158917b..1fb12da21c9e4 100644
--- a/drivers/gpu/drm/xe/xe_tuning.c
+++ b/drivers/gpu/drm/xe/xe_tuning.c
@@ -97,14 +97,6 @@ static const struct xe_rtp_entry_sr engine_tunings[] = {
 };
 
 static const struct xe_rtp_entry_sr lrc_tunings[] = {
-	{ XE_RTP_NAME("Tuning: ganged timer, also known as 16011163337"),
-	  XE_RTP_RULES(GRAPHICS_VERSION_RANGE(1200, 1210), ENGINE_CLASS(RENDER)),
-	  /* read verification is ignored due to 1608008084. */
-	  XE_RTP_ACTIONS(FIELD_SET_NO_READ_MASK(FF_MODE2,
-						FF_MODE2_GS_TIMER_MASK,
-						FF_MODE2_GS_TIMER_224))
-	},
-
 	/* DG2 */
 
 	{ XE_RTP_NAME("Tuning: L3 cache"),
diff --git a/drivers/gpu/drm/xe/xe_wa.c b/drivers/gpu/drm/xe/xe_wa.c
index 37e592b2bf062..0a1905f8d380a 100644
--- a/drivers/gpu/drm/xe/xe_wa.c
+++ b/drivers/gpu/drm/xe/xe_wa.c
@@ -606,6 +606,13 @@ static const struct xe_rtp_entry_sr engine_was[] = {
 };
 
 static const struct xe_rtp_entry_sr lrc_was[] = {
+	{ XE_RTP_NAME("16011163337"),
+	  XE_RTP_RULES(GRAPHICS_VERSION_RANGE(1200, 1210), ENGINE_CLASS(RENDER)),
+	  /* read verification is ignored due to 1608008084. */
+	  XE_RTP_ACTIONS(FIELD_SET_NO_READ_MASK(FF_MODE2,
+						FF_MODE2_GS_TIMER_MASK,
+						FF_MODE2_GS_TIMER_224))
+	},
 	{ XE_RTP_NAME("1409342910, 14010698770, 14010443199, 1408979724, 1409178076, 1409207793, 1409217633, 1409252684, 1409347922, 1409142259"),
 	  XE_RTP_RULES(GRAPHICS_VERSION_RANGE(1200, 1210)),
 	  XE_RTP_ACTIONS(SET(COMMON_SLICE_CHICKEN3,
-- 
2.39.5



