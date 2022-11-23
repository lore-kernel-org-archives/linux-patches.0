Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57811C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:40:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35253C433C1;
	Wed, 23 Nov 2022 09:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196434;
	bh=HTtkplH0Al1Xn/NgtjXg4+3UjrdAKVV8cT4XsQznA4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sH7MIGsR6LepnZxSVIZYk6gfhovryXFASZ8agR1u8S602KGADXeC1OevBE9fGA/Nn
	 Q9n5PTBiRd+K6/O/5BWNV4w+msXYeqzTnkljI+xp/d0m9g4sLS184nqhZh5s0VJGXC
	 xGTMYV65LGlC8EYQtMZQThdVn70tRxq229Hpka0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Qingqing Zhuo <qingqing.zhuo@amd.com>,
	Alvin Lee <Alvin.Lee2@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 029/314] drm/amd/display: Dont return false if no stream
Date: Wed, 23 Nov 2022 09:47:54 +0100
Message-Id: <20221123084626.839143173@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alvin Lee <Alvin.Lee2@amd.com>

[ Upstream commit abe4d9f03fae76c9650b0d942faf6990b35c377b ]

pipe_ctx[i] exists even if the pipe is not
in use. If the pipe is not in use it will
always have a null stream, so don't return
false in this case.

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Alvin Lee <Alvin.Lee2@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource_helpers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource_helpers.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource_helpers.c
index 1f195c5b3377..13cd1f2e50ca 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource_helpers.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource_helpers.c
@@ -187,7 +187,7 @@ bool dcn32_all_pipes_have_stream_and_plane(struct dc *dc,
 		struct pipe_ctx *pipe = &context->res_ctx.pipe_ctx[i];
 
 		if (!pipe->stream)
-			return false;
+			continue;
 
 		if (!pipe->plane_state)
 			return false;
-- 
2.35.1



