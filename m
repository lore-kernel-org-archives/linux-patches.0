Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15AA814AD29;
	Fri,  6 Dec 2024 14:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497093; cv=none; b=MOJUMs0HewV/Htc9VD4mzlImF1kdA9dshGDA0hrV3YFWAdmGOb+booJJvQtSFuo2YmMfaW9MV1OUY3C/hlp9ugR19i2/0JAewG25P9x7b/7FDEq445gYJ5VVcdfpDvSQ+8lgJauXS0IhvoejfbypjvGLrFUVdSfQtnEr41qAVQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497093; c=relaxed/simple;
	bh=aDDs1wLZydfc8A5W8CuO6OkXbJHZG0PbgLeNsNRIOEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iNuDl1zsCynuL1+6obeJRYte/hoQi62ZXz1AK1t3t5E6ETnq3QjG3hfsL3Y06AtM01DlSTOBOvBK4Rnwsl1eanQhyoreM7q+GQNQ8KSmu7QqNfhgNvjtt5ZwME7lHOlYx23F6HpAyWhfmQzHohY49gFSSCUhOs6Yw8dAICXph7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bhU5No7d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bhU5No7d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71851C4CED1;
	Fri,  6 Dec 2024 14:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497092;
	bh=aDDs1wLZydfc8A5W8CuO6OkXbJHZG0PbgLeNsNRIOEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bhU5No7dwElEXr4pRlgJdDQHRUdBPv7dr7Q5JQqosTTBdaSseUEqcnjzIx2igP4DY
	 CNKkUDA+kbnZUu7TodIbKMD3ZggCuqX/pPSNEWPRwWJKmHbdC6KESWdzopaDMynw7f
	 ZPPZI18ahd8X4CSbPsDa94iO1eR3cTbGU3yYSrxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 193/676] drm/vc4: Match drm_dev_enter and exit calls in vc4_hvs_atomic_flush
Date: Fri,  6 Dec 2024 15:30:12 +0100
Message-ID: <20241206143700.883300231@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

[ Upstream commit 6b0bd1b02ea24b10522c92b2503981970b26d1a2 ]

Commit 92c17d16476c ("drm/vc4: hvs: Ignore atomic_flush if we're disabled")
added a path which returned early without having called drm_dev_exit.

Ensure all paths call drm_dev_exit.

Fixes: 92c17d16476c ("drm/vc4: hvs: Ignore atomic_flush if we're disabled")
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Maíra Canal <mcanal@igalia.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241008-drm-vc4-fixes-v1-2-9d0396ca9f42@raspberrypi.com
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hvs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hvs.c b/drivers/gpu/drm/vc4/vc4_hvs.c
index 27c8fb9efa854..008352166579e 100644
--- a/drivers/gpu/drm/vc4/vc4_hvs.c
+++ b/drivers/gpu/drm/vc4/vc4_hvs.c
@@ -583,7 +583,7 @@ void vc4_hvs_atomic_flush(struct drm_crtc *crtc,
 	}
 
 	if (vc4_state->assigned_channel == VC4_HVS_CHANNEL_DISABLED)
-		return;
+		goto exit;
 
 	if (debug_dump_regs) {
 		DRM_INFO("CRTC %d HVS before:\n", drm_crtc_index(crtc));
@@ -666,6 +666,7 @@ void vc4_hvs_atomic_flush(struct drm_crtc *crtc,
 		vc4_hvs_dump_state(hvs);
 	}
 
+exit:
 	drm_dev_exit(idx);
 }
 
-- 
2.43.0



