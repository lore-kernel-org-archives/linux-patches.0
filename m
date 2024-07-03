Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9AA817E8EE;
	Wed,  3 Jul 2024 10:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003983; cv=none; b=nrv/3W/4zTGRrhUBiKc1tIIvc168aj4VDBZEJ+8TD69iIEzmIZYWtlKMy1ZIuTYGNLcgfvyZTkkdBBwZILzk3oEqrCdi4g9O7ssoURjW8mKbpPwTpvdYUe38/1+W3o0l8x0zZhJOutjMAXsZ56G590gpic4cn0btA19/VDdXmE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003983; c=relaxed/simple;
	bh=RpMRYQeD+wuWqA+mguKW9lvbqxBsGkTYXghCUl2QXuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WxMpVT6CO82i42ax3pVHRCJAGYvwSOKWAypJSleXt/Io2sBySyrTV2jeMdMiE8FciAnJFZ7T6LzL5Z8wLC9x3ARTo/Q7usGQjn9l0/I04Sy4evdKnJQTPR8My8g7dj9o+jqWyomC+ZoGBBVTE2dF0TRBPdD9z3s7XxJsTKOlgog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RcxaKzdT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RcxaKzdT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D01AC4AF0B;
	Wed,  3 Jul 2024 10:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003983;
	bh=RpMRYQeD+wuWqA+mguKW9lvbqxBsGkTYXghCUl2QXuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RcxaKzdTxuCw5rWGFjDaZjlX69uMLtATID40Rwc9OmpY6t+UByvwTYdcL0nYnzr9I
	 6zjpFgfOLf2m+a7hY8Zt6kRRpl3kpG5AuWF3QEKAuJUVUrfr0dsr6gSNUGHAS6u/t/
	 4CoM+IO4gfoJGgTn5LPZzG/2GeVBjZCe19kvShC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amjad Ouled-Ameur <amjad.ouled-ameur@arm.com>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 058/189] drm/komeda: check for error-valued pointer
Date: Wed,  3 Jul 2024 12:38:39 +0200
Message-ID: <20240703102843.700113377@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Amjad Ouled-Ameur <amjad.ouled-ameur@arm.com>

[ Upstream commit b880018edd3a577e50366338194dee9b899947e0 ]

komeda_pipeline_get_state() may return an error-valued pointer, thus
check the pointer for negative or null value before dereferencing.

Fixes: 502932a03fce ("drm/komeda: Add the initial scaler support for CORE")
Signed-off-by: Amjad Ouled-Ameur <amjad.ouled-ameur@arm.com>
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240610102056.40406-1-amjad.ouled-ameur@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/arm/display/komeda/komeda_pipeline_state.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/arm/display/komeda/komeda_pipeline_state.c b/drivers/gpu/drm/arm/display/komeda/komeda_pipeline_state.c
index 31527fb66b5c5..c6c4847c6904c 100644
--- a/drivers/gpu/drm/arm/display/komeda/komeda_pipeline_state.c
+++ b/drivers/gpu/drm/arm/display/komeda/komeda_pipeline_state.c
@@ -259,7 +259,7 @@ komeda_component_get_avail_scaler(struct komeda_component *c,
 	u32 avail_scalers;
 
 	pipe_st = komeda_pipeline_get_state(c->pipeline, state);
-	if (!pipe_st)
+	if (IS_ERR_OR_NULL(pipe_st))
 		return NULL;
 
 	avail_scalers = (pipe_st->active_comps & KOMEDA_PIPELINE_SCALERS) ^
-- 
2.43.0



