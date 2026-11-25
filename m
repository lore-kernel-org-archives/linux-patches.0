Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621353;
	b=eOJm5Yc393utEHNUbQdH7UY/K3xXYjH1tJxVQwFhmxppOCaCuCXkdlT43La6aGRgr6mw
	 XteIVkjSdNKANgcnWCA5IcaOzSKoACEjVSCOhU/oYzmgT8kEoIRPuREl03VuqUNbm5TDY
	 T61G+0Lw+/JiE3nSYxLNOLEUg6199OyjDJnmL3tFr4qUpU2rvHQ2eZo3abw8eOCPBAfjq
	 CqxcUqiDx+yOaMxe7hee4OQFkK6BL5Mz6LJLM1ESjMTxPL6V+6zFbZyfVVL/P6qhJp8Ei
	 TmfiFYU1CHck72grgX98mWrDXnTBV9H8osTew+Miw8KIXnGzdBNpDBGwjXo3+vZQ7Nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621353;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k/sqQsMFKJZTr7t48/+cJIcfbXt1fYLstZTvty60Wf8=;
	b=Zrq4lJ9jKXB6dHNUW6FYVPazb3v/W47ClVLq77NdV5OWFlSHMwNpbaEtO+2yhMWPLS+j
	 nfx4P4BTzdayPyl6+hUCDNis2Eva7tWtq6fWBYDwJS/MfbXrT/F/+g7qIdjd4ZSeWdAqy
	 uGvi270WSsz3FJ9WyT8ed+Ytb8uGBkpY13pg93HePGvpNUYEMVZ3clMAQpQ9A1e+RKvKy
	 4IFAL7g7/5w0XbvvSndhhdV8nyeo9jtqzlWPpigaFbxTCX5mcWQ5GX9JlQuc5iD0xUQHt
	 /o5ektzkE5yJ5t4Uf3E8OUxMher69vkqI6R93wciqUmTTeRvYGFouZxl6K13W9xesfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w2M8uOxM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A160606A6A4;
	Wed, 25 Nov 2026 15:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w2M8uOxM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6852F1F000C6;
	Wed, 25 Nov 2026 15:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621352;
	bh=k/sqQsMFKJZTr7t48/+cJIcfbXt1fYLstZTvty60Wf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w2M8uOxM0gwc93K+AVCKeC+RC4SSznzSON4PbqUHXqyT5OyiZyjJbTaK6ZC2mZIL7
	 d92QD9w/Wrq81tTz1RihZZvFNJRLMh9y6x5KevZyCRSxYHsJ9KDqFI+zlyvvoQCcDQ
	 9z8QwBBtqwO0PMUaJuitlrTDA3/80eJs/LGEwtrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <oss.patchbox@gmail.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 162/990] virtio_blk: Reset device on probe error paths after DRIVER_OK
Date: Wed, 25 Nov 2026 15:25:29 +0100
Message-ID: <20261125143825.888178549@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Yuho Choi <oss.patchbox@gmail.com>

[ Upstream commit f4f6e9a9cb349003d333f0776de94f12ac95b8d2 ]

virtblk_probe() marks the device ready before revalidating zones and
adding the disk, and either of those can fail.  The out_cleanup_disk path
they take goes on to delete the virtqueues, but nothing tells the device
to stop first, so it is still live when the rings are freed.

Reset the device at out_cleanup_disk, which is only reachable after
virtio_device_ready().  virtblk_remove() and virtblk_freeze_priv() both
reset before deleting the virtqueues for the same reason.

Fixes: dbb301f91fc8 ("virtio_blk: add error handling support for add_disk()")
Signed-off-by: Yuho Choi <oss.patchbox@gmail.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260922211207.523999-1-oss.patchbox@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/virtio_blk.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 6cfad73bf47df..29317945a7c00 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -1583,6 +1583,7 @@ static int virtblk_probe(struct virtio_device *vdev)
 	return 0;
 
 out_cleanup_disk:
+	virtio_reset_device(vdev);
 	put_disk(vblk->disk);
 out_free_tags:
 	blk_mq_free_tag_set(&vblk->tag_set);
-- 
2.53.0



