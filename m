Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030425;
	b=oUX5OGq8UNqLoowIIWEP+mMrsTlg3y2ambxFjjfrNKEHdrh6hVpru+6ZrxXjVF/RyAEb
	 sPiSAbk++cQvyNcXElvuf8wFpsY8FAWiGArdWJYEKgPa6MEBnxQEMJ0C6RruuBo7g/zGp
	 9/GmZqpSdjnMxiRjUo+NETRAqoHUVehapICGVrH38FTYk8Ry0hbcq0S4/q7ZVU6vB0jlq
	 ymeYTpl+9STRB+MPuKQIqm+7h/GMNUPTYx22S6C5HWAjyalDRGN+pSpo+Pa4K06mvHwoY
	 FDMp24bz2X5bKrHDZp0Qbagnb9g/76w8uRbJc68KnYoldISslxv1vmCax/wnVCXribw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030425;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+JysDtrwjZgKPcpS+n+FK022lLISiGYEsv5Q3bfcE+M=;
	b=eaf5vfKUxdJgaQy//1x1Vj2u5yz/UjwnOm5v5aKhVb0W/GE+5rqzoxr+Ns6iJycCUGga
	 bGW/AEnzbKAjsfmqTj+TMLelOnHFRyDOBkzLq/+juFDH0LAaDhyUkffOUxtDDH2REe8I1
	 gk8wS1FVDv6yuX/9pjRO93TFPrQTvw8b/yxRRB26fggQAb5yyg7YR1cwwNgFW5vS5rwSj
	 786vZdnvyUdj4BZzk27FRURL5ie4PQxxR63vxtp/NHgtYKmRRW3QGvTIX/DqnvN/ikdCt
	 +4jDaqZdc7YcQjzZDv+ronsvrg4ljZghQcovEKGuMXkSI8M1+jyuLMJ+4unV7ZvM/qA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vnUmPvl2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6B8606B414;
	Wed, 18 Nov 2026 19:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vnUmPvl2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AB651F000C4;
	Wed, 18 Nov 2026 19:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030425;
	bh=+JysDtrwjZgKPcpS+n+FK022lLISiGYEsv5Q3bfcE+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vnUmPvl279H+wORyvpHrkXI5j5lB1TC8Ad8BgjXhRIv3hEAthzQwODFUlmYLTsO0w
	 pCjnC0Qiz3ofCT3Ggsw2V82/q9uKwH38si9Za4Wa5jAui2CyO6WRsSUrNEIDpqSqMf
	 3CxqD63jPR9l5pM7lhUnTSa2rC/ARN4iPwsn4lgM=
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
Subject: [PATCH 6.12 0701/1756] vfio/platform: prevent read-only region mappings from becoming writable
Date: Wed, 18 Nov 2026 15:47:08 +0100
Message-ID: <20261118150037.098574162@linuxfoundation.org>
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
index 3bf1043cd7957..bd7600c6b9de7 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -595,9 +595,13 @@ int vfio_platform_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma
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



