Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC96339BE;
	Fri, 24 Nov 2023 19:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g308pRgE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE8E2C433C7;
	Fri, 24 Nov 2023 19:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853853;
	bh=uK9KlzHatce1xYM+GtbObCxQlcGI1kSsrfraVMm/Dso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g308pRgEE0wrIvTvlTt1BRcHJKnSPiK7jRNRzpJUZWf2yC/zRWSCzXswTJ++1CNgp
	 g9usTJq+DI0lWORadsB+GucfHOtBPhARUPDLqih3up/+8VXeq5CFYlQFtRy7LxTl65
	 rYQUinGj7yPM5QBVz29ATn2UPXomY2G8ouFgb/k4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jun Lei <jun.lei@amd.com>,
	Hersen Wu <hersenxs.wu@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 039/159] drm/amd/display: Avoid NULL dereference of timing generator
Date: Fri, 24 Nov 2023 17:54:16 +0000
Message-ID: <20231124171943.546159359@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171941.909624388@linuxfoundation.org>
References: <20231124171941.909624388@linuxfoundation.org>
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

From: Wayne Lin <wayne.lin@amd.com>

[ Upstream commit b1904ed480cee3f9f4036ea0e36d139cb5fee2d6 ]

[Why & How]
Check whether assigned timing generator is NULL or not before
accessing its funcs to prevent NULL dereference.

Reviewed-by: Jun Lei <jun.lei@amd.com>
Acked-by: Hersen Wu <hersenxs.wu@amd.com>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_stream.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_stream.c b/drivers/gpu/drm/amd/display/dc/core/dc_stream.c
index bb09243758fe3..71b10b45a9b9e 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_stream.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_stream.c
@@ -492,7 +492,7 @@ uint32_t dc_stream_get_vblank_counter(const struct dc_stream_state *stream)
 	for (i = 0; i < MAX_PIPES; i++) {
 		struct timing_generator *tg = res_ctx->pipe_ctx[i].stream_res.tg;
 
-		if (res_ctx->pipe_ctx[i].stream != stream)
+		if (res_ctx->pipe_ctx[i].stream != stream || !tg)
 			continue;
 
 		return tg->funcs->get_frame_count(tg);
@@ -551,7 +551,7 @@ bool dc_stream_get_scanoutpos(const struct dc_stream_state *stream,
 	for (i = 0; i < MAX_PIPES; i++) {
 		struct timing_generator *tg = res_ctx->pipe_ctx[i].stream_res.tg;
 
-		if (res_ctx->pipe_ctx[i].stream != stream)
+		if (res_ctx->pipe_ctx[i].stream != stream || !tg)
 			continue;
 
 		tg->funcs->get_scanoutpos(tg,
-- 
2.42.0



