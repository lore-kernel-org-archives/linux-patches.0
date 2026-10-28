Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210775;
	b=1aB5Rq3HfLnsh2f8lryPBKYZFfrg3sB25t9g+YiuLxXQAP7qG8fS8b1OFnGXIu7h9u7g
	 YFLGsmU0uGRbEYG6jaTRLOzGJ0kQO3+GipwnuAberBwsjRADe1cMyWwVGnRHtDUKVa0Xt
	 ucwQTF/Ap9vfIYwW8x/VuPkcKNR5sqZt6hkvpVaWhdSEvva7F97y6kqLWFSkRbjtCh0P7
	 HhhfzyXt03cKVmO03LUECx9x/9q+L3Gz6G/qDngy/oDAgq9pujfrJ2tnzRNFqdBZXszIA
	 EjmgNP9SMpqlGrR1UUDeq4JnLJaY/Wjzegm9Dgs1ixmaFmOaOQPB13YTekkZBW0iX+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210775;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0almAwZBC61cP+kC1QB6cGtOZJg3HgCUqV7UPJa5xk4=;
	b=KKG8dQEBZqOWKTMczThbFk9esy/34QPEOyZxxc4ZzhKtCq3RwLmEcD7rGorqGc9Hb7ry
	 7IOJ5m0mknjzNW0MNSm5flcvMQXMn9ZlFyNbXAd2ISA01IQkSY/kXnrSqN7GwIYRIPuSu
	 f3PlRu+E4ZpQicvhU6oZu6I48uJ/PXGRpGg8T9vT4sc1I75ZhRa0nor17hn+Fvk6bFV5l
	 ofGILUyvKaCm3Cl3JK0RoE3YoryIAcBQVLrong/oK2OPmi08vT34E47BUnHl0kkXW8s7M
	 HdPYGzm/NwZpxQ71PtlyCTeEZQutSkqizLzwXqp5gX3UfLQHVBUrnJ1vVpuGkMe90vQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XIbrgYAW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42A1606A31A;
	Wed, 28 Oct 2026 18:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XIbrgYAW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE0131F01825;
	Wed, 28 Oct 2026 18:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210774;
	bh=0almAwZBC61cP+kC1QB6cGtOZJg3HgCUqV7UPJa5xk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XIbrgYAW/KH8ZdC9YfiHMWjirNM7Rm8CHN9y+rHDiJ7VxiZcLolIR+WDqI5uJ9uw+
	 nSSJUcgCbfKXZeFJcve56ulT1VQqc0UsSv9lr45zLxSmSo7Nrv6yUPEQ1cmQTCsaUo
	 5bO0nix/z9mwDFffEgjy6iJTqHEHgovzZgzU0pwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 145/571] drm/msm/a6xx: Avoid a nullptr dereference when speedbin setting fails
Date: Wed, 28 Oct 2026 17:54:52 +0100
Message-ID: <20261028170011.456762591@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 46d4efcccc688cbacdd70a238bedca510acaa8e4 ]

Calling a6xx_destroy() before adreno_gpu_init() leads to a null pointer
dereference on:

msm_gpu_cleanup() : platform_set_drvdata(gpu->pdev, NULL);

as gpu->pdev is only assigned in:

a6xx_gpu_init()
|_ adreno_gpu_init
    |_ msm_gpu_init()

Instead of relying on handwavy null checks down the cleanup chain,
explicitly de-allocate the LLC data and free a6xx_gpu instead.

Fixes: 76efc2453d0e ("drm/msm/gpu: Fix crash during system suspend after unbind")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/588919/
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index 95c31009bbec1..ae35e7be077fd 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -1867,7 +1867,8 @@ struct msm_gpu *a6xx_gpu_init(struct drm_device *dev)
 
 	ret = a6xx_set_supported_hw(&pdev->dev, config->rev);
 	if (ret) {
-		a6xx_destroy(&(a6xx_gpu->base.base));
+		a6xx_llc_slices_destroy(a6xx_gpu);
+		kfree(a6xx_gpu);
 		return ERR_PTR(ret);
 	}
 
-- 
2.53.0



