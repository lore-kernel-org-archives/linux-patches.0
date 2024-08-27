Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99CE1E520;
	Tue, 27 Aug 2024 14:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770452; cv=none; b=X7JygAnURQ2DPKMAoICpSVqs7wO+7igAkxSOm5P91STwF7DaqGi5Q6CeCob6S8hB3kFyPKFO/t17tAA5PYGozkaKYS+eZmbN8QNWe0HCsa4VTqFykV7347J7AnvtXkWWPx9blUgFvmem1eg7Z+cKdsBwBwjnOXnmHHlmIKVR+vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770452; c=relaxed/simple;
	bh=FpzQZJ6YENy+ZhQelam/KP7jMuOdJz4+/EjBeI5AYUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SPDCd8gUv2pAXMMz3Fvchj7YXsvVTr7wA0dF7mqMCrEEvygpPoTunJJwg4Fa3xbtOSon285c1bp92+BB1IBJwD9LgK2JCbGxRo6c5qmj73IgR6UsTay+pYA4gWeHspQbitHRn7gvoBrwzQPPKq/kOnLPjr06NUpIjx8szflDC6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xXCb93AS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xXCb93AS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10211C4E673;
	Tue, 27 Aug 2024 14:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770452;
	bh=FpzQZJ6YENy+ZhQelam/KP7jMuOdJz4+/EjBeI5AYUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xXCb93ASEFLgNNbnvK5x+5bU635yt8ARXMr1Ar8H3leEenrAWyB4Cj4JPeLHg1Ws/
	 vJHz205rqKrnCa6lY2ml8xlqCDkx5FSjAM+PKht27pHuqXAzSI2Y5hxTZV2AJcpIoN
	 O3pO6IncspKCZU93Nw8lctXl+di5xIPXJGR5QV5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 234/341] drm/amd/display: Adjust cursor position
Date: Tue, 27 Aug 2024 16:37:45 +0200
Message-ID: <20240827143852.313927148@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>

[ Upstream commit 56fb276d0244d430496f249335a44ae114dd5f54 ]

[why & how]
When the commit 9d84c7ef8a87 ("drm/amd/display: Correct cursor position
on horizontal mirror") was introduced, it used the wrong calculation for
the position copy for X. This commit uses the correct calculation for that
based on the original patch.

Fixes: 9d84c7ef8a87 ("drm/amd/display: Correct cursor position on horizontal mirror")
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 8f9b23abbae5ffcd64856facd26a86b67195bc2f)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
index e3f4d497d32d5..c9f13c3768431 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
@@ -3614,7 +3614,7 @@ void dcn10_set_cursor_position(struct pipe_ctx *pipe_ctx)
 						(int)hubp->curs_attr.width || pos_cpy.x
 						<= (int)hubp->curs_attr.width +
 						pipe_ctx->plane_state->src_rect.x) {
-						pos_cpy.x = 2 * viewport_width - temp_x;
+						pos_cpy.x = temp_x + viewport_width;
 					}
 				}
 			} else {
-- 
2.43.0



