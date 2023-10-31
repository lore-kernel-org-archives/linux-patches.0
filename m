Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B212031C
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CTioll8T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45B99C433C7;
	Tue, 31 Oct 2023 17:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698771770;
	bh=DdDSAXuOvGFFvNvvCDfKAcys2iXO4oA/fE5sxyxWdEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CTioll8Tblqusew7yhNmnNjQP3/J0pFbNL4slLyw6FeN6kzy/A7B1sz3DiglnYhXP
	 b8rzyhdbncZ41x/aHw4HLso4v5/Pa7Q99JlzQx8d7MR9cYK2ENj/zoIFsdtZrelPgv
	 AvicM3PUMeaw75CeTJtZQje/zBGCcfa82XdcaYY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>
Subject: [PATCH 6.1 15/86] virtio_pci: fix the common cfg map size
Date: Tue, 31 Oct 2023 18:00:40 +0100
Message-ID: <20231031165919.086294973@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165918.608547597@linuxfoundation.org>
References: <20231031165918.608547597@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

commit 061b39fdfe7fd98946e67637213bcbb10a318cca upstream.

The function vp_modern_map_capability() takes the size parameter,
which corresponds to the size of virtio_pci_common_cfg. As a result,
this indicates the size of memory area to map.

Now the size is the size of virtio_pci_common_cfg, but some feature(such
as the _F_RING_RESET) needs the virtio_pci_modern_common_cfg, so this
commit changes the size to the size of virtio_pci_modern_common_cfg.

Cc: stable@vger.kernel.org
Fixes: 0b50cece0b78 ("virtio_pci: introduce helper to get/set queue reset")
Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Message-Id: <20231010031120.81272-3-xuanzhuo@linux.alibaba.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/virtio/virtio_pci_modern_dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/virtio/virtio_pci_modern_dev.c
+++ b/drivers/virtio/virtio_pci_modern_dev.c
@@ -282,7 +282,7 @@ int vp_modern_probe(struct virtio_pci_mo
 	err = -EINVAL;
 	mdev->common = vp_modern_map_capability(mdev, common,
 				      sizeof(struct virtio_pci_common_cfg), 4,
-				      0, sizeof(struct virtio_pci_common_cfg),
+				      0, sizeof(struct virtio_pci_modern_common_cfg),
 				      NULL, NULL);
 	if (!mdev->common)
 		goto err_map_common;


