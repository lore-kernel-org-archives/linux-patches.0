Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618081;
	b=ACUsD18WdQGrnV9O5/EEpnYOMbFANHXJeoxdRO0qfQl5JWrF3zpmCQ5300356MHeaAFa
	 Q1UZxk5fk87rh4SKkwMnYeq9tuPqgWz2WT8DVB4htxqMhzmJTSmlJT4LjGleafhXD4sfs
	 jXPRlgBFmE292lf582ssKLTpOujCBNKA6ay23JaBQeOld+oyE7Q6Zi62RR4BZPtpjGQCT
	 LLUampD0ufZh4vbCOzKq9xw8h9geyuSSJ3sI6ghcOgBcaDIYLtImNDeJPl/CjeilhxdIP
	 CJ84Ly8RjhhLC56J7qXCUBBy5yc7orT2rhGsSBLd1v9HT7dpT0MhACkfAzPubLqz2Pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618081;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8sNtnqRaZKoMXUYy/+SgP5IrfzM0L8Ukxpy/PSzuH8U=;
	b=01xWDXJ6VDJW0DuWnMoOMoDh4NPMBjiHXBMit2zOQSBgEeSWaUqHJRL2ioXUEl1bP4Ri
	 CT/Ccj6Mjy9JztD5SDCHow4Vc7ZrU4TDgyiacrH7xWcnzNME5NyYpJ1stkd+1h3mGleNl
	 8ceJF5W+GDNWch/MmV9MG5LtZ10jSC1a1Am3fb0LRbXBcg0UZCBEKwEcz3jDWQeJgxsGg
	 AY2HA7rL+SsPRDuHCNONCzqeP4ntlTlvvqHGVSyD3Ljke4H8DloRqDzpAnwL0wlhJgkCz
	 yZxqI8ofae6usv3hYtvEMnWVkkmbNl42hSF0hGCdkocqLDdGk2bzpI3cRUOcsel3mwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tEwDrcBi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B84B606A31E;
	Wed, 25 Nov 2026 14:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tEwDrcBi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E31C11F000CA;
	Wed, 25 Nov 2026 14:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618080;
	bh=8sNtnqRaZKoMXUYy/+SgP5IrfzM0L8Ukxpy/PSzuH8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tEwDrcBitly+51IwNQfOD7wuR4byv3UCJyC8J0mU0MUO+T1ixQIZEN7Z8iOab1XUX
	 YqfLWKHlcyhbxYLxBYcAEptpTusSwvIVvcHIOala2tV12j32ZMNj4om/vS0rv0zfJ2
	 ohYftrWMzgqt0fXB2m38NrerlwbwSMtqWKfK7c1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <oss.patchbox@gmail.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0164/1005] virtio_blk: Reset device on probe error paths after DRIVER_OK
Date: Wed, 25 Nov 2026 15:25:02 +0100
Message-ID: <20261125143825.583340109@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
index cb694afde3e5d..f97799b5154f2 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -1590,6 +1590,7 @@ static int virtblk_probe(struct virtio_device *vdev)
 	return 0;
 
 out_cleanup_disk:
+	virtio_reset_device(vdev);
 	put_disk(vblk->disk);
 out_free_tags:
 	blk_mq_free_tag_set(&vblk->tag_set);
-- 
2.53.0



