Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2A22DEA6F;
	Fri,  9 Jan 2026 11:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959930; cv=none; b=REzGFtxDLqGODMsz4aqNiiZLI01Uos7dvujM+pFoFRgIKGENHnquZ/E/kAqeJvTIRX1I96f1kM9kCl5GhH9nNNB8BvTrPuE2Vfo6s3x5RoMll96cAGTACQeFAjBd1uvRlINLCoM41CQZqrx6HdCu5JCRzbe8cluKLJ768YuF8Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959930; c=relaxed/simple;
	bh=q0xe5SvPjkGDmcHmq8QtjArtBvVt4tKGF9kJVS8f67I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CMhaysj/uRIPMvLjA+PWLkjcMQp1hngj32sEQFHLejXprf14HyHX4G4aVfIGmlLvXER97818g9bs20EM738wUSDgkdoAllxVXSl37s5xGcNoSFs1OWlfukAXf9/44+As/3REyNc1BdFz6zgmibPx8lIDPMel8Z3rAKeh7tP5zZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E4YKTI5N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E4YKTI5N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D10CC4CEF1;
	Fri,  9 Jan 2026 11:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959930;
	bh=q0xe5SvPjkGDmcHmq8QtjArtBvVt4tKGF9kJVS8f67I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E4YKTI5NY+N5UCzddJucVUjoqDcVGhlHoZL+FQy6h5SQXgcdvYeX8iDrCwpwlgJ7W
	 DCmgggTKC6H9Yd9Uv/I3aNiznMCam8wSGiKbZTHNBGQZHtVcgx1ds1lW4OFqeKplwD
	 qdV3pZ+0xeDPg9kHMtMkSIn1AoLCF3voQUfUtqgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 226/737] virtio: fix typo in virtio_device_ready() comment
Date: Fri,  9 Jan 2026 12:36:05 +0100
Message-ID: <20260109112142.502868468@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael S. Tsirkin <mst@redhat.com>

[ Upstream commit 361173f95ae4b726ebbbf0bd594274f5576c4abc ]

"coherenct" -> "coherent"

Fixes: 8b4ec69d7e09 ("virtio: harden vring IRQ")
Message-Id: <db286e9a65449347f6584e68c9960fd5ded2b4b0.1763026134.git.mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/virtio_config.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index 2b3438de2c4d4..84a9fd21df3e8 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -288,7 +288,7 @@ void virtio_device_ready(struct virtio_device *dev)
 	 * specific set_status() method.
 	 *
 	 * A well behaved device will only notify a virtqueue after
-	 * DRIVER_OK, this means the device should "see" the coherenct
+	 * DRIVER_OK, this means the device should "see" the coherent
 	 * memory write that set vq->broken as false which is done by
 	 * the driver when it sees DRIVER_OK, then the following
 	 * driver's vring_interrupt() will see vq->broken as false so
-- 
2.51.0



