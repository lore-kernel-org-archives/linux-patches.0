Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031218;
	b=YzZ82mxyZLjfCOChSCLoWqGJpjRUSMnNB3TVj/xJZlW7WQBdpyRo2FxPi3JzW9Y/dUW2
	 V9Fx50o6l+fn9VJ6YhObr/9Cm9e2xoF4RWUESaibNhvAWmCGjtxaiZlKvs+er1RmToume
	 /yYsrDPjNrRNdeShvLo9q0LE/ugyPnDDe9KD+SRmXEBzWe/KSADtpjNMPmPbMlgGVMTcG
	 NpNBtGMO8Z4aaBiKvNiFEe9iuXF0JDrzo35sj76CZ9RMrYTHdEWRfCps1elg3dvtGbo6d
	 nRT7B0arQ/q86ca2Kl7BZxJb62F2TFs4mqgGBBtkFDl2izrEppoo62uDwEGiaI3TqHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031218;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PppssSiAlqAbZ6f9t1htCpFrN5e8ugQSJ8DILCenb/s=;
	b=y+boE/+s6oYrntsk1+gwH2y3MG/LA0WBGKmAENBHHxnLH7cZjY64od37obOkZ2t7PWTw
	 GcThBj+6pI3sip300SJ4iQTZYh+eP4woN6GzmtSwa25AV00J18porBHHafClVW6W7loep
	 lGLynluGlZFEevDK3d9Z/F1eETQUmP7lQXvS+ouOa+t/XHjyttnqF57tS6B3FeAxRfRWp
	 ouYPWiRYqq8jLfIQA940mjQka6owlGrAJ2ixDwSSc3mJIa3Ask1L0jbCotOZ7XEQ2nXWf
	 7dN8GO6cyqOBJLYky5vgE+ZcAqVhGZYJ4FW49s9/V7sdCrRrXQZkGC0m1dci3pKTtPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="KV/XYq8E";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A162606A31C;
	Wed, 18 Nov 2026 19:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KV/XYq8E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3DAD1F000C4;
	Wed, 18 Nov 2026 19:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031218;
	bh=PppssSiAlqAbZ6f9t1htCpFrN5e8ugQSJ8DILCenb/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KV/XYq8E+DdIz5iWV3WOsFu8/pL25r/PSiDrLopcVTUdPKJw3m0CZAmBezRXTq4H5
	 /zCF1FZj631tj7mwPKOnARJkPm53bglwwWS60973uQghjXjX+vIPNjiuec3w7ibvmN
	 5Bkr8x38fmE64owHw6mxR5TgfKP+zZh1Pc7/hNgs=
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
Subject: [PATCH 6.12 0982/1756] drm/amd/display: fix vready offset assignment in dcn_optc_lock_unlock_state
Date: Wed, 18 Nov 2026 15:51:49 +0100
Message-ID: <20261118150049.277792950@linuxfoundation.org>
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

[ Upstream commit 3ad7f4ca58efd6c1216632c50873dfffdefbe3ff ]

vready_offset is captured by optc_state, but the trace point entry is
wrongly assigned to vupdate_offset. Fix vready_offset tracepoint field
in dcn_optc_lock_unloack_state to record optc_state->vready_offset.

Fixes: f1943a51f0f9 ("drm/amd/display: Add events log to trace OPTC lock and unlock")
Signed-off-by: Melissa Wen <mwen@igalia.com>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Roman Li <roman.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
index 07a7435516ee7..3151b9b9ae360 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
@@ -700,7 +700,7 @@ TRACE_EVENT(dcn_optc_lock_unlock_state,
 			   __entry->vstartup_start = optc_state->vstartup_start;
 			   __entry->vupdate_offset = optc_state->vupdate_offset;
 			   __entry->vupdate_width = optc_state->vupdate_width;
-			   __entry->vready_offset = optc_state->vupdate_offset;
+			   __entry->vready_offset = optc_state->vready_offset;
 	    ),
 	    TP_printk("%s: %s()+%d: optc_instance=%d opp_count=%d max_h_total=%d max_v_total=%d "
 		      "min_h_blank=%d min_h_sync_width=%d min_v_sync_width=%d min_v_blank=%d "
-- 
2.53.0



