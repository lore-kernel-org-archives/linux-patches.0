Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE444FDA54;
	Wed, 30 Sep 2026 19:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797143; cv=none; b=TPtgw9mqtoZ0QCOPuxmia6F12up2sOXwnsz3bMhzUlD2yRkcp6Ot0sn1IV976oqGh0U2mq0MwBgad7E38Sc5pbEVXIn4P3RmrtAm3xUrHODJbSxXn+bGowKPSlki8IaB/HuFf1r67ZOPOlG293oqkBq/gNzjUGAIqifr09eadAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797143; c=relaxed/simple;
	bh=3o5jNWztwzbMHLqaDENk6QWOoKPtuN+tN20HQ+/ukwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DVv+vBtXHjGi7wuvnEsVusiBnY1L4ias0ZLFS1um3vLfMhiB7dUydexWQl/UDl6k9XBb8/Bp4lsoyUrqFFE3/0Pgx8jcWFTVp10HFrpgQlFnyoVkH3IHO5Wbx9oZNuCGxbRAgRFm/A4nV6t+Hdo9Ua9p+3vgMw2sDHNzwW1AX6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vS8T0fw9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vS8T0fw9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B00D1F00899;
	Wed, 30 Sep 2026 19:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797142;
	bh=dbSraMX2kTggqvhMpyaGbQXkhwGGx/i9/sdf/ez4qYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vS8T0fw9WsTfC3BzwvyMaJLnko53ontMSYAatQa8YJj3ZhUC4o7UInTUA0rclq/It
	 SL6wbVSsTYmwrk8r76KDj4fRYJ/IfjM0eRSJ/YBHtuxO9V+r0Q3I0ykEfIyNiwCGkm
	 h90SKQkLCoRP2HZHjkwgakzVloue1lfbNJBqjTI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1162/1193] drm/amd/display: Ensure array index tg_inst wont be -1
Date: Wed, 30 Sep 2026 17:30:46 +0200
Message-ID: <20260930152500.062468475@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 687fe329f18ab0ab0496b20ed2cb003d4879d931 ]

[WHY & HOW]
tg_inst will be a negative if timing_generator_count equals 0, which
should be checked before used.

This fixes 2 OVERRUN issues reported by Coverity.

[ Backport to 6.6.y: mapped the newer pipe index and helper to i in the
  older acquire_first_free_pipe(). ]

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index 84474d5122284..1f576b2a1960f 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -2354,7 +2354,8 @@ static int acquire_first_free_pipe(
 				pipe_ctx->plane_res.mpcc_inst = pool->dpps[i]->inst;
 			pipe_ctx->pipe_idx = i;
 
-			if (i >= pool->timing_generator_count) {
+			if (i >= pool->timing_generator_count &&
+			    pool->timing_generator_count != 0) {
 				int tg_inst = pool->timing_generator_count - 1;
 
 				pipe_ctx->stream_res.tg = pool->timing_generators[tg_inst];
-- 
2.53.0



