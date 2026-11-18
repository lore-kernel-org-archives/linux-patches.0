Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055914;
	b=XzFuLZkyvGxl8Iz3jSs+R3+LDeO5LXTmc+m23qGEiPOk2YFWQFUdMK9OT4k9gzoYOvS0
	 AXvOSU1TCy7VXCsutpr6XQPjjeAq+oby8+56KUAC/N6PIj4WZ5wu+y3j0PtrhTFLvBVnB
	 AMB+EgQtuZV23V5ZVvuRaFDe5RE7sU7sa36nmPwPP9Q7+zAS08KbGmuHHXxXdIC8YKB2B
	 DoFLauAS/oiTqpCDu6A5rB3VFrpGOz+hcKNoUuwIdxgS2GCJB/GPEVpURggRtnuK9gzV1
	 OHH7YYomODftwa3KFOk7/IS5jcC33bcVddOkemSQuaZjq02cPnKpDZJOK9/IbQ3xYQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055914;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CrXCtCL3vYd9Z/R0mkJZzNqjwFJc8qwo3UdWBCmlnO0=;
	b=KTT62OM7i6XCGTI871zmpndvhGKjppYn2onyEYDxMpRhW4Ak+h21m7ALQ0SSP3SYUBEt
	 P73KDaxUlQ2zn80p4ZQOMltuosRcOmRvyvWg9mdD100Ms33WbRQ1oKtr9j6sojPjqFb+s
	 PLdPpPzFoVQgfZ44bpS80EjLWalTUWh8Gbi98ik6v3dhu/+kPW6EE9+Ei17FMUvviLttJ
	 m3kJWwhQfSeRUi+vBD28LdhMZGPhmfD2i3RC20FCPJfNlz5CpBBrVldOMxgBpjpofIODU
	 yPbw/pl0E32XC6wtszZczKmvfD3nzJjSK2FEmF2uGRi1fo9HPiF23MEnBrWqFdw+wsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cIrXyxYq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB9C606A320;
	Thu, 19 Nov 2026 02:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cIrXyxYq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 301A31F000C4;
	Thu, 19 Nov 2026 02:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055914;
	bh=CrXCtCL3vYd9Z/R0mkJZzNqjwFJc8qwo3UdWBCmlnO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cIrXyxYq3BogEDlnoOqAS1NxdLXn4GLijq7V765rcNabhVu9CF9fwG78r6VTG4zVC
	 xlcg80/OBanSTu2e2UXMcYDrA+zPUtaIzZ1luJknMT5cEr6VGyVSGxJ0JxBdG563Sr
	 vz7Bp+v1c376u/g3X8pSMOn4eRUJJS5dmm+3mXDk=
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
Subject: [PATCH 5.15 1800/2214] drm/amd/display: remove duplicated prev_p_state_change_support assignment
Date: Wed, 18 Nov 2026 15:57:56 +0100
Message-ID: <20261118150123.508808031@linuxfoundation.org>
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
index a8b7c4314efc2..c344a94402da7 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
@@ -520,7 +520,6 @@ TRACE_EVENT(amdgpu_dm_dc_clocks_state,
 			   __entry->p_state_change_support = clk->p_state_change_support;
 			   __entry->prev_p_state_change_support = clk->prev_p_state_change_support;
 			   __entry->pwr_state = clk->pwr_state;
-			   __entry->prev_p_state_change_support = clk->prev_p_state_change_support;
 			   __entry->dtm_level = clk->dtm_level;
 			   __entry->max_supported_dppclk_khz = clk->max_supported_dppclk_khz;
 			   __entry->max_supported_dispclk_khz = clk->max_supported_dispclk_khz;
@@ -530,8 +529,8 @@ TRACE_EVENT(amdgpu_dm_dc_clocks_state,
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
@@ -545,7 +544,6 @@ TRACE_EVENT(amdgpu_dm_dc_clocks_state,
 		      __entry->p_state_change_support,
 		      __entry->prev_p_state_change_support,
 		      __entry->pwr_state,
-		      __entry->prev_p_state_change_support,
 		      __entry->dtm_level,
 		      __entry->max_supported_dppclk_khz,
 		      __entry->max_supported_dispclk_khz,
-- 
2.53.0



