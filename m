Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213725;
	b=IDwHtZqQ9DsIIKLeesRs5mr7QBnMdZWjDuUKCARGC+PhFxcMzKwpkRyEjtXxWFFGfioW
	 yuUf3LXwcOI5I5VpxU1rKMExMaGKjddX+kOcwjAwHd27buHrCBFszVfYrElJNQoTGNmhu
	 Tv4FnL6/MUBy6ZHT6n2BDqNN46Zhp/A45sxqQnbUryiBWB+tN9faw5+MlHTuJJph5zgY3
	 6RD5tFpDo8ADEvPSM99vZwF/KEJlj6Euf0iFQC6kgPmvQUvaea1m3jTcQXlCWuIcQoeyA
	 xtxxBxi7KvFxCKopvh0acfP3btwA737lPXxMNDJRtfwrOvgzxJluj8MYnpZnxfqoePA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213725;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3ru1fE1vG+pNSDkrdjnZuO5p1eguVjZktsxem9z98FA=;
	b=AQSbaDzsE9VF6ypPWSIlDBnfn9u2kfhBbaEuzIoKxAuyuNKI8S9NXeJoWs2ywy1bzF0Z
	 vLx4WR9BznuD1qgq1p4g4niT74JYmMwlT+YUaCgQcXOZnKQaLEbp0afHfGgy126K/r4nn
	 bMw1JR2hH9Sm3SqAPcY0zsehS4jfvdxiKm1XQOez3P6cjubDuIK2+chzeE8RAoBdYH2GV
	 zrWUOW0I3mwjWJCxuPkVHLWGJk/P47pshPNTQFx6dBdgLy/fInXxL1f6iWtO1nD4PXhDl
	 i5jJrWS9Go5HqY38reEFbKgDMXYGZfayUGrgEQwrHdQqzfF9ahz0270mZEN4dowb8Kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wHlL1EbW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737B7606A324;
	Wed, 28 Oct 2026 18:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wHlL1EbW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856681F01825;
	Wed, 28 Oct 2026 18:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213725;
	bh=3ru1fE1vG+pNSDkrdjnZuO5p1eguVjZktsxem9z98FA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wHlL1EbW1MyxJsBEYaCxLLOTCaYLLkSQD60N5B0kP/kdmmQRo5Lrn5dn4ZvmGXGds
	 4vdVvU29Mk1BOjH4GRc0+rmVovRiyaDAPbCOwC5Ca2Ds2nfPcrwT0AjwmuLIqomnmV
	 Qvi+rfyodQ3eozfUQ7X9AsDCaUAaJEiYzmMkyRdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Charlene Liu <charlene.liu@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Chris Park <chris.park@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0606/1887] drm/amd/display: Prevent crash when disable stream
Date: Wed, 28 Oct 2026 17:45:02 +0100
Message-ID: <20261028170513.206825281@linuxfoundation.org>
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

From: Chris Park <chris.park@amd.com>

[ Upstream commit 72d72e8fddbcd6c98e1b02d32cf6f2b04e10bd1c ]

[Why]
Disabling stream encoder invokes a function that no longer exists.

[How]
Check if the function declaration is NULL in disable stream encoder.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Chris Park <chris.park@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/link/link_hwss_hpo_dp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/link/link_hwss_hpo_dp.c b/drivers/gpu/drm/amd/display/dc/link/link_hwss_hpo_dp.c
index fd9809b17882a..7dbe7909f163f 100644
--- a/drivers/gpu/drm/amd/display/dc/link/link_hwss_hpo_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/link/link_hwss_hpo_dp.c
@@ -137,7 +137,8 @@ static void reset_hpo_dp_stream_encoder(struct pipe_ctx *pipe_ctx)
 	dto_params.timing = &pipe_ctx->stream->timing;
 
 	stream_enc->funcs->disable(stream_enc);
-	dccg->funcs->set_dtbclk_dto(dccg, &dto_params);
+	if (dccg && dccg->funcs->set_dtbclk_dto)
+		dccg->funcs->set_dtbclk_dto(dccg, &dto_params);
 	dccg->funcs->disable_symclk32_se(dccg, stream_enc->inst);
 	dccg->funcs->set_dpstreamclk(dccg, REFCLK, tg->inst, stream_enc->inst);
 }
-- 
2.53.0



