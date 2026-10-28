Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214031;
	b=P/b/RKG4PDv0ybiMQFN08e4XC/hT70o/Z2qH5MKpE5E/3UnViVbtrmMxWzHhkFKLOkkM
	 fdPtfLtFq2FLajXv/S++lKg+KoBV8qnW3OxhGl1vTHoXwF8vBguPKMncwY3Ypgo8jcsMd
	 0vHLzfZ2YZY8iMZ5kDzdJ/hV+4rDKZHOlH+qbnjUFWfVEmumRMMQFvslk+mIn012r0i2u
	 0EvNiK5hyW+zUtoeOxOv8RTezRWUD/21Or+1E1/CJxv34kJefl61N8cKmg37cohCKkWAE
	 WXUGpvey6DBEW5gMJyDulhXEQ/sIdc5GoqUjZrSVtvGpeU1xRwiusnFUYh0DMBWuDVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214031;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HSXIjuBz1oEIkpdK92E+5aFSz/lXgQMOmMGpuN8udOA=;
	b=CQTlLgBP4dHBeBoSYuR4CN9hmtCuxnBVgUbLMbMrFgA9s3q0zdgif0niOhpKAdP2BB8Y
	 Ze/7p+bXvuYUOwGo6nGAik9s7kyawXa+yNiYRhfxDwhnrqB7nZLTcs4XUeS1ek4eJEwL9
	 EaQQpudOnn6jzRV46vR+6ci+iBBNAoiQZuMVquwHWDKiKhuaKzYT8yKDLBAUqkBY2Ta1D
	 Zzi9HNLHjB0MFQxQJoPqmi8Q+FUDdGYFlSG9qZVbiRZsqk9swbUnbcnwb30A0hllDhRPx
	 lsKULUNRWXRKgHANWNoumJjHRH4mx5zyCRVFiII5wJQUp1yS2VcF2AvvLDm8rfOGQ0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e0Y1SUTh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2ED160A381B;
	Wed, 28 Oct 2026 19:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e0Y1SUTh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4311F01828;
	Wed, 28 Oct 2026 19:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214014;
	bh=HSXIjuBz1oEIkpdK92E+5aFSz/lXgQMOmMGpuN8udOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e0Y1SUThKWTPWB96xBhcCZr3+xH3KpkWuiOr1AOxDWmz4ZiWH/FQydgzkxsw2PK3d
	 9tqkMtPxMdAjNvkUUmbyT02fxWKXj+eCWhROb43Sbr3SDkTRZwaZixqzntqc4shUpA
	 8GiXndbJHKQ5UbtOYMPy/WVz+rasIH++G0Sblbcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Jerry Zuo <jerry.zuo@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0672/1887] drm/amd/display: Check null pointers before using them
Date: Wed, 28 Oct 2026 17:46:08 +0100
Message-ID: <20261028170514.704516981@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 1ff12bcd7deaeed25efb5120433c6a45dd5504a8 ]

[WHAT & HOW]
These pointers are null checked previously in the same function,
indicating they might be null as reported by Coverity. As a result,
they need to be checked when used again.

This fixes 3 FORWARD_NULL issue reported by Coverity.

Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Jerry Zuo <jerry.zuo@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 53ec5f3a8e6f3..14f2cfcba5f65 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -8628,9 +8628,10 @@ static void amdgpu_dm_atomic_commit_tail(struct drm_atomic_state *state)
 
 			DRM_INFO("[HDCP_DM] hdcp_update_display enable_encryption = %x\n", enable_encryption);
 
-			hdcp_update_display(
-				adev->dm.hdcp_workqueue, aconnector->dc_link->link_index, aconnector,
-				new_con_state->hdcp_content_type, enable_encryption);
+			if (aconnector->dc_link)
+				hdcp_update_display(
+					adev->dm.hdcp_workqueue, aconnector->dc_link->link_index, aconnector,
+					new_con_state->hdcp_content_type, enable_encryption);
 		}
 	}
 #endif
-- 
2.53.0



