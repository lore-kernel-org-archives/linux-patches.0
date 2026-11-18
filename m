Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024202;
	b=owsMWY1qQyXzrFaad+dDc3KreuhPCn2DiIRJeOjOsuzLr1ubj/kwuY0LXerMCSBFuXqK
	 0VQ5sPfwEmzqaMfqf3fxzJUqtZ2nwwTG9BDebgT+IYW5sURtV99W1FgYv7+B8QszuhmAP
	 XIQAcwvlWcVRsH4JB3Xo6N/tJ7XNTuUsxgvzi0cemYjr1QZXWqKARnXpvQRZhctYWpkQe
	 NoH9BbFnKu4SLWWRNzLEfXZJ1aa5ct/+siDVri2cHoKxlmY25r3KgIxV/Pk4TPw0RnuSc
	 lbaUhccpcHB5ypfSQS5CAzUudOxF7td+fG1AV4h1odWvSOiZvs0KqySoqN0nLCTaIoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024202;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/Tq/U2W3Bw/N+1dtCcZvdtaeFRmGxDG9T7NKyiLsJss=;
	b=yNtdnaF8Tv3qluHf6XksU4/dg2f+5ndwZkivfUnnOgiF1mIB57HSVO0KsNm4W7ZY//kp
	 ckt5Zz/ZBl/JG++KHZ0OYboh8gLt05/RpR61XzbuaWPUO8JXsYJSjFJtBq/taI1ZmwTTa
	 ag9gA0HircFFnfcEps39nIvFPnkIJMWtk0eED4r7gIr28TceHw2TnSvKNRlCRpJkJzAH5
	 cswQGezJqcdnzyxAg568atFIx++xwmasvJsO/NeC1XJ+fXTiP8agfuCivmoJ2NN0okPxY
	 Jrk05GAEzqga3LLqk2hQ6pZcyWWXX8V2Mmu/srql6Nl51W7DQUuKsv0r6gGdL9Sus/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TicCd0l0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7BE606A31C;
	Wed, 18 Nov 2026 17:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TicCd0l0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83BAF1F000C4;
	Wed, 18 Nov 2026 17:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024202;
	bh=/Tq/U2W3Bw/N+1dtCcZvdtaeFRmGxDG9T7NKyiLsJss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TicCd0l0dyJQ69WBb6JWeV+Fx8m93pcqjL03QBvCErAAy2mq9TA9SgjUGsyoKcsFr
	 GFqTxnlaNl889sPcnd0bBkC7VXdH/+kuBjJ+zVPZFI1Dbl/4kDDSueakmKwfQl3FkJ
	 NwlHCoa9DcbzbHjaQa3/Uid/ohKcrAWZdBzvf6LI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0640/2151] swim: Handle FIFO timeout error
Date: Wed, 18 Nov 2026 15:39:35 +0100
Message-ID: <20261118150145.181177746@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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



