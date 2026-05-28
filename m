Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FFEA25F7B9;
	Thu, 28 May 2026 20:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000339; cv=none; b=qnexSHt55jhJemt4mWJErHj/M4HZhYSIHJ/GF3RdQERqh3klAIBf108FVyWktoP7wEu/tALWZIXJ2x3BnKAF2w1s0yBwwdY0UMzqTlNSUm0cCXZ4GXxztJ0lL6w+WTdEiCAlnFLkEkbU0ex4W20/oXx+D6QEy3cseQaMkYPPNw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000339; c=relaxed/simple;
	bh=SYi8FXv0FNbkbrBIMtGrrIUCxkcetVXYBNJRycOsdeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U6bE6XvKi5KkWfAwDpSPmfdxHO7SZaEQXopzJCGY3AaaqZBTsBE5jdZc4YhWQ323ttaCVBodx7YMsNoFcKn2i3ZyuTjjoR0nqxRATZbIIDcOzMWhyMhXXhLZRJtg2gKVNcMRzEnds/j5J/gMTY4nVHhyiDrC27NUpv7cNZZkmk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fjXwpcGb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fjXwpcGb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D9201F000E9;
	Thu, 28 May 2026 20:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000338;
	bh=ldDURr0RCh6JXaSv4fa+Zsuf0HYMSOxuFl/veVd6wYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fjXwpcGbyD37+y8w7XBT39/YgFJOFw7biBWBaDSBaYIRPP8KVPlJZ4pIIi35irali
	 QFzhQZIB68u0ZuVJ8nHzHorfyl2Xwff9TG820UvxcAYHIAw2xczY0lL/DxjgHUhrUc
	 KcGiKX3iHKhmW4t8bX6zFVG/uIu3w17vY9C6AJc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 002/272] mptcp: pm: ADD_ADDR rtx: allow ID 0
Date: Thu, 28 May 2026 21:46:16 +0200
Message-ID: <20260528194629.452848735@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 03f324f3f1f7619a47b9c91282cb12775ab0a2f1 upstream.

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
[ applied to net/mptcp/pm_netlink.c instead of upstream's pm_kernel.c ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/pm_netlink.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 5d892583ab4ef..857e8db670a75 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -304,9 +304,6 @@ static void mptcp_pm_add_timer(struct timer_list *timer)
 	if (inet_sk_state_load(sk) == TCP_CLOSE)
 		return;
 
-	if (!entry->addr.id)
-		return;
-
 	bh_lock_sock(sk);
 	if (sock_owned_by_user(sk)) {
 		/* Try again later. */
-- 
2.53.0



