Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590643;
	b=GCG1tuU1BpSYY6hmw36aNhHZtnaYROPCjaoYm4SfnUEZmLPvYEUuoyneyUs3aBcUgYCZ
	 fHZDW9pZnfkzKWER+1ycGM76MVbCiRSOAEi2jEKhPlpsKo5MrT6ualaBWQGKr2AlbxvUU
	 hYOtcwXOEpsS22sdxKoIUPL8zQgOGbpruw02QCdL8WAAucqTUNQEWKLmtivKnOSV8R/5X
	 A5mOvPxmz2LEc3bYs55NVt9XEbsX4LgyXDubYFqttas0I9aIpJjvLdWbEKHGA4mUP+cTN
	 HkgAIhOKpIvMTOjXc4e1u/ZIelB2ZHWeTSmZDnYYmS9zDlTTta9L0ko4CNTBg4WAH8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590643;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sWpZ2cBU7bAXRfpnEKVG6i+3kEEvWDElMjHvi9vo/xM=;
	b=A58UGaK/W1awj1Wipuz5H0n6Hwq9bj26FRL+RuT9fQC+aF8Ki5S4+d9V4u+yKrRZvsV9
	 07u8NiXotautG/O1AVPKwgIZjfKDA2mZfo4o3pBHj0NtPVGokk/o20YUu0Z+MKQrJN5Ig
	 /5YHhAIT/8cZFvYVE/NSWaJt46cN1+FKZb4TFVG7dt5DZpHioRPR7s8Q9lzYEi0755BwI
	 XwQSWkzfk27WVqYLETdDYVF2ZpZjIgYhhYmoinA627/UfEsvaGFRw70qQ1yFk7svJXsTI
	 h3FFDQ774cBroDGoeSxAGRkwvjmXf6bpxJas5evM9et77GndwLprVuGre3EcFUX4gzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Px2BkI0J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7A66077D40;
	Fri, 13 Nov 2026 17:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Px2BkI0J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2618D1F000C4;
	Fri, 13 Nov 2026 17:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590643;
	bh=sWpZ2cBU7bAXRfpnEKVG6i+3kEEvWDElMjHvi9vo/xM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Px2BkI0J8RM7RBuOlefiy2+hps0er+093KoWcAcj75UM16C+MHxiVwZiHpxgstsTn
	 Lu8riFTwQG04M7hqCHWnYqjpHE6nBXDSSWi9Sb1QASyqPVUY7yJg4+JG9k/+fzzSX1
	 GAZelIbCrBCR2BH25nSliQ9rj0l1g+RrfPVW/bXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 565/686] vfio/pci: Restore 8-byte ioeventfd support
Date: Fri, 13 Nov 2026 10:51:38 -0500
Message-ID: <20261113153840.810735651@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit b30b52c2fb82e6d38ee2845a4d85e8254b44f3d8 ]

Commit b44a06bd28f2 ("vfio/pci: Remove #ifdef iowrite64 and #ifdef
ioread64") inadvertently converted a conditional 8-byte rejection
into an unconditional one.

Originally, 'count == 8' was rejected only if iowrite64 was undefined
(#ifndef iowrite64). When iowrite64 became globally available via generic
fallbacks, this rejection became dead code, allowing 8-byte ioeventfds.
However, b44a06bd28f2 removed the #ifndef wrappers but left the nested
'if (count == 8) return -EINVAL;' intact, breaking all 8-byte
registrations.

Drop the unconditional check to restore 8-byte ioeventfd support,
matching the original intent.

Fixes: b44a06bd28f2 ("vfio/pci: Remove #ifdef iowrite64 and #ifdef ioread64")
Cc: stable@vger.kernel.org
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Link: https://lore.kernel.org/r/20260922040013.2188-1-lirongqing@baidu.com
Signed-off-by: Alex Williamson <alex@shazbot.org>
[ sashal: Adjusted context to retain vfio_pci_core_setup_barmap() instead of vfio_pci_core_get_iomap(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci_rdwr.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index 25380b7dfe18a..8338708b99c1e 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -449,9 +449,6 @@ int vfio_pci_ioeventfd(struct vfio_pci_core_device *vdev, loff_t offset,
 	      pos >= vdev->msix_offset + vdev->msix_size))
 		return -EINVAL;
 
-	if (count == 8)
-		return -EINVAL;
-
 	ret = vfio_pci_core_setup_barmap(vdev, bar);
 	if (ret)
 		return ret;
-- 
2.53.0



