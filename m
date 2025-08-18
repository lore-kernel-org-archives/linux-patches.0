Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DBFF3375D7;
	Mon, 18 Aug 2025 14:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525709; cv=none; b=flJEg1e58RSuUq1y2ndnr1GUxcPFLhVg7fiyVqyFApP1R0MF3+AOz5/Idqwbkw4o7lzKglUDJ4cubDdohQ6c3nJb3eCXNn1p8SCdA0YgRGDQLgn6pJ5ksw5OviyCFAr0Ipu3Pkp9bYFfifWPy7Di/g/aFsIWEvvsBaXC1mZnkFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525709; c=relaxed/simple;
	bh=TDEfV52WJ9dhGoOfUiAYkQFSvYTe+T7wEbOOkVumnZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QqD6d//4Q0pj309MWYKfPo1dbxvk9jdJaOojk+PREAN6vkJyKwLPdCnfzmtsZIzHbbFTNh8v0pUDZNjjJ85CGeerttoaQOuGtUgMDtA0hYsJr/PiM1vd/VV235iUqX41mfogdyB69KxmzjVrDgi8K8kcajsyMh55g0GcsYiy8D4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HyVl+IL8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HyVl+IL8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05BACC4CEEB;
	Mon, 18 Aug 2025 14:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525709;
	bh=TDEfV52WJ9dhGoOfUiAYkQFSvYTe+T7wEbOOkVumnZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HyVl+IL8xkba7hFRc5wq/49myfsW4rM96hiuDizmLcu1A6Go+rIK28rMZUBcDsBvF
	 MBF4FMxOKIZGGzVPZ7OAn2gCdX9+y06Xq4IWbb8+/nEJg+yARl7Rv8p4XYpklYcalm
	 WDwWiSLsN8RDSc9KLmPEZkqjJDjXTPC5KnsSuGIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Fangzhi Zuo <jerry.zuo@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 311/570] drm/amd/display: Initialize mode_select to 0
Date: Mon, 18 Aug 2025 14:44:58 +0200
Message-ID: <20250818124517.849719928@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 592ddac93f8c02e13f19175745465f8c4d0f56cd ]

[WHAT]
mode_select was supposed to be initialized in mpc_read_gamut_remap but
is not set in default case. This can cause indeterminate
behaviors.

This is reported as an UNINIT error by Coverity.

Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Fangzhi Zuo <jerry.zuo@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/mpc/dcn401/dcn401_mpc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/mpc/dcn401/dcn401_mpc.c b/drivers/gpu/drm/amd/display/dc/mpc/dcn401/dcn401_mpc.c
index 98cf0cbd59ba..591af5a3d3e3 100644
--- a/drivers/gpu/drm/amd/display/dc/mpc/dcn401/dcn401_mpc.c
+++ b/drivers/gpu/drm/amd/display/dc/mpc/dcn401/dcn401_mpc.c
@@ -561,7 +561,7 @@ void mpc401_get_gamut_remap(struct mpc *mpc,
 	struct mpc_grph_gamut_adjustment *adjust)
 {
 	uint16_t arr_reg_val[12] = {0};
-	uint32_t mode_select;
+	uint32_t mode_select = MPCC_GAMUT_REMAP_MODE_SELECT_0;
 
 	read_gamut_remap(mpc, mpcc_id, arr_reg_val, adjust->mpcc_gamut_remap_block_id, &mode_select);
 
-- 
2.39.5



