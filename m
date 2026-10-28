Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213900;
	b=pp9TNEjkLNiBG++sQob0vxnC7vmjYeLIYNt3vuG6d6t14NpfgLRI2+cTS68CWck9GQi9
	 Lw8vmbbp9WJVoPTkPrWE9SftIsL0htCXN/k826oZ7sA8Xpk2zaip69s/RGhHVrmU7ptri
	 Td6EZFt3pMqqQPj1kCYoLYshkd4YMNGFk71vz8gggMNuEPg9XDDzfzRzzn2Ui+ObGQkym
	 lJxdQfs099TJgYdmqWUa+hJo/o7NJBOURrROtvtSbOL9dEHn6q08JjVCmgSrkduWqgC+V
	 ij7NXuKNeDGc99bcx66MlRNIEHZ/vyLCQUlQ6w3vAZm/ot3f9fCEQullN/arddc2ZRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213900;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BB09DR7sDoN3HGiI49Y1ZDpCwM2SzN4p0U7QnpLo0dk=;
	b=cTOaVLlq4kpNugS9TXgKEExDdTSvJBE3VsiYLTfMdty68w7T1fpCOtIKsUABmJmYgNLt
	 s3j9ImJdLKpbfuBnbVzC8Tny4E+Az6ZAaLcerOGXoa5z31l6k/oiZ1FA7/AbBOb2u+4Gf
	 FWnXbM6rMjaSd3gBGWPDJ66zKWWxl5yZmtL2HB4Y0pJt84Uooj4B2e1IA99bi6abtNOxK
	 kY2Mv5tfsbOX0ASA1IstoG0/MHolikQEtHmbRBv+tR3PdyYVPiIJqgtypVAMHoCcC/jRe
	 97SNQ7LqeKXmIUninpwXYp5v669e9u+kM9ubzHkjyfrbe2p2VONDzlbmAfbsuJoPDJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=esYe8hB4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71CA9606A31D;
	Wed, 28 Oct 2026 18:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=esYe8hB4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9BC71F01825;
	Wed, 28 Oct 2026 18:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213900;
	bh=BB09DR7sDoN3HGiI49Y1ZDpCwM2SzN4p0U7QnpLo0dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=esYe8hB424NE0nVAMdSYHhWk7uv4ypHnVwqPJD6NBSioRgZZ456Yz2EGzN5ulYkMM
	 npj8OslYJ2vzzrfoN2XC9cBWHDaFkj2VjIRV0pw83dlmwkruKKpde4IdFyyF4LqP62
	 qZ8/mISV2E8u6EGdZyA0U8F4ccAl77GysUequEsc=
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
Subject: [PATCH 6.1 0667/1887] drm/amd/display: Add null check for pipe_ctx->plane_state in dcn20_program_pipe
Date: Wed, 28 Oct 2026 17:46:03 +0100
Message-ID: <20261028170514.591304328@linuxfoundation.org>
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

[ Upstream commit 8e4ed3cf1642df0c4456443d865cff61a9598aa8 ]

This commit addresses a null pointer dereference issue in the
`dcn20_program_pipe` function. The issue could occur when
`pipe_ctx->plane_state` is null.

The fix adds a check to ensure `pipe_ctx->plane_state` is not null
before accessing. This prevents a null pointer dereference.

Reported by smatch:
drivers/gpu/drm/amd/amdgpu/../display/dc/hwss/dcn20/dcn20_hwseq.c:1925 dcn20_program_pipe() error: we previously assumed 'pipe_ctx->plane_state' could be null (see line 1877)

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
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
index d1f49232efa87..d0422e1c14fab 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -1693,7 +1693,9 @@ static void dcn20_program_pipe(
 		dc->res_pool->hubbub->funcs->program_det_size(
 			dc->res_pool->hubbub, pipe_ctx->plane_res.hubp->inst, pipe_ctx->det_buffer_size_kb);
 
-	if (pipe_ctx->update_flags.raw || pipe_ctx->plane_state->update_flags.raw || pipe_ctx->stream->update_flags.raw)
+	if (pipe_ctx->update_flags.raw ||
+	    (pipe_ctx->plane_state && pipe_ctx->plane_state->update_flags.raw) ||
+	    pipe_ctx->stream->update_flags.raw)
 		dcn20_update_dchubp_dpp(dc, pipe_ctx, context);
 
 	if ((pipe_ctx->plane_state && pipe_ctx->plane_state->update_flags.bits.hdr_mult) ||
-- 
2.53.0



