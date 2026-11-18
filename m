Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041059;
	b=Sb0jvsLhoHzpKyJ66eahNoNbCiauKOnljAM0EqS7X3SOS/pIUeveR8zcBNoW90rFVdMl
	 /dTDscishfzJB0yxAK7OPW+RzUfSx4OE86s/NRlJwhB+GZK9rO5iUNxtoI0lyfmR0kbGd
	 aW5wKWLg1Op0DHIhy1yvhGSvdxTFkbluHnSYc3f3dia6gp80Q18IImJdSNcTj9OpB8l8G
	 fCoWLYflH9+r8axUpCJq/WBcoRs/fDFGp9T1evR4GZmipxDLAtIUjWWZOWEf1jLT7F3Ht
	 eNdaW5SEJFDiD2rRSrfOKrA0VtQ0AyqCjypsbxTHvf+byTktSXXU2UM+f3tZSbpjEOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041059;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ULi2haAkJ+XgrcmEnAsZEw+XspJfGtMnBiKpq7PVtMc=;
	b=hRjs8U+PA24R+TXqBS6QFHeratkkkEtruYB/00B9KtFyZuuz8m60lWvS4fgpA6ARMzC+
	 vPTaqLZaoIIDxnZinBC5xUBGeEdxTm/bR9efjrEnUxyRvHIzmWSNQ467xIGoi3Ou30Lcs
	 ZchbCo/K6+3aPxe8rqt5btiuwBWAempZ6U3et9ml/eLBj8pCK+B0y8nhK5pto5LzlQ53v
	 gAI9JhitmfagQM+oDQqiZzXpFQQxJKMYnFufN+uNDphcwuvYNiFAlBKN3PLWrrgNDU569
	 +CYhZACzYL+kfPP9qLX76eANw0Wlzyhme7D+PlWe8745kXXPRX9BP98LPLkidyRV7Dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r63lepaL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76441606A325;
	Wed, 18 Nov 2026 22:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r63lepaL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9853A1F000C4;
	Wed, 18 Nov 2026 22:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041059;
	bh=ULi2haAkJ+XgrcmEnAsZEw+XspJfGtMnBiKpq7PVtMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r63lepaLJP3o/jdFdzoa8aiDGeNN3eFtINCqlZdSnwqcVjzW0CVAZOBkvhn9I90YU
	 stelh99BXzVYEGs8pzU8DznEOoU0BJ6fV0ZKArHY+IjHz9EMi2mwOhqhC/J+mzKsFx
	 xg+6s7GrPlC2yC6R0sJreH5IJPLNU0dOBxP7FWyA=
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
Subject: [PATCH 6.6 2679/3318] drm/amd/display: assign missing trace entry in amdgpu_dm_dc_clocks_state
Date: Wed, 18 Nov 2026 15:55:01 +0100
Message-ID: <20261118150441.360699441@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0f580ea37576d..900ad1ab31369 100644
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



