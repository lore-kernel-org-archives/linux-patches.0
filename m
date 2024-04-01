Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E471CA8F;
	Mon,  1 Apr 2024 16:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987425; cv=none; b=eW/9GBcooNjSrLLrT6fA2YkPxpkn2tGNYmfnQHFhVCv7VHJ1WBo1yituL4DD7VYMUyLi/ACtMtURiSwx9TWDcfJwSonT2zfVC5qaYH8OHIbcRbv86UEnoOoux1HACn4YKvApQSE4n2A1JIc9e6zDt8/rVaI2J8A2cPEspt9E0YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987425; c=relaxed/simple;
	bh=zRfFba6z0lKcBriOMch5o8kxuR3w9XCa+cN+gthyLrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iJebK2AH9CFwJx2VjFKUe01YQb6gIffgDjCVBm3ZLZSn5+rPvhH20vfMwnZgA/LsVm/+jfAcrm8yFlkKgcisQOXeeYKzsg8T4Bnz1y5I8T7ooGQvijqicun0g+9XsNof8AY+9D1AGMa82bC0LhJuui89dUuWgX3CxSt/jUQ/taE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NuMtp5aa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NuMtp5aa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23BCBC43390;
	Mon,  1 Apr 2024 16:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987425;
	bh=zRfFba6z0lKcBriOMch5o8kxuR3w9XCa+cN+gthyLrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NuMtp5aaKGgQB5huNMKudc9T+TRVvvw6aH0YPP7/DwK9FVLCkftK0kgBGCeAfe9x4
	 D0O0AkUiQBcGBUQqGd83quMYekzZ1A33by0ksPYwDvyI9lYKOgrRAb3AdG/b7vzdnM
	 u73FB3bf0HisvEmorYaRPMsOpH87fJalJU8x3gzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Charlene Liu <charlene.liu@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Chris Park <chris.park@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.8 283/399] drm/amd/display: Prevent crash when disable stream
Date: Mon,  1 Apr 2024 17:44:09 +0200
Message-ID: <20240401152557.630243424@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Park <chris.park@amd.com>

commit 72d72e8fddbcd6c98e1b02d32cf6f2b04e10bd1c upstream.

[Why]
Disabling stream encoder invokes a function that no longer exists.

[How]
Check if the function declaration is NULL in disable stream encoder.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Chris Park <chris.park@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
@@ -1185,7 +1185,8 @@ void dce110_disable_stream(struct pipe_c
 		if (dccg) {
 			dccg->funcs->disable_symclk32_se(dccg, dp_hpo_inst);
 			dccg->funcs->set_dpstreamclk(dccg, REFCLK, tg->inst, dp_hpo_inst);
-			dccg->funcs->set_dtbclk_dto(dccg, &dto_params);
+			if (dccg && dccg->funcs->set_dtbclk_dto)
+				dccg->funcs->set_dtbclk_dto(dccg, &dto_params);
 		}
 	} else if (dccg && dccg->funcs->disable_symclk_se) {
 		dccg->funcs->disable_symclk_se(dccg, stream_enc->stream_enc_inst,


