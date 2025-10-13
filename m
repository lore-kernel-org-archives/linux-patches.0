Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A6026E702;
	Mon, 13 Oct 2025 14:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367201; cv=none; b=cETeWa8ETb8LyEfDZseeMl0U8wTXcTcM65spgLS8SApJh74wajHNoXWv9/aE2riSpBvDfkWS3dTqZE0z5h1hnv1t5tgFi2R1J3svXA02KbbKv07atmnnqdIuxs58HT8Q30B76PddVi2Fdyg7KvQ6Sm8iHJyoGao6QCVy8OwSvFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367201; c=relaxed/simple;
	bh=G9jWyIlcBX/vLTsctuwL+Wxqa2HVXOwVruSNZo8Nx4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u3lsoxEOKCuv9NdG0NEUiQadXbxH93BAr9JQvOCMlyk45LX2RFvaDP99QCmrDOMAdQD4zoul2nmT74o/DTKm+VN1arJvQFpeT7zMw93gsQMUfBf5wGM1ARix5R93DmsjLEteUNaJV1yDy8oCKA78M1Ko2jA+rJnmYlC4kMJxV3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SQ61+hbm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SQ61+hbm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DA19C113D0;
	Mon, 13 Oct 2025 14:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367200;
	bh=G9jWyIlcBX/vLTsctuwL+Wxqa2HVXOwVruSNZo8Nx4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SQ61+hbmfOIy/A9McebDuUCxm74ys779aDbX6vNZEi5rVSk2WD6+aPB9Czldh+Plz
	 JDMHlwlPE7jhnvCzkF7m/tju3VAIreK0X/ueboSwaXwaKMFtDxJB0sqeoyulHow9l5
	 RKloMckQKsyE6kGr74Sb+6L7+6ETE1jYyusAH2h4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Yuanhong <liaoyuanhong@vivo.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 094/196] drm/amd/display: Remove redundant semicolons
Date: Mon, 13 Oct 2025 16:44:27 +0200
Message-ID: <20251013144318.101035376@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



