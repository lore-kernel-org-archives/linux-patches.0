Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831406;
	b=BFfwbY83DZf44h4x2xsujY5GYV9wgeFO/wXy+PbZ9bMXEnjDy5XzpY5U6DJwjNYkw5N5
	 v78awVEwQmrfd5noK6OQ3/zrqD8AjPvkaK78BT6KnQQpP+B8ndVF4BIl2g16AfXxj6FT6
	 g4N3KhsV7hsqb8iUOYfcUXkW9ak+biuKVoBPR4dHrNGMREymQ6AwZ97Hv+XNRz0N+jIHy
	 SK1cT6ZCXu3vG6o7QQAHPloLxAvaLAuqI5AlKfMx+kBTYI8EhZGUDGzIwlPfcO2DKDTXT
	 cumyEQsiVu6BBLAFYayYCQp6UezHLgVNvl2VabnN+fSFrke6i14g440JoTwpV7ZVf8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831406;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HSRvmsumMETTSpYIXOg3XklhCf8cQXSj4UcUkj5K4/I=;
	b=3P60YScyAprys/Kt3OWzx02wa8jupH7rFi6wlnZvORRt42jnGlv6OrgABc4U4eXcwlPQ
	 Osb4bDv3eDcsxG2/2nBDQEbMPSxj1/WXfhIzxNWJFPGH4vmhCfJNIjzTaKpj1PUMEXoYg
	 FwrTpWhPChy9SJ03gJpKdUrGbLu1dYhsrOw7oP4+nU0iRv8P2MnSKulvE1+ACkJQhzU41
	 auftnP/Xq0JIvcb7BlL5G0YyaCEsQAKUqlyBtVddesO8Q5Lq0bF2Wc3R4PoSE2rS8OS+y
	 VQtpSneUnaZGM8RsgSRPbgoJ2KDP+JcW7tHJJQqHWRz1XQsIHVbaaw3A31Ns/9m5iUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2vehOpMX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD11606AB1A;
	Wed,  4 Nov 2026 22:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2vehOpMX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5C611F00919;
	Wed,  4 Nov 2026 22:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831406;
	bh=HSRvmsumMETTSpYIXOg3XklhCf8cQXSj4UcUkj5K4/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2vehOpMXraPTf1I9/GlNVI+Xsj5SIJXcSZsYe+dzOZlOkRmxTTDaJRms6XLL4Xvgs
	 v/05/XhjNh9Hrf8AuIX/ul+ezRaVD+6oO/KFIGluXPrO5ToJoZ+HjhsjOJoU+1Od3E
	 PUUlkBjYHlihap88vHZ6ScXUvTgK4G816P6cJU8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.18 0686/1005] s390/kprobes: Prevent kprobes on instructions with exception table entry
Date: Wed,  4 Nov 2026 16:06:59 -0500
Message-ID: <20261104211102.836355881@linuxfoundation.org>
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

commit fc9bb0ecd310b53af5116415952a1fb89d4660b9 upstream.

The mvcos exception handler ex_handler_ua_mvcos() decodes the faulting
instruction, assuming it is an mvcos instruction. In case the instruction
is kprobed the decoded instruction is a breakpoint instruction instead,
which leads to incorrect instruction decoding and potential register
corruption.

Fix this by simply preventing to set a kprobe on such instructions,
similar like arm64 is doing it.

Fixes: c488f5187a24 ("s390/uaccess: Shorten raw_copy_from_user() / raw_copy_to_user() inline assemblies")
Cc: stable@vger.kernel.org
Reviewed-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/kprobes.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/s390/kernel/kprobes.c b/arch/s390/kernel/kprobes.c
index c450120b4474..e806b124e4ba 100644
--- a/arch/s390/kernel/kprobes.c
+++ b/arch/s390/kernel/kprobes.c
@@ -85,6 +85,9 @@ static bool can_probe(unsigned long paddr)
 	if (!kallsyms_lookup_size_offset(paddr, NULL, &offset))
 		return false;
 
+	if (s390_search_extables(paddr))
+		return false;
+
 	/* Decode instructions */
 	addr = paddr - offset;
 	while (addr < paddr) {
-- 
2.56.0



