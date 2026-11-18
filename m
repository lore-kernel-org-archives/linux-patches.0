Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051674;
	b=pSWVxKlb+h1+xiqoYdgA0PuCXgAg1/MfmCEV4FpHdlOkS5nqo/xCOy8VYljlkqGT/Zwq
	 Lt3Z3Ij7RFHMU0WsQidgvKx2YeUvETKQabt6MPYIQjA+VyCLE+bTc5yWI88S3tCA0Tyyy
	 7DP46DPs5EQqBGcn+cjvCNFKI4UfuP72WX09CIexhT8wT98eiUKsANdPJKrpwaIXrY4rG
	 ig+4MJ98h2CyMlJ2RzeIU3Ukx7jClzO55WM0SRrz9ewr3fyb+q5vRhS4ox7Nu+EDd2yVB
	 KZzJ2H5MQyFNXerfTwQPyDs5QiW4ggrU+GNWRGC+bUS/HreO8QU0fGshq0sxd0n7b0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051674;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s+dmOxZr584OS1m78OIzyYV7LDaVvSujzmlq1oIQM4Q=;
	b=SiMau/3+I1noZMVHarxA0QZPuAnoRL3fUYlGyD+Y4zy+F8svsyQdeqMXFhyFywfy4wBr
	 jK3gnmJ3/QURhsBtFLIsa+Jnqs7HxCKim17IWOVZLLs+1AcoSiPqnB6ZwkZsikC9XjYdh
	 MkRvS3ZbbkRdhZcn4tEqHIH69umb7zpD9z4+pEXekxtC/sBjgNMndyZpoJ57pek7Qc0oP
	 C28za8EtnICwIXBpqZ/ms0CYcF5nGInKGueZhjAMGPcZGCN0aq0wlB9zXRL/e6yDhwCIy
	 OOAlODyCN95r/M5Y5k6D2ZO/KomX1V2n+Zp1OE538KhpUMAxulB9Qs9zN20qZLD0hBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DyfksksA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99D5606A320;
	Thu, 19 Nov 2026 01:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DyfksksA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBB391F000C4;
	Thu, 19 Nov 2026 01:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051674;
	bh=s+dmOxZr584OS1m78OIzyYV7LDaVvSujzmlq1oIQM4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DyfksksAbTkTcgNHBYE/RsNwZJYZ1KPGuhqJb61s9NAj9Ax/5qV3rrfoVfbQQKyky
	 2zbt67NKfgBn09a94Oq2vfSXyJKCEG+f4EYgZNaxGVJ6Ck04UVWmke3c9lA3/w0xlZ
	 ksfk9E0iLRJcQ+wIR8trbn5q9EDTrYB2cBaJ+eqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Kim <james010kim@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexandre Bounine <alex.bou9@gmail.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Matt Porter <mporter@kernel.crashing.org>
Subject: [PATCH 5.15 0291/2214] rapidio: mport_cdev: fix use-after-free in mport_mm_close()
Date: Wed, 18 Nov 2026 15:32:47 +0100
Message-ID: <20261118150021.690760145@linuxfoundation.org>
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

From: James Kim <james010kim@gmail.com>

commit 0f2cd84858e67cf8e02438bf28243bcdc67aa49a upstream.

A use-after-free vulnerability was identified in mport_mm_close() in
drivers/rapidio/devices/rio_mport_cdev.c, identical to the pattern
previously addressed in dma_req_free().

This is observable from userspace when an application creates an mmap
mapping via the RapidIO character device and subsequently unmaps it (or
terminates, triggering exit_mmap()).  During munmap, mport_mm_close() is
invoked and drops the mapping reference via kref_put().

If kref_put() drops the last reference, mport_release_mapping() is called,
which frees the underlying rio_mport_mapping structure.  The subsequent
mutex_unlock() then dereferences map->md to unlock buf_mutex, leading to a
use-after-free:

   mport_mm_close()
     -> mutex_lock(&map->md->buf_mutex);
     ...
     -> kref_put(&map->ref, mport_release_mapping); /* map is freed */
     -> mutex_unlock(&map->md->buf_mutex);          /* UAF: map used */

Fix this by caching map->md before kref_put() and using the cached pointer
for mutex unlocking, ensuring that freed memory is not accessed.

Link: https://lore.kernel.org/20260914042327.49798-1-james010kim@gmail.com
Fixes: e8de370188d0 ("rapidio: add mport char device driver")
Signed-off-by: James Kim <james010kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rapidio/devices/rio_mport_cdev.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/rapidio/devices/rio_mport_cdev.c
+++ b/drivers/rapidio/devices/rio_mport_cdev.c
@@ -2185,11 +2185,12 @@ static void mport_mm_open(struct vm_area
 static void mport_mm_close(struct vm_area_struct *vma)
 {
 	struct rio_mport_mapping *map = vma->vm_private_data;
+	struct mport_dev *md = map->md;
 
 	rmcd_debug(MMAP, "%pad", &map->phys_addr);
-	mutex_lock(&map->md->buf_mutex);
+	mutex_lock(&md->buf_mutex);
 	kref_put(&map->ref, mport_release_mapping);
-	mutex_unlock(&map->md->buf_mutex);
+	mutex_unlock(&md->buf_mutex);
 }
 
 static const struct vm_operations_struct vm_ops = {


