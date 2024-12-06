Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09CC9207E1E;
	Fri,  6 Dec 2024 15:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497945; cv=none; b=ssUerS9X8SsP52aeDF4dsGafiwXdTPzBefr116DZdeaK7gnGhVcGctMS+fojzp938cxeA9drPHqq816lDq4czCN1j80t0ExtR/0FopfTjl0llM2aFgNHZkEJV+AJejV6dJ/8Z5LiO4yFUxq+IAF9FO5NUDjM8oimWkisq3WSn2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497945; c=relaxed/simple;
	bh=ecQ7D4AC8LQ2UxfDHWIEcmCxJU7+1w2EJ3W0Kpl1IaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VE2LLqPj3umr8AY/Vl0Rtj4ot6ffQJyNpod5s7XFnxY2aRUN5H9p166MqGES8/dIFi84FjOOAa+1xrBUGfOXUSmWfeeqSlR6o7IK8o2vonk6ZSlb2HmzAuuMkHqePsc//9tHZrHDfi+aVGcHZpjPghHDp8/sLrbQhSMjmerciwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aVwXHtNp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aVwXHtNp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76D1CC4CED1;
	Fri,  6 Dec 2024 15:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497944;
	bh=ecQ7D4AC8LQ2UxfDHWIEcmCxJU7+1w2EJ3W0Kpl1IaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aVwXHtNpofdKGTC+j+U/bXolwFntN1d16qLkYHjoc7LBMEgVxXR/y4boluAt0JFVe
	 WhM3k/9N+EJJvGRxp0rG9r/tzWok0qmSaYsgFrsei1vXhg0u5yNQNQ/2ugBFJ+2R9g
	 j1/P+bRVhwHan8OnHsMNcnHAHGnLDSJ9uFBQmBCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Chung <chiahsuan.chung@amd.com>,
	Zicheng Qu <quzicheng@huawei.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 439/676] drm/amd/display: Fix null check for pipe_ctx->plane_state in hwss_setup_dpp
Date: Fri,  6 Dec 2024 15:34:18 +0100
Message-ID: <20241206143710.498109637@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zicheng Qu <quzicheng@huawei.com>

[ Upstream commit 2bc96c95070571c6c824e0d4c7783bee25a37876 ]

This commit addresses a null pointer dereference issue in
hwss_setup_dpp(). The issue could occur when pipe_ctx->plane_state is
null. The fix adds a check to ensure `pipe_ctx->plane_state` is not null
before accessing. This prevents a null pointer dereference.

Fixes: 0baae6246307 ("drm/amd/display: Refactor fast update to use new HWSS build sequence")
Reviewed-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Zicheng Qu <quzicheng@huawei.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
index f99ec1b0efaff..2eae1fd95fd06 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
@@ -727,6 +727,9 @@ void hwss_setup_dpp(union block_sequence_params *params)
 	struct dpp *dpp = pipe_ctx->plane_res.dpp;
 	struct dc_plane_state *plane_state = pipe_ctx->plane_state;
 
+	if (!plane_state)
+		return;
+
 	if (dpp && dpp->funcs->dpp_setup) {
 		// program the input csc
 		dpp->funcs->dpp_setup(dpp,
-- 
2.43.0



