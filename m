Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058244;
	b=SBaGy/6kRMeKC+koU3nyE6Bm7SVsjcLsYtxSSSlKwgNBL7qZmZc7fUrwYe2UaBxCW7BK
	 OwTl/47/3K/QgxlOS4iZG1KYzXQZpqw5Ty9zrSTG9VT4AF/67qyvaKh9bCPFQoWIm3ocv
	 C28lWpH1SdTWjS6lq8M1F6isUAua9D8KEXYtg+T0NGxT8WhJKrW60HWbbATGv1aTwfuBm
	 yDeBpgwohZQrkRDDQrNmPoRjZjbo3lOkiPqm/jSu/roPvvz89w2dPHlbti4ZSYamU8mg9
	 p7J0hAPbrz2xmhmzXyVkVE6fYWZomPN9D65gUXYgfG/ec3aAlzklnZxWJLLvabPCdWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058244;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=480WtAM3bjjIo5UXeJfPMriufHjI4TdVa7voK+J5HSQ=;
	b=3XiUP8OYV1FKYcSYP8+UEL7AyIc9cQ1uDv4UhsaIcBpNeM5LxUbUuZtzfCBHFBmjZqqh
	 S19qB0x/C2R1O0sbFuRvbuMBLce297QSdMCcXUgaGLu0yqj3av+AkrVBFcqgY5BD1IijL
	 6HpCbjsYQtFxu7gLpScHLdyJhPxExbzGmEYTwCWBs8Vj12CNt2TNYsIq8EmQSphXamUOo
	 NVdI7e2APJQ+H16S3Iv3043bJkwSiuYCxmylmVvDnY+697r2jW+ptdegYESlwHjzkXEV+
	 eDaRJhO8dzah3ptB0njwEwGeXVhC/q30FRH7mqGSnMCb3x4AdNLnrZO6/lFJmCinnjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a+lwfZ2C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3552606A31C;
	Thu, 19 Nov 2026 03:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a+lwfZ2C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B99AA1F000C4;
	Thu, 19 Nov 2026 03:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058244;
	bh=480WtAM3bjjIo5UXeJfPMriufHjI4TdVa7voK+J5HSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a+lwfZ2Cg/hjy2xkfH2mUkmohFwi5pqz6XbwRW5r/lTIc6BEe2Vq+p8EwnMC6Ol3R
	 l+CA3LVp2ONmaH4nyE6Bi5qepJhoCtMXZScSNj0kFPcwAx66tGH3OxVQdYMv+bVk7n
	 9YDKDlxzICcMC2FkLYdjXr2llkYviAViyphC738E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0417/1848] drm/mali-dp: Fix runtime PM leak in malidp_crtc_atomic_enable()
Date: Wed, 18 Nov 2026 15:40:55 +0100
Message-ID: <20261118145931.428754495@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index af729094260c4..0f2fd85f27824 100644
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



