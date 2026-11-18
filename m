Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031215;
	b=psh2XeTgzl0LfetGWTdZ+ViDAvVmS/I+4lGBPwGgQTcLaS3jm9HhAk4h/pKz+YvlikSj
	 Lr5Efpol5HkWflh7sgczBozUTFM2gGGrroasZI5va+6NRVQn3vA0/FGcCelpj7wEOPByC
	 yaiWU2UWkbjYrtOtT/7MnbdyzUG7HWs7G75q+ZOt/vs28ZcbxeVwMW99YM1aH/8vl0mbs
	 gzj268gft6cLi4/jWn3jynAl3sJhR7cyZ0bEICWMmNqGgb6v9Lyy3snhHZKvgY1ZI8KcK
	 ChStiVl7b42MyxsFfm4gZHeefZmVHzZ2bx2imei92+BMbkz2md4pwwP3BsSG8Pkj2Xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031215;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PY01mEzYjO5sqCzOGUmML5T4Z9Vyu3SZENCycfNQqCA=;
	b=E/ZQ2hBDdsMiXJsQfKDQaJVWi1bh6LHJJZPdWMS+s4cZFT0zASnmq/Vcc/lcHI1Fkozd
	 iUwl+mDnYDq46oaWKIlbQ7p/fXz7BM/UbYjBjX3WZcHBAziE4h4XJp0Yab+AVl1BDQwuQ
	 Xrvx94fPEngWUYj4WV23v9wet9S+CIlp5qX8NwcK0F0eYO1pB0K7e5r3bLeSwK8hOwNDb
	 Yk4v3dPAHk+ENb/qSUYPoqCpRWBaXaykOpaJGbmFg2j5gef8+1ALWrH0GKTcwKLOE4BT7
	 P5tbyATGPsTuoaDgGdQQT7j+377SfH3pALfEFth/F/IeZT4obPG2tSi2t4JKaVMwReQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hbIm7GH1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD820606A31C;
	Wed, 18 Nov 2026 19:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hbIm7GH1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15B8D1F000C4;
	Wed, 18 Nov 2026 19:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031215;
	bh=PY01mEzYjO5sqCzOGUmML5T4Z9Vyu3SZENCycfNQqCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hbIm7GH1UxSkr1LYXSVlcnzT95gaFqfTTlNQtWrqXOsiYkBh0lrG0pcZc1I3MKkKf
	 fIpDsZLN4ZIS38xU41tVMPcGfyrHt9YjYq4Bp41aAdrnn9Z4ByiCbnP7AAEK4LTaAl
	 yJAjXdJKEv3ARfLbXpVdpVFLaDtjYvSav0UNyQn0=
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
Subject: [PATCH 6.12 0981/1756] drm/amd/display: remove duplicated prev_p_state_change_support assignment
Date: Wed, 18 Nov 2026 15:51:48 +0100
Message-ID: <20261118150049.229135612@linuxfoundation.org>
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
index cbd3755ba0ebc..07a7435516ee7 100644
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



