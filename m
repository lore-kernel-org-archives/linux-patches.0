Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028954;
	b=bD+8T+0MDfUVMrnthQKQi5yKqH12Pxt29qJDrn9QAVd0eiPPZ1X/4OrO5v3arTBGC1Im
	 oFLo/FXgdvzYofb+CF4xSodkRObhdIkNf+qQKsXKFUboqTJtlz3bxS9bEuRBgMcO5AO95
	 k4Hlvlp+b5WzCAKxdz7ZAAHPxr2ds5xPQr4/CIuT1Lg5fhqtCBUjYEwevsNGPcPTbFhwy
	 TGFq4WyCYzwdZhFThNMPQh/6QCpnkw0JhJNCtEuxjgR5YZ4imumqNutNUZOtUKHPIC3DO
	 p20w5JJOYzDHGETz9mcdWT4UM2p/WN/9Q+vu6OC7lP7w2AWgol9YTJ0KPb9/UrrN0pA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028954;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tYSvJKJCP7fGuspin0pBjI7i+TDmjCwivEfOS4ZAGKU=;
	b=Bq3CVEc25EYjYF33wexC66Ug+CpAHDV0x+wzsNNN/j4lw62RXIgSrodRmQB5ucaREgRK
	 ZSc0FfhrHs2wNVnaoD9oDdftGHkgUdvQ+SnKuVc6u9XAQvPawsxzBCe9uZYffZvUz06kQ
	 kBnqDYzLaF6P6SumtAOoap+l9Ma0104S5s404d2eYOW72LjeRfLAoJm5SaRR0+XZMVB99
	 KFoBF8Qs/3VS2MOYE6Z3tYInoXyb2k9jl1JGaYDsnkLJcxGkwC2Xbf+mxU6hN3wCeRgAq
	 VjwF2PqImXck6jC7c81+mEzDaYpUVGHm+x5c5T9vS9+NrnLEe6ATmql689BbffKc3TA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GHzLYHcF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5592A606A33F;
	Wed, 18 Nov 2026 19:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GHzLYHcF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A6261F000C4;
	Wed, 18 Nov 2026 19:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028953;
	bh=tYSvJKJCP7fGuspin0pBjI7i+TDmjCwivEfOS4ZAGKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GHzLYHcFT9mcAA8PkixOJxgxy+Ua1NRpV97GW9UfWCxGfKsrEr/ODovMjIVtB5t7i
	 Zzxg59VNQ0Oqv2t8izk1kYnMpEvu8oA8jilu1XzTzSQF5yPyklQw0TpTFc5xUSBGVw
	 dkgwg2bSX6xWObcfd4LpSwONaoGAMwpMeOEWgMUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Bradley Morgan <include@grrlz.net>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0161/1756] kexec_file: stop the top-down search before it underflows
Date: Wed, 18 Nov 2026 15:38:08 +0100
Message-ID: <20261118150014.584598170@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

[ Upstream commit c711461303af9f796b293b5ac06f49a885e46e71 ]

locate_mem_hole_top_down() walks candidates downwards by subtracting
PAGE_SIZE whenever the window conflicts with an existing segment or with
an architecture exclude range.

Nothing stops that subtraction at zero, so a search that reaches the
bottom of the address space wraps temp_start around and continues.

The walk starts inside the range being scanned and only moves down, so
bail out once a candidate ends up above end. That covers every step in
the loop rather than the subtractions alone, and it matches
locate_mem_hole_bottom_up(), which already bounds its candidate on both
sides.

This is a better check than subtracting with check_sub_overflow(), given
that we would have 3 subtractions in this block, and this single fix
would take care of them all (instead of three check_sub_overflow()).

Fixes: cb1052581e2b ("kexec: implementation of new syscall kexec_file_load")
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Bradley Morgan <include@grrlz.net>
Link: https://patch.msgid.link/20260812-kexec_posioned-v6-1-e477887086f0@debian.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kexec_file.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index 909432e804be1..cd9b5b9d0c787 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -474,7 +474,9 @@ static int locate_mem_hole_top_down(unsigned long start, unsigned long end,
 		/* align down start */
 		temp_start = ALIGN_DOWN(temp_start, kbuf->buf_align);
 
-		if (temp_start < start || temp_start < kbuf->buf_min)
+		/* A candidate above the range means the walk wrapped around */
+		if (temp_start < start || temp_start < kbuf->buf_min ||
+		    temp_start > end)
 			return 0;
 
 		temp_end = temp_start + kbuf->memsz - 1;
-- 
2.53.0



