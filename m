Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058387;
	b=tGsDUV1u1KYFwCNhSMTF3z0c/jdJuIapbkIM1/lJMCyMzIeyHhFHHeFiO0VyobiIGcWe
	 q/tqgIS0lr910CBc1pzVocKjo3GPpbHRYPY/vjO6QYI5ZX4rA4qFuV04E65UaAN1g0bVa
	 IjH6Vw6C6z75vAW89FK4FQtPJgnK7vEet6GvkceZug82j9LFGJefqNF5S5o/AT4331tWA
	 84XroezBs1fL+KbFww9vHxZVmcCUcXqLk7qKHFnW3NuiZDDM0OYWw0E6a2Z7X3cnRq2M3
	 b8bIJoFgV4UpUQJwvQd9f2pxBFjXH9vGHIzB+6aAPi9SLFBRbbfl39b6ptfyGVHa9Ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058387;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B/8mux7FN9SbvNaFaKThkOPOBqriAvbTAGutMyNgQZM=;
	b=oAwTlV/n1l46zneIRgOTcx9SqTsoncj2MTiX9vlpbd3N6iuk3qA2bPjDlxR4fCUL3/tU
	 N9QN6pMvZVON/AWPkns4Jdm0NlGvnk9VDd7rjPX/ZcQthYo0BhjJunrZPWdJQAIvkDt0t
	 81YpncWZ/OZPsTC9yD5MYcKQxz4u944trRo9spP8O4UzUP+MyD0UdPeP139AS0lnJYqcJ
	 Fni4XgePQCmldGBIh2sA/85E+6YCVXOCMu5RLaYM4VxiUObop3wFx2YhrZoDNheN9ONPG
	 UN9lsvr4azRriN8LRlXcioXaVfKmsbFTdO7Pu+JcwhqWlKb7KiOrPToCACR1LJm9W9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fDqLznCM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D17606A32A;
	Thu, 19 Nov 2026 03:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fDqLznCM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B77B31F000C5;
	Thu, 19 Nov 2026 03:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058387;
	bh=B/8mux7FN9SbvNaFaKThkOPOBqriAvbTAGutMyNgQZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fDqLznCMx1nsqtlGy5mCO7rHmLO43Wr1x1B5N4SBn+mtmEdTv+uiL5RHcPidHYoyu
	 /Ww9G9+fBRufQhpI+rJAiDUa5PO+iNP3bUVWdwAvUVX+tldK/qyb6CnaARz1aMRypP
	 uEVJr+qTjyg5c51exnzpOOuLe1El2n4XtCLOZrPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0467/1848] media: vicodec: fix NULL deref on oversized frame
Date: Wed, 18 Nov 2026 15:41:45 +0100
Message-ID: <20261118145933.918368093@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junrui Luo <moonafterrain@outlook.com>

[ Upstream commit c657eb609197e289b054bc2c4e86a0fc32dd7ebe ]

job_ready() only honours the is_header_valid() verdict when
ctx->comp_has_frame is set, and comp_has_frame is only set once
comp_size reaches the full frame size. Since the copy is clamped to
ctx->comp_max_size, a header advertising a larger size leaves comp_size
stuck at comp_max_size, so comp_has_frame stays false and the failed
validation is discarded.

Control then falls into the resolution change branch, which calls
update_capture_data_from_header(). That function re-derives info via
info_from_header(), assigns it to q_dst->info and dereferences it as
q_dst->info->sizeimage_mult, with no NULL check of its own.
is_header_valid() does check that same info_from_header() result --
if (!info) return false which is precisely the false verdict
job_ready() discarded above. info_from_header() returns NULL whenever the
header flags resolve to no supported pixel format.

Drop the comp_has_frame conjunct so an invalid header always bails out.
The resolution change path is unaffected, as it is entered with a valid
header. Oversized frames are then rejected by device_process(), which
already returns -EINVAL when comp_frame_size exceeds comp_max_size.

Fixes: 3b15f68e19c2 ("media: vicodec: Add support for resolution change event.")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/test-drivers/vicodec/vicodec-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/test-drivers/vicodec/vicodec-core.c b/drivers/media/test-drivers/vicodec/vicodec-core.c
index 6052a46280fe3..be732f006a6e8 100644
--- a/drivers/media/test-drivers/vicodec/vicodec-core.c
+++ b/drivers/media/test-drivers/vicodec/vicodec-core.c
@@ -654,7 +654,7 @@ static int job_ready(void *priv)
 	 * if the header is invalid the device_run will just drop the frame
 	 * with an error
 	 */
-	if (!is_header_valid(&ctx->state.header) && ctx->comp_has_frame)
+	if (!is_header_valid(&ctx->state.header))
 		return 1;
 	flags = ntohl(ctx->state.header.flags);
 	hdr_width_div = (flags & FWHT_FL_CHROMA_FULL_WIDTH) ? 1 : 2;
-- 
2.53.0



