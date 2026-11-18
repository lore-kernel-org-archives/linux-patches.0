Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049338;
	b=fEPHzDYdMw5hpI394dJRuI8bB5Gh845n1MaDXkKBr2/YxcOlQPcLl7CgpnGKpz+aiHU3
	 qGaDrzIaUN6U0gC7XtQBVMMzZS5ifsgDEQOuIg6NEOcLfyUQyyWaS/sgOtXLPfDy4jYmE
	 pj9rUyTOOHdQUx2ZebEJvtv8dmG4HmDekGmOIZDhPEftiDlnWzBAEepkqVPNWq4bHDE6I
	 ngtV7Exsk8USJVFkuMCe1ESPA2UUHHvO0POBhrb7thsKpOGTHS8cQsVETMFm4OxvaGbOv
	 w6Vx+YyPwkDzJovDHgJswJoKRczmsG+q+mtRWjEne/bpLXLMvuucalQUJs1sgg1oZOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049338;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QraIjJHb6gSoNsnapUmk3Zp72kD5xJq94krmTr9TG7c=;
	b=zJWQbu2hOu3z/WzExeeZIP93+qCGMfGo4A3hL4+d9ylWBILwBX/0qTuw+GHO2UNN+NMI
	 VVGsIVmlHyLHI+uXq2d/+A8sttSSvYYtguPlPPZhoCMCD+x3yEiY9HvQ1Oc1ftsfCMsRR
	 ueZlvMJxverj+NdoJlDZpG/6/xu9HEVU12upvydsBjBR2CERUz+9X7kZ7H1Cc6Pa3C8E7
	 M7wCG7FQTcjrhQd3AGnxPILUtVncTkATZz5KPwCg3CKRBD7TWWZDLbBG90qMZj6gdOwpV
	 Jwy+yxo97Oxh02fq5T7WC0HcPJa0TL6J8gHUNRWk5NmkBjDWX5zJytyq0SGeM/KkcQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sZyzfDO1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09F0606A334;
	Thu, 19 Nov 2026 00:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sZyzfDO1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B9061F000C4;
	Thu, 19 Nov 2026 00:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049338;
	bh=QraIjJHb6gSoNsnapUmk3Zp72kD5xJq94krmTr9TG7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sZyzfDO1vCCW4BoZZtktcYENfsOZzbqoT/kHLT1MpB1AzCBaQJReeSj69FdZvPmOz
	 Bw5YkXAhqCDnQOkKae9rTJZn5ryEmDkZzIJQ3cCUwZp8RfN+CA9jn0yNE/F3mromdT
	 Q7VLaIZxzg7cer29PtG07EzRc9hrAyCoE6LFa2V4=
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
Subject: [PATCH 6.1 2314/2857] drm/amd/display: assign missing trace entry in amdgpu_dm_dc_clocks_state
Date: Wed, 18 Nov 2026 15:55:48 +0100
Message-ID: <20261118150324.837990327@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d3bc9dc217717..048b7f9c6321e 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
@@ -511,6 +511,7 @@ TRACE_EVENT(amdgpu_dm_dc_clocks_state,
 	    TP_fast_assign(
 			   __entry->dispclk_khz = clk->dispclk_khz;
 			   __entry->dppclk_khz = clk->dppclk_khz;
+			   __entry->disp_dpp_voltage_level_khz = clk->disp_dpp_voltage_level_khz;
 			   __entry->dcfclk_khz = clk->dcfclk_khz;
 			   __entry->socclk_khz = clk->socclk_khz;
 			   __entry->dcfclk_deep_sleep_khz = clk->dcfclk_deep_sleep_khz;
-- 
2.53.0



