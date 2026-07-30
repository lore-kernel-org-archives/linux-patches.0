Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EE9A443E3E;
	Thu, 30 Jul 2026 15:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423814; cv=none; b=CnqzEdtIqyiD3xuK8sQbHhjDNN9zSTKM79Viul1VXr2ZetTmIxKv1HzMVMn4RR6HixqCKxfUuyC9ki5h/kDE3PNy6g2s+SzlapLADM523UqCnNEUOf/FtzYd9oQjJLhQGms3rZwbnt/F7/ZYTnU1xFaz6qsaFoglVVwM/xXNqR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423814; c=relaxed/simple;
	bh=2rf9Acf/PwU/Anq49YgbFJr7fbmusWX59mg3YdlD/e0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XzQgOXP5unQUZf9b2tUJaFp4xiPjQMlnr+BLOX6z7pwYnAqT3ZvV1I6KHrCqwUjdh0UjNWC1hTemZjFuXZoyaSo1IENC8UOZ2cbBNBHRnWKyM1U8aOZb8Z5KIynT6WaG1DCMpSk0wt9mIflZAyINFka1oY2viTnaAVgI7QaPurM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vk5T2nXB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vk5T2nXB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D571F00A3A;
	Thu, 30 Jul 2026 15:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423813;
	bh=0hChI+mZlkwPgKmjoxoU7V97i98CBsYivhBsz/WpL8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vk5T2nXBiqi7j1RPGtDg0/eqJLK14P9n17BoKUW21Ckn48bA0MyNFdZI9WKo3zh39
	 wnL7MHL+vVXRqgGQg664fDIHzyttJU3byiep0oBNBFjOiyKAMUuJFxkV/j/prCmOte
	 mmlr1tDga8/ePJPSWY59u5hPsX3nDJmFi/jYweqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinod Govindapillai <vinod.govindapillai@intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 131/675] drm/i915/wm: clear the plane ddb_y entries on plane disable
Date: Thu, 30 Jul 2026 16:07:41 +0200
Message-ID: <20260730141447.928721307@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vinod Govindapillai <vinod.govindapillai@intel.com>

[ Upstream commit e89978c1cff54e265345c66e1177d19ea5a8bc00 ]

The UV/Y plane DDB entriess are never cleared on
sk_wm_plane_disable_noatomic() and can leave stale DDB state
for NV12 planes on pre-Gen11 devices

Fixes: d34b59d5ba41 ("drm/i915: Add skl_wm_plane_disable_noatomic()")
Assisted-by: Copilot:claude-sonnet-4.6
Signed-off-by: Vinod Govindapillai <vinod.govindapillai@intel.com>
Reviewed-by: Suraj Kandpal <suraj.kandpal@intel.com>
Link: https://patch.msgid.link/20260615203355.218578-2-vinod.govindapillai@intel.com
(cherry picked from commit 60f68a6ba298fd1e971a2d91576304bee89a16fc)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/skl_watermark.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/skl_watermark.c b/drivers/gpu/drm/i915/display/skl_watermark.c
index a5862998bf1447..eb54fffc698864 100644
--- a/drivers/gpu/drm/i915/display/skl_watermark.c
+++ b/drivers/gpu/drm/i915/display/skl_watermark.c
@@ -3815,7 +3815,7 @@ void skl_wm_plane_disable_noatomic(struct intel_crtc *crtc,
 		return;
 
 	skl_ddb_entry_init(&crtc_state->wm.skl.plane_ddb[plane->id], 0, 0);
-	skl_ddb_entry_init(&crtc_state->wm.skl.plane_ddb[plane->id], 0, 0);
+	skl_ddb_entry_init(&crtc_state->wm.skl.plane_ddb_y[plane->id], 0, 0);
 
 	crtc_state->wm.skl.plane_min_ddb[plane->id] = 0;
 	crtc_state->wm.skl.plane_interim_ddb[plane->id] = 0;
-- 
2.53.0



