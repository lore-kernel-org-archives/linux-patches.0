Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064081;
	b=HZKNFbTqkBIspN+tobBoN1fRVENTjIRr2QVAuTs+ShUnJav+zbmAIKT9GqvSJZoX3oGO
	 9okrodcBczqMZ70aEKXIflsJ34aUvECR8l5HEsJLxSsJJok8p7AhEkpb9rOtRKL7o72mD
	 qddX+a/gGyybWKPjR5n/EnzKn0W4Qpe7dK95OQ6iiNfohTCt2N7f4ag3bpFmjzmDaaoBY
	 wSbgFtcuDY1/7MDSkA961rhKsAWoi6zgqbIzRvhkgFqTxsnZG1K56lhDDI4b+/R1z/KPl
	 rXgIpitGuADEt1T4Cf/+B/3icNuaiAN49U+5z3oyZljBVl/G5UnIGpwn73d4SAfePoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064081;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B5zZ+GCK8AbDU5kpxYXVsc0Ll3GfmCsQOEfGLNhjlzE=;
	b=5e4ttVPafFvVQJ98GBQnOX88xEzM1VrQ5PlUq75eyumZ0SLp/mglsN1I05T1Mixa1AEP
	 V3JMtcTN/o64a7kGBGbzOOBEOCXDtErXze167txyqIVvzjntNSYVKd70ktCGkbcp/kVSK
	 7HcUmRzEDRAzaVXU3Rn5eZ2r+j4lG9fe7jtU4ihz3X2hVXjBovVwKeTFDtwj6St/iS1ie
	 uyLgFbF6H95WlNhz7n7+h4iDD19tNzXsE5mDv+w0GtZnPkvW/12tSdz6kW1ZO8ynhb4Lb
	 mn1HcjwiuBPM3Hxn1JO6acO6DexFMRAEKHfdoyPVnZR0hJaXdIM9rWevh4fr2NkU2yQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DceCcyuk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EDF660A5BE8;
	Sat,  7 Nov 2026 15:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DceCcyuk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D6B71F008A3;
	Sat,  7 Nov 2026 15:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064081;
	bh=B5zZ+GCK8AbDU5kpxYXVsc0Ll3GfmCsQOEfGLNhjlzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DceCcyukzrUzWaHuVXdOCZbUaZ+CfgYUs21WmbFrrH6Z/mPFt2eqVzaT59xnn1BEv
	 f0qZwcpUeRWh6bdYRrctvYw1GkxvLu1fivT6uFZdlgySAIG3S0kG2eCDsOBQqNG3B3
	 hmt3LZYtem7/Atl6lxPLbkccVzNxMgWJPJvPcgrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0246/1257] drm/mali-dp: Fix runtime PM leak in malidp_crtc_atomic_enable()
Date: Sat,  7 Nov 2026 08:42:22 -0500
Message-ID: <20261107134946.306951404@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index ebe8e10787772..af62bc1027648 100644
--- a/drivers/gpu/drm/arm/malidp_crtc.c
+++ b/drivers/gpu/drm/arm/malidp_crtc.c
@@ -56,6 +56,7 @@ static void malidp_crtc_atomic_enable(struct drm_crtc *crtc,
 
 	if (err < 0) {
 		DRM_DEBUG_DRIVER("Failed to enable runtime power management: %d\n", err);
+		pm_runtime_put_noidle(crtc->dev->dev);
 		return;
 	}
 
-- 
2.53.0



