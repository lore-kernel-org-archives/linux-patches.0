Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064296;
	b=rIUJR65hVLz1271Jfi8/grc21YkVXzVwJiOCzMGWOkjahurwFCXPx5OCSzRC4/4ZwgyE
	 U9gCguX6VcfqauYlGxAXZpOYVxbtAAiCwxa5IrCH6kvZ6M6si9uwNz+y7gtmuxkU2AT2f
	 /YKsk9QQzpVGXGd9MyM90GbXriP12xv0vnOV4V1Ci2ThD60JUQa4h8ofk7B82eX6UQ3PN
	 LBQ4RW9JL83v2RdxU7TlAV3AL8iua52RraPonInLJXO0x5YQuHmcfMAptrJ4a0DsoqknB
	 q6Y7qmu4B28swP1JQzXxHRgOh0WkTi9CcXZfIten/PsEuNImc1i+PyDD+VadehVRq2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064296;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IsACu7k3XY3TiE1hX06gpjvUk0+c0zyPXHzlUkJ7jx4=;
	b=WY1G5F4poFh+7Ifrn3kIKZJCc3MGRwDBKMlfpD2BXchoqcuOGVTvhm+elU9lGy+Zt9Cz
	 at5hf8WDYOVYZbxF8/Rax4jbhHILKyCfIDLVEM9l9r5OCEEcWImnhak9tUGYwPCALe/jc
	 zDyF9y9+lQoLO193E79CGdvkHxs0K3+SPJNTyZFhvs5LN4+C+vK9T1N1nNsjOEfdssNXj
	 qGyogUfmDk4E5C+XliMjUm0ama9ikdEEfW/evoLF3rEtZ3lKaJrYbV+u1fSKBjvIDPcmo
	 8U9fKT0odCP8aR+yWbEHyosspksIoBHKPyhZuivZX4YwHd13/vqLPhcSDWm4NCWqIvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TtqilX0F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48722606A9D4;
	Sat,  7 Nov 2026 15:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TtqilX0F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD311F0089F;
	Sat,  7 Nov 2026 15:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064296;
	bh=IsACu7k3XY3TiE1hX06gpjvUk0+c0zyPXHzlUkJ7jx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TtqilX0FND3Da9MbdD9h9ZNqxdbg0mToGp/rW9tkfClasx8tUF7+nG+Y+0C4+tv19
	 vtmroVI6rI6iZYtLhoauzfL9koPSuzYgU/DhSB01L5cKB311kixTKmKHRx1ZC/wWIX
	 qX6a6lu9bmF7priTpnb1FSlDLx+HPNNqH8VLgqeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0390/1257] vfio/pci: Restore 8-byte ioeventfd support
Date: Sat,  7 Nov 2026 08:44:46 -0500
Message-ID: <20261107134950.321151667@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci_rdwr.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index 7f14dd46de17a..df88480876815 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -423,9 +423,6 @@ int vfio_pci_ioeventfd(struct vfio_pci_core_device *vdev, loff_t offset,
 	      pos >= vdev->msix_offset + vdev->msix_size))
 		return -EINVAL;
 
-	if (count == 8)
-		return -EINVAL;
-
 	io = vfio_pci_core_get_iomap(vdev, bar);
 	if (IS_ERR(io))
 		return PTR_ERR(io);
-- 
2.53.0



