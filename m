Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69392561AB;
	Mon,  1 Dec 2025 11:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588537; cv=none; b=aT2fslLr+J3BBbtw54iA/5bQ9ijm+pWMs2juJqOBytBxKhUJ65oro3qMhHZkMY4HzVbkFp6NHcVf3fr1biud/xHAk73xImLDXqPowJ7BfoSltgz+OFqpctrF5zkU2ZJab4Vl/UxobJr+fJ1dGRFoHVtmza2K59pRXnVdi+hHf3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588537; c=relaxed/simple;
	bh=VE/MngTAyL8DP6PNHPxF6GppnQ1u1E0DOmqVMwoOCXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J22TISsFR9ypYs+lWCIsrXDkTvGCogRn6LjKEtAxSzRnEv8a+gvs1p1rwPt+WqhZfUlA6FabfviEuwy0APqRd3X6UK+ucFwFupX0q7p6jADJAzaO+caz/EUqoGennTQCWq5tBcoxM1HMtqVJjYK+BbU7/jfw5rem7Q6Bbie+HD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ooilOSQU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ooilOSQU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 539ACC4CEF1;
	Mon,  1 Dec 2025 11:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588537;
	bh=VE/MngTAyL8DP6PNHPxF6GppnQ1u1E0DOmqVMwoOCXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ooilOSQU1stq9C7gWzVzXZTLFK92Bj3EAZarU3EgdSbbqtgqx4NjJCdUxm2vpOTjI
	 SMIgBj9cmDTePQV0hi9mbqEaQbwToTHZm1//K6+dULOB0/s9RGSEv543hU1Jl6y9+g
	 9QgpdePNnxky+yohqUd7RzMxIqD+aB/zES6RFw0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wake Liu <wakel@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 050/187] selftests/net: Replace non-standard __WORDSIZE with sizeof(long) * 8
Date: Mon,  1 Dec 2025 12:22:38 +0100
Message-ID: <20251201112243.054012933@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



