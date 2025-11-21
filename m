Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336C334D4CE;
	Fri, 21 Nov 2025 13:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732450; cv=none; b=nFcFeiDJGlHGVfnv6fc8NQtcD2F1aKiwl6O6YB+0mqaNqFw6UoHjPCx6hEXW62kG07663bEgK4k3uJzoFiAHMdRqIXGLPYpzMb9RdzmGOJM6ctI3RFBufdH6g8vSWX6TCLipUrkJTEbHeoPYv53Yh2PbS02CljXY3nTyNfid6G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732450; c=relaxed/simple;
	bh=Jaz782/8T5GUMoeOZbMnFVZt9Gv8giHiO8oRTJQqvwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f4OkckIS+4Wgl5k9ZScuRO32mz+tTiyF/AJ5nJOxLsVDY0A1KAYGAsFb+TXoZR9nw4vkujtkzabCYYIC74KIq9M963GXfGrn4zehLJCVSCyPK/yfiVQvAXZt9K0y/cWvUdvHBFevXuMwv2mgjOPFlvtkyOs8JrwG6du4XHJ0ywQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WT2vP0FO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WT2vP0FO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4064C4CEFB;
	Fri, 21 Nov 2025 13:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732450;
	bh=Jaz782/8T5GUMoeOZbMnFVZt9Gv8giHiO8oRTJQqvwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WT2vP0FOmschNFNB7MT9IjFByiUbW+GHTqwli5gJ6xDVOXZwZX6cYFKbNVc4UcbRT
	 e1EGXvVuneEtZFch1W7CdyGlknTE59CreLDtAp0tNGohbMNVRZHuwdJ8aJXIQ27wtd
	 7EgKXDh849BH+3UX3ZYSVpSu6RkBQTabpIjv+nK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wake Liu <wakel@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 124/529] selftests/net: Replace non-standard __WORDSIZE with sizeof(long) * 8
Date: Fri, 21 Nov 2025 14:07:03 +0100
Message-ID: <20251121130235.434135990@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



