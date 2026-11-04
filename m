Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831385;
	b=yMhy8NRY0GKTsKBufI4zqgHzEtpJ3ef0ScgsKIOmTOQCSnl+AzTQFPp12Zpi2YN8NmDG
	 WQQia/Chdr1tgFV4TjTq2ybiYspgcpiO1O1yMQvTp0EQqB0A9dcgOeFfWcCuxMhVRw8Di
	 uPayHT3eVN0w1DnTTC15a7k5PvP2R54MO82sI2wXLuB1lVeXh45Lqp+g3S0IcYQR443B2
	 CWKtby7ounsQbX1eW8XtJogC1stcuCSHeawC7F0ETSf5LCl9Hm4Jn7jdXICtGgV91zgcB
	 gCpjTHqDK37dKttANgYUF/yI9NfKh4oiMjVr3cfEzIOge20ckQ2cFgO8KbF84hhhUjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831385;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yVmr5wQURwuahLpBpBQYDhpeP9RwUXE5h6YqFpFJOBU=;
	b=L9JuKmVx4/GVzfWkiRjjxDfipphoV9JdX/ljxIfs2p6/AfTFs7TGsrOFCaYTwiruhUu7
	 W9e5SDKLZv0Y4iXl7Dco4CHkFa0xP7MRRRo/S49+hx+qdm2awhe/4Kn8Ja9YdbmqWuwaa
	 dA/PQSRdO/y3p5zmBzS/qFLibdOhAyl4SqMD8A/0AjPCMPcvoU/dayhMoOZ4arI4rfdED
	 OMT2erjVd8tEGlYQpjAiQdXzyL0WRVOqQLWcBs7s0c5uoouuB1gcpDSLARay/WHDupAhR
	 zacwIG/ErfF/U8hBo1vMVGdHAt93ktVnqlHPPM/R/nJbtGuh5ddHKA3BMWre/+An/Ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cvmrk8vb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56DF606A86F;
	Wed,  4 Nov 2026 22:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cvmrk8vb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60DE71F000C1;
	Wed,  4 Nov 2026 22:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831384;
	bh=yVmr5wQURwuahLpBpBQYDhpeP9RwUXE5h6YqFpFJOBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cvmrk8vb220bhSlhyd2WvHXeymGM1JN1Tg2pAf28Il6BJyL2VkEqM/SP9Gq/PThLH
	 TaSGKG3gM3mJVSESkXjamqCc/D4c9ZksfHleoWK2/9KcoThXEwrAUiUE84dT0Mvefe
	 J5tphGFMcqh/sfC+d7v3YyQHL5UBMnf8S0qtHVPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mhklinux@outlook.com>,
	Kameron Carr <kameroncarr@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 6.18 0635/1005] Drivers: hv: vmbus: Bounds check the shared ring buffer indices
Date: Wed,  4 Nov 2026 16:06:08 -0500
Message-ID: <20261104211101.561363306@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
@@ -70,15 +70,6 @@ static void hv_signal_on_write(u32 old_w
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
@@ -282,6 +273,7 @@ int hv_ringbuffer_write(struct vmbus_cha
 	u32 totalbytes_towrite = sizeof(u64);
 	u32 next_write_location;
 	u32 old_write;
+	u32 read_index;
 	u64 prev_indices;
 	unsigned long flags;
 	struct hv_ring_buffer_info *outring_info = &channel->outbound;
@@ -296,7 +288,20 @@ int hv_ringbuffer_write(struct vmbus_cha
 
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
@@ -318,9 +323,7 @@ int hv_ringbuffer_write(struct vmbus_cha
 	channel->out_full_flag = false;
 
 	/* Write to the ring buffer */
-	next_write_location = hv_get_next_write_location(outring_info);
-
-	old_write = next_write_location;
+	next_write_location = old_write;
 
 	for (i = 0; i < kv_count; i++) {
 		next_write_location = hv_copyto_ringbuffer(outring_info,


