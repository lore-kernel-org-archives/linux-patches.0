Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031213;
	b=Zo6VmKvAyvXb51AN6hV439Ef42MatUxufK5EfZZKatPPUku5mBH03h7AiJEybJJlFYG8
	 oRYDQhOri5ASw/EZgZMvgOx8CkPNtYyPokDWXGyxHMmN5QeHxl7y9nBgTGmpTTNMhMFA5
	 zjTUVa97F7S1KecrBaXQ4+bi7xSh7htkL4LT/wMrVMW5F8//SJR3c51RQX4YvR3Uy3o0E
	 XSyed8MdQ9avX2uLfVO4aTu3gtbMz+hpKWJa/19edXA9aZtFVlUYueblWHIgvQ6RV2nAi
	 xwnD+0Q8Cvjrn5Cl/LSTGtyL4A960fiwd5dcNtkaJTry4RDWLZZff33mZdW/ozdj2Pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031213;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KLHWdoNZIq9uewPQYQnvd3jx1UDRZ05qo2yHTOk7ghA=;
	b=XZSMr4HB8L9NYWW5fZxSk/ObJ+mr0ySTdHDZscmPyjVEp78wQ54VgDyUpLbc5vA71bEM
	 3oLGgAfYDDdC80WqWXpgQqmnap6ZEQcQY6ZG0QeKGYfpJcDoWgBJAHn3lGDGM0/+XaXEg
	 Y8Gn4IvK1YkJbHuY/DClXHo6nWje1pzmenl+Grbm8QCqRYlpKmgxi0RqILk+J121MeWSA
	 Qcaq2bvyi5YSoHXthQGKkxC94s4MaoRIvd/w9sHMzpmZptsM4Wik2tm5ntNL8cFQi/oh7
	 W7wJi4m0f5/0aHjTmrtvFP5WmUygyQ+3MXaqd54QNji75qTQr1p0CqRodRYkcJohINw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FM9hkDMS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014FB606A325;
	Wed, 18 Nov 2026 19:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FM9hkDMS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC3F1F000C5;
	Wed, 18 Nov 2026 19:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031212;
	bh=KLHWdoNZIq9uewPQYQnvd3jx1UDRZ05qo2yHTOk7ghA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FM9hkDMSMgAogta/0G5kxy9aSNWa68bGCC8ZJk+E34ewAhexEF5BzUoNPwKVTjlPs
	 wzkaU9PFniLCr3XI+6McN4XMo8xTAy4ilOAjMsh9KD/wzOrpw59Bgr6iL5+7NTL0r0
	 zOjiGUgxeZN8i5UObVYaetvhXGM4sq/TtI9JxEMQ=
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
Subject: [PATCH 6.12 0980/1756] drm/amd/display: assign missing trace entry in amdgpu_dm_dc_clocks_state
Date: Wed, 18 Nov 2026 15:51:47 +0100
Message-ID: <20261118150049.184359744@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4686d4b0cbad2..cbd3755ba0ebc 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
@@ -512,6 +512,7 @@ TRACE_EVENT(amdgpu_dm_dc_clocks_state,
 	    TP_fast_assign(
 			   __entry->dispclk_khz = clk->dispclk_khz;
 			   __entry->dppclk_khz = clk->dppclk_khz;
+			   __entry->disp_dpp_voltage_level_khz = clk->disp_dpp_voltage_level_khz;
 			   __entry->dcfclk_khz = clk->dcfclk_khz;
 			   __entry->socclk_khz = clk->socclk_khz;
 			   __entry->dcfclk_deep_sleep_khz = clk->dcfclk_deep_sleep_khz;
-- 
2.53.0



