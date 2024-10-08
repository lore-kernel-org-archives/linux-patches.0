Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048561D54D1;
	Tue,  8 Oct 2024 12:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391799; cv=none; b=qXQ7+eEVfTPYN+9wlKn3qRgLgMvquJ1JClDE+e5vw85vzo3lv9CpJL3m/zJAZfG332ielyO0NN/YFUqq2miFSI6oJPrq+1pplg4ttGinTUwg+ApasZikzzitZ56Y+LyPXgVwMURuy7cUnJVCmhJuSf4i+eNekr4xbTWaB21m8y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391799; c=relaxed/simple;
	bh=DqxbZeaQr/xE09Kauy446jvnKPS7JKFfM+oo9GjT7Os=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ol/E1oF/UNOR9CYILGW4k+WxUk8J+GG3ykkhaSmCAR572ynZQu1g38eB3utO5apwKlZ2DOdG6LcqsBB8whnOu6jSiwSe2BJPQDKBfA7d5hpHXV0GkL81GJzQw450NyjLI4nNd1jHPZYNxOsMiV2AEdExj4sLMdBDImV16bv6vcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WgKthbsJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WgKthbsJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32BD6C4CECD;
	Tue,  8 Oct 2024 12:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391798;
	bh=DqxbZeaQr/xE09Kauy446jvnKPS7JKFfM+oo9GjT7Os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WgKthbsJFMUHElze8RCQOnsQ30xWhjeZcdPdzSNjTgjJMq1dqEXy4OLfppGgzwn5B
	 JCrDS7Q5QfOlrxe6LNy7BKnIgoIB63kf/09ykMBNBrbh2RhXnC44Vt/Zx0oj56dsDn
	 x6BUp4ReGh8HYudlSQluWVV7CsvaJ3yQej0pwCOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Chung <chiahsuan.chung@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Roman Li <roman.li@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 225/558] drm/amd/display: Add NULL check for function pointer in dcn20_set_output_transfer_func
Date: Tue,  8 Oct 2024 14:04:15 +0200
Message-ID: <20241008115711.196383250@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit 62ed6f0f198da04e884062264df308277628004f ]

This commit adds a null check for the set_output_gamma function pointer
in the dcn20_set_output_transfer_func function. Previously,
set_output_gamma was being checked for null at line 1030, but then it
was being dereferenced without any null check at line 1048. This could
potentially lead to a null pointer dereference error if set_output_gamma
is null.

To fix this, we now ensure that set_output_gamma is not null before
dereferencing it. We do this by adding a null check for set_output_gamma
before the call to set_output_gamma at line 1048.

Cc: Tom Chung <chiahsuan.chung@amd.com>
Cc: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Cc: Roman Li <roman.li@amd.com>
Cc: Alex Hung <alex.hung@amd.com>
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
index 17d1c195663a0..7ca0da88290af 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
@@ -1044,7 +1044,8 @@ bool dcn20_set_output_transfer_func(struct dc *dc, struct pipe_ctx *pipe_ctx,
 	/*
 	 * if above if is not executed then 'params' equal to 0 and set in bypass
 	 */
-	mpc->funcs->set_output_gamma(mpc, mpcc_id, params);
+	if (mpc->funcs->set_output_gamma)
+		mpc->funcs->set_output_gamma(mpc, mpcc_id, params);
 
 	return true;
 }
-- 
2.43.0



