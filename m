Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE1CD3A7189;
	Sat, 17 Oct 2026 17:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257805; cv=none; b=RmhA7jtdSXmNUVcXJsWwShb6VZFbHcbWLPX6TvOOk2eNTBC/RNddlm7ReyLiB8Dz7y61Akg29Av0j05aW8/8P6edTHh+ExXPu8JyaVCDke3KSOrgvw6YhPy5P4bHRFdcgCR2py+3Q+rw4Quxo0KKFVnijTXoy5J4ahNuPIXUvhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257805; c=relaxed/simple;
	bh=w8K76eDd/MxOMEkOQbnoTv95Hf+TVJYDfGYdD824qMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IYJYlcGR4W7alSdL6P7In/+ygvqjr5NPqVdvYFYyOYXIu5VYNLejeMN2w78uicTVdRLfCCsNrHbG3vKBMhVNyEJmnQWmCyEvoaonPZq4C4n1SdwEkPD41gblHAHw2ka2VKDaLzuHWlNYIDk5WfSQn1YalGb+7okHIlk1zSyf8PI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cmP/cHsy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cmP/cHsy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1666E1F000C4;
	Sat, 17 Oct 2026 17:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257804;
	bh=xbxCmgrnKuJzuTW7GPIXgTcXfUW3Ms1qEKRXZkstS5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cmP/cHsy79xIxXFJ93w5uWiOPESSJLiI6t0yc1YA/Y1qGlXRr4SjpWDWvAIjd7m7R
	 yqVCnRZkuJxwfw2I1oi+pUjKrQr4OIRAgJw/l/9yQYcKD0VrLRdtk+fvO0MUHGJtb4
	 M31B/Inht0UaNVQ3YRyxYUQVhslqPMo/Tj+VZucA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Chung <chiahsuan.chung@amd.com>,
	Zicheng Qu <quzicheng@huawei.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0659/1674] drm/amd/display: Fix null check for pipe_ctx->plane_state in dcn20_program_pipe
Date: Sat, 17 Oct 2026 17:48:51 +0200
Message-ID: <20261017160448.027293848@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3fe91d6869fe1..148609f601628 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -1732,9 +1732,9 @@ static void dcn20_program_pipe(
 		dc->res_pool->hubbub->funcs->program_det_size(
 			dc->res_pool->hubbub, pipe_ctx->plane_res.hubp->inst, pipe_ctx->det_buffer_size_kb);
 
-	if (pipe_ctx->update_flags.raw ||
-	    (pipe_ctx->plane_state && pipe_ctx->plane_state->update_flags.raw) ||
-	    pipe_ctx->stream->update_flags.raw)
+	if (pipe_ctx->plane_state && (pipe_ctx->update_flags.raw ||
+	    pipe_ctx->plane_state->update_flags.raw ||
+	    pipe_ctx->stream->update_flags.raw))
 		dcn20_update_dchubp_dpp(dc, pipe_ctx, context);
 
 	if (pipe_ctx->update_flags.bits.enable ||
-- 
2.53.0



