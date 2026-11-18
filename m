Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029937;
	b=K73uAzo6OlTPl+hWJF+a5ZcphO7ery7XUEEF8zDTX81Wfmb/BEipyoxnapiiwjQteCGb
	 StCBDNIBKh9LK8OSsUsF24LyQcpO9LsJyZGucKwmLb7ee0eVbXUBIo4igS223KdB9O/L5
	 g68FmGWakkLCXTHPYj1IhxpquhOHle6UW79H9BQkBGfKp9vwT3HXxFttcnGvO4fJRVdrn
	 EaAjB9QchLbgdoUT9NAvIL73zB8o740MjBjG4FUsXnXyf4hIsWKL3koKvbVwklINnVxXd
	 Ttdc5FLCQV5honFMMrwE1Di9ZrzshmkxEpnxEVsrkpO8aaFhoUfF7RzAytXofq/UjBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029937;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HYI/50YqDIoSuGt5/bGE8e/mtDAr9qtop5EhFef8ob4=;
	b=RK+6xq/PDIUzZjMuqn0P/MyndJbdWFnlJ5XTq32mI1EvP3IlVrSySGm/VYP7Ld+pDTyc
	 1T9/jP74ftmDBmxNKSZLvgD+fuDPYQtFgzX1nyMOS01uIHOVf+DfAU6Hmj9EAj1lnurca
	 gS6l5jXjApGjb4UbB1FtXLOfKeXyfS/tZ++5mQiOVqZRPxCQ0BjvXhExhtcW3qpY0D6he
	 jGDZQHeo/LVggZNuuxV7FiTOV0skswO2CL4jNxHRyARdNwRkH1HAkMoHgcxjzcoDe3Fq8
	 XD/xw39JNIvMqPsFkxcojCUV4/Orlu/lAVya6MoIUnIVIJlaQBWyOJpvk51Bjzoow/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZqWTjV9p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80195606A320;
	Wed, 18 Nov 2026 19:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZqWTjV9p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F6EE1F000C4;
	Wed, 18 Nov 2026 19:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029937;
	bh=HYI/50YqDIoSuGt5/bGE8e/mtDAr9qtop5EhFef8ob4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZqWTjV9prODUteQ1rnyBQ+iPYD/SuHT6NvLFJ9Q9fLnb4CeZMsTLGnxaToVrdE/Wf
	 RD0DVSER8TQ8+bLj2wouG2lx52XfssFagBqGVrQbDMsqhJLmvDdol1Ql8VoFQnFQ91
	 fQUPxXG9uF24gQUhzVLFXGCOT0X9Omq/13PPbKBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0528/1756] swim: Handle FIFO timeout error
Date: Wed, 18 Nov 2026 15:44:15 +0100
Message-ID: <20261118150030.146171836@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit 2e9bcbecee68431b689d16b23bc5529db686f8d4 ]

When polling the FIFO for a mark byte in the sector header, don't
return zero if the timeout counter has expired, return an error code.

Reviewed-by: Laurent Vivier <laurent@vivier.eu>
Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/aadb674d27d6e6d346d9b525597bf2e339c57e04.1788513997.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim_asm.S | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/block/swim_asm.S b/drivers/block/swim_asm.S
index 3d7a2d87595a5..208622ac4aeb9 100644
--- a/drivers/block/swim_asm.S
+++ b/drivers/block/swim_asm.S
@@ -79,7 +79,7 @@ wait_addr_mark_byte:
 
 	tstb	%a2@
 	dbmi	%d2, wait_addr_mark_byte
-	bpl	header_exit
+	bpl	signal_nonyb
 
 	moveb	%a3@, %d3
 	cmpb	%a0@+, %d3
@@ -136,7 +136,6 @@ crc1:	tstb	%a2@
 
 	tstb	%a3@(read_error - read_mark)
 
-header_exit:
 	moveq	#0, %d0
 	moveb	#0x18, %a3@(write_mode0 - read_mark)
 	rts
-- 
2.53.0



