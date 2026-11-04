Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831377;
	b=aom5TA1p/N497cAy1OMtTEikfJ5ptEPtNwM7Da0q1NTJEMf90F8RXzvrzV38+HC8Upuc
	 wdsNXv3Bbjgq/1DGQPercVi2ceiMjnp4PD2c+j72ony6nsqxuQyovo+qkd6PdGlV756K/
	 ZvfGdSMGWjsBKn+dTFRojep9QG7oOPsfFXBl7LLpBKcAhLVtwcjTCf+MQ7o1PmptPQ1ip
	 s66q9uMlzByAV8rWuodbiZk7wPFvNhCmqqqG8L9zZ5oZgFwUIRTLqyUcZNFZQxKYsJdJO
	 l7LsjqaWyQ/MX7puSUitm9KH+rXmjcdv+P3RoNem9y4fMPxOIrQdv60vwQO23sKsLFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831377;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WHFTiWSNl5Z++0FCI2yrL6mHdw8T9CO8Aq3El7ikJzs=;
	b=lf0zsOt3AIxKDvLxzDBi6ae5WN9RVc8TsMyY5UH1RhvrxqjTC4Iuy73cHCGfTLSpieIG
	 Fy/fmfCzajAXKsBHZ3aVk2i3O/Qe59oVBlyfQBA0grQDWbHrmVoeDjdyC9XHCy8v4gxcf
	 rKRD/1YFZDi8S9jW7zLDLHZSZHsJ2wPK/FKFd6DX1tkBzRuLEX4VjBlAYuUUsgrz7U8TS
	 2UIrX8J8hRKRlOd4HJBDxVkFtXG4h38HRLZAFRMw7OgAc3i7GfciIfj2lGgME1tlsBNGZ
	 jP/fYkKcaRIZ65RvGajKx59nB4lgs9PbTayy+qOomNnkFcQ3OrRos5iBw7EPilKTUQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EFR9NaHV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1CD606A337;
	Wed,  4 Nov 2026 22:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EFR9NaHV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D9F1F000C1;
	Wed,  4 Nov 2026 22:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831376;
	bh=WHFTiWSNl5Z++0FCI2yrL6mHdw8T9CO8Aq3El7ikJzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EFR9NaHVjFRoEz2CUDOGItQ78ZCgXtBgB9WOnIIDNg1GYO8AFgNCf1ey1d82xEXA6
	 DCYZ3qbNffJjRf/ZC/LHiWmNtLqP9EhCkv4qDL+COYw/kOV5vMT2b2t90LgiQcenkV
	 3XfhZ6UUNU/UwFazXvrF1uNCUkoNvJdfvkWbeUKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Kim <james010kim@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexandre Bounine <alex.bou9@gmail.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Matt Porter <mporter@kernel.crashing.org>
Subject: [PATCH 6.18 0667/1005] rapidio: mport_cdev: fix use-after-free in mport_mm_close()
Date: Wed,  4 Nov 2026 16:06:40 -0500
Message-ID: <20261104211102.343142059@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2168,11 +2168,12 @@ static void mport_mm_open(struct vm_area
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


