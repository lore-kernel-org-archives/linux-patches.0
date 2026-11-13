Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591214;
	b=m6rNwiE4PA6UWJhul6xImEMea+UhOo+dZ1dB7NVElHjg73Fm9rv8OBLIfIg8Z/A+vdEB
	 CvbTPjz9fCZtUCfCwtBMAX4oCATOhylsOWhQfeN0h0WhS2YD5v7AnSqMIZT9vRB3tYMlH
	 oCw/E8bO8u7kBz9grBqaj4vRZc8NHOcngVuBUviPkAqwQM/ekT8kOS2scLe7GX/jZQ9F5
	 4yLKCxvrLWPI4n7yQJuf8nPpfpA8TT7HN5WA8y2CqPiLB29UNCAWnK3vWvJUoaHYulbQY
	 0H5ij4iljVYFLeqNxE9PphVfJkVT80PeEfeP51FH973LpX3IeIVI7CQbfIb6oMDlLow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591214;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Bk4QwS3uLTp/C22juoJGQzITJ102k+5I4dypn9Eb5+w=;
	b=fuPTt0L2LJi3E2VjKEgKo+JQopdYWoirdX/iOEsJ2BFAU5pSQHrrdsv/PD/76oR5hsDo
	 Tp6QTeH0o5japopvsnAtfmA1maXtpo9hEaKe9NpIVVLiFDrt8lB2Mf2nyoJe3oUq45bRT
	 LAQ3UPxrO6nkjx5LvVmz679k34cV9qRNXrBlPqn5tCxnMJHwQBmmd5NAhaEOXtD3a8//x
	 kO4OUa+pqd1BuVVNDWmuk+5XLzgWNbVcQnlTZp9OY+JA6J8D/BOTw/6KYpz62MsMFdgoe
	 KW7UciHp5+B4CJROn7o9lhTLBetGa7rFkN1v+7NsSK1T5UGMPXZh92rz7h8vbhmVzeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LNYVhNQf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1BF6075854;
	Fri, 13 Nov 2026 17:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LNYVhNQf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5708B1F000C5;
	Fri, 13 Nov 2026 17:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591214;
	bh=Bk4QwS3uLTp/C22juoJGQzITJ102k+5I4dypn9Eb5+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LNYVhNQfUK/cLjnA6oFgpqBSab5wmTUvQ/p0oZcAULnQnuFth78wo91W6SLP1Zt3I
	 iR0hlLVZ9rVTGgQg1HwKBo5vrRB9FVnoFTdMpro+T6kSOcQD3IW01iKh3ZM0YPdFVt
	 5RhuA0PAzRjfqGYvPzrPIrBi3RvZyyWoJNiz5ow0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Misha Nasledov <misha@nasledov.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 348/670] drm/amd/display: Drop clock requirements on DCN32 when no displays are active
Date: Fri, 13 Nov 2026 10:48:32 -0500
Message-ID: <20261113153823.625628200@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1fa4d32ce0be7..c79a175d4d9ae 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c
@@ -1775,8 +1775,21 @@ static bool dml1_validate(struct dc *dc, struct dc_state *context, bool fast_val
 	out = dcn32_internal_validate_bw(dc, context, pipes, &pipe_cnt, &vlevel, fast_validate);
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



