Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2547B2505C7;
	Tue, 20 May 2025 14:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750668; cv=none; b=NZRiVk+mbuxZ9rC7EwXecMmCpqo4Y8gIcK2jG3GiRWRujZyYJ1Obsqiy5tmKSCTDF7cC12QQeSHBKRj11YldcQXs5Qjgye+NUel683ZtjQcUurxy+AbSMlhjrf6KBv+/OSo04Lv1JSXGIsVDFFfqr6ZVMQ36RjB3GxDkMRPSH/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750668; c=relaxed/simple;
	bh=nopCmcI5rkvshDhJhrUZ0sUE5u9wXzVuSuisP3BuB18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i+j2xYOP8ZsZLF3OXml1vw1svsGZhl1bxv4wE1mn6pFfgtcpAgVRfWxatUUwfLAjWW0FuWlUAqlhzcZjIYDnHPi1EXBUDPmRJbVVuGCe9AljwYeZ+00hfHHXmmERxozB9PFEIVloh1f0uqPMji2B4i6axPcsZJsUc+iXMZ8Ye3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kSLN9n+Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kSLN9n+Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE04EC4CEE9;
	Tue, 20 May 2025 14:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750667;
	bh=nopCmcI5rkvshDhJhrUZ0sUE5u9wXzVuSuisP3BuB18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kSLN9n+ZYoSHBndOlDNfEf1t5bvMzrT+HjC4l0xx3eYSi7JCDxCBIKZwHpayUby6A
	 11KOJXpe6aV8TT7m1QF9zKzlgkWvI1OuxVtk7qKbIplcjJhSe81U9RRcy+as0yQHaW
	 zgDK6eY9myPiOwf3kRhT0tAwQOWpPRaQbR/3mKoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 042/145] drm/amd/display: Fix null check of pipe_ctx->plane_state for update_dchubp_dpp
Date: Tue, 20 May 2025 15:50:12 +0200
Message-ID: <20250520125812.220510787@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Melissa Wen <mwen@igalia.com>

[ Upstream commit a3b7e65b6be59e686e163fa1ceb0922f996897c2 ]

Similar to commit 6a057072ddd1 ("drm/amd/display: Fix null check for
pipe_ctx->plane_state in dcn20_program_pipe") that addresses a null
pointer dereference on dcn20_update_dchubp_dpp. This is the same
function hooked for update_dchubp_dpp in dcn401, with the same issue.
Fix possible null pointer deference on dcn401_program_pipe too.

Fixes: 63ab80d9ac0a ("drm/amd/display: DML2.1 Post-Si Cleanup")
Signed-off-by: Melissa Wen <mwen@igalia.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit d8d47f739752227957d8efc0cb894761bfe1d879)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
index 89af3e4afbc25..0d39d193dacfa 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
@@ -2027,9 +2027,9 @@ static void dcn401_program_pipe(
 				dc->res_pool->hubbub, pipe_ctx->plane_res.hubp->inst, pipe_ctx->hubp_regs.det_size);
 	}
 
-	if (pipe_ctx->update_flags.raw ||
-		(pipe_ctx->plane_state && pipe_ctx->plane_state->update_flags.raw) ||
-		pipe_ctx->stream->update_flags.raw)
+	if (pipe_ctx->plane_state && (pipe_ctx->update_flags.raw ||
+	    pipe_ctx->plane_state->update_flags.raw ||
+	    pipe_ctx->stream->update_flags.raw))
 		dc->hwss.update_dchubp_dpp(dc, pipe_ctx, context);
 
 	if (pipe_ctx->plane_state && (pipe_ctx->update_flags.bits.enable ||
-- 
2.39.5



