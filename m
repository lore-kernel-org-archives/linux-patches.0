Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041062;
	b=oSYeZE5Fby5Y19pHHpLxsKnAD7pjKGbG0psz58XMo6uf2a6GMO0xvRNkVm9fgoSGzAxE
	 un22c0u0U+gYYQdvknpkAUHy9j/Md9E0Gw6r5GqAbFgELQ9NroT8VzGRQejKpR6qGr+dz
	 j3uM7zKEQ0WI1RCScY4oroW4mk2/ZIAqhbMoLVChzHZYn1NzMTN+FnlpIvYDS3mlmRQ37
	 jMOfw9ZdNoxI5VVjDCKKwr1ljxhe6wGK1YCmFZtkSFFa7Mp5Hx8IMNz9zfqr0qbUg1caL
	 kOMjMqVamAO3pdRwbS9MvxfcINjBE+C/8g2oR40tu7CvzdVGCIF/EHjavflJyuX9r1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041062;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1oOXEd9QVljGUX/GoGXiMR1DLFFOO3UacIzby3kiJpY=;
	b=u9hlgyXjsAq0upEBVOYYTfLvgUjki/mxdlQtr5lZ83nEZoCWWQFrAfBmgit64e7mDZK5
	 nX4Ea+C/ARLCvouT5O5gY07zBOhJssEqlJKfq6l859LEDPtJT3YIwqp5/X66tnXgECEPb
	 qZ3gqKoY2atavcBdLDd8sbU9RRhyXC36Jx8IoPBQQ1xI1gwFdXb3QCGYBCIq6OfQn4ohY
	 YgS6cGe7nOyog540SOMJPC8W77HnL5SR6ZeD9YRH7tzTROfFLN6W85Y0Mm4HP0PVjdTsE
	 d+oXr27WupsnLfOPem7VKfMRbVOSCGY9Dzsn4j+DoGnM9+gcZKLVh6gdswkRZuhtYxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ZzmdhIZ/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8E5606A31C;
	Wed, 18 Nov 2026 22:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZzmdhIZ/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6335A1F000C5;
	Wed, 18 Nov 2026 22:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041061;
	bh=1oOXEd9QVljGUX/GoGXiMR1DLFFOO3UacIzby3kiJpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZzmdhIZ/9kSRu6+r6fu4834vYTketw3qNMmW4JSmIAaL7fQ2n+1TfSYkEFkhvN6nu
	 KhmVNdmCjQYq6WN7b+tMJ7njb/L5aM7RRdwhrsWDs/TSHEtO/idIbUmG4UD704sq3Y
	 z8T4fWWjsFsuSc0jmHQCtc8J68H9W13CJPHuAAFo=
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
Subject: [PATCH 6.6 2680/3318] drm/amd/display: remove duplicated prev_p_state_change_support assignment
Date: Wed, 18 Nov 2026 15:55:02 +0100
Message-ID: <20261118150441.386854664@linuxfoundation.org>
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
index 900ad1ab31369..058a060c04be1 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
@@ -522,7 +522,6 @@ TRACE_EVENT(amdgpu_dm_dc_clocks_state,
 			   __entry->p_state_change_support = clk->p_state_change_support;
 			   __entry->prev_p_state_change_support = clk->prev_p_state_change_support;
 			   __entry->pwr_state = clk->pwr_state;
-			   __entry->prev_p_state_change_support = clk->prev_p_state_change_support;
 			   __entry->dtm_level = clk->dtm_level;
 			   __entry->max_supported_dppclk_khz = clk->max_supported_dppclk_khz;
 			   __entry->max_supported_dispclk_khz = clk->max_supported_dispclk_khz;
@@ -532,8 +531,8 @@ TRACE_EVENT(amdgpu_dm_dc_clocks_state,
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
@@ -547,7 +546,6 @@ TRACE_EVENT(amdgpu_dm_dc_clocks_state,
 		      __entry->p_state_change_support,
 		      __entry->prev_p_state_change_support,
 		      __entry->pwr_state,
-		      __entry->prev_p_state_change_support,
 		      __entry->dtm_level,
 		      __entry->max_supported_dppclk_khz,
 		      __entry->max_supported_dispclk_khz,
-- 
2.53.0



