Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018012;
	b=lnIZoCYwYQF6C6a/Xk2nXF+FPMbvNTnL+HBp/gCXOqDj++IKDJlV+EC8b+9mxX+u5A1E
	 0WSbcpPXy7gYnIIplLWUQlRKX+RqtA5hXoVzFU24xQ9VzXl13zHUd/oiHxhgYZ6+TKA68
	 sUgZ5PovrHiC2aXwKCmvXcYqv5JPXtV0a+mbUvn+z7M00wtuLkGpUqBPsi1u7oza/34np
	 Md4yFmJSpmjqxqVIf1WlmTWiDNUxP3KDQbb6nmWHgk2Z4Lj17cIzlLOD30YeWhqC35xe9
	 qo/bTR6iQmuMfM97SFXHUuEPclGf7M2Fcq9HfkJ1r0/yr7VeCz6n39qgzDMg53TxIsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018012;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hv4mlUCDEXN5UdJm7E4WvlcV7tqQZdx6mAgz5Wt0cLY=;
	b=2Wm4LYTcc0t/0IXB/ms/aSCtFMNQKevKn0Th+wePfGatkMWA/qeFR+KrNX0y13akLtEy
	 3PnSFDQjVacbPAlKxCutCREyLcsHfxUc7Kupw1WPGbCkZKdZo3gqeQs2p7WNC3nlwJnsB
	 T0zmwOO+rpoiFmcS/ri0VbDUW+LkVK2aVuWaS593J6jipIn+sITZvW/iirMnn8ZtQUoMB
	 FahNzfeg8b+qTk9/xtKl5EtIPR2KOH56gMDfidaBuagrm+ptwcTZSLJRXC2gEOLyUS+fK
	 OFLgoWfy8QUhyFQBw4c/x7of6E0FtCZXK3hrKXAOphOKz5EadHFbrLW0y12uA9VpC/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qKNGef8W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92A5606A31C;
	Wed, 18 Nov 2026 16:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qKNGef8W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BED41F000C5;
	Wed, 18 Nov 2026 16:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018012;
	bh=hv4mlUCDEXN5UdJm7E4WvlcV7tqQZdx6mAgz5Wt0cLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qKNGef8WmZrXxRFmd2cksXeH+RN0ZmXDePBANAJ21xgiB0b1Da7L0aEFakAYCaDgZ
	 OQjJksFBxqHVNq1oPRK2/Kiivbh/ACcNhik8/W037O/8bpnkQub3gqD7HmGeUvgWcv
	 Y8q6K5BaDAQjwt338+rMiQRUOHoarkclL7ddtQjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mostafa Saleh <smostafa@google.com>,
	Eric Auger <eric.auger@redhat.com>,
	Pranjal Shrivastava <praan@google.com>,
	Abdifatah Suruur <suruurism@gmail.com>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1048/2651] vfio/platform: prevent read-only region mappings from becoming writable
Date: Wed, 18 Nov 2026 15:38:08 +0100
Message-ID: <20261118150325.697034955@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Abdifatah Suruur <suruurism@gmail.com>

[ Upstream commit 420bed9131dbbe37abe9d6b32af51219875811e0 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/platform/vfio_platform_common.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index c72db5a99ebda..ab531318f170a 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -591,9 +591,13 @@ int vfio_platform_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma
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
 
 	vma->vm_private_data = vdev;
 
-- 
2.53.0



