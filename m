Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07366199EA3;
	Tue, 16 Jul 2024 15:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145597; cv=none; b=grtd64aP16zbkn52h53Xnbi3tVfJwSlwhRjvPQ+RjAcj674q96P9T2ffgzX4T8mI5JBVvAowofvLdYWAE3QyKN+77M/v3j5+8XLaqCckt9rrQkEeAvXLuAPXJBLgkNLBWTJfgvCJWPpSzYU89yQOO0G/Bm5BebGPRXuCcfTnt6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145597; c=relaxed/simple;
	bh=8j6mowoEtZ79Jh1GvYSdcRZYjTpd7o3yvPrD3EydE/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GlfDkYTMe3xF4GK3u65Tg/uF8JpGmEEGSi3ToMvSvyOVZDlxNaJHDjTJ1ChAFQuTme1n2Zt2hxkOC5aewWg8f579CUyKEPPfM4IY0MX4pNLKPITYadP+tIUiO3a20NejSwE9l1hC+DhylU9Rkxw/cPbilUSt7JhjR9bmdepgFsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=af7mABvn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="af7mABvn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD7BC4AF0D;
	Tue, 16 Jul 2024 15:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145596;
	bh=8j6mowoEtZ79Jh1GvYSdcRZYjTpd7o3yvPrD3EydE/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=af7mABvnPp9S2GymLCH1b8/5Dh9TDGAqYfqgTMzNE9kDvoyWuHceAz+xdREsRsXzO
	 QYM0UDuDSoJ1Hir520LMndg8M2C2lVy1056D/8eRXR+828NUG8M9bpYINbi3QGY9zE
	 +/7UcabM7RopAZhrbxyqZSDfnoPgIEdf2VZ65LtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=C5=BDilvinas=20=C5=BDaltiena?= <zaltys@natrix.lt>,
	Beld Zhang <beldzhang@gmail.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 004/121] vfio/pci: Init the count variable in collecting hot-reset devices
Date: Tue, 16 Jul 2024 17:31:06 +0200
Message-ID: <20240716152751.486707566@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yi Liu <yi.l.liu@intel.com>

[ Upstream commit 5a88a3f67e37e39f933b38ebb4985ba5822e9eca ]

The count variable is used without initialization, it results in mistakes
in the device counting and crashes the userspace if the get hot reset info
path is triggered.

Fixes: f6944d4a0b87 ("vfio/pci: Collect hot-reset devices to local buffer")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=219010
Reported-by: Žilvinas Žaltiena <zaltys@natrix.lt>
Cc: Beld Zhang <beldzhang@gmail.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/20240710004150.319105-1-yi.l.liu@intel.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index a3c545dd174ee..a8f259bc2f4d0 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1260,7 +1260,7 @@ static int vfio_pci_ioctl_get_pci_hot_reset_info(
 	struct vfio_pci_hot_reset_info hdr;
 	struct vfio_pci_fill_info fill = {};
 	bool slot = false;
-	int ret, count;
+	int ret, count = 0;
 
 	if (copy_from_user(&hdr, arg, minsz))
 		return -EFAULT;
-- 
2.43.0



