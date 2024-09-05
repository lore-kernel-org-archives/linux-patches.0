Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE8319755A;
	Thu,  5 Sep 2024 09:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529462; cv=none; b=u5BqvIPy/RbJJIWkCKbFM9DNDuD4virAE67U7gcZeqSgv70WiG2oiSVZVmHL1H3QTSwGsyK9CqMvHGviQBKtPn9cyelxAAEhbOMrgUt9euTbVE5kmDT5wijgDJyfW5h/TcOIh4QnNQBl5R0Q+NQPnsnUowbk8/sQItTj6n3WdDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529462; c=relaxed/simple;
	bh=mMbTd0OcAwab627mubx6kp3OQYKp01oyj4jIYCvojRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mS627FiZ9EBlrby66kWRtw7g/HLtsYToeEp+WbICJhmmEp4lwCaJMtuRtmN6oFLAG221jcwpTZF2Zb63gqfwOEHuhhFomKCxlWu+azcJvX+uFqGCgTxE9K8P1pDUHWt3jCxIVwbLPWWF1WpI6wbS/xhwoKCKbAJdaUYbLlHrYO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f4bHjU72; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f4bHjU72"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D8BC4CECD;
	Thu,  5 Sep 2024 09:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529462;
	bh=mMbTd0OcAwab627mubx6kp3OQYKp01oyj4jIYCvojRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f4bHjU72fODF/e04sL4VkLnZuxCUJzQ6ZAp23/RBoeXEv63KiBOA9mwv7T68j6AXo
	 jU26ZhmyhAUqDgJ8NIn/gRy98LNemPNrbJ4P045ki29BORTX/4602No/HtGAhUlriP
	 G5HP3pUHWxrncqBiczlt9eQvjqOr9RkeZv4cxm+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaitanya Dhere <chaitanya.dhere@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Joshua Aberback <joshua.aberback@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 041/184] Revert "drm/amd/display: Fix incorrect pointer assignment"
Date: Thu,  5 Sep 2024 11:39:14 +0200
Message-ID: <20240905093733.852246789@linuxfoundation.org>
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

From: Joshua Aberback <joshua.aberback@amd.com>

[ Upstream commit 0c9c0674f81add3edb2bb992b3e89be8a44f03db ]

This reverts commit 0a571e8657c40047e6602466abfcb6514a391041.

[Why]
The change being reverted incorrectly assumes that a pointer type was
intended, however copying to a new structure is correct. As well, there
is no compiler error, it was instead an error in the testing framework
being used.

Reviewed-by: Chaitanya Dhere <chaitanya.dhere@amd.com>
Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Joshua Aberback <joshua.aberback@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_state.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_state.c b/drivers/gpu/drm/amd/display/dc/core/dc_state.c
index 52a1cfc5feed..502740f6fb2c 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_state.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_state.c
@@ -191,7 +191,7 @@ static void init_state(struct dc *dc, struct dc_state *state)
 struct dc_state *dc_state_create(struct dc *dc, struct dc_state_create_params *params)
 {
 #ifdef CONFIG_DRM_AMD_DC_FP
-	struct dml2_configuration_options *dml2_opt = &dc->dml2_options;
+	struct dml2_configuration_options dml2_opt = dc->dml2_options;
 #endif
 	struct dc_state *state = kvzalloc(sizeof(struct dc_state),
 			GFP_KERNEL);
@@ -205,11 +205,11 @@ struct dc_state *dc_state_create(struct dc *dc, struct dc_state_create_params *p
 
 #ifdef CONFIG_DRM_AMD_DC_FP
 	if (dc->debug.using_dml2) {
-		dml2_opt->use_clock_dc_limits = false;
-		dml2_create(dc, dml2_opt, &state->bw_ctx.dml2);
+		dml2_opt.use_clock_dc_limits = false;
+		dml2_create(dc, &dml2_opt, &state->bw_ctx.dml2);
 
-		dml2_opt->use_clock_dc_limits = true;
-		dml2_create(dc, dml2_opt, &state->bw_ctx.dml2_dc_power_source);
+		dml2_opt.use_clock_dc_limits = true;
+		dml2_create(dc, &dml2_opt, &state->bw_ctx.dml2_dc_power_source);
 	}
 #endif
 
-- 
2.43.0



