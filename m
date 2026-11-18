Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051646;
	b=srWbRvC2guo/jpf7Y2oUGk0z86MSqJ3FzI/RHClP79j4CbGOVE28kTUP+3f0NNcgeX/k
	 iS6h3sJlDHr3CttBcuxavi/6OacqZsTgcIaQMRyBgzidJEm03HlHam2qllj12b2pmK337
	 +STBVXn5Hg8XahmR9ORaGSvTN6iX2KdFLFx/3ViTIJiFF0vUdTd0qxY0qc/Nhg8UPkO47
	 gKHtvuB/XtpIdisoKv+WipJLwYh32xEg8KuuQ+AXgb32+/kQNwjktQXe0bN444RP1muoj
	 yC+6ADBSjGX7YMrsdNSGc/94TZ8xtf8Gy6PkFZWjcBM7IcZvUBOBOyR5LiNMHnIYsVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051646;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p3tnJjWt3I5Vm6VFZxfETk9LLYn0w63WRi4rBskFrnM=;
	b=NlGMvPM6BlLY/4WquVuZo+e3vnBd0czpdz4o3ibHcBe/m1AuW4yg77sC0LPA5qfMLh3w
	 BuRMz6hPeAQgt4etTa0r+ZiZnStNLf9emFw4Row9rzf63C3GLR2N1Kxmt2IqXjofm+RxB
	 ZjwyCf311dwe1q+9RSiQ/7GZ6tCdX6MQLllEzzXPTzNi2QOIryB0vilde7t7ZlLtzhkdY
	 dSFi57KTPUV2H8Cech4lDn013Zna0woSX7+h/ypFLC4wwGp6Peu3+Ak0aoyT76JNpgKx+
	 y510XLmtKuudu7vQIVaUJcpmZo5Tos7YVRa1xI8N5PneGqYyvUm9Cz2N6qIdCxdIFtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V9ZyZ1qu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6C2606A31C;
	Thu, 19 Nov 2026 01:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V9ZyZ1qu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 674391F000C4;
	Thu, 19 Nov 2026 01:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051645;
	bh=p3tnJjWt3I5Vm6VFZxfETk9LLYn0w63WRi4rBskFrnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V9ZyZ1quhpPXeqhS5hysYzIyxVA4Hjkgk+rzOGsLqPmPjp1thtaXd8azyoZYsJHk9
	 Bj2zMZFkd36I9NiMPFbM4HzA8na+RyOInIhYgUht5Nbx924BecBtOpb30KTR5krdbS
	 6KfRX5RopXK+eBw3MPP4zxiZpwgS8ty5AoJ6d2GM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mhklinux@outlook.com>,
	Kameron Carr <kameroncarr@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 5.15 0282/2214] Drivers: hv: vmbus: Bounds check the shared ring buffer indices
Date: Wed, 18 Nov 2026 15:32:38 +0100
Message-ID: <20261118150021.335661343@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kameron Carr <kameroncarr@linux.microsoft.com>

commit 1d287c17cc5bfd6386fe0770999be410b248d021 upstream.

In a CoCo VM the host is untrusted. Since the VMBus ring buffer read and
write indices live in shared memory, the guest has to treat both as
potentially malicious.

hv_ringbuffer_write() copies into the ring at write_index with no bounds
checking, so the host can make the guest write packet data at any offset
up to 4 GiB past the start of the ring buffer. read_index matters too:
the available space derived from both indices is the only bound on how
much is copied, and an out-of-range index can make it far larger than
the ring.

The fix is to validate both indices before use and to use the validated
snapshot instead of re-accessing. For invalid indices,
hv_ringbuffer_write() logs and returns -EIO.

One re-read of write_index is left unchecked in this patch:
hv_get_ring_bufferindices() fetches it again for the prev_indices
trailer. The value is only returned to the host and is not used as an
offset or length for indexing. Since this is not a security issue, it is
addressed later in the series.

Open-coding the bytes available arithmetic keeps the fix free of
prerequisites; a later patch refactors it into a helper function.

Fixes: 3e7ee4902fe6 ("Staging: hv: add the Hyper-V virtual bus")
Cc: stable@vger.kernel.org # 5.15.x
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Signed-off-by: Kameron Carr <kameroncarr@linux.microsoft.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hv/ring_buffer.c |   29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

--- a/drivers/hv/ring_buffer.c
+++ b/drivers/hv/ring_buffer.c
@@ -67,15 +67,6 @@ static void hv_signal_on_write(u32 old_w
 	}
 }
 
-/* Get the next write location for the specified ring buffer. */
-static inline u32
-hv_get_next_write_location(struct hv_ring_buffer_info *ring_info)
-{
-	u32 next = ring_info->ring_buffer->write_index;
-
-	return next;
-}
-
 /* Set the next write location for the specified ring buffer. */
 static inline void
 hv_set_next_write_location(struct hv_ring_buffer_info *ring_info,
@@ -272,6 +263,7 @@ int hv_ringbuffer_write(struct vmbus_cha
 	u32 totalbytes_towrite = sizeof(u64);
 	u32 next_write_location;
 	u32 old_write;
+	u32 read_index;
 	u64 prev_indices;
 	unsigned long flags;
 	struct hv_ring_buffer_info *outring_info = &channel->outbound;
@@ -286,7 +278,20 @@ int hv_ringbuffer_write(struct vmbus_cha
 
 	spin_lock_irqsave(&outring_info->ring_lock, flags);
 
-	bytes_avail_towrite = hv_get_bytes_to_write(outring_info);
+	read_index = READ_ONCE(outring_info->ring_buffer->read_index);
+	old_write = READ_ONCE(outring_info->ring_buffer->write_index);
+	if (unlikely(read_index >= outring_info->ring_datasize ||
+		     old_write >= outring_info->ring_datasize)) {
+		spin_unlock_irqrestore(&outring_info->ring_lock, flags);
+		pr_err_ratelimited("outbound ring indices out of range: relid %u read %u write %u size %u\n",
+				   channel->offermsg.child_relid, read_index,
+				   old_write, outring_info->ring_datasize);
+		return -EIO;
+	}
+
+	bytes_avail_towrite = old_write >= read_index ?
+		outring_info->ring_datasize - (old_write - read_index) :
+		read_index - old_write;
 
 	/*
 	 * If there is only room for the packet, assume it is full.
@@ -308,9 +313,7 @@ int hv_ringbuffer_write(struct vmbus_cha
 	channel->out_full_flag = false;
 
 	/* Write to the ring buffer */
-	next_write_location = hv_get_next_write_location(outring_info);
-
-	old_write = next_write_location;
+	next_write_location = old_write;
 
 	for (i = 0; i < kv_count; i++) {
 		next_write_location = hv_copyto_ringbuffer(outring_info,


