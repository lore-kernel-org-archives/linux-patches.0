Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064308;
	b=vWTLlL8xWVL4l7+G9NuvYLQyLzMQkax9qXbJl2lg8rIauu2+KNf/y1ShCTz9XQATS2Bb
	 0h5uNCXwSE970JHT6bCW5h64FN+0puvHju3xIv6z9X1z00aLG+u4KKmHrweAgK64OfFRw
	 c5KPQ8+hRqR3CLwqfEoZJuifSE5rFswPwaNYnxKxFcPivAMNT8nr+iz1X84kelf0lVPvD
	 ovmHdkr1Ybc6C6Dl9o6uEu3gMzcvxQp3EEwT/OdtOL0FGElDwfeuAGY2ZThECMA72mjJ2
	 mqhrzCP6/WFPFIGTljexA18y6QBeszVH7p+hPm6QSOo5MWilst5b0kPoZVQZgEMQaLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064308;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ARZWEgiPvBt042VS/Eyf17eiQDLu/pUoeDj+j9Y5YEA=;
	b=T7uftXp5YPCVN+A8GZKzI6LvDNZLpI2FDjKcwONgKYhl6t6AH2xe0rdvjNbzlFp+eQHW
	 jfbCCVuPpD8yKhadfy75s8Pr4L0f2xWpJ5Ft6N2xS2QhGAA6T5KuTnMvcxpGWEjU8d8Xt
	 qvrniUO+PoBuGBNvWG/VyTCt57ZrnQrBAYzz3HCF3LZomWT3zewcRXQTEcQjkNWFHJM9P
	 ggMxd+ZqgEnZozCA+sMi8fnRmO3mRMoajfcXPHBy9FV8woASLZyKOxAzoqXgw0kAoa9QR
	 yapmHVHwGXCvzqFFaN+irpsuYjgTF5rUvnuAV8Mn7O3YLp8ckaeAoC5Uw/i8+gbC5uQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Iq1gCTjA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4505F606C025;
	Sat,  7 Nov 2026 15:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Iq1gCTjA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E84AD1F0089F;
	Sat,  7 Nov 2026 15:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064308;
	bh=ARZWEgiPvBt042VS/Eyf17eiQDLu/pUoeDj+j9Y5YEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Iq1gCTjAHAKk+FOUyYiRnC6eKU2vln3F3ECQ56x1LjoUAwL3fZCZBhgGodhHpGNxx
	 gCX2X4SGoWYgAA6Yps2xLUp9COPu5LuuJoGZe+seV2A+BknBiEJgeIdGdiqj3MYe+n
	 qf/4wFEhW6Uct7Srwdcaxrq+dAS456LJC03e70vM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Rob Clark <rob.clark@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0399/1257] drm/msm/dsi: Fix VM leak in dsi_tx_buf_alloc_6g()
Date: Sat,  7 Nov 2026 08:44:55 -0500
Message-ID: <20261107134950.557715505@linuxfoundation.org>
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

[ Upstream commit ab91ba61871a896ca2ecc6e048d80a152136da44 ]

dsi_tx_buf_alloc_6g() takes a reference to the kms VM with
drm_gpuvm_get() and stores it in msm_host->vm.  If
msm_gem_kernel_new() fails, the function returns early without
dropping that reference.  Since msm_host->tx_gem_obj is cleared on
the error path, msm_dsi_tx_buf_free() will never see a non-NULL
tx_gem_obj and thus never calls drm_gpuvm_put(), leaking the VM
reference.

Drop the VM reference and clear msm_host->vm on the error path.

Fixes: 5e05be782645 ("drm/msm/dsi: free TX buffer in unbind")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Rob Clark <rob.clark@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/754332/
Link: https://lore.kernel.org/r/20260916175738.2089950-1-vulab@iscas.ac.cn
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index b292dfd266d17..d92659d80f172 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -1254,6 +1254,8 @@ int dsi_tx_buf_alloc_6g(struct msm_dsi_host *msm_host, int size)
 
 	if (IS_ERR(data)) {
 		msm_host->tx_gem_obj = NULL;
+		drm_gpuvm_put(msm_host->vm);
+		msm_host->vm = NULL;
 		return PTR_ERR(data);
 	}
 
-- 
2.53.0



