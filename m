Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705809;
	b=nNwh9WIrZpz9QqFo1YJ2dXku96leUVOsyHw0p6vDzaC40ethDCCDPiYx9FpVyWARaW+H
	 kqbjt5OR9rzWrfuZ+8aXjSYHUPAK+akhVap9lWq1bZr3NjYegI7mljd1KQZckM9LcbDNu
	 lfA8MOrkjaLF8AKmVOq2Uo/4N5P2Uu/JPnsfQodHKHieMIly7ocEXswttzEILgpky91y1
	 8WEaa2/Ci3EuJjF5yuWrSQd0edW7Ee1SFxc1NhOsgbU85x/twEeLv0lCGrktK+t6NYEy7
	 cQWcF3kEPksC4p/Zmu+QLBrt4GI75+vGvdL9NIx+ysXDa+1uZHGC+Dj+N1+1zBDGAjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705809;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qgM5rMexZr8VKYBNrp4V4cYEtVBDgpwXCNRJ2t440pE=;
	b=KRULp+S6uxXjmwXPuwEGMSyzcGAk2rvz0pKxIkjzVHZF2m/vjq82FFUYrjQngqCxjxBL
	 q0h+nYqPxxZxm3pzOOrytAbHcQ2jLWuDPqi/qv9gK3WNIDEdV86SAdyJQYNrbxXPSki1n
	 uwnengBIAuvHEiUTDjeY2pSpsQNS9JXl84cY9nTbg72KfOdWYvxkvaCSiS+dS43EebA4d
	 eMjqg93gCxO10D0yucDyH8mz3nk8/F9c2ZONYd3FmIcquvui9ZQh++CUYQ/NtLT0j4rVE
	 FxG1LVoaP0QgyaD0RB84nCwUASDapDmk0/WS+4vblP6kWUM18Wdua+Oe4uygY7rQq5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xo+HjfdN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3CA0606A32A;
	Thu, 26 Nov 2026 15:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xo+HjfdN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15C441F000CA;
	Thu, 26 Nov 2026 15:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705808;
	bh=qgM5rMexZr8VKYBNrp4V4cYEtVBDgpwXCNRJ2t440pE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xo+HjfdNGvtHKH3AfKEwzk0AL+kx+7D0rLFgbW058jA0FLB2UcBhENNcNGW9VPsOt
	 ajhxT8I2S350X7Zl0KvWtIvjsxzkcUhYdi9ueC9+LSRksjsIqmktzyC+CveaTWh7QL
	 HLZWqRtJWq9IvNoKCVgB0zfzPxQQiNqFV0pCBk7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mostafa Saleh <smostafa@google.com>,
	Eric Auger <eric.auger@redhat.com>,
	Pranjal Shrivastava <praan@google.com>,
	Abdifatah Suruur <suruurism@gmail.com>,
	Alex Williamson <alex@shazbot.org>,
	Alexander Martyniuk <alexevgmart@gmail.com>
Subject: [PATCH 5.15 315/319] vfio/platform: prevent read-only region mappings from becoming writable
Date: Thu, 26 Nov 2026 15:41:23 +0100
Message-ID: <20261126144013.871146235@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

From: Abdifatah Suruur <suruurism@gmail.com>

commit 420bed9131dbbe37abe9d6b32af51219875811e0 upstream.

vfio_platform_mmap() rejects writable mappings of regions without the
WRITE flag, but leaves VM_MAYWRITE set.  Userspace can map such a region
read-only and then upgrade the mapping to writable with mprotect().

Clear VM_MAYWRITE for regions without the WRITE flag, as i915 does for
its read-only objects and as fixed in drm/vc4 (CVE-2026-68445),
drm/panthor (CVE-2024-53071) and commit a5edadbae57e ("ptp: vmclock:
prevent read-only mappings from becoming writable").

Note this is defensive hardening: no in-tree platform driver currently
publishes a region without the WRITE flag.  The guard costs nothing and
keeps the mmap() interface honest if a read-only region ever appears.

Fixes: fad4d5b1f042 ("vfio/platform: support MMAP of MMIO regions")
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Signed-off-by: Abdifatah Suruur <suruurism@gmail.com>
Link: https://lore.kernel.org/r/20260929094848.7439-2-suruurism@gmail.com
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Alexander Martyniuk <alexevgmart@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vfio/platform/vfio_platform_common.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -603,9 +603,13 @@ static int vfio_platform_mmap(struct vfi
 			&& (vma->vm_flags & VM_READ))
 		return -EINVAL;
 
-	if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_WRITE)
-			&& (vma->vm_flags & VM_WRITE))
-		return -EINVAL;
+	/* Prevent read-only region mappings from being upgraded with mprotect() */
+	if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_WRITE)) {
+		if (vma->vm_flags & VM_WRITE)
+			return -EINVAL;
+
+		vma->vm_flags &= ~VM_MAYWRITE;
+	}
 
 	vma->vm_private_data = vdev;
 


