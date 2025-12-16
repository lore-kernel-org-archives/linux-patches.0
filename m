Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F2D340DBF;
	Tue, 16 Dec 2025 11:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884737; cv=none; b=Fb3Bu+ydPID0U5L1u0kRE8zgBvQoyqqWnUFwDTSyEzaTazWkGF+yCSrb/Wu01N/ykgnSTipfRKjwSlLBUG3f4aD3c4t6eXo0tDkaPt5gBUYgkTXap+WSjWMNTl0uBdyi1jbnSPacf3Ud5vLciJVyBbLK5Me8E/k/x/1UQgQCPuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884737; c=relaxed/simple;
	bh=bAXPDulxDDZ5D4xKzLb+p9CYOFdCNlAU9+FRTP7oTjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sprswSBvQkl45pOCQyoWIfer5L52S+TRRx3PY3EuxIkE89nhYfjb0GdRHDilTqVWBwg0kWPNMQqxvH6yCEaqEf5ilKJcH67MEx2ahfbaTttZPmqk9oT7F421X1H3YNMjI6OplPSs6M5gdEXgV7Vp2eC3/SLFz9Dw+UqFKL93t8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D/aGLlHJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D/aGLlHJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2E9C4CEF1;
	Tue, 16 Dec 2025 11:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884737;
	bh=bAXPDulxDDZ5D4xKzLb+p9CYOFdCNlAU9+FRTP7oTjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D/aGLlHJII/eQdxcwL71+RWOCgeH7f6HqnZem8kv6CzQXjnVjQsWZ/O24L6A4/jnr
	 fep2ffzi8xxfaeXLkdi2UnoLOHBthaNUVDFDoZRQF9S7fnyXvc2b5MmKzeFUnGa90S
	 LrkTyFyz4vED6gc1Jl2oBQe5Z0bPNWzDEFMsmI18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 250/354] virtio: fix grammar in virtio_queue_info docs
Date: Tue, 16 Dec 2025 12:13:37 +0100
Message-ID: <20251216111329.971313283@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael S. Tsirkin <mst@redhat.com>

[ Upstream commit 63598fba55ab9d384818fed48dc04006cecf7be4 ]

Fix grammar in the description of @ctx

Fixes: c502eb85c34e ("virtio: introduce virtio_queue_info struct and find_vqs_info() config op")
Message-Id: <a5cf2b92573200bdb1c1927e559d3930d61a4af2.1763026134.git.mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/virtio_config.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index 8189f859231cc..1255493b7f377 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -24,7 +24,7 @@ typedef void vq_callback_t(struct virtqueue *);
  *        a virtqueue unused by the driver.
  * @callback: A callback to invoke on a used buffer notification.
  *            NULL for a virtqueue that does not need a callback.
- * @ctx: A flag to indicate to maintain an extra context per virtqueue.
+ * @ctx: whether to maintain an extra context per virtqueue.
  */
 struct virtqueue_info {
 	const char *name;
-- 
2.51.0



