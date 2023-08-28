Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B5711C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:25:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F8FC433CB;
	Mon, 28 Aug 2023 10:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218327;
	bh=3x8ZqQdsBQJzXZmmqqyylx7RJcuk5kmzYtF8MVWK3js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KMEbI4fXJhnVLtDpNickbEnMSeIdZyqD1Ca5BLjSu7vV7FpMiK5uGuT2b3I5YgPWf
	 T36KUDetrZ90+qELsJV1Dt7cbb5tCmwJKMo/Qa9NeNzbzTtMolis5KA+65WlqrYgPx
	 CyvKBZxemz6nHgDvai3tdZIt2vD7j9ebylnx8m8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tang Bin <tangbin@cmss.chinamobile.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 047/129] virtio-mmio: Use to_virtio_mmio_device() to simply code
Date: Mon, 28 Aug 2023 12:12:21 +0200
Message-ID: <20230828101154.953541777@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101153.030066927@linuxfoundation.org>
References: <20230828101153.030066927@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tang Bin <tangbin@cmss.chinamobile.com>

[ Upstream commit da98b54d02981de5b07d8044b2a632bf6ba3ac45 ]

The file virtio_mmio.c has defined the function to_virtio_mmio_device,
so use it instead of container_of() to simply code.

Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
Link: https://lore.kernel.org/r/20210222055724.220-1-tangbin@cmss.chinamobile.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Stable-dep-of: 55c91fedd03d ("virtio-mmio: don't break lifecycle of vm_dev")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_mmio.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
index c20a678436263..d654e8953b6cb 100644
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -536,8 +536,7 @@ static void virtio_mmio_release_dev(struct device *_d)
 {
 	struct virtio_device *vdev =
 			container_of(_d, struct virtio_device, dev);
-	struct virtio_mmio_device *vm_dev =
-			container_of(vdev, struct virtio_mmio_device, vdev);
+	struct virtio_mmio_device *vm_dev = to_virtio_mmio_device(vdev);
 	struct platform_device *pdev = vm_dev->pdev;
 
 	devm_kfree(&pdev->dev, vm_dev);
-- 
2.40.1



