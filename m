Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040090;
	b=kHgNnCWkvJHdaOpxajf6SYJAlz3Z1KKGKZcL2351K3mf4uVADFdwBlwPhMIZbN8rCb3V
	 gzKEPW9cRDWyvGAAT5bSQM/hkTnstRqgwSbG7qxq6Du7sbtPxmp9fV0mCa1XaydM4sckz
	 ZJNZkrY7iLV9d6QnSjQ9Jlska7gOkfEcV4BvpZqfdENY8R4xYJWQO79pu2KK6f2Sw8ijG
	 9QT/Vd59TC+jfNmug8wnWUvcOGr0uAMa3Pv3PmNsJZAcAItZRDSPUhfCo57ZqkO43PmfZ
	 5Q2sZzc6mW/Ade9NegB8tJkdEZLzjQ5EAsHz6ONkV5HKpF3bc0LfEfSgOzf32iz1vaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040090;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eRwXv5n3Ja8ViV9RFSW3S98e/nsF8gVeFF36Cc23CGk=;
	b=HaTgHAW5Qutqh1zeVBdcyPGgTefh9Rik4vhwZDrVBQgBrp6HICdiK72H7TtVoeK7X7qn
	 99A8RkoctD+n+WWf9eta09jNwIjNCCmj5kXw7H41ntYlftHU3QfBeuD956LAcWPLn5dKj
	 JZzee4TZiQTbkvxUzP/1RfuAr5KFlTlhGWwtjKA9utdwuEuZL4ewEtUx62EjjTy8tDIzI
	 oiQpe5bVcYcM28MCjuJHwhqJv6eYdb6O5XWall3BIS1t6wN58Z6+BrVFsK8gFuZ4g/XZH
	 yT+6rPRMKeYnT4dRBtcjPPVTeTdGwHO6sD8/MAx/oeKpnOGq9Dj1HzEFCyvNH56LB6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2IAp8Xa2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BDA7606A31C;
	Wed, 18 Nov 2026 22:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2IAp8Xa2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C59611F000C4;
	Wed, 18 Nov 2026 22:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040090;
	bh=eRwXv5n3Ja8ViV9RFSW3S98e/nsF8gVeFF36Cc23CGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2IAp8Xa2/aLPWl9jr4wfPegMGy+UTT2ue0zbW1VlYC3Di5R2nbb53ERyZ7gZVYRW5
	 Ca+4j+Up3py9Wb7ix9sA8P7hrgdLPbCEqvwOkG99uwaPtGPZRmH+7xVHL45LQfLOJB
	 V8Xvy7LqE5v4R7xnS1qJqPw+OFX5DYwEKj+NFvo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2316/3318] swim: Handle FIFO timeout error
Date: Wed, 18 Nov 2026 15:48:58 +0100
Message-ID: <20261118150431.167053350@linuxfoundation.org>
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



