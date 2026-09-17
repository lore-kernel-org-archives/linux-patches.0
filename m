Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6094973A6;
	Thu, 17 Sep 2026 15:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660640; cv=none; b=ISK51lUCf58p6FJjhtJ/XuuEQOPAr/QMi6jZUQsROx1Z8MqWD7aEfE71PKZqV7Amn6Dm03h7YbFAOuneRzabHcXDhBQ/tMHq6j9B+0QjBN4S/a3TFUjax7Uf8WAKgeXP4VvwsBrfX83Wr4G6DZdTmrUyEH9mrJPtZcmoRuwgxnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660640; c=relaxed/simple;
	bh=v99qKWCOc3T7DoNPmKt1Twxjg18f3e1fGsJMO7lZpSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rl8hX99dyt1N+b75PH9FkOJNmAozqygs8M9XIUkg2QYl5c9BpNe7+De0rseE7nB+K+mmHA1u6TvwLJBGADa3R6kVBq3t/qqrW/ZtAwjR2KF6Vrf23ZzxUCxf89q+pnKH8teMfyEfnQ7WHtmzadgCyYzRY4jDD3Xc7oyCeJWPw+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hRb4jYxF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hRb4jYxF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EDAC1F000FF;
	Thu, 17 Sep 2026 15:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660638;
	bh=BuxOC358b4tHZsaQlJHVlb6TTKXV9+LoDsFI1fzNMTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hRb4jYxFMgUQiCstlDyTFRznXvI/JnmYz2eaEbhmDQiocV19IQ3GaEeNwrybnaY/f
	 FExxl1Sh68+VthoVl1g29pCcIuVBDL9vzDvUsFp0RluskN/DolYFni9Blc0IBqo9Lt
	 XbQuPPxAhiHBJQN2ao0K9+IovARgoaG7LV8O3qbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 622/733] mptcp: pm: reset retrans_time when ADD_ADDR entry is reused
Date: Thu, 17 Sep 2026 16:15:30 +0100
Message-ID: <20260917151408.038978818@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit f968190c0b42ea2004dc1426359a53ec365a7a37 upstream.

When an ADD_ADDR entry is reused, the timer is re-armed, because the
goal is to re-announce an ADD_ADDR, and eventually retransmit it if
needed.

In this case, the retransmission counter should be reset as well, so the
re-announced address gets its retransmissions back instead of relying on
what was left before, and possibly not being able to retransmit it.

Fixes: 304ab97f4c7c ("mptcp: allow ADD_ADDR reissuance by userspace PMs")
Cc: stable@vger.kernel.org
Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260803-net-mptcp-misc-fixes-7-2-rc6-v2-0-b8f496d71664%40kernel.org?part=4
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260908-net-mptcp-misc-fixes-7-3-rc1-v2-9-df1de70348b6@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -462,10 +462,10 @@ bool mptcp_pm_announced_alloc(struct mpt
 
 	add_entry->addr = *addr;
 	add_entry->sock = msk;
-	add_entry->retrans_times = 0;
 
 	timer_setup(&add_entry->timer, mptcp_pm_add_addr_timer, 0);
 reset_timer:
+	add_entry->retrans_times = 0;
 	add_entry->timer_done = false;
 	timeout = mptcp_adjust_add_addr_timeout(msk);
 	if (timeout)


