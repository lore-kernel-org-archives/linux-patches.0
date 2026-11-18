Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045945;
	b=pL4cWSxWDrgx7SyBr58Djk9MaS+bIgnnQq2X+Ss2wveSFqASh4x/G38GRDQu6dm7pfn0
	 g6YmnN7kOnDfjGJ7qxrnI0nj96uzS7TJ5yUfZmf9o+Q+8JyQdkRlgn/HDXaG00i2ewldX
	 s3iPyW3BHEOdNRwBGMQEHNml7+ZWeaYGntYm0TiJOPRnH82Sjzv/Tn0EeSFMlpoitXmyY
	 9pdJCVsncRwSHm3JC8k/+EVsfnMJ8q1DzBrEBm/iPyYVTxbrKY54C5BJfG0RzORz8Nj0T
	 mq4A+AcYLeofBz0/44DbI1L+PrWIV+vF/eF1rSKE0LM7Ps2TvCKYuJcKoNqY538yL/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045945;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YJMXB31/YWE9z2vx0zK/4OPpaXZqJ1OyT219rOR6C+8=;
	b=5j9DdvibvAREJ788+EoKsKsBPLx4iQuNeDd9OuuSUw7oAq/k/nIWS3RSP+L6as7kYAYZ
	 kCrxPNa2CwFjZ8/V6xFxgyRZ7kP0v7crrLlbmcpVJvf8/BEaSApS7Vt55V1jR9SNn7ZFG
	 JTrli88y0FUeU1wJSLtJM6OQW9Ft83IOGdUE8bv3Q4fp/dPKh6dGzXUFaXf57SnwVnnQl
	 Fv5/24GyMq0kWHgW9Vz19OFM5wqdu43iE9LrGoLZSrrtIB3blPIfuaJ1esv9oEWhrftjw
	 NiSJZZ9eeEM3OmF8EDyMY7YVJ5xzTw/4kDjI3ZRzLGfUPI8kCY/cxBr7+92BEEjymeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1XUwpuDz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B184F606A320;
	Wed, 18 Nov 2026 23:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1XUwpuDz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19A4A1F000C4;
	Wed, 18 Nov 2026 23:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045945;
	bh=YJMXB31/YWE9z2vx0zK/4OPpaXZqJ1OyT219rOR6C+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1XUwpuDzWNiXNDWD+PDf/UxmueoxxyMDJ/A0sHUqTeZ2Vam0PHdDsmfNPwhAZxW14
	 VD7MqMM8QjWnYLQS4FWAnyi8eViax0ItcPel+BpgEkoUHzLTAYeSJ4Wc0XSwojPiCc
	 x0nDkANhy/B2YjARVOZOqPAEX3gTKywOtM36siCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Andriy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Petr Mladek <pmladek@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1104/2857] sprintf.h requires stdarg.h
Date: Wed, 18 Nov 2026 15:35:38 +0100
Message-ID: <20261118150241.384424977@linuxfoundation.org>
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

From: Stephen Rothwell <sfr@canb.auug.org.au>

[ Upstream commit 0dec7201788b9152f06321d0dab46eed93834cda ]

In file included from drivers/crypto/intel/qat/qat_common/adf_pm_dbgfs_utils.c:4:
include/linux/sprintf.h:11:54: error: unknown type name 'va_list'
   11 | __printf(2, 0) int vsprintf(char *buf, const char *, va_list);
      |                                                      ^~~~~~~
include/linux/sprintf.h:1:1: note: 'va_list' is defined in header '<stdarg.h>'; this is probably fixable by adding '#include <stdarg.h>'

Link: https://lkml.kernel.org/r/20250721173754.42865913@canb.auug.org.au
Fixes: 39ced19b9e60 ("lib/vsprintf: split out sprintf() and friends")
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andriy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sprintf.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/sprintf.h b/include/linux/sprintf.h
index 9ca23bcf9f42e..4dcbfd1015118 100644
--- a/include/linux/sprintf.h
+++ b/include/linux/sprintf.h
@@ -4,6 +4,7 @@
 
 #include <linux/compiler_attributes.h>
 #include <linux/types.h>
+#include <linux/stdarg.h>
 
 int num_to_str(char *buf, int size, unsigned long long num, unsigned int width);
 
-- 
2.53.0



