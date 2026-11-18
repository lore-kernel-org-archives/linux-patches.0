Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034979;
	b=rRvuWa0uzNOVNC1/ROVTjaNWEiUYJbXjp8DJEVis5vj3pRVIdo8EkDEB1VOV8J5rcYNd
	 +jqx+ypoiGFIowkHqI2GEA8khrpd4JQUDSIQCHD+J8q/2AYFbgG6DDOejAAWtMgL1Xoln
	 kixJrsAza1Xn/bUXs0kZoCeR6ykjL/sNHIrKMnxJ+CVqMD0Ihe5SWQ9Wk3V7LnH+ZzWcP
	 sxpLfV3yNjCluJC3m+y/9WH/BSB6qO1qm3SU9fuc4AP6pIW6y4tsSUzzwMai/i30TwEol
	 LldBFRjkWHMseo1DpSOFP75zo2yiEjZ14tM7ZnavE9b3VJccO6WjRaBRwWP/Qoenv5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034979;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yGTGbp7pc54oAb84lmSRnd8+vm5gTRWdmbmcoiFJFN8=;
	b=tsjKEX5vBV/WhnDMjZzWppgAt9wWtx8RfiSsYX1KgJq9nLttPTXbCKDRTqKcubKodJOq
	 2frLqNyGQ+r+ZwSFDxYGecuQdcqLTXMR55y9/LDzAV3xDuJTD9WrHiUGQPKKVh+CLDHgO
	 JWA5qG2QaUtGyDTMx5ag2c4dJ0zSf/3FHLhpER+YfJIkhMiOG8OIiOdKlDLWEsRipwqsc
	 PEtvIy1cqAlfqQ/8M4JSmNweiTv4eF3bBfYoFIgGVrCL4FJnEfU2Kop1NVXhXyEzAM3VH
	 C672SlJaf6o2ydDaPRPqaTj7RIDhDXcdCLZYtMG1QFV7NJlnkNIv3SywB2gh5lQCykw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zc5guiq8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE01B606A31C;
	Wed, 18 Nov 2026 20:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zc5guiq8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07A6E1F000C4;
	Wed, 18 Nov 2026 20:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034979;
	bh=yGTGbp7pc54oAb84lmSRnd8+vm5gTRWdmbmcoiFJFN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zc5guiq8AqN5w3XPwZ5Vn9N71jLtOnrqKu7PJM5gdmhWQfFPXGi2d2S6YZ1Ifdopv
	 gccBec0T3zfg1WNno/ovTydxoQ0DymgWJujvy+Y3i8PpHI4n4WYwm7HYbMyNk0jurx
	 m35zULw8Ddxtte8fCxFUOSMMH350z+P6VNESNsXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mhklinux@outlook.com>,
	Kameron Carr <kameroncarr@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 6.6 0562/3318] Drivers: hv: vmbus: Bounds check the shared ring buffer indices
Date: Wed, 18 Nov 2026 15:19:44 +0100
Message-ID: <20261118150334.234709091@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -69,15 +69,6 @@ static void hv_signal_on_write(u32 old_w
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
@@ -281,6 +272,7 @@ int hv_ringbuffer_write(struct vmbus_cha
 	u32 totalbytes_towrite = sizeof(u64);
 	u32 next_write_location;
 	u32 old_write;
+	u32 read_index;
 	u64 prev_indices;
 	unsigned long flags;
 	struct hv_ring_buffer_info *outring_info = &channel->outbound;
@@ -295,7 +287,20 @@ int hv_ringbuffer_write(struct vmbus_cha
 
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
@@ -317,9 +322,7 @@ int hv_ringbuffer_write(struct vmbus_cha
 	channel->out_full_flag = false;
 
 	/* Write to the ring buffer */
-	next_write_location = hv_get_next_write_location(outring_info);
-
-	old_write = next_write_location;
+	next_write_location = old_write;
 
 	for (i = 0; i < kv_count; i++) {
 		next_write_location = hv_copyto_ringbuffer(outring_info,


