Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F433C01;
	Tue, 27 May 2025 17:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367415; cv=none; b=HteCtcgJ3PhMFmeYEdffnTxzlFhO8N7/PziX4nsqjRilipZiC3DFznqrK0PHTyNxkcckusY3JbKXVSKFE+Antt+5ZUoN+4XOYpv52r56aTwo06xjK8yhCPUPROQgRgOu4qpVxcVfWSE5GJu/oDW6OOzrnqRG72NWhB/dPp/Bkko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367415; c=relaxed/simple;
	bh=XngBFkuFcbEuR6VzCCGXapcH0Su/yqEJ4ThVYIWOFTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EUdEBlCFwY8wKLkHBfQmlhipGTf8Sl6Q9LqhXGnnu0euQtNZ9bx9abDCUDC6ClrD2rzyYihilN/oZuA7PTF3a01dYe6do2aGkvPE3J8+DUD6fj+7nnljcRNtceSF4F6KC8MuO/fcwgOnvAT5TGKtw2JZML6yVKeeZ8lgeULfQLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jLFDqvX3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jLFDqvX3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4986FC4CEE9;
	Tue, 27 May 2025 17:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367415;
	bh=XngBFkuFcbEuR6VzCCGXapcH0Su/yqEJ4ThVYIWOFTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jLFDqvX36HoDIxPMrsRUKGRujzWW50j0V6tD/3LDYsLGU/uLxtK6ul+ZcEgYNq0EW
	 aFNHbiVT+nbCO8dkeO6PM3L90cKa7BVTWlWPgsQa9vXlWfni3JNNnf0zNLGSAb+jdH
	 SUK9h3/v126utMwrYfvf+F1NPIp3xx9ki3VTLlW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samson Tam <samson.tam@amd.com>,
	Yihan Zhu <Yihan.Zhu@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 350/783] drm/amd/display: handle max_downscale_src_width fail check
Date: Tue, 27 May 2025 18:22:27 +0200
Message-ID: <20250527162527.320742207@linuxfoundation.org>
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

From: Yihan Zhu <Yihan.Zhu@amd.com>

[ Upstream commit 02a940da2ccc0cc0299811379580852b405a0ea2 ]

[WHY]
If max_downscale_src_width check fails, we exit early from TAP calculation and left a NULL
value to the scaling data structure to cause the zero divide in the DML validation.

[HOW]
Call set default TAP calculation before early exit in get_optimal_number_of_taps due to
max downscale limit exceed.

Reviewed-by: Samson Tam <samson.tam@amd.com>
Signed-off-by: Yihan Zhu <Yihan.Zhu@amd.com>
Signed-off-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dpp/dcn30/dcn30_dpp.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dpp/dcn30/dcn30_dpp.c b/drivers/gpu/drm/amd/display/dc/dpp/dcn30/dcn30_dpp.c
index 40acebd13e46d..abf439e743f23 100644
--- a/drivers/gpu/drm/amd/display/dc/dpp/dcn30/dcn30_dpp.c
+++ b/drivers/gpu/drm/amd/display/dc/dpp/dcn30/dcn30_dpp.c
@@ -425,11 +425,6 @@ bool dpp3_get_optimal_number_of_taps(
 	int min_taps_y, min_taps_c;
 	enum lb_memory_config lb_config;
 
-	if (scl_data->viewport.width > scl_data->h_active &&
-		dpp->ctx->dc->debug.max_downscale_src_width != 0 &&
-		scl_data->viewport.width > dpp->ctx->dc->debug.max_downscale_src_width)
-		return false;
-
 	/*
 	 * Set default taps if none are provided
 	 * From programming guide: taps = min{ ceil(2*H_RATIO,1), 8} for downscaling
@@ -467,6 +462,12 @@ bool dpp3_get_optimal_number_of_taps(
 	else
 		scl_data->taps.h_taps_c = in_taps->h_taps_c;
 
+	// Avoid null data in the scl data with this early return, proceed non-adaptive calcualtion first
+	if (scl_data->viewport.width > scl_data->h_active &&
+		dpp->ctx->dc->debug.max_downscale_src_width != 0 &&
+		scl_data->viewport.width > dpp->ctx->dc->debug.max_downscale_src_width)
+		return false;
+
 	/*Ensure we can support the requested number of vtaps*/
 	min_taps_y = dc_fixpt_ceil(scl_data->ratios.vert);
 	min_taps_c = dc_fixpt_ceil(scl_data->ratios.vert_c);
-- 
2.39.5



