Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F048530AAD6;
	Sat, 25 Oct 2025 16:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409406; cv=none; b=Dd2ECbu/LV0Hhvfx2nVb/2CRMW04zXzudqrvNROxtq+Z5VL0ziaNehJB4nUlbIMkRsH1EuVF0aIVMRLIohomLGOOoNPAjGsX50+dV7T66Oq0vkMVclVXnHryPU9BEjk66kKKgH8tUYBJIQKxQOEDi2FKSUNv2ZtdGPK6XPIjIbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409406; c=relaxed/simple;
	bh=tqD7wQXMOM5PwsngKwg1xLbplDqYzrJdEa4gjMqbcw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TeR3Cy/gJ33+ce2PThlon0nQMEZO2fULWhnKe1je2dCCmPIuyc61reRpc+AUpD1Li7syMj093uoPa1x2UZOKp5q+97wGW57I8xcTyyc0ATiewB4W47xqc53QwQEsL1LSd8fnuiEYL8l2robxW1FnnjJlUR1nlf3y0WVFoLKcvKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZWaKgXST; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZWaKgXST"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40BD9C4CEF5;
	Sat, 25 Oct 2025 16:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409405;
	bh=tqD7wQXMOM5PwsngKwg1xLbplDqYzrJdEa4gjMqbcw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZWaKgXSTFKlZa0PzxF0ijFdywcxZRnktqbFZb60xBPB+gzh/2iWHnjWNFeP7MNWUW
	 gPXf97cygtyTor6io5DJeXO397ByBHHWMqkwxKf/HKisSdS2Vrqlj1zkNT+ixK6XDO
	 e5lnHt2JpYsaCBs3WBDVwWZ+FEBzhESln7S3RPQ8a4SvbUgUO5HIWfMFEZg8a6pG3e
	 ctmo6U103jeEN2f62eAJ8FCBl0XIHw94ocwYE5yk5WJpY/wkF9asJGtDNlRwUbwR1Z
	 HaNKW5DpxP1Ho91FBOEnlHjGF+zpXoU24nxZnaNZLBz5zV7xBNh1Ov8kaFlcYqj3eo
	 3qweErNtC0nTw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sridevi Arvindekar <sarvinde@amd.com>,
	Alvin Lee <alvin.lee2@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Dillon.Varone@amd.com,
	alex.hung@amd.com,
	ray.wu@amd.com,
	mwen@igalia.com,
	Ausef.Yousof@amd.com,
	alexandre.f.demers@gmail.com,
	rostrows@amd.com
Subject: [PATCH AUTOSEL 6.17-6.12] drm/amd/display: Fix for test crash due to power gating
Date: Sat, 25 Oct 2025 11:58:59 -0400
Message-ID: <20251025160905.3857885-308-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sridevi Arvindekar <sarvinde@amd.com>

[ Upstream commit 0bf6b216d4783cb51f9af05a49d3cce4fc22dc24 ]

[Why/How]
Call power gating routine only if it is defined.

Reviewed-by: Alvin Lee <alvin.lee2@amd.com>
Signed-off-by: Sridevi Arvindekar <sarvinde@amd.com>
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES – Adding the NULL guard in `dcn20_fpga_init_hw` keeps the FPGA init
path from dereferencing a deliberately cleared power‑gating hook on
Navi12.

- Root cause is that Navi12 forces
  `dc->hwseq->funcs.enable_power_gating_plane = NULL` to avoid the
  unwanted register programming (`drivers/gpu/drm/amd/display/dc/resourc
  e/dcn20/dcn20_resource.c:2728`), so the unguarded call in the FPGA
  init routine dereferenced a NULL function pointer and crashed the test
  path (`drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c:3132`
  before this fix).
- The patch simply checks the pointer before calling, matching the
  pattern already used in other init flows such as `dcn10_init_hw` and
  newer DCN generations, so functional behaviour is unchanged when the
  hook exists and we correctly skip it when it is absent.
- Impacted hardware (Navi12/DCN2.0) ships in currently supported stable
  kernels, and the unfixed bug is an outright NULL dereference, so users
  running the FPGA/diagnostic init sequence still hit a crash today.
- Change is localized, does not pull in other dependencies, and aligns
  with existing defensive guards elsewhere in the display stack, making
  regression risk very low.

Suggested follow-up: 1) Run the relevant FPGA/Navi12 display init test
(or the scenario that originally crashed) on the target stable branch to
confirm the NULL dereference is gone.

 drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
index 9d3946065620a..f7b72b24b7509 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
@@ -3129,7 +3129,8 @@ void dcn20_fpga_init_hw(struct dc *dc)
 		res_pool->dccg->funcs->dccg_init(res_pool->dccg);
 
 	//Enable ability to power gate / don't force power on permanently
-	hws->funcs.enable_power_gating_plane(hws, true);
+	if (hws->funcs.enable_power_gating_plane)
+		hws->funcs.enable_power_gating_plane(hws, true);
 
 	// Specific to FPGA dccg and registers
 	REG_WRITE(RBBMIF_TIMEOUT_DIS, 0xFFFFFFFF);
-- 
2.51.0

