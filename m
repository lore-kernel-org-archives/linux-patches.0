Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FCFA25393E;
	Tue, 25 Aug 2026 13:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666288; cv=none; b=Egz0T6IfC7ikeRXoc7VENCY/y9ZjaeMOU92uXLJ5NYI5sWjv1JbMsotp+8NCtdwDSpHWE+lBdNDtbW6ibUBfH0jiCEJQrrnIU0HirRU1VPOiwgYd9aAPAfCkSHjdQ4nT6iidcKx3ncawvrwVcqU9CCRT9dFtSTKBQaXIXeEOMnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666288; c=relaxed/simple;
	bh=j2lu8it4Y0XiF5rhWj6iRJZ34Gzyz+REkRCeESe6gMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lci1FUutewLZxddrX/5lV1qpRlhknYYDMw/yvFq+lbyZdTag+19a7DpRKGCxv63dIhz8tXIIzJTXEkTr1I7vUvf1WtvaSJaDu3WamRHfppOji/GG14w1Tx4hT4EwR8u6DbmEk2ahK9rOdJuAyWJ/VXdSjKc2ZEKsbpLqUybDSog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DCxc1RgC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DCxc1RgC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFB401F000E9;
	Tue, 25 Aug 2026 13:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666287;
	bh=hH0H2jxU9Py7IPJFIQAZ13L7X3M3je9KxZZQ3y/xIek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DCxc1RgCJAqjramcsTtLmtSX09gYedwfxnvfzzJBxmZV4rc45ysmcEgz/4niFZaoa
	 uUu+bI+JCS8fYz+MkTO3EVx3iRjaKe5UwZ0QVU0Ybh+1d/Yak0xRW0c3W0+qVTusM2
	 hKSybFG2x1xJmh2fGjOjnFHkKVNDOBcLbi1n8eY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 68/76] mptcp: pm: ADD_ADDR rtx: allow ID 0
Date: Tue, 25 Aug 2026 15:27:01 +0200
Message-ID: <20260825132544.226757589@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.568214149@linuxfoundation.org>
References: <20260825132541.568214149@linuxfoundation.org>
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

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

[ Upstream commit 03f324f3f1f7619a47b9c91282cb12775ab0a2f1 ]

ADD_ADDR can be sent for the ID 0, which corresponds to the local
address and port linked to the initial subflow.

Indeed, this address could be removed, and re-added later on, e.g. what
is done in the "delete re-add signal" MPTCP Join selftests. So no reason
to ignore it.

Fixes: 00cfd77b9063 ("mptcp: retransmit ADD_ADDR when timeout")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260505-net-mptcp-pm-fixes-7-1-rc3-v1-2-fca8091060a4@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: a7aad5b69d3b ("mptcp: pm: fix data race in add_addr timer callback")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -326,9 +326,6 @@ static void mptcp_pm_add_timer(struct ti
 	if (inet_sk_state_load(sk) == TCP_CLOSE)
 		return;
 
-	if (!entry->addr.id)
-		return;
-
 	bh_lock_sock(sk);
 	if (sock_owned_by_user(sk)) {
 		/* Try again later. */


