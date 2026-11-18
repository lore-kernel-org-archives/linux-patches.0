Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052306;
	b=WJL1V60qe2LQfWMwFDekrgRFEdDrd2Pm5hkA+qr3tDbVCrgJr848Bs0oCkpGpXxtn3KT
	 6n7kOxxwyBlsWd+AKIpmmqId8j0gLue0Vjf6qyMATwJStsU4Cnow78sB5NpJApoUGA9rk
	 nwRwuVIAbAq6p8M8W6GBa9Tssu4rK0FvvFnULx9lVFTpPowyCZ3ecswB8HIB9Cl5SycGG
	 hgcutVknhCuzn2xl5CC6pL7w9oy7Fy176PUBWf89HO1dE8M+w7WqQ/VoOAMRfvtZcW62n
	 BunWECF5fzIMRvzWsE0JaNO5vv0kRpQRqQ6BgpPngwss6PAsGKF9R1dACUNSLxDnQDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052306;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TzN28iyKeiUc+j3F2j/VMFISFN30m3hIo2MvOr1FjUg=;
	b=5h/iCn/qhIm8b+9fbrzchPhpKw5s9rFVmOw46Hm43reVZTJnzAioxn1M0//JT3PWwMpu
	 0WWJXJxlahQZkY07NCRShbc2s+YwnZNzxuVSV0upalEc2WQhF5lVEmz876lmpMk0Bew6n
	 eowAgqiZLEnTYS1Ez8hBKEEFJiFLZsCvCXSbnxO/d2HhNfP/vyR9dNRCue5I/zx7GJsM8
	 EibY0kVKBhFR0Q+XVRywvNi/3/xeYOdCJi6KWzcLrLRn+j6Q2A41tnqnqlARqbc3i8yTP
	 8mhGUZl60gXCpi2YyIblIpKwk9ogfVd1R3SL42OWe3QtvENsBKuVhQNz9P6Ur1W9uXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nRj8b28b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A41606A32F;
	Thu, 19 Nov 2026 01:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nRj8b28b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CAC11F000C6;
	Thu, 19 Nov 2026 01:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052305;
	bh=TzN28iyKeiUc+j3F2j/VMFISFN30m3hIo2MvOr1FjUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nRj8b28beLSb1XRMJTuuKdRYR5QSmVencMwY2fxZ9ifxeescRqHsNDdBTmSwKsFzM
	 U5O+tz3lDxolG9I80D/HksvDzVz/1IsE7Ot6dD6wrzx6AhBBqPsOBSlM6DZNUmnhRC
	 QqZJbI5iM/vHUUfOkhBR7GEpBfg23fkLT2YoBVuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0514/2214] drm/mali-dp: Fix runtime PM leak in malidp_crtc_atomic_enable()
Date: Wed, 18 Nov 2026 15:36:30 +0100
Message-ID: <20261118150031.667043483@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 73ef663c75688168e31dbe9c585b939be410a945 ]

malidp_crtc_atomic_enable() resumes the device with
pm_runtime_get_sync() and returns early when the resume fails.  The
runtime PM usage count is incremented by pm_runtime_get_sync() even
when the resume fails, so returning without dropping the reference
leaks it and, once the error has been hit, prevents the device from
ever suspending again.

Drop the runtime PM reference with pm_runtime_put_noidle() on the
resume failure path before returning.

Fixes: 85f6421889ec ("drm: mali-dp: Enable power management for the device.")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Acked-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patch.msgid.link/20260916102112.2018372-1-vulab@iscas.ac.cn
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/arm/malidp_crtc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/arm/malidp_crtc.c b/drivers/gpu/drm/arm/malidp_crtc.c
index b5928b52e2791..076a0c95e754e 100644
--- a/drivers/gpu/drm/arm/malidp_crtc.c
+++ b/drivers/gpu/drm/arm/malidp_crtc.c
@@ -55,6 +55,7 @@ static void malidp_crtc_atomic_enable(struct drm_crtc *crtc,
 
 	if (err < 0) {
 		DRM_DEBUG_DRIVER("Failed to enable runtime power management: %d\n", err);
+		pm_runtime_put_noidle(crtc->dev->dev);
 		return;
 	}
 
-- 
2.53.0



