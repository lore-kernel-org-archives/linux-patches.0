Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778D21CAA7B;
	Tue, 27 May 2025 17:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367607; cv=none; b=rgRNnjAErptrmzB7qFu0DVWbI24mdBqrXw5htyiDSVdJfuCOReV4aFgyVO/PS+63MWfvUM3MNpyds/oBRYQUgRqs866sm1PhDGxVVqNjiYYNsfrwB/y2j67G+/L+LRXsPrysEfi12IAWUtFhofMHFl31IuoFt700U584CWJgUTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367607; c=relaxed/simple;
	bh=u0zPlmkkkzmrpwNYIBrSoQVKaOtZdEXYfMmTbilevG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kRtkAICem/1fdk6IYBLyXxi+lgpOiU0kROt2kPEefTJ9l9ucALoJyQy0khmjROQC/784vD+y7ahR/b60MKyKzjR+b9a3WzcJeYENKk9uPMrDAjJSdR06X6H8FEASf5Eub50zQ+LwGIrXA7q1H0QNQN0HNn3ehmsf/Dkc1rmZTOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pB6bP57f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pB6bP57f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D6CC4CEE9;
	Tue, 27 May 2025 17:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367607;
	bh=u0zPlmkkkzmrpwNYIBrSoQVKaOtZdEXYfMmTbilevG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pB6bP57f135PZo1w7pP8elEB4SKDS6SLUoG/4tRVUN1dZO4HsM7Q1mn/g50qD3HzR
	 ncArYkoHar2meLr9jMfB3d++dFtre1AKloXDpCqa+B6PTupXUbRY5BzrL4XhhXRxXX
	 mZtsdD9A2lJMDuklxGPG8doD07mHkp3rzM38ghGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dillon Varone <dillon.varone@amd.com>,
	Leo Zeng <Leo.Zeng@amd.com>,
	Roman Li <roman.li@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 414/783] Revert "drm/amd/display: Request HW cursor on DCN3.2 with SubVP"
Date: Tue, 27 May 2025 18:23:31 +0200
Message-ID: <20250527162529.958980170@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Zeng <Leo.Zeng@amd.com>

[ Upstream commit 8ae6dfc0b61b170cf13832d4cfe2a0c744e621a7 ]

This reverts commit 13437c91606c9232c747475e202fe3827cd53264.

Reason to revert: idle power regression found in testing.

Reviewed-by: Dillon Varone <dillon.varone@amd.com>
Signed-off-by: Leo Zeng <Leo.Zeng@amd.com>
Signed-off-by: Roman Li <roman.li@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
index 56dda686e2992..6f490d8d7038c 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
@@ -626,7 +626,6 @@ static bool dcn32_assign_subvp_pipe(struct dc *dc,
 		 * - Not TMZ surface
 		 */
 		if (pipe->plane_state && !pipe->top_pipe && !pipe->prev_odm_pipe && !dcn32_is_center_timing(pipe) &&
-				!pipe->stream->hw_cursor_req &&
 				!(pipe->stream->timing.pix_clk_100hz / 10000 > DCN3_2_MAX_SUBVP_PIXEL_RATE_MHZ) &&
 				(!dcn32_is_psr_capable(pipe) || (context->stream_count == 1 && dc->caps.dmub_caps.subvp_psr)) &&
 				dc_state_get_pipe_subvp_type(context, pipe) == SUBVP_NONE &&
-- 
2.39.5



