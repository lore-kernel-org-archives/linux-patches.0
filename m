Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5E514B946;
	Mon, 16 Sep 2024 12:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488136; cv=none; b=kNw+Q0BNeoEDS5O67esOXIOk1m+jSySMSTRXVAuJHPDGgUmUiN+dKVwJfX8KkakPuObPs7TAHTW/ZOQy85v3Wlcby9dQqYJa9wmD2jIJRWGQe3nl8jVQSU46j9qzAgiERVKoqLAnVBE3wbY+qUgwI1nQdandCzNNoP/VgN31/Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488136; c=relaxed/simple;
	bh=99AFPWlBUSHZJVJ69OqatdfjMZ3TQux5TB9C7i1Kieg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pM+wIU7IO8avKytFW/h/c7Bv3Mrs6C1klhJOA+M7k3UNCgFVWXCkR8xiipVayMTmwgegUuIHHO//lyH27Q6L8PGsSlZvp1c6g4qU8yIkyHFTIZTJc7Vi2mMJxfo+yrJ8ftpRj58rnI9wZQYdQQPUkYncJH5UXr71S9VSx3vo7is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R2bmg/1G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R2bmg/1G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF17DC4CEC4;
	Mon, 16 Sep 2024 12:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488136;
	bh=99AFPWlBUSHZJVJ69OqatdfjMZ3TQux5TB9C7i1Kieg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R2bmg/1G5Go0UoXJ+cyzbyMtnjrxr2dASqV/qDWk2/0hoPYi5E040KeLwx2iC6y0R
	 06z3pZBaI4Fi0eUJR52CA0ULxh73UJfk1efJsriudaafoNOzlREA1O8z3VYc/NxHaD
	 DPMFb62zfRl4T9xeqa9PRbyOmDnDhUpfWjVg/3+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Michal Luczaj <mhal@rbox.co>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 36/63] selftests/bpf: Support SOCK_STREAM in unix_inet_redir_to_connected()
Date: Mon, 16 Sep 2024 13:44:15 +0200
Message-ID: <20240916114222.338950446@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114221.021192667@linuxfoundation.org>
References: <20240916114221.021192667@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2cf0c7a3fe23..cef5d3595171 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
@@ -1909,7 +1909,7 @@ static void unix_inet_redir_to_connected(int family, int type, int sock_mapfd,
 	if (err)
 		return;
 
-	if (socketpair(AF_UNIX, SOCK_DGRAM | SOCK_NONBLOCK, 0, sfd))
+	if (socketpair(AF_UNIX, type | SOCK_NONBLOCK, 0, sfd))
 		goto close_cli0;
 	c1 = sfd[0], p1 = sfd[1];
 
@@ -1944,7 +1944,6 @@ static void unix_inet_redir_to_connected(int family, int type, int sock_mapfd,
 close_cli0:
 	xclose(c0);
 	xclose(p0);
-
 }
 
 static void unix_inet_skb_redir_to_connected(struct test_sockmap_listen *skel,
-- 
2.43.0



