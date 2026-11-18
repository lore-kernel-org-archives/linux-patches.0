Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055275;
	b=cwR6/1smJLYb+w7bQ6Y4/DHCmzTYVLsR4CbgVzUEPWGQcwO7COjcMfdTXPwSdHPZ2wAK
	 m7JdMg4j5uyxtw6HgeqWkpdDVUClvJynTmIGG/YIhoqtHcMWRk9NOvgy053Zorr+F0sLb
	 xP/KlCXgA33pIre0TiuwsMHMplqQn/SzvSrADigwfNx4BG+BBpunQG/pRBF7NoW8xkb+b
	 MR+vJItvKziZrKfyeCJCryGpb0YhWF8oqjrZf4cViWIDNvwT0PSg3DmYiq4YnpGeQc3nt
	 YE4wtTTAUDjb5Ey5BTQvAaCqc3Q26Fk9+VSpqYKPL1+n6mkMsDoGd1ZggC4R+xtbO9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055275;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P4xSgmtpQcsMU4jaEDGRdrwZDFMC7H456O4RfSn4i0Q=;
	b=uXCx76lHrt/6uaYE2/Rz1p+a4w7PRLeE++6Xwfq6MFoOVUOmvJhKXZlsR13HV3kMcD7l
	 nJt0BSh2Alzrg5Ef1tZ2MCITWpv4yhBdk5gssqbwVzYbaSM8mOIHq2utjMe2JIIPx2Qn+
	 JDL+ZYPKFIcP2c6ZN2LK8iogbOiIUp+950ZgDYD2PA35quG23n4NIPHm4AjDxq5NKRS3t
	 wsx7WFmXYuA4g4oUnQrS4pBIfc4BuRxOsMoZYntAri/nuzQ1aPGRMHQD7DU8J9fyLeCqe
	 GIWm8lTaoJu8Cv634KfW+Jlq5g978Q+5ZpfW6iISJlkgUHsCs3+GDpZ69ScdwvEQ6NQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="LB9/hC5s";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3D6606A32A;
	Thu, 19 Nov 2026 02:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LB9/hC5s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E97C1F000C4;
	Thu, 19 Nov 2026 02:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055275;
	bh=P4xSgmtpQcsMU4jaEDGRdrwZDFMC7H456O4RfSn4i0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LB9/hC5sgXdnJKsu7DGPQy/SIPcNLFMINDVQ67YW5+oCZLJ/e1sVvE2rj+npkteOB
	 1yIa3xdupmQdfWjsfhBqd+Nqg+/tMlL+KVwDk6J6IBZR72oerdmZ+qqmAsM9KClCQ/
	 /DbnuMSUR57wTFLWtMtPPM2WVem3PykZG8btTWPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1573/2214] swim: Handle FIFO timeout error
Date: Wed, 18 Nov 2026 15:54:09 +0100
Message-ID: <20261118150114.973302536@linuxfoundation.org>
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



