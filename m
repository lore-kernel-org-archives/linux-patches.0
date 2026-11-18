Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024901;
	b=AtAQ1hXY173HX4a4ZTzt3Yhaf586VyAGWnHSMMZifFYpjmlLEmh3lKhvCgq8spJ4Tii9
	 JRBSP1KCFt2n0rkCbUIllDIXmx25ytJyVAqTThXUjGqaa5ILPtPynSacbc++REE6W7Ghe
	 tT/mYqUmzorWo5V8CsHo41q9JD5GLh8PgDMJBBAtVMhsLHQUcbzewPVzAmfUh05Up1Sp6
	 2MKRl3G+ktA6lX360+G0Mx6jHi4i9cNzJ2q9PEuSdgrFmPlmJBc3xkUKZSjgxzmfEttGo
	 GiSw7hZLRYJsQLHhsWm9BAWhOh06A5Rque64+zMlWRPyxSVcdAzraD0z+s+2lw0u0jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024901;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cBK8cvlQvAfoRmnr8E1Lz+CdWDTlcRCaBxpQL9O92lQ=;
	b=O4pWzd87LhlK6K0bZX13xdk2HaHxEmcUgmrrWxqjNy7K1IGzpnLNrzgpMUeAgtrOo3hJ
	 pKoW5JRRjlqjPYDk/+4nA8Ec7gh7QgwqdLkJLFtoZXmqnJJy3zcAxpoZF2jehqtuyG3iq
	 qnRpqn0InK4A5Fz6Ar8Sp2+e2LzTXIofrHr3aQ0RBxJ/070u8Gv0Fr66k/Bwaf3sqRV5O
	 hl3zBR/u7oMNIs3Cfr+HSPzq9KobU3saSSnRv4JefQgTGcSeluk3Ezoc/nJU+PBpR+kBh
	 CjFa7nyE3InQZ+p2MmDh8sg5jwAq0bgsit2MVunhJc1j+6j+VFpH/Jj9nxzEeVeEc6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kgTW7oh2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CD26606A31C;
	Wed, 18 Nov 2026 18:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kgTW7oh2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3F61F000C5;
	Wed, 18 Nov 2026 18:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024901;
	bh=cBK8cvlQvAfoRmnr8E1Lz+CdWDTlcRCaBxpQL9O92lQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kgTW7oh2MBQfRkTfJ2oyCkdJHhXaMlLfmwd7602E8/Onc9n6njw+U1ngjslrqdhhI
	 OJlGNvQqF8qR0z3j0WymMGLpAAtLXVgVPF/8dTsXgf28e66dDuPZAYy6k4mk2u2aSB
	 k1MIpE89whbl1lf9us9NMFSIXRGSht6YtQwjr09A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdifatah Suruur <suruurism@gmail.com>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0889/2151] vfio/cdx: prevent read-only region mappings from becoming writable
Date: Wed, 18 Nov 2026 15:43:44 +0100
Message-ID: <20261118150154.692624309@linuxfoundation.org>
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
index a9639730cfdf5..a7f33a47df52a 100644
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



