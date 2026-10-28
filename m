Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211217;
	b=LktGoynCr53AJTfMFBY163/+KTfBwVHqZuYiiW/9lEnTLUQcba9buZsEqJ+kk6rEY4xo
	 Y60Sse4oqDAOIdFZ2zh04k+Zf0R8CT3rr5+Q3Fo0y3LbUI9H3EeRiuodY8wy3NRNkwjYp
	 MN9W9BtFVbRWv8Wv3p6sWxuX+mwpI75Q5XZGFBGEoz+7sa/fsMoOXbM6KBrGlJAQ6hELY
	 vBNToWSX6kd6Fe4N7ktpDr5MQQoWOyTEwFhJdpka1c5wTYt1V07Ot8oEKXAZ2/2Nx41Pf
	 pHsb6YVPPOJxq17OhPGx0fK4MoDxQU22T1+NOdTP1OkdE5fr0rMvyVaEUMQWjbw25iQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211217;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nXIMFH3rPTlk/CRmbR/HkSAqHKDAq7Fgw0PCDUyTXq0=;
	b=3zafWQlFrgUw/R9zivSbUlgNG3v1SxndyT3/zSI+eSUpAVmZUNAAIokIdIaHezfOX1Os
	 EQNhnM3drpFEZeLjO493+aEEqNMpqmAAYh8hUif0p9IhuflAiOSB5v9i6pKGVJkRdPiiP
	 JExj1d3AsXh7rVHrXv9o9lBwhU77Yz9fB4kNgADq4L2H17hm4BNWZsFHKiPt1QXNX4Etw
	 17A2pgUk/A5RuXLQFQPrrCDURQxZmVrmlEI0imsG+R6/wVMMnGWqViDsa9cPGmfAiKSUW
	 bOUTKaqH448clCsXthT+YDxOqChy8k4s7O0nYcGScXugAdRDZvXg1yzUuwmtnpgHISA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="wJ+a/3Xv";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40068606A96C;
	Wed, 28 Oct 2026 18:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wJ+a/3Xv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B0D1F01825;
	Wed, 28 Oct 2026 18:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211217;
	bh=nXIMFH3rPTlk/CRmbR/HkSAqHKDAq7Fgw0PCDUyTXq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wJ+a/3Xvg8w2DjSs7LHcKOyVfXePBNa33OKyR/VLhQ32xkfed4i5stnISIZzb8vTh
	 m5m8n5q79okLjkVIbGpY86aGDbXcy38kYE0PHnU4CyojvDxSAWMwZm017aEjzsKD2J
	 znAAVD6fZ+35KswD9XKYQsh6GGmVP9vDAlfoMOdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George Zhang <george.zhang@amd.com>,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 299/571] drm/amd/display: check dc_state_create_copy() for NULL in dm_suspend
Date: Wed, 28 Oct 2026 17:57:26 +0100
Message-ID: <20261028170015.093868564@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Jiangshan Yi <yijiangshan@kylinos.cn>

[ Upstream commit 015e72cde567d2450e282c2790773463156b2d0a ]

dc_state_create_copy() can return NULL on allocation failure.
dm_suspend() only conditionally skips dm_gpureset_toggle_interrupts()
and continues execution, returning success.  dm_resume() then
dereferences the NULL cached_dc_state in link_enc_cfg_copy() and the
following dc_state->stream_count loop, crashing during GPU reset
recovery.

Return -ENOMEM immediately if the copy fails, so the caller aborts
suspend instead of leaving a NULL cached state for resume.

Fixes: 8092aa3ab8f7 ("drm/amd/display: Add null checker before passing variables")
Reviewed-by: George Zhang <george.zhang@amd.com>
Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 84b6d7932fdd2857795a257f9f258562a3cddcab)
Cc: stable@vger.kernel.org
[ sashal: Adapted dc_state_create_copy() usage to dc_copy_state(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 4530d22139355..288ef18e70d05 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2440,9 +2440,14 @@ static int dm_suspend(void *handle)
 #endif
 
 		dm->cached_dc_state = dc_copy_state(dm->dc->current_state);
+		if (!dm->cached_dc_state) {
+			drm_err(adev_to_drm(adev),
+				"Failed to allocate cached DC state during suspend\n");
+			mutex_unlock(&dm->dc_lock);
+			return -ENOMEM;
+		}
 
-		if (dm->cached_dc_state)
-			dm_gpureset_toggle_interrupts(adev, dm->cached_dc_state, false);
+		dm_gpureset_toggle_interrupts(adev, dm->cached_dc_state, false);
 
 		amdgpu_dm_commit_zero_streams(dm->dc);
 
-- 
2.53.0



