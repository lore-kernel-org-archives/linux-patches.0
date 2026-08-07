Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142A9476CDD;
	Fri,  7 Aug 2026 15:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114815; cv=none; b=X+1GKtgWSYYG4ddVFWe8D7iQ+YcigqBNMxXNlkyHJmpFxOabpwxVpBR885vK39XBYyvoKNOE01Q9wI9Y07+uNSQGh6lZeGswqG1uUWIqRpSgyFzJ0yi7vLtFjoJx6H26bW9ba26r/qu9wMR0Db515uDt2PnXOmniW7tCgpf7oj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114815; c=relaxed/simple;
	bh=B1Crmn36nUTRZ3CJszNss9dN2QeN/MJyCNk5GoEiYdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MwG7hYXVDXYdxM2ep60TBMDItjGQGLox+MyAvmdNKwgDgAMZeufs685BOR7FQGwqeHxq0eKG+b3i17acFkni3HcWPnTPZr4FTMQ3MQSZSZe9QV6a8kbTNlDwN6k3YzB6EgN9uHQFN3XbZFiueNqOb9yvadIJQmAQjpck8s7aU4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xyLKybGw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xyLKybGw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EB111F00A3A;
	Fri,  7 Aug 2026 15:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114814;
	bh=P6eQE9esrXe1pxSlTOboaiFF5xYz/xuHED7G7UfLiWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xyLKybGw59wg7QDMVkK0B2vhoJB6vAant6KqhivXTNkROJPFFYCV0AIe2Xz+MgHpn
	 WqZ7+63RdcIani8sEnZ4o2BxrCZOH3/XlaoxWsxEJOTUZzUzcUJCdh7BiotIJ0D9ZN
	 thCs6rlOACVKgxYD+s37fKDf8mp2mEYGzNxU59DQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 058/396] selftest: af_unix: Create its own .gitignore.
Date: Fri,  7 Aug 2026 16:33:38 +0200
Message-ID: <20260807143425.523880477@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit adb6b68c50604f3113d62758e839cc0186b94ce8 ]

Somehow AF_UNIX tests have reused ../.gitignore,
but now NIPA warns about it.

Let's create .gitignore under af_unix/.

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20251124212805.486235-2-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 7f57c650d08b ("selftests/net/af_unix: test listen() rejects wrong socket states")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/.gitignore         | 8 --------
 tools/testing/selftests/net/af_unix/.gitignore | 8 ++++++++
 2 files changed, 8 insertions(+), 8 deletions(-)
 create mode 100644 tools/testing/selftests/net/af_unix/.gitignore

diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
index f627f1a2a2b8c..e2e2063399675 100644
--- a/tools/testing/selftests/net/.gitignore
+++ b/tools/testing/selftests/net/.gitignore
@@ -4,7 +4,6 @@ bind_timewait
 bind_wildcard
 busy_poller
 cmsg_sender
-diag_uid
 epoll_busy_poll
 fin_ack_lat
 gro
@@ -18,7 +17,6 @@ ipv6_flowlabel
 ipv6_flowlabel_mgr
 ipv6_fragmentation
 log.txt
-msg_oob
 msg_zerocopy
 netlink-dumps
 nettest
@@ -35,9 +33,6 @@ reuseport_bpf_numa
 reuseport_dualstack
 rxtimestamp
 sctp_hello
-scm_inq
-scm_pidfd
-scm_rights
 sk_bind_sendto_listen
 sk_connect_zero_addr
 sk_so_peek_off
@@ -45,7 +40,6 @@ skf_net_off
 socket
 so_incoming_cpu
 so_netns_cookie
-so_peek_off
 so_txtime
 so_rcv_listener
 stress_reuseport_listen
@@ -65,5 +59,3 @@ txtimestamp
 udpgso
 udpgso_bench_rx
 udpgso_bench_tx
-unix_connect
-unix_connreset
diff --git a/tools/testing/selftests/net/af_unix/.gitignore b/tools/testing/selftests/net/af_unix/.gitignore
new file mode 100644
index 0000000000000..240b26740c9e0
--- /dev/null
+++ b/tools/testing/selftests/net/af_unix/.gitignore
@@ -0,0 +1,8 @@
+diag_uid
+msg_oob
+scm_inq
+scm_pidfd
+scm_rights
+so_peek_off
+unix_connect
+unix_connreset
-- 
2.53.0



