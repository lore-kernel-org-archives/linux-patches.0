Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060752;
	b=gI3rHKYuaX+bMmPpY2eJLDgm7LZN0Q4+bpzQbJsHtriPYVJmdtdmGonXBhRpZ+NlbWOM
	 y8rSpWNvY8SIbnMYwr5erwRf36cHKNoOz2B8h8Ym0PD41sJisu23B5BQ/V3v7APyeH7/k
	 FMWvVayxg6o+a+WFMru8vkjuazQbYHXASLG+ekX5cTKhFtnMROprLvArKF6xqDURLNC0/
	 RPXZ9Fuceyteizf97F7xi/MS+cWmm7MZVRwG0Bw8SSN+DAr9ZbdhDP0YZ8oVleWgW04di
	 MFHxQkZQCMvrYIF/NEJUVWe9bDNop3nkmY1OE/QwkYThe5xF4DnALCX/c8QRoYxE4Qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060752;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xgQI1e8ZfB82jr8tmb+Z7KDZ3L9j+lWiJLfa1IXMD18=;
	b=MeXOU+2Z5jtFVW9CtSBTArke8eL0oFhplcuGH+wYujCnrZ+Df8uBqXrDbA6n0CQJTsp8
	 i5KUcv0lRSi2hx6qOIbb0mxh1rX7woyXbq7oRpZ/VaUPj7eYSTpGrz5Kh/q3D1Bd2KHvP
	 mqCI1u4BGUBxCYyjt2c2/42S9hOVbsH8eQDxcfXh7I7t7N6xvS4FgImuGvNfqqaZGJSEX
	 BAk6GhYOjHzNsntdckOfGc30mI2MENDamBbpX8hJOh8+dtgvb46qevq/MCFZoPvfVTsb1
	 4S5PhZyaZNyAa11CT4Y1aGgavAC1veCf1iHoIippDntAh/+VXR5Pvc+ihbQfMsr190g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V+GeBBMD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD95606A331;
	Sat,  7 Nov 2026 14:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V+GeBBMD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03C541F008A3;
	Sat,  7 Nov 2026 14:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060752;
	bh=xgQI1e8ZfB82jr8tmb+Z7KDZ3L9j+lWiJLfa1IXMD18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V+GeBBMDB/9hgObgu2G1cvKP9sn9GGCzWg/cP+VfCkabHEqzIkKp105RuzuduBJfJ
	 k+hGi41ry+pUpfMGxXiOH+fIi0WqG0VwAPXNHcHab198/qODTvN43TxTAlG/xkvmfM
	 XZizHMcLN/G+lv32s8R3F5ey7Xw88pC+SVsK4N8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Gmeiner <cgmeiner@igalia.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0127/1536] drm/etnaviv: check all modules for idle after reset
Date: Sat,  7 Nov 2026 08:35:43 -0500
Message-ID: <20261107135001.253336035@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Lucas Stach <l.stach@pengutronix.de>

[ Upstream commit 1006d1f7c03d92b28c252333836635df8e165401 ]

While the FE is an important part of the GPU, which needs to be idle
after reset, all other modules should be idle after a proper reset.
Check all present modules for being idle to determine whether the
reset was successful.

Reviewed-by: Christian Gmeiner <cgmeiner@igalia.com>
Link: https://patch.msgid.link/20260511085148.652256-1-l.stach@pengutronix.de
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
index df0bc828a2348..d2f9ad9d9e89d 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
@@ -558,9 +558,9 @@ static int etnaviv_hw_reset(struct etnaviv_gpu *gpu)
 		/* read idle register. */
 		idle = gpu_read(gpu, VIVS_HI_IDLE_STATE);
 
-		/* try resetting again if FE is not idle */
-		if ((idle & VIVS_HI_IDLE_STATE_FE) == 0) {
-			dev_dbg(gpu->dev, "FE is not idle\n");
+		/* try resetting again if any module is not idle */
+		if ((idle & gpu->idle_mask) != gpu->idle_mask) {
+			dev_dbg(gpu->dev, "GPU modules not idle\n");
 			continue;
 		}
 
-- 
2.53.0



