Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585840;
	b=qBj7fBYKoFPayLf5E2FQ/v8e8fQrmWkOTYJMxe4ACTOBrt0gjw5ad1TCLwWP/CJLJxon
	 C4Ui+cWnVsEWHM4l+nlK3Gh525lcIRWVoaH2veOmLQzSCM7GAVDoCBifQ0o+gRdyTcixd
	 35OK93obM4mnz3hGNzf9C8NOlfguW1drPLa2SZCp1OF+Up+qHoloKu9mSC7OnRxkHxoqN
	 kkySKnq6wE/m6ZWk+Qwf8Pemrf+CmzKiMNnhQTLh2giM4gllga5MdYWo0Lm3d2nsEeD4J
	 mR8Gz7YKcWnBSWpUZfp9IUZ4T+JvouJAZwxlUsqTP/9byCB2/xr7eudb76T3/lxvoQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585840;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8+yeV/LkPaRQi9oR3OXNplJ4Jm8cVHF1PcN7oT9odUw=;
	b=C6dO0PrAiTyO4rPgY8yuCdKWL0N4tW4qWik+YWHDEDvO5rCUUX+t4VlPR303ydhGAd4A
	 PcrYMUVWeGOnqLTWR4faTR3AIGUegVdTWPLB7t1r8RysgwE0MB55IDlXVzTe3tYQoTjP6
	 c4SmAIEal2NDQu+Yb5uNLIzdMq9AexA+KZceOUQbkd5yUyJrOlkiQyogHz1ng7aqucn4U
	 Z5aYcq8BVqNYOFjQ1T4O5VGQzKzCUrv4MChGrjNukN4ztb66s6nBPAlPR/wXfgP8dYIwV
	 iTBN1jHGJvblT+U1rYVLU2k2uYWYvbfHcCbIekcDCSsL1+F1NvdMMofJoiq1+W1jQXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LlY7Q4ot;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E067606BAA7;
	Fri, 13 Nov 2026 16:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LlY7Q4ot
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB9021F000C5;
	Fri, 13 Nov 2026 16:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585840;
	bh=8+yeV/LkPaRQi9oR3OXNplJ4Jm8cVHF1PcN7oT9odUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LlY7Q4ot8bCjWuuFT/r5dv0/qnkR0PsiLRn2UfW6opNS8oQDo+vx1T6dSdm/v9cX7
	 Rn4sPNdhf8z3MKHyRMT3qm1DuL+r+Xmjju1izqA5gn1PJDpQStnoTEwPuLh7VXsIqH
	 qfyBH1wmWKDavPBzMuMGMOrtKJ4MxfCB0KDYTWjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Misha Nasledov <misha@nasledov.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 366/507] drm/amd/display: Drop clock requirements on DCN32 when no displays are active
Date: Fri, 13 Nov 2026 10:51:10 -0500
Message-ID: <20261113153808.417848558@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Misha Nasledov <misha@nasledov.com>

[ Upstream commit bba4dc3306483335ddbe065c05b2d8359ec387a4 ]

amdgpu_dm builds the new dc_state as a copy of the old one. When the last
stream is removed, dml1_validate() returns early on pipe_cnt == 0 and
never reaches dcn32_calculate_dlg_params(), so bw.dcn.clk keeps the
dramclk/dcfclk/fclk requirements of the display that was just turned off.
dcn32_update_clocks() then keeps those hard minimums applied.

On an RX 7900 XTX this leaves UCLK at 456 MHz and DCFCLK at 637 MHz with
the monitor off, and the board idles at 28.4 W. With this change they
drop to 96 MHz and 145 MHz and board power falls to 15.3 W.

Reset the clock requirements in that case, as calculate_dlg_params()
already does when no HUBP is active and as the DML2 path does for
stream_count == 0.

Signed-off-by: Misha Nasledov <misha@nasledov.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 0261a0ef89f37ef962fbc9dbc724ebf65fe681cf)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../display/dc/resource/dcn32/dcn32_resource.c    | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c
index a2e66761b8ec0..81227df686802 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c
@@ -1941,8 +1941,21 @@ static bool dml1_validate(struct dc *dc, struct dc_state *context, enum dc_valid
 	out = dcn32_internal_validate_bw(dc, context, pipes, &pipe_cnt, &vlevel, validate_mode);
 	DC_FP_END();
 
-	if (pipe_cnt == 0)
+	if (pipe_cnt == 0) {
+		/* The context is a copy of the previous state, so without this the
+		 * clocks the last display needed stay applied with all displays off.
+		 */
+		context->bw_ctx.bw.dcn.clk.socclk_khz = 0;
+		context->bw_ctx.bw.dcn.clk.dppclk_khz = 0;
+		context->bw_ctx.bw.dcn.clk.dcfclk_khz = 0;
+		context->bw_ctx.bw.dcn.clk.dcfclk_deep_sleep_khz = 0;
+		context->bw_ctx.bw.dcn.clk.dramclk_khz = 0;
+		context->bw_ctx.bw.dcn.clk.fclk_khz = 0;
+		context->bw_ctx.bw.dcn.clk.p_state_change_support = true;
+		context->bw_ctx.bw.dcn.clk.fclk_p_state_change_support = true;
+		context->bw_ctx.bw.dcn.clk.num_ways = 0;
 		goto validate_out;
+	}
 
 	if (!out)
 		goto validate_fail;
-- 
2.53.0



