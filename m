Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213920;
	b=107F4SoiuIYl1QyZSI3XbyJgUPZXeYSwpYM1TIebIK4dbJwzCdRwGrmFPSR54bxIQj57
	 RYh6v5xcLs2YSOMF39M+ILubX06ufS6x5aosXUmvZMQIU/3rNFFIONwhwVtSaig0bMntr
	 x1Zu52vjN0Oj/A+2ipkv+IQqzdCFYS21ZN/F9WPOWsFM6eTDtCTuR/T5wrunf9RbyejpL
	 xyJaalGI3BDQfWbaWIihHkwUCcAS3Q/qL7fnL5XHc6qCLRatq/uEX/Gd2Co6p5tAdZYgN
	 KbScqjYXXbAZfsOxKTje65VyMneNxHFoF+VRMxuuuG6bDxy7WYiD/RcGFyXBUYDPnag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213920;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D4z6khgjBwwk83TmfoZcwQkDVHZf5F6kSyHNSR0OTnY=;
	b=u3vGLSB+tmNcPyRsECprR5MPn6xnYNR0tx3DSbJEfB7tZbVj7HoCPoC5nrTYK8LYjDT6
	 umW6XxGbSyB0Dev9aub67lA5g/eiMFAVWEOgwOyRH+TFlaRSKet7m2rMwji1s9iewphcz
	 U+9eHSMEsT5At98vJWtUUdbsdtcG9hAv8PnPxPA3AI7N+HAEZAYQH6GOvr22NLmpG0AtA
	 iUPldcXLEZdoH8IRb8Rc9kMRiLzmHOTwAQPjrh9HAPrS+WFg4uwqR5GOzh6zcFLBzsc7u
	 9+q2Bqo+nEVrvTaGV85IRvsye/gT7alL1AKqoaVSDgtZlFXRfCW6F189husTDlEvVmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eLYZAEIY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DAF4606A31A;
	Wed, 28 Oct 2026 18:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eLYZAEIY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69CB71F01825;
	Wed, 28 Oct 2026 18:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213920;
	bh=D4z6khgjBwwk83TmfoZcwQkDVHZf5F6kSyHNSR0OTnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eLYZAEIYenc5R2ooBhek8P8CbCcdIxo6O134i0B+aUPyUu4vvYgtfYmcYlMM2p0Af
	 ywIW/25Xh18n/0DVsdxqGezOcWYK/l4w2GLhSJL+8xpqF0ZBF3ZdvEFWm/YztkIcdf
	 7FfFgJMljFlhNucjosZ9Jnoubhv01yr5Kj9yJ7OU=
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
Subject: [PATCH 6.1 0669/1887] drm/amd/display: Add null check for head_pipe in dcn201_acquire_free_pipe_for_layer
Date: Wed, 28 Oct 2026 17:46:05 +0100
Message-ID: <20261028170514.637328125@linuxfoundation.org>
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

[ Upstream commit f22f4754aaa47d8c59f166ba3042182859e5dff7 ]

This commit addresses a potential null pointer dereference issue in the
`dcn201_acquire_free_pipe_for_layer` function. The issue could occur
when `head_pipe` is null.

The fix adds a check to ensure `head_pipe` is not null before asserting
it. If `head_pipe` is null, the function returns NULL to prevent a
potential null pointer dereference.

Reported by smatch:
drivers/gpu/drm/amd/amdgpu/../display/dc/resource/dcn201/dcn201_resource.c:1016 dcn201_acquire_free_pipe_for_layer() error: we previously assumed 'head_pipe' could be null (see line 1010)

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
 drivers/gpu/drm/amd/display/dc/dcn201/dcn201_resource.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn201/dcn201_resource.c b/drivers/gpu/drm/amd/display/dc/dcn201/dcn201_resource.c
index 407d995bfa99b..fee527977c375 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn201/dcn201_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn201/dcn201_resource.c
@@ -1009,8 +1009,10 @@ static struct pipe_ctx *dcn201_acquire_idle_pipe_for_layer(
 	struct pipe_ctx *head_pipe = resource_get_head_pipe_for_stream(res_ctx, stream);
 	struct pipe_ctx *idle_pipe = find_idle_secondary_pipe(res_ctx, pool, head_pipe);
 
-	if (!head_pipe)
+	if (!head_pipe) {
 		ASSERT(0);
+		return NULL;
+	}
 
 	if (!idle_pipe)
 		return NULL;
-- 
2.53.0



