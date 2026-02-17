Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05F1266581;
	Tue, 17 Feb 2026 20:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361459; cv=none; b=UT0BjfLgMrpSD2bGzvSrjYdjLRfUH3fRL5HBvN7NIojK/HOwDTt3LZLspfZ30lU1u2+nOeBVVZupdMcu+Ku87affOZZcQsHjby4rCdBfmo2m92gPlESY5b8mtEH3utvM5hXhEeQPfolTGFUbTGLs21OluStPgSMXbVeFpyiGZrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361459; c=relaxed/simple;
	bh=kh36k6uwXlPuLEkLpu4gMoY5fh0chWaJzRQTvICcIGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HD1OnMz7rIU3BEqKs2Syy1ve2nXpe50aB3fuqVlOIarTmeqLuR3W7XRb1I1uqZgheI2k3NQpig0SrssaSE8UoI52ow4N+kHUZbX/m02MbcisKx13OtPUrws5F60RqiN6HGyK02URgc8mejdjtXmbi5mpnmfd8jQib14OcmeuUEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xm04mFAd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xm04mFAd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB16C4CEF7;
	Tue, 17 Feb 2026 20:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361459;
	bh=kh36k6uwXlPuLEkLpu4gMoY5fh0chWaJzRQTvICcIGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xm04mFAdEWGeUjy27Nzgn1xREXpOw/OjgKnoBEVS/uRzJ4U/UWaFXKvXPX2VIjZo3
	 6juhsLYRj1Y9+6cMhPGe3KxWZ5jbPgPzSthNy5lXwfZs4vEYoYlFkAhGLmk3uLJas9
	 XL9+k4hidICiHkL9PndHGeWwgRdlju6LZkJCKzf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 22/43] drm/amd/display: remove assert around dpp_base replacement
Date: Tue, 17 Feb 2026 21:32:02 +0100
Message-ID: <20260217200007.317450434@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200006.470920131@linuxfoundation.org>
References: <20260217200006.470920131@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Melissa Wen <mwen@igalia.com>

[ Upstream commit 84962445cd8a83dc5bed4c8ad5bbb2c1cdb249a0 ]

There is nothing wrong if in_shaper_func type is DISTRIBUTED POINTS.
Remove the assert placed for a TODO to avoid misinterpretations.

Signed-off-by: Melissa Wen <mwen@igalia.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1714dcc4c2c53e41190896eba263ed6328bcf415)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c
index 30bb5d8d85dc2..c6fde355ac823 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c
@@ -502,7 +502,6 @@ bool dcn32_set_mcm_luts(
 		lut_params = &plane_state->in_shaper_func.pwl;
 	else if (plane_state->in_shaper_func.type == TF_TYPE_DISTRIBUTED_POINTS) {
 		// TODO: dpp_base replace
-		ASSERT(false);
 		cm3_helper_translate_curve_to_hw_format(plane_state->ctx,
 							&plane_state->in_shaper_func,
 							&dpp_base->shaper_params, true);
-- 
2.51.0



