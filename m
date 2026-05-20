Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81403F23A1;
	Wed, 20 May 2026 17:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297087; cv=none; b=FbpPAZu8HY7kkTqx7Vitv0F0AMvQrVdFfERLqhQ72KL/p9UJGirJaAE/bF5ckrjlCUPlCxc++cWoRN9s06QCY8YWajCqxoEF9Ho0SqcO7vOMJvitMP/PWHN0yT/v68UO5vsfb7bzGgcTf2EZes1InH4Ya4rp3U6jS53GUUiSKxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297087; c=relaxed/simple;
	bh=qpiV9TOepGCFSFpnnFN9DmW20z+pQ/6OLYWy3IBvJDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=krWXrZ2g3asIK2JlZ/e8xtXZg7YBGzpmTrxxRGbm+5eLuW8FYaKR2eQoY72HPOTRMvD8F7oE3XswGkAIOIS9R9LTeJcb2CIl1Dj0pe+ULZNgCQ39DxaESgtlX1ikXnu9kgjOVMEYqTmyFUBsDcFfwn2u4vE5qLmNhsgYPSTAHS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gAHFLs7n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gAHFLs7n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 478C61F000E9;
	Wed, 20 May 2026 17:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297085;
	bh=o6OhcRt43DyBPk4cp1d/+aDBOUO2DGSMq2I/6omjsCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gAHFLs7nk2MduV1cuNtHSdjPPwHvadyfZte/GoyX7VxKhnSCMNSsUNBkXF6MiFkf6
	 6w8scyXi3iFO/xDyUHajx0Xmyt700vYdr5KBRQpMHjfvNJ1sTpSS0rjQwv3s2eQAyR
	 Wn2AqlwROo/vK3X47QcSmDEAXh4M2/IkZ4P5HX+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 1004/1146] drm/amd/display: Allow constructing DCE6 link encoder without DDC
Date: Wed, 20 May 2026 18:20:54 +0200
Message-ID: <20260520162210.954705738@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 880498a1943f865529819f778df3b9945ca57262 ]

When the DDC channel ID is set to CHANNEL_ID_UNKNOWN,
pass NULL to the AUX regs array.

This is necessary to support embedded connectors without DDC.

Fixes: 7c15fd86aaec ("drm/amd/display: dc/dce: add initial DCE6 support (v10)")
Link: https://gitlab.freedesktop.org/drm/amd/-/work_items/5192
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 38a70e50b22a188ff601740d64dd75f46213121f)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/resource/dce60/dce60_resource.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/resource/dce60/dce60_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dce60/dce60_resource.c
index 3d52973dd7f20..15f220671fbed 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dce60/dce60_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dce60/dce60_resource.c
@@ -753,7 +753,8 @@ static struct link_encoder *dce60_link_encoder_create(
 				     enc_init_data,
 				     &link_enc_feature,
 				     &link_enc_regs[link_regs_id],
-				     &link_enc_aux_regs[enc_init_data->channel - 1],
+				     enc_init_data->channel == CHANNEL_ID_UNKNOWN ?
+				     NULL : &link_enc_aux_regs[enc_init_data->channel - 1],
 				     enc_init_data->hpd_source >= ARRAY_SIZE(link_enc_hpd_regs) ?
 				     NULL : &link_enc_hpd_regs[enc_init_data->hpd_source]);
 	return &enc110->base;
-- 
2.53.0



