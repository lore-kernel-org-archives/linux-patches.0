Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC491D0412;
	Wed,  2 Oct 2024 14:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878955; cv=none; b=XVuSOwKP+Vtph5jCUfBDRdhd0NJ84aX5cqTSfZx6AL/PuStQ3lANFLdmmx9FIoMm65kCkcVwnTc/kMtbF7rBpMG00WVEzfO9sctGsW1mKRSCyys+T8ricCO3x+lF5cuP2YwegcHTzXp1E187Kt+19FnJKK1S3yzZ2GIl3uBh23o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878955; c=relaxed/simple;
	bh=g4mfKMbudAorbhSVsofnNFF51o3tMYM5xYlbsreNXi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B2McGW8DLCO3JtDQrTTzge9QN4X3wLQaWi/vrcDImP8isRaUvyGdnRxj8T5ptCqC5xiJfCxlUw5ghT0Tq70oJc56ycd9JXex8sNiF1r2Pm2YBZVdqMBphRwih0jRsK3KZfXzCqOGitMQh5IOYGAYoS1YNastiBXX+5OfCxxb1Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LWUmoYrY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LWUmoYrY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 035EFC4CEC2;
	Wed,  2 Oct 2024 14:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878955;
	bh=g4mfKMbudAorbhSVsofnNFF51o3tMYM5xYlbsreNXi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LWUmoYrYGv0vpK58FREi3VMDbncx8+3l33Y2zoAvTeGaiWUeiJ8QXFCozjTjCcCHO
	 pRVLcr3CD3cFqCL9EnvTYWMy8sLzRLum7fxiCgmoiJPzXeCl4bq1VltHn/RHWzAt3i
	 zO/apsDeX3Qk39/Z0ZQSLcwAPjFJi+1ZtA36N4IE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willy Tarreau <w@1wt.eu>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>
Subject: [PATCH 6.10 590/634] tools/nolibc: include arch.h from string.h
Date: Wed,  2 Oct 2024 15:01:30 +0200
Message-ID: <20241002125834.402999629@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

commit 6ea2987c9a7b6c5f37d08a3eaa664c9ff7467670 upstream.

string.h tests for the macros NOLIBC_ARCH_HAS_$FUNC to use the
architecture-optimized function variants.
However if string.h is included before arch.h header then that check
does not work, leading to duplicate function definitions.

Fixes: 553845eebd60 ("tools/nolibc: x86-64: Use `rep movsb` for `memcpy()` and `memmove()`")
Fixes: 12108aa8c1a1 ("tools/nolibc: x86-64: Use `rep stosb` for `memset()`")
Cc: stable@vger.kernel.org
Acked-by: Willy Tarreau <w@1wt.eu>
Link: https://lore.kernel.org/r/20240725-arch-has-func-v1-1-5521ed354acd@weissschuh.net
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/include/nolibc/string.h |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/include/nolibc/string.h
+++ b/tools/include/nolibc/string.h
@@ -7,6 +7,7 @@
 #ifndef _NOLIBC_STRING_H
 #define _NOLIBC_STRING_H
 
+#include "arch.h"
 #include "std.h"
 
 static void *malloc(size_t len);


