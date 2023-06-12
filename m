Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11B9171BB
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:34:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35AA8C433EF;
	Mon, 12 Jun 2023 10:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566098;
	bh=4nK9KDxxZK7Zf3QJsdzdRDRq7AwgaI13wsMe8JVuquo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n/b9TZpx6tPLGMKm6s9uqzabnOvG5AfOkqHgQoHNWafniaLUW8096AAzShte9zWpL
	 tiH1dc/hpJDByO9kTo/E2jneBlJn6kQPucTX+JNJZzzq1j51rAQuo1LTNji5OqEwuy
	 Uz3hQb/KmgssVdHx7VsbJC34AgaAvRwYO0vRO4GE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rui Wang <wangrui@loongson.cn>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.10 64/68] MIPS: locking/atomic: Fix atomic{_64,}_sub_if_positive
Date: Mon, 12 Jun 2023 12:26:56 +0200
Message-ID: <20230612101701.098412455@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101658.437327280@linuxfoundation.org>
References: <20230612101658.437327280@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rui Wang <wangrui@loongson.cn>

commit cb95ea79b3fc772c5873a7a4532ab4c14a455da2 upstream.

This looks like a typo and that caused atomic64 test failed.

Signed-off-by: Rui Wang <wangrui@loongson.cn>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/include/asm/atomic.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/include/asm/atomic.h
+++ b/arch/mips/include/asm/atomic.h
@@ -203,7 +203,7 @@ ATOMIC_OPS(atomic64, xor, s64, ^=, xor,
  * The function returns the old value of @v minus @i.
  */
 #define ATOMIC_SIP_OP(pfx, type, op, ll, sc)				\
-static __inline__ int pfx##_sub_if_positive(type i, pfx##_t * v)	\
+static __inline__ type pfx##_sub_if_positive(type i, pfx##_t * v)	\
 {									\
 	type temp, result;						\
 									\


