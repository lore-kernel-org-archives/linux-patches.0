Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB4D38DD1;
	Thu,  5 Sep 2024 09:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529626; cv=none; b=fq+xCKsUCxtc6POM0I2w7MVlGoWT8Rw5fciyWp9GjSwWi65Nz4a3IGoyNXt2NSJhmS5XtCPUhD8XBT5aJO8uBHjpI+qQvLLG/mw3brA/M5ouOeQVHoNUCzKC0IE+sspz9k98oplj4cY3GuoXOR4EktCHcrcwwatMRi7+zr42FMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529626; c=relaxed/simple;
	bh=krSd+U//Bn+ZgIsaBMlTj+zzTznhTTI1fQMADtH3ApU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AiN4GWu1GjNLJO4s+CjBcbC0Oa6VokE9eRbV9QsOLqL/8F/CNMqs4eIYvTVHVnq9uxofI5gb2qzSdHzhMH6MAclIg4bi97FVY1tZ85HStUyfYBiQ2ddj4qEgLsRMajTqEfirRwITHf6yIUbVBr8MsPekzNQ607T+D55n7P0bXkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eNzmC9c9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eNzmC9c9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96654C4CEC3;
	Thu,  5 Sep 2024 09:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529626;
	bh=krSd+U//Bn+ZgIsaBMlTj+zzTznhTTI1fQMADtH3ApU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eNzmC9c9AJBA4+qdSGsAOctxU50+WRjdv7QsLkQGHPkQZGxNDiHVd2zH+2B4FaoGX
	 CkDOVZzCiJWcwGmo1is6TP2GDyQlYPw4CICcRerw0XVuCflWCVLbSbzL0dNwgMg2+S
	 KGR1OgrXmz6tI+i/tWV49VLZBVRKsPwCzT1zd0eY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 061/184] drm/amd/display: Fix incorrect size calculation for loop
Date: Thu,  5 Sep 2024 11:39:34 +0200
Message-ID: <20240905093734.621202886@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 3941a3aa4b653b69876d894d08f3fff1cc965267 ]

[WHY]
fe_clk_en has size of 5 but sizeof(fe_clk_en) has byte size 20 which is
lager than the array size.

[HOW]
Divide byte size 20 by its element size.

This fixes 2 OVERRUN issues reported by Coverity.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn35/dcn35_dccg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn35/dcn35_dccg.c b/drivers/gpu/drm/amd/display/dc/dcn35/dcn35_dccg.c
index 58dd3c5bbff0..4677eb485f94 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn35/dcn35_dccg.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn35/dcn35_dccg.c
@@ -940,7 +940,7 @@ static uint8_t dccg35_get_other_enabled_symclk_fe(struct dccg *dccg, uint32_t st
 	/* for DPMST, this backend could be used by multiple front end.
 	only disable the backend if this stream_enc_ins is the last active stream enc connected to this back_end*/
 		uint8_t i;
-		for (i = 0; i != link_enc_inst && i < sizeof(fe_clk_en); i++) {
+		for (i = 0; i != link_enc_inst && i < ARRAY_SIZE(fe_clk_en); i++) {
 			if (fe_clk_en[i] && be_clk_sel[i] == link_enc_inst)
 				num_enabled_symclk_fe++;
 		}
-- 
2.43.0



