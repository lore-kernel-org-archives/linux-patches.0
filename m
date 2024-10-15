Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14831D89F5;
	Tue, 15 Oct 2024 11:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992177; cv=none; b=j6WePX6mmXn8FJ5m0kSviYnVLu0V3dlGPgz0iwXvbESKrhUcbsrfDPYZ2Sh7LM6ePoHKi/3tB+z6PG9j4X0QMDDEKHzBV0jKzHASVW4IUQVLgzleBjg7lOIJ2PHbTXVVzOdPe1pFSrgR+bcpghRuSLxIdTwsiKrj0keyxgCmxrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992177; c=relaxed/simple;
	bh=uUbXltVWUaWE+2sckeEcQZPZw+jVZ9deiy2vGa+zVSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JvnKwTE1i56faL6he6szFwDL8639HJh2h9t7HY8nxhSdsOrqXxhKotHNHY2yDA4iyGpMne6Xe4+L9UBWMQy6zCdOEcSDHJuWOmSOEjafC8oD8GrfT6G6fb65VA9pPARljU8/nep8pIIDKCeoiVhw24ftXaeLq7NV9OrZv8B00bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=maCZPAP9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="maCZPAP9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F58C4CEC6;
	Tue, 15 Oct 2024 11:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992176;
	bh=uUbXltVWUaWE+2sckeEcQZPZw+jVZ9deiy2vGa+zVSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=maCZPAP9YxFdS5bZOutpO908hPp71FR38gpOhYhhdHc6bt3AiACgLoJcAen+OHOcc
	 5B5IZ/Lbk2xWerDZmKoUnoaM1N6vhsHvQx5+B+9RoXniJtMMtNUYbPQnR9mr37IRYe
	 HEcS3xLGjghh2tRn3IDpcC8Nns+JS5jcgvlvh+t4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Michal Luczaj <mhal@rbox.co>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 039/691] selftests/bpf: Support SOCK_STREAM in unix_inet_redir_to_connected()
Date: Tue, 15 Oct 2024 13:19:47 +0200
Message-ID: <20241015112441.890955680@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d88bb65b74cc..1a0c678cba90 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
@@ -1911,7 +1911,7 @@ static void unix_inet_redir_to_connected(int family, int type, int sock_mapfd,
 	if (err)
 		return;
 
-	if (socketpair(AF_UNIX, SOCK_DGRAM | SOCK_NONBLOCK, 0, sfd))
+	if (socketpair(AF_UNIX, type | SOCK_NONBLOCK, 0, sfd))
 		goto close_cli0;
 	c1 = sfd[0], p1 = sfd[1];
 
@@ -1946,7 +1946,6 @@ static void unix_inet_redir_to_connected(int family, int type, int sock_mapfd,
 close_cli0:
 	xclose(c0);
 	xclose(p0);
-
 }
 
 static void unix_inet_skb_redir_to_connected(struct test_sockmap_listen *skel,
-- 
2.43.0



