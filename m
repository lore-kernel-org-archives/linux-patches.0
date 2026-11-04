Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831404;
	b=4mnHldIJbtWoHTATXJArse/f32Csv9MGAYBSR/eUXrNEyEoJFPoddwItXqgfJZZoMLAe
	 LfDwLew1PTYIxCrFeJ1F1Yhi1j52hy1KNDpbWF2WDv+JhO+KHiDEYA2yO0lxlxRp3TxmV
	 h8Z8s9R5SYYsXHs9MrVHAsCYhKH05ooQPotRcBR1sXzuFED/dzNz/s1a25I3rHhKEtUhO
	 cvOEQugwb9i3CtZp/zMX59BhtD5d2yErBRiF12w5FvZObJNLdg9m9Ar4Q0GRTu1J6nzXy
	 pntOrZaealyb4P2hClJj7b24XaTRgJexr+4ALx3IPNwe2xdC5Z0f+2qXQFLmLTwvacA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831404;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7tiP6CUVrnq2YVnxAy4ZrBUVlOUfmCoKbC9Z3joq920=;
	b=4HSNIeCHOdWzLRMnY+cPtLYBakcPYJld4vbw3H+Z+o0udiUqbvWWHiKD6IC/l7/a5yBz
	 R+A9yiKqmqyofzC+1R1fyiY/0D1OQDuOGXMVWmtvhP0iVIkcglrDvHreneCjdpbHvtClN
	 7g3tiIjex1qIYyIN3AswNeHc5cx/7dbP/w1wfi9bbPPiLamhTj3aqos013P5ut4sUM9mk
	 /7b1FtDQh9E3cX7M/AzFvYZLtfh+By14n5sjIUvGAs18Cllk+VisvfSTcboGZD46rbiOo
	 +pH0pjPmBDtT8mDFy1r9FR9e6eoq6ctbKzQBzfjifuehXL/jQsk6R5A9rArdi7XlSbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HRZyMbcm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8605B606AB1A;
	Wed,  4 Nov 2026 22:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HRZyMbcm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D8171F00919;
	Wed,  4 Nov 2026 22:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831404;
	bh=7tiP6CUVrnq2YVnxAy4ZrBUVlOUfmCoKbC9Z3joq920=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HRZyMbcmev6fPjglccPWBLFU3l6UkAvbTTYr0/lNPYdIMm/4mIPQmqeJZFQhnxCnN
	 EzZzQKIWUJRaGZ+CRkACWdnpvyl1ZyrLe/5nI9M9yRgSMWTXkz2U1S9PQaPgSDqhmv
	 goiuaAzSZo047jkKpaQAL8puWvOimWSCSsSMRnUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.18 0685/1005] s390/extable: Fix mvcos instruction decoding
Date: Wed,  4 Nov 2026 16:06:58 -0500
Message-ID: <20261104211102.810635969@linuxfoundation.org>
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

From: Heiko Carstens <hca@linux.ibm.com>

commit 4044466ff004c7ad5fd47be717cd933077e6e874 upstream.

If either the b1 or b2 field of the mvcos instruction is zero, register
zero is not used for address computation; zero is used instead, according
to the architecture. ex_handler_ua_mvcos() incorrectly uses the real
contents of register zero. Fix this.

This shouldn't be a problem for any generated code, since the compiler
would only generate such code if it is possible to prove at compile time
that either the source or destination address is within the first 4kb of
the designated address space. Such code should not exist (also confirmed
by an allyesconfig build and decoding all ~7000 mvcos instructions).

Fixes: c488f5187a24 ("s390/uaccess: Shorten raw_copy_from_user() / raw_copy_to_user() inline assemblies")
Cc: stable@vger.kernel.org
Reviewed-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/mm/extable.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/s390/mm/extable.c
+++ b/arch/s390/mm/extable.c
@@ -90,9 +90,9 @@ static bool ex_handler_ua_mvcos(const st
 	regs->psw.addr = extable_fixup(ex);
 	insn = (struct insn_ssf *)regs->psw.addr;
 	if (from)
-		uaddr = regs->gprs[insn->b2] + insn->d2;
+		uaddr = (insn->b2 ? regs->gprs[insn->b2] : 0) + insn->d2;
 	else
-		uaddr = regs->gprs[insn->b1] + insn->d1;
+		uaddr = (insn->b1 ? regs->gprs[insn->b1] : 0) + insn->d1;
 	remainder = PAGE_SIZE - (uaddr & (PAGE_SIZE - 1));
 	if (regs->gprs[insn->r3] <= remainder)
 		remainder = 0;


