Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030428;
	b=Y40/nt7BfQBy6H7BnLGZTrXxRXC0X7LXudTE1b//2UUwTZgiCl4Ya1MGMYpOI5u+66ks
	 IJ0rOYFmLxr2pP7s40Ld143C0IunzDwmvk7LxiyFUoZlEvu20lBXk6YIxjYJS4MV7x0Sw
	 darOj0Aymn1KxvKLs2olpZJNKNhYhp+yKeVt6RWj9uHl9ggSiKBDo4h5FKRMogA3VMcec
	 hIrj3HsxirHWf6+Wysbv58O2LTqA9ZhCzcsAnB8OjXLDQRU7ixW1rfzNfjOu6ii6WU19r
	 zB4twaVx8R1OVwh1AYnUZeCDTdPQLjZE2WkNnqD63Lei3ZxnvOPSZp7hXBsv60rVa+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030428;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OzYYtHPfzaTfL24iF8au4Dk9DPJ/PVdL60/gkSaQB10=;
	b=I5C/0sEjw/QFxJJTF9QyXOxX/Ueao4UzFzNEE+LsUe5HV5lHfYSJ0+mzCNWtjvCq4wIr
	 rf59Fn58/SBMoXrdyEeGeoOXGO1Gd0Lt4l/BEVSnSVXlrQ0YwYbMIYG1Gdhk3XJjGZwxJ
	 ANJaF3FOQ2vHgPVTo0YqfzVAP0Ev1v/3Srh2uR496u8oALriu5u2NZ6kE45/EQtlTtyK4
	 6LuRT9C2xOl33/2ZPx3ShuSmWEdR6JeLFMWY7WWXNHnUD+MFXgbY6hUfBc1wwqVKLscan
	 uE5StTv8dkMjS0Mck4brrTisNJ7tICfRb7OLowK4emWHDGzf04OCvNfwt2rhStNPy6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xPgURkzV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C89A606B13F;
	Wed, 18 Nov 2026 19:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xPgURkzV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E254C1F000C4;
	Wed, 18 Nov 2026 19:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030428;
	bh=OzYYtHPfzaTfL24iF8au4Dk9DPJ/PVdL60/gkSaQB10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xPgURkzVb8SOHFM3cq0Sapm0ktHO+6Aegby7ooEnJoART8GUMOIgqcVYJSAa4KO5J
	 cQcgY6BCXlD7Qf378B4ND1s3g/ittIa11Q+ZlLXv7FZt4ekvYbE54MDE0yaEpSexIp
	 80OKO2NLDbGxz39a1NXf9lZrzQ+MhbFgXWrSU/ZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Abdifatah Suruur <suruurism@gmail.com>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0702/1756] vfio/fsl-mc: prevent read-only region mappings from becoming writable
Date: Wed, 18 Nov 2026 15:47:09 +0100
Message-ID: <20261118150037.132837570@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdifatah Suruur <suruurism@gmail.com>

[ Upstream commit 25fd8b27ee8d4f59cc2ad99cf67aef4570b82096 ]

vfio_fsl_mc_mmap() rejects writable mappings of regions without the
WRITE flag, but leaves VM_MAYWRITE set.  Userspace can map such a region
read-only and then upgrade the mapping to writable with mprotect().

Clear VM_MAYWRITE for regions without the WRITE flag, as i915 does for
its read-only objects and as fixed in drm/vc4 (CVE-2026-68445),
drm/panthor (CVE-2024-53071) and commit a5edadbae57e ("ptp: vmclock:
prevent read-only mappings from becoming writable").

Note this is defensive hardening: the fsl-mc bus publishes all device
regions with the WRITE flag set, so no device can currently reach the
read-only path.  The guard costs nothing and keeps the mmap() interface
honest if a read-only region ever appears.

Fixes: 67247289688d4 ("vfio/fsl-mc: Allow userspace to MMAP fsl-mc device MMIO regions")
Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: Abdifatah Suruur <suruurism@gmail.com>
Link: https://lore.kernel.org/r/20260929094848.7439-3-suruurism@gmail.com
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/fsl-mc/vfio_fsl_mc.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index 03600872c4809..4a7fac70f103e 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -409,9 +409,13 @@ static int vfio_fsl_mc_mmap(struct vfio_device *core_vdev,
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
+		vm_flags_clear(vma, VM_MAYWRITE);
+	}
 
 	vma->vm_private_data = mc_dev;
 
-- 
2.53.0



