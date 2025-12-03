Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4371A2C25;
	Wed,  3 Dec 2025 15:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776070; cv=none; b=GsNsSGLov5bW8JkRcmKDPyTF5UFlm9Rg7hSzqWviF9H+cAoRi55SjM6n7UrpLt5MPpEDxltvogQwJmhCpQ8fxRYAgfcsMvT/4iZtrspwraDQTX8ch1QShwNS6dgbfLF3N2u39IG1P38HSQGZC2UY0DODynV4lUc90mGUYOPZtzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776070; c=relaxed/simple;
	bh=7WgmJrE9+ljYQTOdqdg/sCDSQhALmFaXYdIpNRoWzjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qagb7nve0GgoHK59NHI0zs+8vHW/2wGbiTPdTW56BmYsFI5PPXfAHeOSFZiwGOpbpdM9/nHSakwP7DDrzR8+B3rBTkJqgHzfFyai5njrtlKAodw9arjnfT//nLxJFiGXDRoQPbGgRQTaD9YOdsB/EtlYaJS/UpUHyRi5vUE21Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QTJ4pzr+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QTJ4pzr+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C025AC4CEF5;
	Wed,  3 Dec 2025 15:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776070;
	bh=7WgmJrE9+ljYQTOdqdg/sCDSQhALmFaXYdIpNRoWzjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QTJ4pzr+UilyimjzeRvsk3EYdUgXsYeKp0125YaqZwUYo2Qtq+/MMj0oxxDaZYczh
	 rIDCQhieGxytYBFTZDG8jhhWS5CMhJ6ZTz9CsFznDCzqmWvTi0UFxg5Q0FUIuAl6Mg
	 uD5BLeE3xrb0zPjyziaHZ+er/YTBzuttKVmP88DU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wake Liu <wakel@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 072/300] selftests/net: Replace non-standard __WORDSIZE with sizeof(long) * 8
Date: Wed,  3 Dec 2025 16:24:36 +0100
Message-ID: <20251203152403.289921317@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 404a2ce759ab6..93092d13b3c59 100644
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



