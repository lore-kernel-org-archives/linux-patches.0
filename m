Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670642DCF45;
	Tue, 17 Feb 2026 20:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361639; cv=none; b=A0u75DpZglT85gSlySfxIIBvW00Af/7/aHtyLhfNtRwuswVDrO6g0btcw1usns74eedEfzXIaZVpYoLkZa26VkQ1hVDhIwFgWnAWgSUbauvOr9qZSgLKoMarka9Xs7KE7BzNWr5r+sYYhAKonLq8vvyK+giUhOA5c9G+k8dZdyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361639; c=relaxed/simple;
	bh=eX5ZSSYfmFdVunzjuAGN2D9UFDGFcxrQVlk/z8gn3Wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kttuKoQFXkPWXhIMY5QrcnWeQQmT8NZneOKGkA1o1VahsKEXZby8t4btCFXT6jc5HU1mNAqTMOOz8Y/VRUq9bkOEVYP/rMyOSz3ZZHo5WsDWi+DNT1Ey3K56U1Uf8EGyQuUn3Gjcr1giiHlj5Jh7ACE7UWulI5V8ZxQxyZtrWIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FOjLQ7pn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FOjLQ7pn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B33C6C4CEF7;
	Tue, 17 Feb 2026 20:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361639;
	bh=eX5ZSSYfmFdVunzjuAGN2D9UFDGFcxrQVlk/z8gn3Wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FOjLQ7pnsZudZ8sBVwbe4QniNy0AhOfWuUecn9WynYisrroXyxpqkHF3jlGhQTKu2
	 LHKwhbyJwB9qU8aojVaoIHW4u8IRXg0o/KdURB8eg8BVEvevu2szNwgJaHkI+V207u
	 +dauWemuL20gd8Rihkw+45O3fS7C8yiGT8r+nwcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 23/42] drm/amd/display: remove assert around dpp_base replacement
Date: Tue, 17 Feb 2026 21:32:14 +0100
Message-ID: <20260217200006.888298568@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200005.998240758@linuxfoundation.org>
References: <20260217200005.998240758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 17b6eebadef69..39cc924463502 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c
@@ -499,7 +499,6 @@ bool dcn32_set_mcm_luts(
 		lut_params = &plane_state->in_shaper_func.pwl;
 	else if (plane_state->in_shaper_func.type == TF_TYPE_DISTRIBUTED_POINTS) {
 		// TODO: dpp_base replace
-		ASSERT(false);
 		cm3_helper_translate_curve_to_hw_format(plane_state->ctx,
 							&plane_state->in_shaper_func,
 							&dpp_base->shaper_params, true);
-- 
2.51.0



