Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108F112B72;
	Tue, 16 Jul 2024 15:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144878; cv=none; b=KKpjvGWn0hglcQpCHXPZOnV/lCnqbYdhnfYSMqTBTGg9IUbqJV1fv5wbpa2a5h7WwM7RGXH+7OWuVSRKUX45eYVB3kkkuYoUhHnMgVds100M4IrG6B7rvXBmutN/xHYRjujLVcZRzmf2Xy8ky5U17WaPHLIGcmAA+D2m4so/jAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144878; c=relaxed/simple;
	bh=cHr2k8/gH5bidPIynfCc8C7hP3Nz4Kr1YiZzS83th7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GCfOe2GH7p7sgGmIzBgb16iL+BKQpaxoL45yYW0bJowg47w4csWHxMb0Cx/KU57h8Qv0rBQexTVJ3YyqhJF/jkQptmKBXG/ZNYbKAMTlC5lxWqgOOH3Lw/2cVtfnkBSO90HBbTaRI1VyCEmSzhUP0TPVrgq8VS0gHhNgi0zqzm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T5hBq05N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T5hBq05N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87D6DC116B1;
	Tue, 16 Jul 2024 15:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144877;
	bh=cHr2k8/gH5bidPIynfCc8C7hP3Nz4Kr1YiZzS83th7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T5hBq05N0aN+4dEfQVE6wcIG226IwDfyD/kDhWyAcajibucq0Q846VgPg3JY9I8IF
	 UDixI+FmibRvzu66+dkGgAVgOHPTNldDQdeRfhi+HhC/QXsAbhkdJJQsQkeEhG9g3Y
	 OpTAShjuWO+RJIeAIPBQbvjYu7Jm2Wkla92xqnf8=
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
Subject: [PATCH 6.9 004/143] vfio/pci: Init the count variable in collecting hot-reset devices
Date: Tue, 16 Jul 2024 17:30:00 +0200
Message-ID: <20240716152756.154513415@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index d8c95cc16be81..ea36d2139590f 100644
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



