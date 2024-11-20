Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293411AA783;
	Wed, 20 Nov 2024 12:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107594; cv=none; b=rp58ufdyqIwp9GfeZ+do+/psP1X32xeHafyKtsa1mfeDpG3UnHNM+0mkas40WTjs/K33h4cmIOwKr+R8y0dUk43/Gcft8hcTNtdWtoKks4a60ZGB3hVeKDemjb3qxEiK/WmmAIU1FV/SeWARaBunlaW6aD8DUzdRofoEUh7RuOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107594; c=relaxed/simple;
	bh=0iCmUTn1fTfJzA8DXDaFFCS9jnxokmScmP8ZqACvnDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HBYcwIEyqnbWx1Qewfmea8DFLBKmfjmMgXyKHjvIG3gfWPA6qRicL3AV60GAo3E5vaY3FORaxT+OysOO9jX1I1/3SFZxCGSlPKP4CY4uGUFMiBvP9F771HLm8Cw+M85gD1PRF/sYOWXvfWNblC4JsKYRBj/fUDiTC8rUJ1lTT4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C7reGzEc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C7reGzEc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A58D6C4CECD;
	Wed, 20 Nov 2024 12:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107593;
	bh=0iCmUTn1fTfJzA8DXDaFFCS9jnxokmScmP8ZqACvnDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C7reGzEc79pIf2mRmtgyeIX6Xe3tk9LjA/LRR1PiDOKjVEqP5Kyc+7NKMO+HxvjQH
	 CHT/+WTHTsJi9PUkNH1h40//SOItS2OeS4Zk27PJl0fD2mjPgh8W6btn0+mN7VtfvA
	 GzZ85uRO3Oeqz4LISpqDfN3L1dhGA+dmPdAki9W4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andy.yan@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 04/82] drm/rockchip: vop: Fix a dereferenced before check warning
Date: Wed, 20 Nov 2024 13:56:14 +0100
Message-ID: <20241120125629.722777440@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
References: <20241120125629.623666563@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Yan <andy.yan@rock-chips.com>

[ Upstream commit ab1c793f457f740ab7108cc0b1340a402dbf484d ]

The 'state' can't be NULL, we should check crtc_state.

Fix warning:
drivers/gpu/drm/rockchip/rockchip_drm_vop.c:1096
vop_plane_atomic_async_check() warn: variable dereferenced before check
'state' (see line 1077)

Fixes: 5ddb0bd4ddc3 ("drm/atomic: Pass the full state to planes async atomic check and update")
Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20241021072818.61621-1-andyshrk@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
index ee72e8c6ad69b..a34d3fc662489 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
@@ -1076,10 +1076,10 @@ static int vop_plane_atomic_async_check(struct drm_plane *plane,
 	if (!plane->state->fb)
 		return -EINVAL;
 
-	if (state)
-		crtc_state = drm_atomic_get_existing_crtc_state(state,
-								new_plane_state->crtc);
-	else /* Special case for asynchronous cursor updates. */
+	crtc_state = drm_atomic_get_existing_crtc_state(state, new_plane_state->crtc);
+
+	/* Special case for asynchronous cursor updates. */
+	if (!crtc_state)
 		crtc_state = plane->crtc->state;
 
 	return drm_atomic_helper_check_plane_state(plane->state, crtc_state,
-- 
2.43.0



