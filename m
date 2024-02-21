Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C295469E08;
	Wed, 21 Feb 2024 13:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521554; cv=none; b=DKAF7DPgWs8yfo1/qn5Z5OYz3Tflu8jyRDfg7s0lGWyian5HLGkkt/e5Ym1fPff5tgc0JvGNWzuO+YwA1b3KRX9Cc5PWz0UP1ptq2/S9mQ6v4CSILiTxqgYXzdCXWl3X1VBA/VIjN5Hji6wtcoC0fBk6Gy3eQ28BPbDOc61hNhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521554; c=relaxed/simple;
	bh=6+7JFT1hY/tG1cYKPQg1ZRHR/T1os9rmurpBubH79tk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=evO94w956I/DVWmYRU36GBjLlFfjo1P4EEfzcORad4CzrxmTTnq6RtFwDNe86jjJ4iLKtuXIHw/PVzvsNWGhtIr9aaQAFT4l1YkCiDpX/J+rMOXXqKxmR9thJ+DgPfSR8hwA9WFQtDLiGOadhjnpJnL2NF/FOoOWfTZR2N+B7Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EsZha+Vv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EsZha+Vv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0FFBC433F1;
	Wed, 21 Feb 2024 13:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521554;
	bh=6+7JFT1hY/tG1cYKPQg1ZRHR/T1os9rmurpBubH79tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EsZha+VvnQ6yrykEJafUdjQyT9U/KmsTHvYd/g90UMvteHNuP6kMSLHlmoLdiv/AT
	 efn076VF18eZJEEA3HJQ4H5fILeMu/RIxSZYsYrMQX44mM6AHBX6QvvWWm+RXxzbkU
	 gRRU3rToWjqtUDEc4i1UZDCdCsx0iKQNLjI0pqhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aric Cyr <aric.cyr@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Josip Pavic <josip.pavic@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 113/202] drm/amd/display: make flip_timestamp_in_us a 64-bit variable
Date: Wed, 21 Feb 2024 14:06:54 +0100
Message-ID: <20240221125935.391317308@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josip Pavic <josip.pavic@amd.com>

[ Upstream commit 6fb12518ca58412dc51054e2a7400afb41328d85 ]

[Why]
This variable currently overflows after about 71 minutes. This doesn't
cause any known functional issues but it does make debugging more
difficult.

[How]
Make it a 64-bit variable.

Reviewed-by: Aric Cyr <aric.cyr@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Josip Pavic <josip.pavic@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dc_hw_types.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dc_hw_types.h b/drivers/gpu/drm/amd/display/dc/dc_hw_types.h
index b789cb2b354b..c96ff10365d2 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_hw_types.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_hw_types.h
@@ -357,7 +357,7 @@ union dc_tiling_info {
 	} gfx8;
 
 	struct {
-		unsigned int num_pipes;
+		unsigned long long num_pipes;
 		unsigned int num_banks;
 		unsigned int pipe_interleave;
 		unsigned int num_shader_engines;
-- 
2.43.0



