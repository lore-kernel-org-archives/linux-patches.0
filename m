Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024898;
	b=MDqko6ldkYzXhsaIakNI9xfh5hJajFKS18uuS1j1seuhYLD1ihSw8M6JEIfmqPlhWS2T
	 THbeyLeixbr/OIAUjhrFYkajBRcy4Q53bHPk3e/4GohmXGLgcn4y8YT3WOlIDgG+60l/c
	 8x4/3ezxRTKMDMXSz2w10l5Pixbj/i72Esdyyi9p1pfl9ZM+j5SZNRV6xCJp+VRt9mzjt
	 /x4p5QU1Oo+VoGJw+gj7i/uvLomdcDEtWovc4h/zWK+bkNvDNBzTbGUC/nYejTZ/yPo81
	 bfNGuMFqlajLyf5hKnAl0d2pEUcpihCd6uxyfkAyyOH5Wh7smPCNJ6vZttUzVLPmbSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024898;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KifpRO37SU4IY2pVlcHUZwln6Y5V4LfGRjZlDxS1Z5s=;
	b=lTfq5W2IPk0jEY9d9Uz54vHFx2Jq3YCi7kwvZCNL2G/Pdq2b9cKdQFm2JJ/pbmpkA1S6
	 D6o18B8TImvpqfH53ITlhyc+g33atGfqQT0SNmAKm5rNCgGKHXAcw3+mhq2i7gfUBhC/G
	 qy9rpyqCLjTGZlNBQUm21DpIjdJ1IVOB7fOcRaLAPuDc/P+KgbFQpRl0wM1jHadI4ydV1
	 /QrfNj3OF2UnnFNtJwO7K5mNGUdBOQ8rXBs7fgslpW9Bc3qSlm/UO5UzpXh9IFyhdCbW3
	 45CGyjA9UlROfUM5QWYbpij0bO8hne4tP8+TnqhNEm5N8IRVNK9YNGjqUgIH8E7WKvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yEZwnf3+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719A5606A31C;
	Wed, 18 Nov 2026 18:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yEZwnf3+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2D561F000C4;
	Wed, 18 Nov 2026 18:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024898;
	bh=KifpRO37SU4IY2pVlcHUZwln6Y5V4LfGRjZlDxS1Z5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yEZwnf3+J8iY+04aaCxsLuk4r7CJRtcO25Z/7gOJp0rHrj/ORzY651wET2U4Mp1X/
	 ddYx6b10FOV/pO0X1ydMZBalmlNTKhZZcpS0647zYZeLDeFYMKyIkJsv0rEyE55lbx
	 o0daxLz2MzrLaoXn7bjTNOPwQp/KMsE9NyZt/iV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Abdifatah Suruur <suruurism@gmail.com>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0888/2151] vfio/fsl-mc: prevent read-only region mappings from becoming writable
Date: Wed, 18 Nov 2026 15:43:43 +0100
Message-ID: <20261118150154.659488262@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 84cd0eb65c471..944d4f22c5c36 100644
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



