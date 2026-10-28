Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217231;
	b=W57rjVRUCHLPDbhgzQ+CfvVxdAbn7GK3jIHbF50HYUJyIO5bIxHcuAwfLjsNJzjhVOnf
	 2zUMVd6eqPajgj1UaYVY4Bz0mP2UeQ79dakxYMN4Gi6f2tPkgmqijdiycUqup548wWVLG
	 HMoljT8avLnqvlsjL62bT7F+etgu3AOU1tT0whXv+FaA9xegnpaBrGUAo/glwd6kaHfjA
	 FEgcX0aGVDU/hlwCGRAdH9WqVy2XwoF4eF3ptVgZBwTKd+L19yccuMcdemjjvZ+FRBnBI
	 QzHeOFELrZNCljux5oK5W662U84X4qhFkpSeM6z/xTtSkVksp7dcoKkMpQGGjYMZn8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217231;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fcXTT4gQmK2C6G0ZTBVOx/wUjyJvSkaSfi4fqw8p2hg=;
	b=ofVIOKjDkJuc/cbMcZuw80Qhe/HmhyB5URxWcMinyBu4sysK66on5GeBe3b5mGXtgnI2
	 ZIyiZ3CIdEQr8tXqCdaECK5Qbmi9yJcIkiB1IyCWilfgfEwq5M4HON+A/I20f/pGzT5fN
	 MJ0wA8hWItMNiVTB9q3aRhHG74pVXQ7GhUuYy332Ce5h6hXybQV7lU+H4ozwYWWOVYIKP
	 tMe4zh0cTufV+eXenrrjM1rwelNw3l55GGus7vaFkbgCeQGB294zovokXPrbKqfZwTBNb
	 gfQSAvdQawtfP0V8RexALiF2WaeqIsauvrmoV0USwlp2ZZ8gZp+KPHnCu3WBBeds+CQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MI+7VGOO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13163606A31A;
	Wed, 28 Oct 2026 19:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MI+7VGOO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B5461F01825;
	Wed, 28 Oct 2026 19:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217230;
	bh=fcXTT4gQmK2C6G0ZTBVOx/wUjyJvSkaSfi4fqw8p2hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MI+7VGOOAbZZuUsi9M8JNJgKZqMcxDvFqMvZGMk2pdylod0QBcdHNWkBLsZwl7I9t
	 imgnIk85etM6PnwOy+wk0iPPnfKmnPYPnWFYiLs2qMu+7qtECoS4/tciBh6DZqEp7+
	 fDNmBGSTdY2lIWl9GelL+1qGUqzVq0sM9JzSuS5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Chung <chiahsuan.chung@amd.com>,
	Zicheng Qu <quzicheng@huawei.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1830/1887] drm/amd/display: Fix null check for pipe_ctx->plane_state in dcn20_program_pipe
Date: Wed, 28 Oct 2026 18:05:26 +0100
Message-ID: <20261028170541.090158264@linuxfoundation.org>
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

From: Zicheng Qu <quzicheng@huawei.com>

[ Upstream commit 6a057072ddd127255350357dd880903e8fa23f36 ]

This commit addresses a null pointer dereference issue in
dcn20_program_pipe(). Previously, commit 8e4ed3cf1642 ("drm/amd/display:
Add null check for pipe_ctx->plane_state in dcn20_program_pipe")
partially fixed the null pointer dereference issue. However, in
dcn20_update_dchubp_dpp(), the variable pipe_ctx is passed in, and
plane_state is accessed again through pipe_ctx. Multiple if statements
directly call attributes of plane_state, leading to potential null
pointer dereference issues. This patch adds necessary null checks to
ensure stability.

Fixes: 8e4ed3cf1642 ("drm/amd/display: Add null check for pipe_ctx->plane_state in dcn20_program_pipe")
Reviewed-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Zicheng Qu <quzicheng@huawei.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
index a554867ee1a93..8a32b86c34d37 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -1693,9 +1693,9 @@ static void dcn20_program_pipe(
 		dc->res_pool->hubbub->funcs->program_det_size(
 			dc->res_pool->hubbub, pipe_ctx->plane_res.hubp->inst, pipe_ctx->det_buffer_size_kb);
 
-	if (pipe_ctx->update_flags.raw ||
-	    (pipe_ctx->plane_state && pipe_ctx->plane_state->update_flags.raw) ||
-	    pipe_ctx->stream->update_flags.raw)
+	if (pipe_ctx->plane_state && (pipe_ctx->update_flags.raw ||
+	    pipe_ctx->plane_state->update_flags.raw ||
+	    pipe_ctx->stream->update_flags.raw))
 		dcn20_update_dchubp_dpp(dc, pipe_ctx, context);
 
 	if ((pipe_ctx->plane_state && pipe_ctx->plane_state->update_flags.bits.hdr_mult) ||
-- 
2.53.0



