Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213898;
	b=Werp4TPcQG/c6i1e9OzVtjwti2Ha4WKwz9NC1pbo/VOEcU+ZhuFfMEsQe01k68H2CPAI
	 BAhmVK2LrVRqo4J0wx1ATkJ7xOVX02pPQS7b5NoVFYqe+QdO+06B0w1XxG/boz1o90WkA
	 +sQAjQW/CmgAXvzlhO4WIiEclL8EHEepURKbv+JW+6anKExD44RP9wANmeV/Pjyq/a/s0
	 G9zaJz1e46SwrUFCDUcU1dLPjEz5L/9HV9jPa3J6md/SHbB79C+0XGr9cqdDD4n95R0P4
	 ikDqe79sfAFi0J6XotCF2QNxdg+rrHuXuOrDL4rQ7w63sp2Lo941xlkwv8e/OKBu+7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213898;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VHoPE7w6b+ANKi3YrBpfC9QsGEiHzxuyfB6NejOxRMs=;
	b=Yp4UWQfQhjR251DzpSQI2sanLwlAlCd69WVoBr9GoCsRrwwZ3kYkyldVWyjCL2oDAOhz
	 cD1rqDcnFxk9C5UNsjBvyhG8ikUgH3Jdm8kWZTm/sBnPaTBY2QRNqvp/1E0SEhvsJiv9c
	 6dzgso2nUpkLsNk6Jh5OxYKiBfokrjd2GB8atq3A9BD+Gh+CKH9Df9SCW6rkmPG3XA4BK
	 ANh1jucOUE9cT5yGltCRsDLUccwRD0u03EsvjPVb0cAjDRP1yc/Bce0/filEBUxnJuIR/
	 7oW18X71d3Ct1qzP9NedrOSVTmJ/NGOfWPIlg1cQOlGR2IOfTzZZjLW38KNeUuIivaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VRRUcN3m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD383606A31A;
	Wed, 28 Oct 2026 18:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VRRUcN3m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31FB41F01825;
	Wed, 28 Oct 2026 18:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213897;
	bh=VHoPE7w6b+ANKi3YrBpfC9QsGEiHzxuyfB6NejOxRMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VRRUcN3mOoKxwirTZDFK9QVVM32eUaovtYPsUYa+pXMTLeMn98LndAqmGmKe7Vzhn
	 IozvlZ6pxx5QZIiOqFBXZZw1Yzh3wzePrK0ymQOiACWwbrxkX+UxU35Ch0E1pfIm/W
	 VA0OwmszC4NENOkv05DgogC1XPcptaHlKWGq629o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0666/1887] drm/amd/display: Check null pointer before try to access it
Date: Wed, 28 Oct 2026 17:46:02 +0100
Message-ID: <20261028170514.568509946@linuxfoundation.org>
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

From: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>

[ Upstream commit 1b686053c06ffb9f4524b288110cf2a831ff7a25 ]

[why & how]
Change the order of the pipe_ctx->plane_state check to ensure that
plane_state is not null before accessing it.

Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
index d252d10c81347..d1f49232efa87 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -1696,13 +1696,13 @@ static void dcn20_program_pipe(
 	if (pipe_ctx->update_flags.raw || pipe_ctx->plane_state->update_flags.raw || pipe_ctx->stream->update_flags.raw)
 		dcn20_update_dchubp_dpp(dc, pipe_ctx, context);
 
-	if (pipe_ctx->update_flags.bits.enable
-			|| pipe_ctx->plane_state->update_flags.bits.hdr_mult)
+	if ((pipe_ctx->plane_state && pipe_ctx->plane_state->update_flags.bits.hdr_mult) ||
+	    pipe_ctx->update_flags.bits.enable)
 		hws->funcs.set_hdr_multiplier(pipe_ctx);
 
-	if (pipe_ctx->update_flags.bits.enable ||
-			pipe_ctx->plane_state->update_flags.bits.in_transfer_func_change ||
-			pipe_ctx->plane_state->update_flags.bits.gamma_change)
+	if ((pipe_ctx->plane_state && pipe_ctx->plane_state->update_flags.bits.in_transfer_func_change) ||
+	    (pipe_ctx->plane_state && pipe_ctx->plane_state->update_flags.bits.gamma_change) ||
+	    pipe_ctx->update_flags.bits.enable)
 		hws->funcs.set_input_transfer_func(dc, pipe_ctx, pipe_ctx->plane_state);
 
 	/* dcn10_translate_regamma_to_hw_format takes 750us to finish
-- 
2.53.0



