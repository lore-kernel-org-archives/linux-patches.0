Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049480;
	b=wqTOQUzB89Jh84xJ+c2fiuRJlY6LPoCqkEJTzj9sP7g5rqMEKe5HMwhLpybt1KJEd8Uf
	 /Tw4YVbDaY76NnRMRqOnw9OjklEHURe/DWY9XzkcxPCD00miu1WvTsypo3EYNrPn9MO0d
	 jQqOn7G9gaZA9tPTNCekN4jMSeyMCLOQtn8adLyv3gK9j73Lo0f5SxMrYXXJcr9YBfkWD
	 lyGzsVgyxsl0inVEo8uAebiMcBPuWmPR7ldVHirfJswdSHsf6c2VDFYqIpedZzqQWc0eF
	 fn8Oq6BfBgPstjnX5VIrVUakQqmjmgEXViWUeLnZrvUWEqIFb2w0mtde4HmupOMen6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049480;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YdY4rjWeP9IzEQtpfWteieh5H9Qr1hIbkGHhF4xvO2Q=;
	b=Qx0De4epQwscrn4YcVrPA7Kc1J24mIbf4Yb3zfgafNVywfUdcAvrbRksK7Tc9F1GQjZ+
	 EhEPHDcVYH47NmbkB9Jq3ZfT/PgMZGTeL5kB4+tqTdL4s5tt9qimNEpwNSXvSEnPKBbgY
	 j2DbuQCIJEmru5b9V3SjC4WNQ/cys3vIUhxjmCsU1jlOenOxbUB/uHVUt4+UaBh5PnZ8r
	 cBDZFIpyX5mH3qIYlQaOL0838uB8roytG/zF/auOYnQXu0MHznJIOglUVUipPskuQKlBg
	 35nxorBSwBE9h85k7rEQEj/vTh6c1BZXviANZ6sl4iE+VDSHu3aD4OUv20u00SD/xyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=moA75z8q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4E3606A320;
	Thu, 19 Nov 2026 00:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=moA75z8q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC4591F000C4;
	Thu, 19 Nov 2026 00:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049480;
	bh=YdY4rjWeP9IzEQtpfWteieh5H9Qr1hIbkGHhF4xvO2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=moA75z8qB9eJjZ+DSqCNSDc3FVF9NupsWtLHSxg8WM8B0Sk5KWFAR1zbFNJ2bCY2n
	 fcARwrMULnxM+Bb1owisN9yzoQvZ8wb3ysWTaBLMoyw2xXgG20bqO16VF+4ZSPfRkJ
	 6VHVjUg5ys0LnFhT9t3azfQQTP7SC9QE3PALN/1U=
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
Subject: [PATCH 6.1 2315/2857] drm/amd/display: remove duplicated prev_p_state_change_support assignment
Date: Wed, 18 Nov 2026 15:55:49 +0100
Message-ID: <20261118150324.879624034@linuxfoundation.org>
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

[ Upstream commit 11e8f72b09a6a3c0950b9558abd37559dd098698 ]

The prev_p_state_change_support trace entry is assigned and printed
twice, remove the unnecessary duplicates.

Fixes: 13b5ca42ca9c ("drm/amd/display: Add tracepoint for capturing clocks state")
Signed-off-by: Melissa Wen <mwen@igalia.com>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Roman Li <roman.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
index 048b7f9c6321e..d7813017f7c24 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
@@ -521,7 +521,6 @@ TRACE_EVENT(amdgpu_dm_dc_clocks_state,
 			   __entry->p_state_change_support = clk->p_state_change_support;
 			   __entry->prev_p_state_change_support = clk->prev_p_state_change_support;
 			   __entry->pwr_state = clk->pwr_state;
-			   __entry->prev_p_state_change_support = clk->prev_p_state_change_support;
 			   __entry->dtm_level = clk->dtm_level;
 			   __entry->max_supported_dppclk_khz = clk->max_supported_dppclk_khz;
 			   __entry->max_supported_dispclk_khz = clk->max_supported_dispclk_khz;
@@ -531,8 +530,8 @@ TRACE_EVENT(amdgpu_dm_dc_clocks_state,
 	    TP_printk("dispclk_khz=%d dppclk_khz=%d disp_dpp_voltage_level_khz=%d dcfclk_khz=%d socclk_khz=%d "
 		      "dcfclk_deep_sleep_khz=%d fclk_khz=%d phyclk_khz=%d "
 		      "dramclk_khz=%d p_state_change_support=%d "
-		      "prev_p_state_change_support=%d pwr_state=%d prev_p_state_change_support=%d "
-		      "dtm_level=%d max_supported_dppclk_khz=%d max_supported_dispclk_khz=%d "
+		      "prev_p_state_change_support=%d pwr_state=%d dtm_level=%d "
+		      "max_supported_dppclk_khz=%d max_supported_dispclk_khz=%d "
 		      "bw_dppclk_khz=%d bw_dispclk_khz=%d ",
 		      __entry->dispclk_khz,
 		      __entry->dppclk_khz,
@@ -546,7 +545,6 @@ TRACE_EVENT(amdgpu_dm_dc_clocks_state,
 		      __entry->p_state_change_support,
 		      __entry->prev_p_state_change_support,
 		      __entry->pwr_state,
-		      __entry->prev_p_state_change_support,
 		      __entry->dtm_level,
 		      __entry->max_supported_dppclk_khz,
 		      __entry->max_supported_dispclk_khz,
-- 
2.53.0



