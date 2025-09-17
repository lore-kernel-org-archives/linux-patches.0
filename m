Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ABB41E489;
	Wed, 17 Sep 2025 12:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113018; cv=none; b=GTrprwpTCWQaxNG0viNj39z4Pspbj5cGE8gmqI1l6jM1eCQ3J2J7G9BEm+ifLGw9+3+BDfjbwFt9cTAQwii3X9/C/cgVaDxHitDIKXrbFWIuXjQLSwlozI00xW7JXHuoGuzMwqpH/Iw3SvIE6+YmiVbcC2M7LaGdabHLC2J0CRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113018; c=relaxed/simple;
	bh=Nb5NIsLt3rO6Hj5WH1g3l6VnDQKP/quFU7TY6uSo3VQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oSeJuyfr1hcHiNIDLA5rYKRTzBKYVlK4WohYYemokHYOPE2HnQayYz6GK7mktw8AkurOOt4eruYWw2ZEYg84g8FaGaRT9uBhIZEtaLn4fooXxJ4Kcp3iqxRIPKANtQDYuLdRj2OaiUZf/mCnWkUjPPW8Eyf3ybISjslTSUB8tR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w5zRKxNj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w5zRKxNj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 846F2C4CEF0;
	Wed, 17 Sep 2025 12:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113017;
	bh=Nb5NIsLt3rO6Hj5WH1g3l6VnDQKP/quFU7TY6uSo3VQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w5zRKxNjxucFUKnH3kc68DDIJ4Sqn0NUYkgD8YF59X4zewu1b6nw42506tNb4fojf
	 abQw7T3XCB4FLwtWJafT37Xn9gsGZk9IkUvfmX4GDylsNs6Ad+VzmnHrAsMe8hUvex
	 kD2v3WwdOTwG886sIYqvqiKeq+mVfcLXutEeg578=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wen Chen <Wen.Chen3@amd.com>,
	Fangzhi Zuo <jerry.zuo@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 144/189] drm/amd/display: use udelay rather than fsleep
Date: Wed, 17 Sep 2025 14:34:14 +0200
Message-ID: <20250917123355.385711821@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 1d66c3f2b8c0b5c51f3f4fe29b362c9851190c5a ]

This function can be called from an atomic context so we can't use
fsleep().

Fixes: 01f60348d8fb ("drm/amd/display: Fix 'failed to blank crtc!'")
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4549
Cc: Wen Chen <Wen.Chen3@amd.com>
Cc: Fangzhi Zuo <jerry.zuo@amd.com>
Cc: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 27e4dc2c0543fd1808cc52bd888ee1e0533c4a2e)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
index cdb8685ae7d71..454e362ff096a 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
@@ -955,7 +955,7 @@ enum dc_status dcn20_enable_stream_timing(
 		return DC_ERROR_UNEXPECTED;
 	}
 
-	fsleep(stream->timing.v_total * (stream->timing.h_total * 10000u / stream->timing.pix_clk_100hz));
+	udelay(stream->timing.v_total * (stream->timing.h_total * 10000u / stream->timing.pix_clk_100hz));
 
 	params.vertical_total_min = stream->adjust.v_total_min;
 	params.vertical_total_max = stream->adjust.v_total_max;
-- 
2.51.0



