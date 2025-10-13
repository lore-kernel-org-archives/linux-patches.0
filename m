Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63BC026F2B6;
	Mon, 13 Oct 2025 15:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369509; cv=none; b=EbOkCLi+/qacO63T12yS5JDDi4ifvHWBP5tNKc8aZFlqgEHfLNtd+DdjnQWsEm0Jp0M8Fy6cY1hxPxUlJWY+sAWrH5xnHxmQMv3CBpdRmMpOrKdb1Bn1cCMperFa7OPA+DOErIeHLwcA85DMrILQmPiBp14kRkmGVCve3EImbB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369509; c=relaxed/simple;
	bh=oUUQzcZiBWgUt8j0wmREue2HAMy2WGkQVC0PVi3rSDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hwDR9k13Vda50LTP4B149+XWck2pPnJ0KOjF7uV/09L9rbrDHbV3zhHU/aFwuS/sCehU4RzCbU3ckxCNWSUJMn9SiRH7NmExI8GY2l7i9tFGLsBxuLJw7WSbPnDO4ht9lL3c7iqXfMJqrkBJXXucZE9TWxo0kv1ZjT6tyANQ6OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YqjZhVDI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YqjZhVDI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E52B6C4CEE7;
	Mon, 13 Oct 2025 15:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369509;
	bh=oUUQzcZiBWgUt8j0wmREue2HAMy2WGkQVC0PVi3rSDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YqjZhVDIS/yE4OdrIy6TjTBR19TOwcyd8bP7n6SuxXTFRx+iRpD3aAKI2vD9qZHAf
	 gVklqvNb907Ph79sHWyYCmfiVzWX5W/sfwY91Om0/6fV1C4kxxn5NB9FhHlK3rV48B
	 RI0xCS2a97PROSGpp+oBhHn6nWTjuNMt1zZ3d4VA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Yuanhong <liaoyuanhong@vivo.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 239/563] drm/amd/display: Remove redundant semicolons
Date: Mon, 13 Oct 2025 16:41:40 +0200
Message-ID: <20251013144419.944809395@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liao Yuanhong <liaoyuanhong@vivo.com>

[ Upstream commit 90b810dd859c0df9db2290da1ac5842e5f031267 ]

Remove unnecessary semicolons.

Fixes: dda4fb85e433 ("drm/amd/display: DML changes for DCN32/321")
Signed-off-by: Liao Yuanhong <liaoyuanhong@vivo.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/dml/dcn32/display_rq_dlg_calc_32.c    | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_rq_dlg_calc_32.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_rq_dlg_calc_32.c
index 9ba6cb67655f4..6c75aa82327ac 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_rq_dlg_calc_32.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_rq_dlg_calc_32.c
@@ -139,7 +139,6 @@ void dml32_rq_dlg_get_rq_reg(display_rq_regs_st *rq_regs,
 	if (dual_plane) {
 		unsigned int p1_pte_row_height_linear = get_dpte_row_height_linear_c(mode_lib, e2e_pipe_param,
 				num_pipes, pipe_idx);
-		;
 		if (src->sw_mode == dm_sw_linear)
 			ASSERT(p1_pte_row_height_linear >= 8);
 
-- 
2.51.0



