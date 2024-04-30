Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D007612C47A;
	Tue, 30 Apr 2024 10:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474500; cv=none; b=L0HoJn20uNQh9vLCWypOg9XmK+Iow3zZsJGm2iaV4jbbujwFB6guY/lDCVob8IOs5h8bYbVENCS8fStNFUUHP8w6BfSBZyBZqtcl4Y/1wxx0LJHPbokTer6SB842O9ydnNPS8uN0xG+kOSiI4sODGf0c4Qcw+m+4uBwlzar/Xek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474500; c=relaxed/simple;
	bh=9p0pSXQCSOwXDhqTGh4PD2GymW+KdSjAs4vWdDUOPJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hik13GpuEk0tMkYxtUBuSlszIrKGS0q+zHc5JlJP/fxlvIV0NBGC9UyrbFTI3cJYxzs5fiWMACSMBcGUNd8P6tDpHZIEA7XcPLlLuJgeCA+U8rzo75/0Kj+oZfZEwPOz4Acht7j5pRnr/5oZmpG+1+Dz5xAmvS1ZQKzZ1OjvyUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LB4cu2Dn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LB4cu2Dn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A70C2BBFC;
	Tue, 30 Apr 2024 10:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474500;
	bh=9p0pSXQCSOwXDhqTGh4PD2GymW+KdSjAs4vWdDUOPJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LB4cu2DnX2RtcT3itW7PJSH/1o7SIs/UUgj/FBhjwjSj88NrFFQBxNXxFN2uVZ/Wl
	 ZiYeFHuw4WQdpZY8fp10O3fGo17zTAVxfTVG9bqN1l9Bvb7j5Rtd0zJmXkQ0O2eetf
	 xG0vckd1pils7pyY1n7sIsB81NLgI8Bq5WVTUrzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Stach <l.stach@pengutronix.de>,
	=?UTF-8?q?Leonard=20G=C3=B6hrs?= <l.goehrs@pengutronix.de>,
	Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 6.8 175/228] drm/atomic-helper: fix parameter order in drm_format_conv_state_copy() call
Date: Tue, 30 Apr 2024 12:39:13 +0200
Message-ID: <20240430103108.852527781@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas Stach <l.stach@pengutronix.de>

commit a386c30410450ea87cd38070f9feaca49dadce29 upstream.

Old and new state parameters are swapped, so the old state was cleared
instead of the new duplicated state.

Fixes: 903674588a48 ("drm/atomic-helper: Add format-conversion state to shadow-plane state")
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Tested-by: Leonard Göhrs <l.goehrs@pengutronix.de>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Cc: <stable@vger.kernel.org> # v6.8+
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20240404081756.2714424-1-l.stach@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_gem_atomic_helper.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem_atomic_helper.c b/drivers/gpu/drm/drm_gem_atomic_helper.c
index e440f458b663..93337543aac3 100644
--- a/drivers/gpu/drm/drm_gem_atomic_helper.c
+++ b/drivers/gpu/drm/drm_gem_atomic_helper.c
@@ -224,8 +224,8 @@ __drm_gem_duplicate_shadow_plane_state(struct drm_plane *plane,
 
 	__drm_atomic_helper_plane_duplicate_state(plane, &new_shadow_plane_state->base);
 
-	drm_format_conv_state_copy(&shadow_plane_state->fmtcnv_state,
-				   &new_shadow_plane_state->fmtcnv_state);
+	drm_format_conv_state_copy(&new_shadow_plane_state->fmtcnv_state,
+				   &shadow_plane_state->fmtcnv_state);
 }
 EXPORT_SYMBOL(__drm_gem_duplicate_shadow_plane_state);
 
-- 
2.44.0



