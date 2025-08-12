Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B2FA2FE569;
	Tue, 12 Aug 2025 17:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020300; cv=none; b=WeyoZechmjVsleT8evoSq+fp2+RhRMTh2ipyT3JwOksrLEGm+zVIhbo8fjpA8s+MPoNVTe0rucuBfUN+VdsAd8LDSOFmS2uTCs19S/Gap1axAqVwrBPGYYLicnCu4w6YSAogk9RONGChuyns+i887hKT4iknIAp+32kXm1sNUdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020300; c=relaxed/simple;
	bh=andT6rSOWPWDCfXCP7KxI+gOH7Sly9DPnvB806PiBYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lQixTpWEJa1723HxO5pkHeEuMYTUweeI9+Eza/5bLUwSrmWNRTUzUjvonh4m1KKgK+wHz9XqhK5C4wmUxkuRVzU6IOgC+x9po2rj2tpVfygItFjX4dHjYh0XTyBATZHHwJtyedXrAPaXUjFjb/+y0jubkkMV6OwOiLacX5wWhJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MY8HK76w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MY8HK76w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 966B8C4CEF0;
	Tue, 12 Aug 2025 17:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020300;
	bh=andT6rSOWPWDCfXCP7KxI+gOH7Sly9DPnvB806PiBYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MY8HK76wylX7/bodW26Nq8rjLZO3lVIKhS99ebLbgXfQ92hyegvbWVhwIuNA6QZvV
	 oI0vLDmqV0luMI5N3nVXmdG+lKXGUCh7xCmZvwHgL67/DZC14V1QZ3VYjdqzCSx7iI
	 JPU6f2O5/5HsH2DHs9WbGpCefGDJALl/VETIp4t4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Devarsh Thakkar <devarsht@ti.com>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 022/253] drm/bridge: ti-sn65dsi86: Remove extra semicolon in ti_sn_bridge_probe()
Date: Tue, 12 Aug 2025 19:26:50 +0200
Message-ID: <20250812172949.660140927@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 15a7ca747d9538c2ad8b0c81dd4c1261e0736c82 ]

As reported by the kernel test robot, a recent patch introduced an
unnecessary semicolon. Remove it.

Fixes: 55e8ff842051 ("drm/bridge: ti-sn65dsi86: Add HPD for DisplayPort connector type")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202506301704.0SBj6ply-lkp@intel.com/
Reviewed-by: Devarsh Thakkar <devarsht@ti.com>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20250714130631.1.I1cfae3222e344a3b3c770d079ee6b6f7f3b5d636@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ti-sn65dsi86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/ti-sn65dsi86.c b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
index 26a064624d976..6595f954135ad 100644
--- a/drivers/gpu/drm/bridge/ti-sn65dsi86.c
+++ b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
@@ -1333,7 +1333,7 @@ static int ti_sn_bridge_probe(struct auxiliary_device *adev,
 			regmap_update_bits(pdata->regmap, SN_HPD_DISABLE_REG,
 					   HPD_DISABLE, 0);
 		mutex_unlock(&pdata->comms_mutex);
-	};
+	}
 
 	drm_bridge_add(&pdata->bridge);
 
-- 
2.39.5



