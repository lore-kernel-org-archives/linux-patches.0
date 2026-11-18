Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026008;
	b=CO8YzoguF6wZa+wTC77sTbDJJVHDKKzU1Jj/QRi9swcNVeVxs9fi2LVMhw3Jp611a3JA
	 BRr4Gqwc9W3EGLF072nD6aPk60IlckJ6KjZn4nM5Z1S4b+smIPO1VbUWKrvU9CX07ugV3
	 YoRNqFvevPva0ctyQc4wNFoaqCCeTvuV+tgWc1/Ww7QVIorTbWiN8+xn9H4cNabwXsibD
	 Hq73y9BQPQqjiv6r/oTk4gl4bhcKK2ybrWRS0UUnQ00yJ9K1OXOb+1kejV++MjK+GTTg7
	 Zipm14M/Pj4plgruKJ+u1Et60lfufXWfZ6Y43mL/LSWxxHKFBkCDAjcRT23V0so5nyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026008;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dGCmicnZBcEJzKM7zDHb3VofrRliO3Qkziuat+oqBek=;
	b=Mht72N022Z53h1wmhm+6wNJ4z/E6sXc9RHQQuD3L2cAGaAKeIOkqfSSvbY731FHBezkF
	 o/TQGoedPboWaA4YICpYiUdBHYh6RRIFQsfoEQnqQBRJOru4/fRKGyygEpIGzJZuK1N0B
	 CcYWFguRCAuydP6CVoFdLLsqjz9fy3R+Uu1kKJWBGf0Omv5x9nAW28pR6ljUQB8Rv9ALK
	 xMQUdvf/Wl6kaOi/DfwiVgSBSxIjrqyxvLzgEybHxpe+YFPyJsRDvcXTgr4NPwZ7YRY2z
	 s+ZtSP8PsDrD4Evs9UMfmi43oEi/+rRjin7CU0GS+g0UYepit+4BYQNkNcsxY2uYcZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pesM2D7w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82681606A31C;
	Wed, 18 Nov 2026 18:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pesM2D7w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D72C91F000C4;
	Wed, 18 Nov 2026 18:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026008;
	bh=dGCmicnZBcEJzKM7zDHb3VofrRliO3Qkziuat+oqBek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pesM2D7wUhv7vMQx4YGi4D4xE0cKeH48qYSxS474ycFQfDt38nUyUzSUt755uhwmX
	 ILqkIdpAZ0OGZugzV7uQ0D98DF+G2dvLNEMBycMVoMrFoktfT0bpxGGEU11++rmqo/
	 1ZMj6Hsow0TKip573jnk1v9yJFBIHGEvqDbElh+E=
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
Subject: [PATCH 6.18 1245/2151] drm/amd/display: remove duplicated prev_p_state_change_support assignment
Date: Wed, 18 Nov 2026 15:49:40 +0100
Message-ID: <20261118150207.521516530@linuxfoundation.org>
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
index 0995522bf58b5..a4b1b86237891 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
@@ -523,7 +523,6 @@ TRACE_EVENT(amdgpu_dm_dc_clocks_state,
 			   __entry->p_state_change_support = clk->p_state_change_support;
 			   __entry->prev_p_state_change_support = clk->prev_p_state_change_support;
 			   __entry->pwr_state = clk->pwr_state;
-			   __entry->prev_p_state_change_support = clk->prev_p_state_change_support;
 			   __entry->dtm_level = clk->dtm_level;
 			   __entry->max_supported_dppclk_khz = clk->max_supported_dppclk_khz;
 			   __entry->max_supported_dispclk_khz = clk->max_supported_dispclk_khz;
@@ -533,8 +532,8 @@ TRACE_EVENT(amdgpu_dm_dc_clocks_state,
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
@@ -548,7 +547,6 @@ TRACE_EVENT(amdgpu_dm_dc_clocks_state,
 		      __entry->p_state_change_support,
 		      __entry->prev_p_state_change_support,
 		      __entry->pwr_state,
-		      __entry->prev_p_state_change_support,
 		      __entry->dtm_level,
 		      __entry->max_supported_dppclk_khz,
 		      __entry->max_supported_dispclk_khz,
-- 
2.53.0



