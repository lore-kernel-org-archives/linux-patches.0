Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5C6142903;
	Mon, 16 Sep 2024 12:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488692; cv=none; b=AjlDJ5aWygapsb0ecZsvYOvi3tBkodmgbysWqRygA8InKHgk4Y7htmfwqRakIMyihrvsGoOGtYG3F2TFv4u57nLr12ioIA9iihk9isgOjKsV205yF9S56dTrPwn/F1Idq/mzw/qVqk+KZ426FjGksefzn0avah2OeztJ3SegKk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488692; c=relaxed/simple;
	bh=p0SWhdegiRX/cDvG4zJ2z5YmE+prU0MUMvExZNo7IKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i78te92hVxUFky0gAX3loyHmcBTDCYNZJfvs/hvz8nc/SId5aMrMUJKhE+/XOtdn6CdPEYaGSPZlJcWbfdMUj4SVGOTW6c1fncR5qYRU5wH4PkIZHAIilM6aUX5I/jFcyE3ugJTQ0zC9EUOfza5JBSqoWToAiWjhrCE0VHFg2Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X4dWC7eK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X4dWC7eK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A6BCC4CEC4;
	Mon, 16 Sep 2024 12:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488692;
	bh=p0SWhdegiRX/cDvG4zJ2z5YmE+prU0MUMvExZNo7IKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X4dWC7eKxJAhaibWWbc4yQjyR9U9o2cc8Ga+ze7RxT4CMyykFTWap1w3rO1N/5IuT
	 cz31DTrltsgOEgCiM3vH96CTPzXaLrPnp1lY6JNsnad/BdoEF8tD2NYP+KfhmG3eq+
	 6Kar3Z+xRwHtbiLkxmgbTlbQ5Q13qzn1v6pQnUoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Michal Luczaj <mhal@rbox.co>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 53/91] selftests/bpf: Support SOCK_STREAM in unix_inet_redir_to_connected()
Date: Mon, 16 Sep 2024 13:44:29 +0200
Message-ID: <20240916114226.260760291@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8df8cbb447f1..84d59419e4eb 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
@@ -1841,7 +1841,7 @@ static void unix_inet_redir_to_connected(int family, int type, int sock_mapfd,
 	if (err)
 		return;
 
-	if (socketpair(AF_UNIX, SOCK_DGRAM | SOCK_NONBLOCK, 0, sfd))
+	if (socketpair(AF_UNIX, type | SOCK_NONBLOCK, 0, sfd))
 		goto close_cli0;
 	c1 = sfd[0], p1 = sfd[1];
 
@@ -1876,7 +1876,6 @@ static void unix_inet_redir_to_connected(int family, int type, int sock_mapfd,
 close_cli0:
 	xclose(c0);
 	xclose(p0);
-
 }
 
 static void unix_inet_skb_redir_to_connected(struct test_sockmap_listen *skel,
-- 
2.43.0



