Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB7936A011;
	Tue,  6 Jan 2026 17:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722104; cv=none; b=iPyjq5jGuq1xO7kGM0xdE6573j16dvJVgOJiCPpyCqdqQ4gnbd7AlDEBXDmZ36QgLFLA4Nz6HLYIYvRClri9CEkO/IG4c3FhHg0xSZXbKyUhBVtrleXcpQgW2PrQhO9H/pXw/k8Y6n+9mRAIntzTU1ESzQCLTu1WQhX42NPwt8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722104; c=relaxed/simple;
	bh=9ZFpmLIBHrveaPXzGSbiPDbstGxj9UXPbawZpFErsc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SoglWUMzseZEl2htx2S7uWBwLit5HauJNXniJK1XRlmLrNu8Sd8SxYWFpS8QMgxCXz99zxYIqkgg6NWNbXGFm4kISlSP7jEEpSVet6JHBYEmml3CUQ14rlgosw4MptLJoWGl3eJte0USg1ukFZSh3fe7kgAu7gYQ89jk4W1FRho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bKq3Jkko; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bKq3Jkko"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A27DC16AAE;
	Tue,  6 Jan 2026 17:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722104;
	bh=9ZFpmLIBHrveaPXzGSbiPDbstGxj9UXPbawZpFErsc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bKq3JkkorPQ4ffZJcSkgWa4uloNKmJtsLYMCRhZbkWj/MJXJufykWQ7znN4WqWfIY
	 zcM2uJFyf2M3LEy8SxyLiZtgYmnnNg7yLMPb6pRqeEa7vWk/r7Tp1uJ0KwliO0NQyB
	 FC/Ad8Q0ANrUCbvif6NrdTjfxUIspAKnnrlg0b6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Longfang Liu <liulongfang@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Alex Williamson <alex@shazbot.org>
Subject: [PATCH 6.18 123/312] hisi_acc_vfio_pci: Add .match_token_uuid callback in hisi_acc_vfio_pci_migrn_ops
Date: Tue,  6 Jan 2026 18:03:17 +0100
Message-ID: <20260106170552.294897717@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raghavendra Rao Ananta <rananta@google.com>

commit 0ed3a30fd996cb0cac872432cf25185fda7e5316 upstream.

The commit, <86624ba3b522> ("vfio/pci: Do vf_token checks for
VFIO_DEVICE_BIND_IOMMUFD") accidentally ignored including the
.match_token_uuid callback in the hisi_acc_vfio_pci_migrn_ops struct.
Introduce the missed callback here.

Fixes: 86624ba3b522 ("vfio/pci: Do vf_token checks for VFIO_DEVICE_BIND_IOMMUFD")
Cc: stable@vger.kernel.org
Suggested-by: Longfang Liu <liulongfang@huawei.com>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Longfang Liu <liulongfang@huawei.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/20251031170603.2260022-3-rananta@google.com
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -1564,6 +1564,7 @@ static const struct vfio_device_ops hisi
 	.mmap = hisi_acc_vfio_pci_mmap,
 	.request = vfio_pci_core_request,
 	.match = vfio_pci_core_match,
+	.match_token_uuid = vfio_pci_core_match_token_uuid,
 	.bind_iommufd = vfio_iommufd_physical_bind,
 	.unbind_iommufd = vfio_iommufd_physical_unbind,
 	.attach_ioas = vfio_iommufd_physical_attach_ioas,


