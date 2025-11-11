Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0947225F797;
	Tue, 11 Nov 2025 01:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823316; cv=none; b=ajTNZhmt3dsQ4fCJ6EwYaHyYgo5sxVQDhHqOleKt8TKcsrBiFuhPxl4ExWJptz7KShRi1fYxKrV1PHlh6XH727KyuPHn21ohOKNOmwCd/BwmjQgsLFeFD98KU6tMJLZ2EKYKYBwPzOJt4vfBLlYZPOnNsMa2sboq0zXc4nL5jEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823316; c=relaxed/simple;
	bh=kN48xLI2kl7w8jxbGAzW4o1yS2vCOeFkQ9yjAVEHY4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o31ai3239PlL9edcrJ3ot8l84UBcQvRKICGXWzeorJOQkGt5cZ2f+WdWFwi3l2SJQAfN/m4MIRVcRs+tsIwJIrlLsI5++GT0TcV1aPXSMv3BPeJr6dvHQiwllh5aOcWOMFgQySEnVArkosPeOT67w5h87/OTwPSE0AE4ygJItH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m5Tg9/sH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m5Tg9/sH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96356C19422;
	Tue, 11 Nov 2025 01:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823315;
	bh=kN48xLI2kl7w8jxbGAzW4o1yS2vCOeFkQ9yjAVEHY4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m5Tg9/sHVLYSOx2q8ae+ES4XkDCb4B7qJhooQlvTph5OtudSMx9bLQKkSWr0+X339
	 Mph0Eqe3VAOhlRGzmJ0+5B/cA3r6v3nDitGJa3Wg/TE5t3Qy5q4d0V9oQLbYcTdsnG
	 azAn3udMO/kDoU2L6GFDs+BO+LOTy0IPWNM48dqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wake Liu <wakel@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 274/849] selftests/net: Replace non-standard __WORDSIZE with sizeof(long) * 8
Date: Tue, 11 Nov 2025 09:37:24 +0900
Message-ID: <20251111004543.052617833@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wake Liu <wakel@google.com>

[ Upstream commit c36748e8733ef9c5f4cd1d7c4327994e5b88b8df ]

The `__WORDSIZE` macro, defined in the non-standard `<bits/wordsize.h>`
header, is a GNU extension and not universally available with all
toolchains, such as Clang when used with musl libc.

This can lead to build failures in environments where this header is
missing.

The intention of the code is to determine the bit width of a C `long`.
Replace the non-portable `__WORDSIZE` with the standard and portable
`sizeof(long) * 8` expression to achieve the same result.

This change also removes the inclusion of the now-unused
`<bits/wordsize.h>` header.

Signed-off-by: Wake Liu <wakel@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/psock_tpacket.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/psock_tpacket.c b/tools/testing/selftests/net/psock_tpacket.c
index 221270cee3eaa..0dd909e325d93 100644
--- a/tools/testing/selftests/net/psock_tpacket.c
+++ b/tools/testing/selftests/net/psock_tpacket.c
@@ -33,7 +33,6 @@
 #include <ctype.h>
 #include <fcntl.h>
 #include <unistd.h>
-#include <bits/wordsize.h>
 #include <net/ethernet.h>
 #include <netinet/ip.h>
 #include <arpa/inet.h>
@@ -785,7 +784,7 @@ static int test_kernel_bit_width(void)
 
 static int test_user_bit_width(void)
 {
-	return __WORDSIZE;
+	return sizeof(long) * 8;
 }
 
 static const char *tpacket_str[] = {
-- 
2.51.0



