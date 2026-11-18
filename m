Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040452;
	b=sROBhAuNVFvUJ5QtYG1xE07cS2Ctx3oPZOsVrvzH5K/14z27ciBc7VVAOu0pXcNZtmNB
	 HkGznN7n75r9JZTyf6Cw8iRxOTnhp6WsB8Y3z6hrxZ60Gk6RrGvtQbW2aTTJx6cKmzhbc
	 tH1v4xEsfJBE7Vd9cD7R/rRizIRfzLx8AyzqYBaEvUm257wJyvy5OU5cF8i28a2Hg1BSV
	 moDBerxKT3nx/hKeqiZaKbYUrlIP04O01MgPpdk6SK2l1dU8qhk4kZ82Kb2aMiGCbf7rv
	 7QTrcz0p9gahvyFi5C77yVe/WCT1KXIzUWflwW1SoveKGX5eDLKCVjO2GtIT9bD3sZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040452;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JDgmeg8ucjmll0P4JyzE1qnhU024iQkqbkHYF9iwG8w=;
	b=F+j5BzC4fr/zcVgxLHfGcKbIR59NQl9VhM4athcacHggQzI8EHiwUFXBF06ehJEaJf1m
	 8jDhRc/X1b83Knf3Ro4YPyDv/cCPE0xm+BLe6DP849iIPgMe6UBlh0E2oqmytHNIZJ9RD
	 52Lgpo3vuqhrrz8fT41iUrCEgDuLoLuJYAy8xkNgPs8LsNnU4ZT/D5WyZpSACSFxFP1e2
	 JLXBBNQNKML0AOjpsa7aFu9VAmij7JlLwP/R9ZcunHnBlzp8ke9ji1xQ6uLa9N60rpcUw
	 P4SKhf9VgB5WmYXcCHeXSIgAcQNfIMtAflI4IN0SHzaDha/08uUqyCinyjRgXim3f/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nh5X4ba5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92EB3606A31C;
	Wed, 18 Nov 2026 22:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nh5X4ba5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 003191F000C4;
	Wed, 18 Nov 2026 22:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040452;
	bh=JDgmeg8ucjmll0P4JyzE1qnhU024iQkqbkHYF9iwG8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nh5X4ba5EeigmydSsuME+BpcT6de0IMDgXxQpkUIlPOOhfPOuO0/iI5YHg09mYjmj
	 9sWqGfWZXPlfRgclF9KJ6eMjvxthAK81DnjO96nyssLqJdNG6WS6+IgD9a6t7FK3SR
	 /a0gzFNxkry3/bOqOmmrb96CjBQQBTFd0Io3tk/c=
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
Subject: [PATCH 6.6 2463/3318] vfio/platform: prevent read-only region mappings from becoming writable
Date: Wed, 18 Nov 2026 15:51:25 +0100
Message-ID: <20261118150435.316645798@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



