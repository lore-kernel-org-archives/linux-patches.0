Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057745;
	b=iXh4Auo9iI2qinAJD9PU+FVrMaQQuyIx1qwN3u5o7kggMcFK+u8ras5vQsD5SroUa28e
	 3R8l9zNaC/PHG7SUYulU8M3rKf3n68Tf0L7RUHTlsNrTcq0DK3ocVA8WWC06dGrHA4gVO
	 rjj/I0Zvqk+WxVex4f7xMx/+Ytee4RyXlj4Ndnoip8NF5kXLEW2poKGq+GVKlhK/c/YYt
	 kXSHtdJreOzvN2D7watHWanUwJflBN/41bIsT+/+00DwAaLNeGy+NIhD7ZXlgQpru8zZG
	 mwdyB+RmBMUy7VaTuJhNwmFScgezu4YRyAoMcm32hlWQNX3j6iwSoacZVItEdLi9iYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057745;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JLH9xttFwM4hD28st0WCkbcKwCnxz0olnYi5ciscHLk=;
	b=L1Ny8gzamsZ8+1NXfOjbXkHEF++h9rchYyZ1hfRYC2Lm7y4uLI5LTrHkEMb+NDWxI3Dk
	 etMSMb6iRsyrjLDujEscCZgzHF4oc8o+Oq+PN6nRUJQCe7kgtHlsPP/5KEYCeAcwFkVcb
	 Qqs8gJ6WaWE4E0NMy2QKZMRaD+DtJ5IcaUKOiHeZzdhEBV4WSA8eTYpV2fm7FavkP2rXY
	 om90xU411t9J86AqMFj1pqzeGLpv7ASbdkus/GkaOHhkiOPdcm2bg3q26rJBNUP2smj85
	 cq2caMlJMo9p2Pb05tLFBwzDHwfV5UKDnjFGR+Eettn/o7M511cNhaz98Cm8x3jqpSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="VmT50G/N";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4764606A32C;
	Thu, 19 Nov 2026 03:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VmT50G/N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20FE31F000C4;
	Thu, 19 Nov 2026 03:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057745;
	bh=JLH9xttFwM4hD28st0WCkbcKwCnxz0olnYi5ciscHLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VmT50G/NSGp+NlnIXD60h7CwpSWYRIyqc/AY1eu42GrGunZZ7f2FraujzTOJb7+18
	 PH68IlgSJz+3S7DL9kdY4cUJJwgkmgXirCpV/SWv+8Rv+CHBFlw3CjTNHPAObwkSpA
	 pEbio4haheX6gZSuLytI6HKWifXz3aHz/gi1LxsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Kim <james010kim@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexandre Bounine <alex.bou9@gmail.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Matt Porter <mporter@kernel.crashing.org>
Subject: [PATCH 5.10 0239/1848] rapidio: mport_cdev: fix use-after-free in mport_mm_close()
Date: Wed, 18 Nov 2026 15:37:57 +0100
Message-ID: <20261118145921.919694822@linuxfoundation.org>
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


