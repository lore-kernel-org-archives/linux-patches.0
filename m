Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030431;
	b=f1yZ0yDZ0QraY8Q/RK9x2SC27MEw3BBLyPDZhKf3S5bylMfW6pmPeHo4wZaloM+LUNL8
	 zVL2K7B1qqhaDXhbXNSp+qs1V2vgZXm088lCyaj463jg/UWM/ddNwFkjaeXvAJ+wTuivp
	 a61gsGWUvDcGC2Ted6YmDsw567j3tLk64blmvfruGBHLqSfByM/dIsPP6o5qVqQ2cwB/H
	 czT6EOJEJDdgkmd470wSwJb6HEQS9+4Wyv7RLMf31YdA33ftDBMNUCMwhN7coSIqg+M6R
	 zcgeL7F2RjF6GkGz4tbWD8o1+E6DzFX2Ss4y0gCS1yEOhf4SG9kFhDLNQ4QD/TWVBWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030431;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vKea4YdH4dVjA3v81nwFTg64BqRbDvt/6jbPtDMkVAw=;
	b=d80ZdBYXJ4Xp550URecoZxpizPw6ybJjA1WyYpKjfKBkp6h7GVT7pQ/7dPOfbfqRk0PC
	 kwglYySCGZlZeepoOKqY6Ayxdk2Pa1JBjOYINOUD+zqenI+HsOZ4+tk0SW4JM2wsUi5iX
	 4aSJKtNY6DSIGsS8BKzLq6Q+QlT9b80ztZUp1fRmqYWwpkzoIfbyRp9eX6CDyDKKrw2zh
	 JM9AHc1L3c+/BMPY5gd8nkEJBNKXFkNqJ/mYzWVgSqkiW2ihqTY9ye0ZTWcsBgGrTaf/X
	 ClER7oypYVoHqIbJPd/nGd/ShqcucC6gMSr4Utw8DvoBXW0jtLG2x0nJGuFJ4H8x2xA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=odY83s9K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D3A606B422;
	Wed, 18 Nov 2026 19:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=odY83s9K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B87951F000C4;
	Wed, 18 Nov 2026 19:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030431;
	bh=vKea4YdH4dVjA3v81nwFTg64BqRbDvt/6jbPtDMkVAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=odY83s9KDjNnmJEucBooMv2K6yyANAQ8YeBl0do3EWDEH5pwWWGNuDEATpuuJ3HQW
	 du46SzOVlymZQLTod32uF9jo8hNrdwXeCGEoTXo3dUAlNTTJd2pJMQ3X8WuaRukPts
	 xGFIGhQRB0dPPM580MYKAIECdyqlbJutCFUahoIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdifatah Suruur <suruurism@gmail.com>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0703/1756] vfio/cdx: prevent read-only region mappings from becoming writable
Date: Wed, 18 Nov 2026 15:47:10 +0100
Message-ID: <20261118150037.168747404@linuxfoundation.org>
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

[ Upstream commit 9c5cd385d295fa8621dff0e9f6063e3f6ff24159 ]

vfio_cdx_mmap() rejects writable mappings of regions without the WRITE
flag, but leaves VM_MAYWRITE set.  Userspace can map such a region
read-only and then upgrade the mapping to writable with mprotect(),
writing to MMIO regions the device marks read-only.

Clear VM_MAYWRITE for regions without the WRITE flag, as i915 does for
its read-only objects and as fixed in drm/vc4 (CVE-2026-68445),
drm/panthor (CVE-2024-53071) and commit a5edadbae57e ("ptp: vmclock:
prevent read-only mappings from becoming writable").

Note this is defensive hardening: no in-tree cdx device currently
publishes a region without the WRITE flag.  The guard costs nothing and
keeps the mmap() interface honest if a read-only region ever appears.

Fixes: 234489ac56130 ("vfio/cdx: add support for CDX bus")
Signed-off-by: Abdifatah Suruur <suruurism@gmail.com>
Link: https://lore.kernel.org/r/20260929094848.7439-4-suruurism@gmail.com
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/cdx/main.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/cdx/main.c b/drivers/vfio/cdx/main.c
index 4cf2e4fb02c81..921e259c0288e 100644
--- a/drivers/vfio/cdx/main.c
+++ b/drivers/vfio/cdx/main.c
@@ -289,9 +289,13 @@ static int vfio_cdx_mmap(struct vfio_device *core_vdev,
 	    (vma->vm_flags & VM_READ))
 		return -EPERM;
 
-	if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_WRITE) &&
-	    (vma->vm_flags & VM_WRITE))
-		return -EPERM;
+	/* Prevent read-only region mappings from being upgraded with mprotect() */
+	if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_WRITE)) {
+		if (vma->vm_flags & VM_WRITE)
+			return -EPERM;
+
+		vm_flags_clear(vma, VM_MAYWRITE);
+	}
 
 	return vfio_cdx_mmap_mmio(vdev->regions[index], vma);
 }
-- 
2.53.0



