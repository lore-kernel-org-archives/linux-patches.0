Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016952;
	b=kpSCB2YXEJauHefVoSf6hy1gSKr+M2freYnO99zRIpsf8qEj5c2bD8ZxQwfsEo2/uIzE
	 br2a6/4L6MZWo/k8L2tdRzF5p1QwbbTVEeoOtoFH7Bq3FlC79JHsE8EuqNz6oit4lLsVz
	 i8viwvxFdgIhgPn+rTyneApY4FYCuX1ZyOB+hC56580s0D9H1OwCwFjLsj/FAd8WTWfA1
	 TXoAn3KaEL0DR1Xac0BuOOGZYSWnwN3ExkHkNjfKopW7SyV8FfRAF3CAYoDEtwzarWTtj
	 JxiruUwaqP4gRpgoEefMT823Z1y8Nz5dvaIFssnZJ8NHBmF2GjQHKxusrgHe78g+kmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016952;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MVvUsJQmsNjgz6oKXk2C6EfSMiUMuPhBnc5+FXEO0v0=;
	b=qIRkEmA7L8LTX9JGQpk52aij/8OzI5TwwLzi4/HLOR8L19JA2QzVVQIe5md+8zArsmOQ
	 FZ9+P76KwcjdMcsh+Eokq6zbSmX1GG5cGTOaUPmVVBPdL4/dT3tqKJIxmisX69mspfzfw
	 s5IE+inD3EB5spAXiUO1BAg0ZTD9hmmN2IntI/jFAYFRqV3A9ooYOQLrFj3CJmrL4b8Hz
	 D1QLqiMC4ebVmAwtPFieGoezLbw02sy7H8MkGAG0x6pCDZVAF9qTP1NbJMx9NSwGTz0QL
	 LSXtTaqzhxRYqVPBIdcXTB5z7sJ/MnSl+PiZxDmjGwyg/wAgV1STvrCUbldgvelJ9pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pM7KyhKc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24371606A334;
	Wed, 18 Nov 2026 15:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pM7KyhKc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41B011F000C6;
	Wed, 18 Nov 2026 15:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016951;
	bh=MVvUsJQmsNjgz6oKXk2C6EfSMiUMuPhBnc5+FXEO0v0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pM7KyhKcGmjOsddR7UvypDHUXjXoyvzRkj7oa4h0ixR9gFytSE28uz0LxFM2krNck
	 bbuQagLEfnZA8BJfTC/HALKLOApRGfNrfGsRwOuAun0UbZkVwrNbaMa2ucr3xf/JAZ
	 M5BgsBVMs/gWZ6E19uDrrwxAg7T5MeL85sj9UQpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0711/2651] swim: Handle FIFO timeout error
Date: Wed, 18 Nov 2026 15:32:31 +0100
Message-ID: <20261118150313.419444748@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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



