Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025977;
	b=r3yPmhx4D1A3KdbmLGCe8aBHGPVHn9wzUE536An/auzk6katlNsLmEnBFhMdw5ufRomA
	 etxwuhdq5Ymm25fAH3CG5WAyW1S7Om4WMIBOymBJWbeHSWJkZpTuKiF+1AYzgrU8Im5TQ
	 idgNATmREjW9pBT9BR3SZmGJMAwZ347iHFMvi6VadH8NOOg5qAhgka+YzWxbHy1qWwqHg
	 8O4BNZnTl870dwFgmthJMbmTHWN9jyFkRmtvQPDZMHZB5rcYapK6IkV17Ehi5uK8/1l+I
	 BRZ/1jd2fXvfGHhs3gHDNXagDRB2Rh6QQy/PjA8B+F4wGMxJNRF4/7dYy0PqeTWCrUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025977;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hA8+TgzDCU3mOwR16CslbcSM8a6MUt0vzx6Ooig1gBI=;
	b=zirPYyMTWUhBcGh3tE2t3Yr7yfC7rRXnH4ScgXvZAWQFn/dnJAuP1E3WQFj2Q/ub1+ED
	 GbZDg6YYch1phxepGl9FSahhtSF6lD5rFn8mIX++bmkfAlMijMYBlKOOIZHZaYSncQ9f8
	 MWwgAnuJlOGsNi6UlO/WuPdqEqppcSi8MV0w73gt8/JhWsoLCztm9kPk5ZPTbgC7qiO4i
	 6BhptH/pH+thA/8z0SqsEO/ViVtEd4DsZdXzIrs11i4z+yFtc8rPrt+HhPqNzCw9xtsyh
	 60ySRz7+ZDXYqZ+nEJtn5VxzkXYZr5/Qb8R4UA+pWevq356dSiEKU5W4S/O8/4zwSVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1SRL9LTZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918BA606A32C;
	Wed, 18 Nov 2026 18:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1SRL9LTZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF2AD1F000C4;
	Wed, 18 Nov 2026 18:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025977;
	bh=hA8+TgzDCU3mOwR16CslbcSM8a6MUt0vzx6Ooig1gBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1SRL9LTZyUw7wBNgrrbPdiHy1LKzPJso+h8verWw6py6tl6O9Z22NLadGg2HtVNcJ
	 lUAD18h/P6UxwqGrEIBfQ5WLevpqhflAvYNFUmJusQCO0N+n8vaNIEzKvBrBAbc+Po
	 FKcMSe9rmB2tgQvzffrjXnExJHwf77Wo/XCorCbw=
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
Subject: [PATCH 6.18 1244/2151] drm/amd/display: assign missing trace entry in amdgpu_dm_dc_clocks_state
Date: Wed, 18 Nov 2026 15:49:39 +0100
Message-ID: <20261118150207.485042035@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index aa56fd6d56c34..0995522bf58b5 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
@@ -513,6 +513,7 @@ TRACE_EVENT(amdgpu_dm_dc_clocks_state,
 	    TP_fast_assign(
 			   __entry->dispclk_khz = clk->dispclk_khz;
 			   __entry->dppclk_khz = clk->dppclk_khz;
+			   __entry->disp_dpp_voltage_level_khz = clk->disp_dpp_voltage_level_khz;
 			   __entry->dcfclk_khz = clk->dcfclk_khz;
 			   __entry->socclk_khz = clk->socclk_khz;
 			   __entry->dcfclk_deep_sleep_khz = clk->dcfclk_deep_sleep_khz;
-- 
2.53.0



