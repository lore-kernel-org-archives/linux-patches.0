Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590274;
	b=aV00/iET4YDWvZ+sNkadjokoFWZJ3fNdc7inzvRj10PEWWpDtj9hG1wNqLJOP149BU7X
	 KW6ITDdZXqrlqdpVUdzYaZrALtRHmpf+XVkjlrVJbGiisYFVeX+eT22MAIpMIMELKqSaV
	 IXWFhRDYtV1PU1b1LvtlQhFRhJsU8dnogkSJ2hJNgkTuOm73EM2oIFKiYDc+YNyKe0AQa
	 5ODNXCglArLUwhv6kQc5MbeXO7rNxAvBBvaOV7bIpV3Tx4mZRcL0JQQfFta37NYfHWkZW
	 xcUr82KREYcjkddxzriF7ZiSyWbuCepibXFgw7OuRUo+3wt4lcX4fSbq0SV9hnGHMAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590274;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=vDVLKudhXxZAXmLsWAbtVHddtKPp7VSYcfsTWRRjOBE=;
	b=FJv52zAMV6UOoFXUACgRx3v10KxCL9K9CY68T7MOyviWgQdRFLtgQ/fWNB2bfuTtFG58
	 f3mftvns2/AmGB1IhqrcNuf2YZtPRAxWKkUrHkff8eAlXd5pa7+OPKPZ1o3M33A7/fi3r
	 6w5BlypBXiCLR1+qlCW4YEU0UqOTy1JN9m+gSi6W5PO7jGAkc6lKs3eISD/Sqi+sU/TVU
	 aH8z7mOFBFJ+43i/bE2Yq8VD9/WbTyKgQq81eKnSvin2fPlcg0QGaJN3EjlQq2JtEiUSu
	 RCbNMGFiKgj+Q3w3pYret3JEx93UY9FFTlNhv1fXReURFSPMIAIsutRGa5mQ2wBZBqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=19DWDWNa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A138606B20F;
	Fri, 13 Nov 2026 17:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=19DWDWNa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A99711F000C4;
	Fri, 13 Nov 2026 17:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590273;
	bh=vDVLKudhXxZAXmLsWAbtVHddtKPp7VSYcfsTWRRjOBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=19DWDWNaekBTVfmPPwEOmVIKaLK8xNw6Svrg9L52uCNjElsCF0l7zcVStR1dw6g8n
	 FiL5RWDu917BUtDkuAadXjoMY3V7QaOpigFk6WE++Ai1GNyv2jgSuPMBsHAQn+pXWI
	 B8P9MX8RU34PY2ue+7KwccjlY5ZMpd6utf99Ga/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iago Toral Quiroga <itoral@igalia.com>,
	Jose Maria Casanova Crespo <jmcasanova@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 264/686] drm/v3d: Widen cache_clean_lock over the whole L2TCACTL sequence
Date: Fri, 13 Nov 2026 10:46:37 -0500
Message-ID: <20261113153829.972748005@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit 994ba6e5c87d6a3d471ea987fe8622168f092334 ]

v3d_clean_caches() and v3d_flush_l2t() both write the single L2TCACTL
register and poll its status bits. The mutex cache_clean_lock exists to
serialize them, but v3d_clean_caches() only took the lock around its final
FLM_CLEAN write.

These functions run concurrently: v3d_flush_l2t() is issued from the
BIN/RENDER/CSD invalidate path while v3d_clean_caches() runs from the
CACHE_CLEAN queue, and each queue's scheduler uses its own ordered
workqueue, so their run_job callbacks execute in parallel.

Because clean locked only its final write, a concurrent flush can write
L2TCACTL during clean's unlocked phase. Both use non read-modify-write
writes to the one register, so whichever lands last wins: clean's TMUWCF
write can land on the flush's in-flight L2TFLS invalidate, triggering the
GFXH-1897 hazard of writing L2TCACTL while a flush is pending.

Hold cache_clean_lock across the entire L2TCACTL access sequence so it
is fully mutually exclusive with v3d_flush_l2t(), which already takes the
lock around its own write.

Cc: stable@vger.kernel.org
Fixes: abf888b03a98 ("drm/v3d: Wait for pending L2T flush before cleaning caches")
Reviewed-by: Iago Toral Quiroga <itoral@igalia.com>
Reviewed-by: Jose Maria Casanova Crespo <jmcasanova@igalia.com>
Link: https://patch.msgid.link/20260707200738.659002-2-mcanal@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/v3d/v3d_gem.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/v3d/v3d_gem.c b/drivers/gpu/drm/v3d/v3d_gem.c
index b499f6635cd24..92df68f5523b1 100644
--- a/drivers/gpu/drm/v3d/v3d_gem.c
+++ b/drivers/gpu/drm/v3d/v3d_gem.c
@@ -222,6 +222,8 @@ v3d_clean_caches(struct v3d_dev *v3d)
 	struct drm_device *dev = &v3d->drm;
 	int core = 0;
 
+	guard(mutex)(&v3d->cache_clean_lock);
+
 	trace_v3d_cache_clean_begin(dev);
 
 	/* GFXH-1897: Ensure pending flushes complete before writing L2TCACTL */
@@ -238,7 +240,6 @@ v3d_clean_caches(struct v3d_dev *v3d)
 		DRM_ERROR("Timeout waiting for TMU write combiner flush\n");
 	}
 
-	mutex_lock(&v3d->cache_clean_lock);
 	V3D_CORE_WRITE(core, V3D_CTL_L2TCACTL,
 		       V3D_L2TCACTL_L2TFLS |
 		       V3D_SET_FIELD(V3D_L2TCACTL_FLM_CLEAN, V3D_L2TCACTL_FLM));
@@ -248,8 +249,6 @@ v3d_clean_caches(struct v3d_dev *v3d)
 		DRM_ERROR("Timeout waiting for L2T clean\n");
 	}
 
-	mutex_unlock(&v3d->cache_clean_lock);
-
 	trace_v3d_cache_clean_end(dev);
 }
 
-- 
2.53.0



