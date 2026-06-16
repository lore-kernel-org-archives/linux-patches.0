Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F8B536C9E5;
	Tue, 16 Jun 2026 17:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632498; cv=none; b=mY2vPAGYHTb8X5tXw4oyV73pQS+nLOIJIOZ4T9e00Y32TdkA8smvCnxmn6vYnugP0lxi5qZipaAqpXMgXyG9TrJY+REdIjoNn0zwBTTkUlMV69mgqh+FiUzzzQR7w0bo4GP9YSBIO487dyei5cIV4SDTFYjal1FO36KTf8aquPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632498; c=relaxed/simple;
	bh=oiVIAOYpXH6X1t/EwasVTsPit0bczakjFJNtgf1rP2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lIJ+SF14lzncxvF43GMrwk8Su6ZT6yHsL2PLl7+SYQ/WA1D/L42bQ7XjFkC5+vksKkpZiITdYKYLmKngAJQeFS+VZRCFCjxN27w7nb3uxiqLWnUK9ywJLNHluxL2n7iT6dq6vdV+K0hYp0haF4BaXgaXM5A4acjcXJaS5XxH6EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yXVdoLFj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yXVdoLFj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08C351F000E9;
	Tue, 16 Jun 2026 17:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632497;
	bh=vQm+wglflOAsWMwwZl6oVGcIeynu0CBpyL+0mRjQTvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yXVdoLFjWtih8XgyTvIRkBAxcq0iKWA616+F96EpCHuF3exkIobCPYn8CBhnK4RN5
	 thg1A//3ZrSHkfwwl+Os/0yDibGr8sUkL6N0+Vtslu0EHqieRPUiJpd+qoe/WtpIFO
	 P3Gg6ur/uB7tNxNNfUmYimvcKUpB6Cze+7TUzR9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 423/522] mptcp: pm: ADD_ADDR rtx: allow ID 0
Date: Tue, 16 Jun 2026 20:29:30 +0530
Message-ID: <20260616145145.779948621@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ relocated the 3-line deletion from net/mptcp/pm.c to net/mptcp/pm_netlink.c ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -315,9 +315,6 @@ static void mptcp_pm_add_timer(struct ti
 	if (inet_sk_state_load(sk) == TCP_CLOSE)
 		return;
 
-	if (!entry->addr.id)
-		return;
-
 	if (mptcp_pm_should_add_signal_addr(msk)) {
 		sk_reset_timer(sk, timer, jiffies + TCP_RTO_MAX / 8);
 		goto out;


