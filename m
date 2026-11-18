Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050842;
	b=iZQCa/puHY4YiV+GisxVQ1J3neG2QdOMwiU2PokZYyZrdf+qOyFJdtDTDcp/rPMPMGq5
	 rOtgDbb2raeY0fZfzMnu3uaD6neFeBEALT7BgJn6rUxnOb9Ik2ElJ9z78eccRgglDjY9x
	 UTU3WMVpSG+c7wN+T9nyyRpgHTwBED8TfGOKQ9+tb5d/SQ9IBfv/TY/PhsKn3WDLzwDlJ
	 EQrqP0Zlm2pOrcubebkXmuLxRXOIbf4sEKBDKJwFM1jp/FG7U30PZdnPaFoY/hmXd18Nq
	 vM5t9oupFu3Ff0gH2U+JUws12UGYaQnVOGacQlNHsASkunftpe0NKXC1aygcJnCKDVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050842;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tA9zSy9HhfXJXBT0BFVC+9/9v5r3zQdQylFT+Asyr4Q=;
	b=N8FJbfNe6ok3Vzy4ZIQVD1Y2xY/bGpX8cFzcTPztTGJPuZD0IalVEgmphf5cBWkoLWJf
	 auDVGspLI5GY1PWd4EOi6V/zYBn04BOXnuf63ce58sLd3JE8zrAQ8QCHFGh1184LG6HR9
	 ibGP5hNtcFrW0iSQwv5KfnQ1YMJ/SC3j/T/5NtcawXViCzENUCiPs3euNJZUB77xoMYKw
	 iBLgmecM3Luh/PO/Y1C22cruEpVTtH9TlHIsODRiT14jjRWbcpceNtlGamNcB5AyKxE5r
	 nHUHR9FnPYgJnmhK0RIipwKeQp315YEzaIicXLBwQ0md6vtpM/AMwuxgzc59EiUaO9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GICx8pr8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB701606A32F;
	Thu, 19 Nov 2026 01:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GICx8pr8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 671971F000C4;
	Thu, 19 Nov 2026 01:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050842;
	bh=tA9zSy9HhfXJXBT0BFVC+9/9v5r3zQdQylFT+Asyr4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GICx8pr8Vvx/D0KZKDsWE+e2f0piilhJfL5xlgcpmnUNO4j282omvsSfxqrwal+Qe
	 KEA0QMaZ49NPzgaa3LfjyremhKuFOwPSmRaLIvH9i01YtQy4u2tHVuJQWc6hQN2Pgx
	 45XMJHFFSKPMlqK/ixic+5x4W8L3gCYLadSpGYZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uros Bizjak <ubizjak@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.1 2853/2857] cleanup: Remove address space of returned pointer
Date: Wed, 18 Nov 2026 16:04:47 +0100
Message-ID: <20261118150344.307284842@linuxfoundation.org>
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

From: Uros Bizjak <ubizjak@gmail.com>

commit f730fd535fc51573f982fad629f2fc6b4a0cde2f upstream.

Guard functions in local_lock.h are defined using DEFINE_GUARD() and
DEFINE_LOCK_GUARD_1() macros having lock type defined as pointer in
the percpu address space. The functions, defined by these macros
return value in generic address space, causing:

cleanup.h:157:18: error: return from pointer to non-enclosed address space

and

cleanup.h:214:18: error: return from pointer to non-enclosed address space

when strict percpu checks are enabled.

Add explicit casts to remove address space of the returned pointer.

Found by GCC's named address space checks.

Fixes: e4ab322fbaaa ("cleanup: Add conditional guard support")
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20240819074124.143565-1-ubizjak@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/cleanup.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/cleanup.h
+++ b/include/linux/cleanup.h
@@ -118,7 +118,7 @@ static inline class_##_name##_t class_##
 #define DEFINE_GUARD(_name, _type, _lock, _unlock) \
 	DEFINE_CLASS(_name, _type, if (_T) { _unlock; }, ({ _lock; _T; }), _type _T); \
 	static inline void * class_##_name##_lock_ptr(class_##_name##_t *_T) \
-	{ return *_T; }
+	{ return (void *)(__force unsigned long)*_T; }
 
 #define DEFINE_GUARD_COND(_name, _ext, _condlock) \
 	EXTEND_CLASS(_name, _ext, \
@@ -175,7 +175,7 @@ static inline void class_##_name##_destr
 									\
 static inline void *class_##_name##_lock_ptr(class_##_name##_t *_T)	\
 {									\
-	return _T->lock;						\
+	return (void *)(__force unsigned long)_T->lock;			\
 }
 
 


