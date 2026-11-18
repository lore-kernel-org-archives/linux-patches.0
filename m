Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019161;
	b=tDWGBVOawo42vHvwAhCmxELz6InPUdsV8du1/V5JCl0DkVgyq+vauzjGyLQIz2FRmHen
	 8fv40aF4jUIjtqp/dkQEmOXTnvr7HC11Pf9qbtr46JL9nsaUimjnYBXdNz18IJhYFZyhj
	 +b5G3GrNBFSD/Eu7PDvfYh24gPt+e03HREMHc+GqlsFpXYbDTqQ17/ixmIOOtcFuyR+Kd
	 j05EwdPxLnnjhOGHpyMyve426imdxvz+/gyATo/7ceo1wQq/fr+JNF+qR3f3W3NUdLDHI
	 HHPihqRWFf2421fqIbGhNm8pZAthJDX66rt99BF+RIA+3Zq0liNaEqsr+fn6l3qi9ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019161;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qhUHpP3cszy8VVyUqrEfcqta07lrbrW40vUoIhW+Pfg=;
	b=EfmdwjyG/oiB8p2b2RWAFhWwSGjeCNT/wJJkSRTEjEUxB4gpEaYvUnbRPpJD/O0n7hii
	 iEY1MjliW8gTx3e/Drxb1aBk1pLS9H7mM8kQ+3TZtbbnsTihCPHG6BVR8znxdHyjLPg0s
	 DMt3aTARCyES3ZkXx4rIrI2g1IQGxTOf3u5MeS9+zzcP3Va1QoOUjeE1j0wnbLjivCjCh
	 TsLolsEENNpFfJP3Ea+9SL+iCrvGS26WDz7agZOLvBrhO1JwskyvusoZT7iHKUgKgEFwZ
	 MMZtvhbOEnTsYi9vqi+69Lb0TpMwRMmHl205S9yFezFP0BMgTp+EuZTghnuE2bmhb6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bE5YlUgg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0DE606A325;
	Wed, 18 Nov 2026 16:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bE5YlUgg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 092B51F000C6;
	Wed, 18 Nov 2026 16:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019160;
	bh=qhUHpP3cszy8VVyUqrEfcqta07lrbrW40vUoIhW+Pfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bE5YlUggFe202pL+gnPkqPBws47b8fxEh7lh19LaEsTGZRInX86IaDXbWd09A2253
	 apoYs60LiSQqudwkm9/3Y8LWLijMQLa6Lr2zcsgb6vBVJU04X8uVBHo1aXX/y3jL4k
	 7/90W7Ng29NmEfPLCnIwJVbmIKfzTMHSR8f5Gu/0=
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
Subject: [PATCH 7.3 1498/2651] drm/amd/display: assign missing trace entry in amdgpu_dm_dc_clocks_state
Date: Wed, 18 Nov 2026 15:45:38 +0100
Message-ID: <20261118150341.949389491@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index f33a2c1e0da5f..cc70aeb757980 100644
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



