Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214051;
	b=R/wRB0w2pAybSqMpNblcKVXX83EeXFt+MJwCApbUMc/b0zitstpfqhb4lc9MThGB/w1D
	 1OxlVC16RqOrSzV0rZeOLcTxGxN7GXyO32+EQSUFDsc8EMnIq+ryhnOctYEL7BfaVq+Ol
	 Mx13E0fX3x5art1f/e3uIfnPuef9N1ek6mYW9mnAkfkj5Nm4kYDpyBPPFc2mwJn5aOpUi
	 2faV6A2GUGAEJRIBjMp0kZnDG+GsiwQ5d1zjJv0risd1pOJ7MaACQ6rYQOJHAFJaqibF/
	 AqG8ZsldCZHrVaGpP9odz/D20ACToOyoohBi4wrUd6/A0l8SGK43wkbM64cV8l2WQ6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214051;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VG+rCJAUjIR3wk+7hR2bo7pqk71FxeLRpPrLig3l9o8=;
	b=JIlLn19WpBAcgYtPOlv9fcLcAlejHNgDs4UmGEHZ9f89wsOEbsfhTkEBltyv++DpM4PZ
	 F/E05enHM1v5JtUh8UTFP+D+eP1QWjo5fQ8jdsIJT8fsunRGBTlUPIGCPJMIwLUhiIRzh
	 ZXZvc+l+sa9LrvtiHk2uWyjSEJhlIkMvv8BuvBMtPWBmWoQvTrpzmYdp9FQDMVAWlLUyC
	 5jBkbOZHCPzIz5e6c91X+Nt28PVaffhUytsZgD8dzdLTCX5LaFDN+sNzhdtqZdEpTKheI
	 T0qv/ikI6w5z/FSBbuRUu5kfNkwA9tX5ccS2iicVt9Ou+eQwuC8Oe47/HOa1XbhyAPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t96NNmPo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E74606A325;
	Wed, 28 Oct 2026 19:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t96NNmPo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F4EF1F01825;
	Wed, 28 Oct 2026 19:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214051;
	bh=VG+rCJAUjIR3wk+7hR2bo7pqk71FxeLRpPrLig3l9o8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t96NNmPolvkwKoWDH6nTZ4bOY6XpMJvx7ZpQbG4391hjbbG+CFrU9CnpVVODUgjE0
	 sT+BMwHgbRB5PCUgZrx5KkvYtKVfX+VqzOk4p+dqeUb7ZOBfRKjkoQy8WR3K2s4VVb
	 myP7UIoOFF6eWf+YxbUej3ZQjcpkNtsrOlrPr86c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Chung <chiahsuan.chung@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Roman Li <roman.li@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0668/1887] drm/amd/display: Add null check for head_pipe in dcn32_acquire_idle_pipe_for_head_pipe_in_layer
Date: Wed, 28 Oct 2026 17:46:04 +0100
Message-ID: <20261028170514.614890067@linuxfoundation.org>
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

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit ac2140449184a26eac99585b7f69814bd3ba8f2d ]

This commit addresses a potential null pointer dereference issue in the
`dcn32_acquire_idle_pipe_for_head_pipe_in_layer` function. The issue
could occur when `head_pipe` is null.

The fix adds a check to ensure `head_pipe` is not null before asserting
it. If `head_pipe` is null, the function returns NULL to prevent a
potential null pointer dereference.

Reported by smatch:
drivers/gpu/drm/amd/amdgpu/../display/dc/resource/dcn32/dcn32_resource.c:2690 dcn32_acquire_idle_pipe_for_head_pipe_in_layer() error: we previously assumed 'head_pipe' could be null (see line 2681)

Cc: Tom Chung <chiahsuan.chung@amd.com>
Cc: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Cc: Roman Li <roman.li@amd.com>
Cc: Alex Hung <alex.hung@amd.com>
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
index 1b1534ffee9f1..591c3166a4687 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
@@ -2563,8 +2563,10 @@ struct pipe_ctx *dcn32_acquire_idle_pipe_for_head_pipe_in_layer(
 	struct resource_context *old_ctx = &stream->ctx->dc->current_state->res_ctx;
 	int head_index;
 
-	if (!head_pipe)
+	if (!head_pipe) {
 		ASSERT(0);
+		return NULL;
+	}
 
 	/*
 	 * Modified from dcn20_acquire_idle_pipe_for_layer
-- 
2.53.0



