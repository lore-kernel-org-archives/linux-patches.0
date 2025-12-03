Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347E734D4CE;
	Wed,  3 Dec 2025 16:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777757; cv=none; b=mH+wR+jLTcIGIGZxtR06Hx71tSX4lleHzbzJ+OO2y2Rm9FifFNaZpbPpaAS/GXqqyQTeniCAWjeRCZpzcH17ZwTgzgmUcdUag20IhrmqL47Rnyvtl4nVzHdWWqX9Xv7aDw4b2bwfcTPw+5YK+pcaA7W/+jCA1nrwmecBHvjBjXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777757; c=relaxed/simple;
	bh=U1xv2y9oNdQTv3QNzndKwBVbuQWLSo/F5gjPVVaAcC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a0QAgfUrW1AvK9Qvha6xnOrsLPggI4fUBKWfooyvvQAkXh7F7hOu+IzXvVgmGuMy1v6tawoAzdo+qQMaNTe0TCdeREtG3zywDNdlTXSQar59iD+nWDM8gc/bkMu4FswTANvqWIHRqXWrfEqH+NSZIrXb1F3KSYjx4pYokVS6S10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rJgjYXTr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rJgjYXTr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A35B0C4CEF5;
	Wed,  3 Dec 2025 16:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777757;
	bh=U1xv2y9oNdQTv3QNzndKwBVbuQWLSo/F5gjPVVaAcC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rJgjYXTrmgZVR7emd+eUyvRvSqZXZc2igUz87m9eoUQO4mfDp+pE41eCWikbP0kZF
	 B7uEqUNUNtXuvYezQpTYeKk1Nx/tJQuBNXmIT/TiTT5m5bCd5W6UY8qtSbvGHmyGOr
	 K2uTJBa5x9+Ms3qiT5PMLF9K285jYPhB+uhE3Bw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wake Liu <wakel@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 095/392] selftests/net: Replace non-standard __WORDSIZE with sizeof(long) * 8
Date: Wed,  3 Dec 2025 16:24:05 +0100
Message-ID: <20251203152417.597850352@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



