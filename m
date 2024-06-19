Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D7E1E492;
	Wed, 19 Jun 2024 13:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803994; cv=none; b=ein1MEfqedCdaKifX3o6oIHitD/k24HXo6Rd8Qri+c8u9OsrZl/EduTVI/Vi1Nuw3QfiD4rDwb6l4yDPQvEZ+wkfLJldEdLkOpWo73xGAH13J5SdQGISvgvCCIv0AksOhDjg3Pa1yHDiV2NZLG8R/n91nK3Xh/3vmHq7fDGc4dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803994; c=relaxed/simple;
	bh=6Q58Xk02jtrgTRGc7Hk7D+a4tH58Na8CjpKBj/p6TZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e3u+s0yfCu3647uELXjsmy+eONmRdR+AcyABWiZOsLAtSrNGEuUF6oEd8+WS78P0O2QF1/1BdrM8W65LiAHoc5WOzz7DFbbkRHerzDZDBONHMMM4VesSJzAL69Pdwvr3FK3CCVbFYfHabM+kaAADkGzVZ+H8yCLVUyyIHiaUZcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kBleytj2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kBleytj2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F64AC2BBFC;
	Wed, 19 Jun 2024 13:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803994;
	bh=6Q58Xk02jtrgTRGc7Hk7D+a4tH58Na8CjpKBj/p6TZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kBleytj2mNRo5cMVtxC9cBpRC1p8jg785vBnAIiTU220K6ibWNdbdGcxoNgzmhBbk
	 L8oxl47mdP3NQ28n9gGQL1bPs1EVaVI+jGXj1+XLiScw4A5AxkxiWQJF3opKQS+5Qp
	 G4sysKWjZYI+JNApiji7uzYiAXk/7Sb64t4uMJb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amjad Ouled-Ameur <amjad.ouled-ameur@arm.com>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 142/217] drm/komeda: check for error-valued pointer
Date: Wed, 19 Jun 2024 14:56:25 +0200
Message-ID: <20240619125602.170843707@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 916f2c36bf2f7..e200decd00c6d 100644
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



