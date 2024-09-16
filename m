Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794E313DB9F;
	Mon, 16 Sep 2024 12:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488387; cv=none; b=SQro4KjF5pTliLAPJQzm7qn0HLjXG/qt/BNZxMp7xgy4DcvudpdyD6LZY1fdfufAIqCNbegYwxGAPGjwqnt/FO8z2Ht0dwmIi0Zr/Khh0nXwBNqMsaGou2VOCvV1IX1K7A65ICkEwa2JntV3+ZS9GR2642Rb2wKnfa/mGIHP8hI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488387; c=relaxed/simple;
	bh=6nx+n+7bGqeMRHz/NSr6JnZp/oCbT4VCh0Hg9hBd82o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MbiNwzAyZX4Jy3htUh4QYH3WCfu39sh/B3czFEhcfvNBKFD+GPxuLFeupDH4FUakGBtHftiL325jL7TwejKcn8H4G16ZVtXyy1m4+UD2QTjPaTTWDev58YNdGJQr96yLuv3LRZRMJ6PctR/W+TJ5nQKwULJE4hxnSD4xepkKZ1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M52OG7qt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M52OG7qt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029B0C4CEC4;
	Mon, 16 Sep 2024 12:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488387;
	bh=6nx+n+7bGqeMRHz/NSr6JnZp/oCbT4VCh0Hg9hBd82o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M52OG7qtgL/c1lt5lhp6Pegk659lNh6xsg6RhbveG8O5bW0zbYpb/gBt4gJK1kLF1
	 al7B3N+PqZcXq38aPjC2EtOhR64+MF9lvV4C9KWgMhmY6GuX+ohob3h/rbABjLxEhX
	 OM3gGCtB2ClCgrgRH67XSrIh/hP8bng7qikQGF6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Michal Luczaj <mhal@rbox.co>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 068/121] selftests/bpf: Support SOCK_STREAM in unix_inet_redir_to_connected()
Date: Mon, 16 Sep 2024 13:44:02 +0200
Message-ID: <20240916114231.415933018@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Luczaj <mhal@rbox.co>

[ Upstream commit 1b0ad43177c097d38b967b99c2b71d8be28b0223 ]

Function ignores the AF_UNIX socket type argument, SOCK_DGRAM is hardcoded.
Fix to respect the argument provided.

Fixes: 75e0e27db6cf ("selftest/bpf: Change udp to inet in some function names")
Suggested-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: Jakub Sitnicki <jakub@cloudflare.com>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/bpf/20240713200218.2140950-3-mhal@rbox.co
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/sockmap_listen.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
index e91b59366030..c075d376fcab 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
@@ -1828,7 +1828,7 @@ static void unix_inet_redir_to_connected(int family, int type,
 	if (err)
 		return;
 
-	if (socketpair(AF_UNIX, SOCK_DGRAM | SOCK_NONBLOCK, 0, sfd))
+	if (socketpair(AF_UNIX, type | SOCK_NONBLOCK, 0, sfd))
 		goto close_cli0;
 	c1 = sfd[0], p1 = sfd[1];
 
@@ -1840,7 +1840,6 @@ static void unix_inet_redir_to_connected(int family, int type,
 close_cli0:
 	xclose(c0);
 	xclose(p0);
-
 }
 
 static void unix_inet_skb_redir_to_connected(struct test_sockmap_listen *skel,
-- 
2.43.0



