Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40041F891F;
	Tue,  3 Dec 2024 15:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240123; cv=none; b=XjdlS+2B4TRh8Ftm560mZzKjhigvp4/i3BGVAKqK2M8Z7sYHlABzmCz/tcf8dsdFsBtckri/hDCg7WI7JbS/H+6pQ4mwkzAhrzr4l90rIwqAnaaIHqaVfkaSdmSq4x0uIRnMCGsX5qIERGvI6kRWzuRf6dheIc5mbCxGBEBm32M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240123; c=relaxed/simple;
	bh=jY54cRx7JtxcKe9sSjaaFIGdbHpxHBmjEgQ+rULITKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=njy/cLTXikc+sAPkLk6wb/wfQSNL4B9jR4tlhCzotPVwPaJcXmjtXKxZMl/IQHnzxb0dPMhyS+Sb8u75kFaiyDKFcdn9Qeb3+YIKWTvFYQpCoY59cmF4XFa+2SsrRhNREtxcwxiiVNh4epP5eUY9FZJguQtenhMZDU8kqWHFiu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pA6dU//M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pA6dU//M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18504C4CECF;
	Tue,  3 Dec 2024 15:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240122;
	bh=jY54cRx7JtxcKe9sSjaaFIGdbHpxHBmjEgQ+rULITKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pA6dU//MGsZOtMMmnkr3BU9jiQbq+0v6eobhcQxi7kPiixBECWiySBmuKKeL8F496
	 WZCTWkTUu8RLL34GxtwQdUg+OhQNirJzDzXeMPzOqCHHHBX/a3N+j8U+roREaIgbRJ
	 4l0a4vw+gmfl8YN/HHHVGtV6E5U7RPJdVlL5kGD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Fangzhi Zuo <Jerry.Zuo@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 003/826] drm/amd/display: Fix incorrect DSC recompute trigger
Date: Tue,  3 Dec 2024 15:35:30 +0100
Message-ID: <20241203144743.577780850@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fangzhi Zuo <Jerry.Zuo@amd.com>

[ Upstream commit 4641169a8c95d9efc35d2d3c55c3948f3b375ff9 ]

A stream without dsc_aux should not be eliminated from
the dsc determination. Whether it needs a dsc recompute depends on
whether its mode has changed or not. Eliminating such a no-dsc stream
from the dsc determination policy will end up with inconsistencies
in the new dc_state when compared to the current dc_state,
triggering a dsc recompute that should not have happened.

Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Fangzhi Zuo <Jerry.Zuo@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index f756640048fee..32b025c92c63c 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -1313,7 +1313,7 @@ static bool is_dsc_need_re_compute(
 			continue;
 
 		aconnector = (struct amdgpu_dm_connector *) stream->dm_stream_context;
-		if (!aconnector || !aconnector->dsc_aux)
+		if (!aconnector)
 			continue;
 
 		stream_on_link[new_stream_on_link_num] = aconnector;
-- 
2.43.0



