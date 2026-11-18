Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040455;
	b=x9l+5scL5lW5725c9OvUnNp5IEEbR+YcKmKd9EgetOf14pukU4DmhqfpUMlclSjzaBnc
	 ucxixKDg7xqRHe/qIJwNwOPMKb8AIYUFDnF/d4H0h9mFsMtOuNSMRCeZ06l/vLjyz8x7K
	 t0Ifc+XZOjKLkrR2LWfoNMOX5fWVI3v1Fnl9GG3VaepVF74vsYP6ue/UNeNx0ZvrFeIlq
	 3LhtsGtZbz8EOMwN6BrSceuQPJdLd9ug3K0s+q9pJV+OaankXhW9GecTWKXmOAB2YiSjL
	 a9r8E163QPr7IkBc++Wa6oBzZ2+XFP174vaYJQih73YGux9hmkCh0TOVpnI8DmZgmlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040455;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B/3Wkt3mzYmomXTfAAz7v2nxlUjOqE4w5HoXonZu5+I=;
	b=SuchVXDQrL87CTvlFsoMDoRPcyw4cisEB0ZClCwWXSB6ZQ+CK9O/qsQ7TejfRqYHcd/F
	 HfH5KZSo+RXus/7549ZNJ9GxEzftIzFEYqcltRS3ckoAx6n1WH9fGf2U996gtZBcLcxjS
	 0jgT3A6NwE0A7/3O2mID99lVnj3KA5RzAWGaDevtva1kJM7GZshO4oSZw515nK9AGT6iR
	 Np1Dl07qUmkz/ixfpCKmSSWr11QfdMuBDkWf+KseeSvUAJ6bxn+Y3sQcy1Ix+NksXqJVN
	 P10A5congT8wNaBugI+2UcYvdBG8HX16+PB2C8dOGbfuHUaZwE+EwToWkQYAn3cOSlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UQMIbLbM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6F9606A31C;
	Wed, 18 Nov 2026 22:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UQMIbLbM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A520A1F000C4;
	Wed, 18 Nov 2026 22:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040455;
	bh=B/3Wkt3mzYmomXTfAAz7v2nxlUjOqE4w5HoXonZu5+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UQMIbLbM9TstHi+/cKYKm+KaWJCkCjFwi+B72y0Y6Akg7gK5ecMhiwnWCaZGBqLCv
	 dqhHGVeASU1QduecO1ur0ry/feoeLQnybV0V9H2CpSlfe0pLUQFHnVIu+bUO7U2Fwg
	 sK3kreJlanLl6C81gvV5fvw7EG26ryOna40nvBHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Abdifatah Suruur <suruurism@gmail.com>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2464/3318] vfio/fsl-mc: prevent read-only region mappings from becoming writable
Date: Wed, 18 Nov 2026 15:51:26 +0100
Message-ID: <20261118150435.343799373@linuxfoundation.org>
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



