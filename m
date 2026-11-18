Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048509;
	b=mkTCOxgpkz0w5B/6pwpWkYdkxzMImcDrx1YDHv7nR/pr6UScnU0b+Rydu1RKW7buhXf/
	 93GCYM79SJNmNg/fXAKOb9vERntrTJsB6D8d/StUY8iPLfelCS9XGy61MOcKmEaS9ges7
	 8Sutnk2Q0BOrIIQTAkvOiUrmUfp9qv/OXzl2jZPJ+vQ3uJdwpWO/NR2PJ9EAN60k9JaoT
	 8kggtE/0h0dZMZZTqqUSa+eW4wG9QM8p+DP8f5Ttp4M9RN8E2zGBqJeWg9BOO7vUbGm7a
	 FUNVvqHcrHSFEK5fcl/h6EqkoB8Nhi4tzrriRUKJG7Ihpx+BlQNSaHXON17qGe1iTzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048509;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ADb1E7Uoit+XShrEgmMnXGqBr44EOr0VRxRXutEVcNk=;
	b=zi5mCY5rKDqsaHyAX6Gbz5gVnyzz7IJXH1mdbxXBuIeKG5pmK/qUCTaW/ihEfZNTJkQL
	 NfpjVR9Pdn/Yep7KqSIjwiA2xOGT9VYGfvpv1RGolHTt26GSasfR90pN/g9PCv28LE6K6
	 sXbBzuuxsyHw/aU3WuksNzsDiwTCdVO2qs1coRtniWdAlwuJP5GtNGoA/KUpzjwGwYlI0
	 jb/nWaVVdRcgTawDBI26SsRHlEV8k3gGevolbE1oSVHnTifDRHTFVvhrvdECAwH542D1d
	 KR6dO6GFq9FLVLO3qpe+U64lCHkyhGuwl7U/8xxfmS3NrI74WKkrun1GHMDh+PCLEow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ODiGbQ0o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7877E606A325;
	Thu, 19 Nov 2026 00:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ODiGbQ0o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D49E21F000C8;
	Thu, 19 Nov 2026 00:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048509;
	bh=ADb1E7Uoit+XShrEgmMnXGqBr44EOr0VRxRXutEVcNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ODiGbQ0o2QypB0dOJk+9wNM4eSXY/Ku06jqegj37Sm5HX8ubZdgPclSkdVRAbqGD/
	 dBfo5QZPduJLu9WWXvRoSDy0+X6cMa2p4ggGiw4rJo0+okO0Z5rWKosYZ4Paj2NoFT
	 VSSgqt8lwWWgNinRdU/Wh9i924fXE+VxfjhLvPWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2019/2857] swim: Handle FIFO timeout error
Date: Wed, 18 Nov 2026 15:50:53 +0100
Message-ID: <20261118150314.098612581@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



