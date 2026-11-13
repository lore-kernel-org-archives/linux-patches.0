Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585517;
	b=cYsh+AekgfSUooY0WE1QiniBhMh3S6VV7ECDFjhGjGUYcYNTAqdT+UV8IZPGbzRw0GsH
	 CRUfRXy00WsisGFSWjYHYVUPkZ3htyGbRGpNFgBAPLDaZ3/eUf/W7rjbsrbKg1w41QdZ0
	 sfX/5gNe+xmowL/cTGFl+WT+L0c+LuL1XmO2Cf97ro8sHKAVeB2qDNrYmtiDvognMxcYG
	 LN03bKxocbPXTIpECDd3h1UiENAfRa2sd0veXriJvN2fZHgzkUV18MDCrmWYOXW8lTxOB
	 kqNqu8lmdHm5CvZp8oNCOYHzzaF3J5v5cYvcscXvjT0rRBVVTSsabDAsJnt1+mf2qJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585517;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=LIwS/t+yuiwhLATe1lzo9Qj+NFGcvsz/suvLtmmmdHg=;
	b=Cq9z9nlcwu/ka2T2wLwBq97WFEJRnO924bl5GEWnqBicxgNuEA5Fqq726yEPsMvSTuju
	 Xx950Rv3MzSgSAfFl1+E++aNHrENJ3DD/eDoQc55/+Llyi0y3BUACplNvJbYgSN5UmVQb
	 +Ccew6S/RYT+PZeiiV58Cg4Wb7qNyY+JzQGf/X6hDEEzPt2q4IoJ79pOe+sLlhWKP4TYA
	 r4b0HD+13yJOI+Wmg0qJMlxz4NHEMNyfuM6RjGJDrq9ivlaS94Qrjqq7Ejhy4296r1UYk
	 pv6+tmJhHOwJmZa3Tr7lhtFIrntgHCzBUrwETbsvxpn9OJFM+vtQo1zOOCLA3joBkiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kR7YLXAG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3074C606AE3F;
	Fri, 13 Nov 2026 15:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kR7YLXAG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEFB71F000C6;
	Fri, 13 Nov 2026 15:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585517;
	bh=LIwS/t+yuiwhLATe1lzo9Qj+NFGcvsz/suvLtmmmdHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kR7YLXAG3MKyMxj985lsNkWdtGsFokUtuny3Sa6UDlwJXlUbGbr7WK3xCtTM/aNm9
	 8b/zNvb7ch5/GCLd1QDbNjJKAT+mbuE9SncaOSSXWN88MsndMxvprgvV2cw1piqF1Q
	 CFKAnF0C0qawWDUcUSuRVoD/20BMS9tOx/PIZs1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iago Toral Quiroga <itoral@igalia.com>,
	Jose Maria Casanova Crespo <jmcasanova@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 161/507] drm/v3d: Widen cache_clean_lock over the whole L2TCACTL sequence
Date: Fri, 13 Nov 2026 10:47:45 -0500
Message-ID: <20261113153759.958010788@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index bc88ebdcdbead..cf3df526e7739 100644
--- a/drivers/gpu/drm/v3d/v3d_gem.c
+++ b/drivers/gpu/drm/v3d/v3d_gem.c
@@ -217,6 +217,8 @@ v3d_clean_caches(struct v3d_dev *v3d)
 	struct drm_device *dev = &v3d->drm;
 	int core = 0;
 
+	guard(mutex)(&v3d->cache_clean_lock);
+
 	trace_v3d_cache_clean_begin(dev);
 
 	/* GFXH-1897: Ensure pending flushes complete before writing L2TCACTL */
@@ -233,7 +235,6 @@ v3d_clean_caches(struct v3d_dev *v3d)
 		drm_err(dev, "Timeout waiting for TMU write combiner flush\n");
 	}
 
-	mutex_lock(&v3d->cache_clean_lock);
 	V3D_CORE_WRITE(core, V3D_CTL_L2TCACTL,
 		       V3D_L2TCACTL_L2TFLS |
 		       V3D_SET_FIELD(V3D_L2TCACTL_FLM_CLEAN, V3D_L2TCACTL_FLM));
@@ -243,8 +244,6 @@ v3d_clean_caches(struct v3d_dev *v3d)
 		drm_err(dev, "Timeout waiting for L2T clean\n");
 	}
 
-	mutex_unlock(&v3d->cache_clean_lock);
-
 	trace_v3d_cache_clean_end(dev);
 }
 
-- 
2.53.0



