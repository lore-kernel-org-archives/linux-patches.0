Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2CF3369D64;
	Wed, 20 May 2026 16:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294957; cv=none; b=JuqthXWZqNJngGkGHMxndQUaOz63kx7c9pE87flHUEmdBp/RN4DJQqIgskA4QCzgd2Rey2acqvuyaaI5nmtAbxTrDsQQjjWTy9FKoQqH26VhSUO+Z8IWLjsmSdJzKo5w6gNhKaTxtPbYnzTZP+/W3BzIKDXAFXhDvwaiCJeN2JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294957; c=relaxed/simple;
	bh=PwVev8MQ5Yj5SjItCSjbEnRHr1F5yp2t6biU87xDsmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lTZG9/Sex1t9/p9xbFAm1d9CANus8e19Rqf3RvYqgEWddm/TN88BEOin6Hhej/k0lToG8fdTeOn11P3ITEaQwKTIjEPM6FAret5L7sIuV2SjPXazm5jddZoK8StGoZbNXomLxdRdnOapn4Ap040H95Zv/L6ELQHM/KnkuEbnEG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=biZgWiaS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="biZgWiaS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 528091F000E9;
	Wed, 20 May 2026 16:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294955;
	bh=d3qbTJe3iXplJ2BLBDzzp2NNF9Uu5KXyL0BAfSW2Hfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=biZgWiaSATufTdllOzFeoPFzzfZQ7SZ7HJUfnhzAOcj3z3uMIgrXtFqMGD6aqy21s
	 9lBvBYKN7i4Bl/jjYCbA5FS/ep8xbU4lZqiPV5adcBhUtFX/BOGxzHO1k4rjweLUce
	 GRhZ8Wk1KxRg5QLSUNelwpV6s1ZrwMs6AsWC1CJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wens@kernel.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0236/1146] drm/sun4i: mixer: Fix layer init code
Date: Wed, 20 May 2026 18:08:06 +0200
Message-ID: <20260520162153.586929564@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jernej Skrabec <jernej.skrabec@gmail.com>

[ Upstream commit 744629904c68bde847c31819f23482d09152f810 ]

Code refactoring dropped extra NULL sentinel entry at the end of the drm
planes array.

Add it back.

Reported-by: Chen-Yu Tsai <wens@kernel.org>
Closes: https://lore.kernel.org/linux-sunxi/CAGb2v65wY2pF6sR+0JgnpLa4ysvjght5hAKDa1RUyo=zEKXreg@mail.gmail.com/
Fixes: 4fa45b04a47d ("drm/sun4i: layer: move num of planes calc out of layer code")
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Reviewed-by: Chen-Yu Tsai <wens@kernel.org>
Link: https://patch.msgid.link/20260218183454.7881-1-jernej.skrabec@gmail.com
[wens@kernel.org: Fix "Fixes" commit hash]
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun8i_mixer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/sun4i/sun8i_mixer.c b/drivers/gpu/drm/sun4i/sun8i_mixer.c
index ce9c155bfad7f..02acc7cbdb979 100644
--- a/drivers/gpu/drm/sun4i/sun8i_mixer.c
+++ b/drivers/gpu/drm/sun4i/sun8i_mixer.c
@@ -321,7 +321,7 @@ static struct drm_plane **sun8i_layers_init(struct drm_device *drm,
 	unsigned int phy_index;
 	int i;
 
-	planes = devm_kcalloc(drm->dev, plane_cnt, sizeof(*planes), GFP_KERNEL);
+	planes = devm_kcalloc(drm->dev, plane_cnt + 1, sizeof(*planes), GFP_KERNEL);
 	if (!planes)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.53.0



