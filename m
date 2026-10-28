Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213844;
	b=tL03DL4fxPteg8WbEXTbrefPH5aPpYJ93JVh6CwyUrP/T5je+BgRdte9tcOfLSOvc4v+
	 7XR0LoWT3oZeZlzCecCfEGCcnepwcUFBoxFhcZbjkGcwva82tlH9za9IB1z6XP/tBTP/T
	 mMwc+znb1ZmfrWPIvzVQ1xMSXJZXV0rYSOQYEDb4OXmaWtdE8Z9X4BbPOzz+NhAaQpJ/T
	 HvIjx4WOsqKKniYOYpGaNwmX8GYmFdjFRjqoUG7TQt76tq1dS5Kgifv4xeRJxA37XoLvG
	 TI7435VLp5zOKrSw+oA67JQudcnORVkbksiWYxl6HLNs01gPRtOT3gkJ59819IKhs+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213844;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j0X/zR+dZAXIaBiWowldF54th9lmjcJ7AfaqDgyrn70=;
	b=kaPGbatQ28Ie7wooIn60uU8afJnNmMzZLVm5SaqtU1ytK4CMPtLxdygdMjavMH+a+lyN
	 iOzLp7zDWQmiwEytFvWJ8cnEs5Lxh7KDiLi3LHMl9VlRAVloKdO7f32a0Bb+XF6vbHtQm
	 /p1cGMM0MWB14oxuBKQkwEILX+JV2LZ+JNfLmDlVYL9Jn3wO8RtsaM0C59x66ZDmqE13S
	 7HWGpgRvQCTxhNM6enpVqT7hcCBztzoRh/T6mvsAA29IJRXONfeIZMS7jm6OA7+fKr35q
	 tR0OCN62Pwku7R0aDQYS2LRvhujtvGH/w5CHpU1Eo4jO7f2jwB7hiIxx++9qy0agdog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t1ga9cxz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0FB606A32A;
	Wed, 28 Oct 2026 18:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t1ga9cxz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64BCF1F01825;
	Wed, 28 Oct 2026 18:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213843;
	bh=j0X/zR+dZAXIaBiWowldF54th9lmjcJ7AfaqDgyrn70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t1ga9cxzSRLQHnAF7LfVzmBEHtVrKZ2x+oB8oRrqOrRgLgJNtlbmuwUyXLYt0I4vV
	 GRgOszq2o3Hc4tVR/hVYnFfj8aCIYG+VJnD9q/mlfE0ocQXQgDbb+26uy6CqP9+3qt
	 xFsK2g5rSAcBJLmba2QpodrFqRul0VZWWEs84FJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0649/1887] drm/amd/display: Ensure array index tg_inst wont be -1
Date: Wed, 28 Oct 2026 17:45:45 +0100
Message-ID: <20261028170514.179261992@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 687fe329f18ab0ab0496b20ed2cb003d4879d931 ]

[WHY & HOW]
tg_inst will be a negative if timing_generator_count equals 0, which
should be checked before used.

This fixes 2 OVERRUN issues reported by Coverity.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index 876b70157faa3..5adae27fb460d 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -2115,7 +2115,7 @@ static int acquire_first_free_pipe(
 				pipe_ctx->plane_res.mpcc_inst = pool->dpps[i]->inst;
 			pipe_ctx->pipe_idx = i;
 
-			if (i >= pool->timing_generator_count) {
+			if (i >= pool->timing_generator_count && pool->timing_generator_count != 0) {
 				int tg_inst = pool->timing_generator_count - 1;
 
 				pipe_ctx->stream_res.tg = pool->timing_generators[tg_inst];
-- 
2.53.0



