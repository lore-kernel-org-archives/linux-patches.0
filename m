Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055912;
	b=lC5gPDr3YgOwWahMUdwhwfS6MTdtgMPznvPB0kv5X8c479cosI4NzfnomeHjeqPUluvb
	 7Vh7aYXp6w7Kyd/8qCWn4IhjTBVbiY6a8ZYlDkm3xRHlJ6+UgB5/PMmAHurp1b8JCJ86K
	 hx0dcg2CUGxS1h0ewMX4haktlfboTEXEZSCZeb/OU1Bj8aHuLy2jrzQ2rXhCWD0XIegaW
	 JiZvvItzhzurx/e6xtQUoKjm4qWe56sNMhO4eQLKXHPOH/8VffYLySmkIa6gCZ3wJGvyW
	 f1uoHLNfOkQikokxWCxrhuk+9dU/IhEGUse8G0cjDAi381gGkGpLWnj/68a5dyf9z3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055912;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LSj/0uDcLQlDj00yVblmeR5SaX07AZ51Hd7a7FHf9Jg=;
	b=NpeSKkZHQ4kbs+Htny4n0FjaXeFwZQ6mHR/WG/+E56fUYl88XmF16aP/tpmKFNVL+1Zl
	 m9WcsdVUqlhFVG2KSvl5UkkB+DLUqCXxrunhBrY90eVqcCYZ4RWkwfrid6hfGYbv68ggV
	 xe45DpVdQq6U2TaQ9KKzH2tm5Tnqtl40PTIv+paeX1ex9FkYoSuLl33U/+bCMPt8rF/KS
	 nlnxeRlcrBmeKdY9wpMaPC13f6HhE1H/hRfcoq8qUHQyWYCFWn6kmK3GAErc/Ty3pm2Pg
	 s7cIuMGxlys33VXJuPNcD0GZ0P/CvGe60DABsASMJT1HYzIjNL84+pt8nD6pcN70T5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a52DzW3f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEDD6606A31C;
	Thu, 19 Nov 2026 02:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a52DzW3f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5531A1F000C4;
	Thu, 19 Nov 2026 02:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055911;
	bh=LSj/0uDcLQlDj00yVblmeR5SaX07AZ51Hd7a7FHf9Jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a52DzW3fvLJC30EodMhq3uMmr0RTiQ7WcFrWvXVvRv9icpO0mqF1AxsEqC/9Ykh2k
	 23rx4Gp0aJfTr/4wtzqqzcpQEEJhldpVSQ1Fr1sfVEwbetZX02fvmeUoMfXg6Wf+T+
	 ifivVChMYTphcFGOmyTeTvw1QvpmX96Z9VfEAggM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Roman Li <roman.li@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1799/2214] drm/amd/display: assign missing trace entry in amdgpu_dm_dc_clocks_state
Date: Wed, 18 Nov 2026 15:57:55 +0100
Message-ID: <20261118150123.471868732@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Melissa Wen <mwen@igalia.com>

[ Upstream commit ec167063dbf9fc66dc1364b6f9dd220c6742edeb ]

disp_dpp_voltage_level_khz is declared and printed, but never assigned.
So when using clock tracepoint the value of this clock is just garbage.
Assign clk->disp_dpp_voltage_level_khz since this is stored in dc_clocks
as other entries.

Fixes: 13b5ca42ca9c ("drm/amd/display: Add tracepoint for capturing clocks state")
Signed-off-by: Melissa Wen <mwen@igalia.com>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Roman Li <roman.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
index fdcaea22b4560..a8b7c4314efc2 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
@@ -510,6 +510,7 @@ TRACE_EVENT(amdgpu_dm_dc_clocks_state,
 	    TP_fast_assign(
 			   __entry->dispclk_khz = clk->dispclk_khz;
 			   __entry->dppclk_khz = clk->dppclk_khz;
+			   __entry->disp_dpp_voltage_level_khz = clk->disp_dpp_voltage_level_khz;
 			   __entry->dcfclk_khz = clk->dcfclk_khz;
 			   __entry->socclk_khz = clk->socclk_khz;
 			   __entry->dcfclk_deep_sleep_khz = clk->dcfclk_deep_sleep_khz;
-- 
2.53.0



