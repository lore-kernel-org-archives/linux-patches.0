Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F7A2773E4;
	Tue, 17 Feb 2026 20:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361234; cv=none; b=kwjsdOMzV/s7rZ/7LwaBXp2BQ4WO37jsur1amq8bJ8UYEfeVtxaROr/QqCx06RzvPcSi2yErAg+6NQ/VVaqJVd3gexrlHqoJ66qXniHghHRJULHJRNWWuIlvV0pNNN1fQrqEBBWNYSpCbuLjf6H+TZE0IR4HrrPuVIfED8JgpZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361234; c=relaxed/simple;
	bh=ut2YQMkk6OLJjg6nDnyLVn93uVkgah8tuTb5U+Tz+00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gSaf0l256teV8kJdPUdZI/Y+NO9ip8N0KNxFYsJhPQ+uRmop/a2Hmw8fpohUO3EQ14cvIEf+g2/0fbcld4xPnpvCCerEADAbsRzd/2HHVeHwqlZqL1EWxSopjyK2d5qhG8mMuS3bp5z7O5KYXz/9eJcI0lRWMLV6QXXOQs35o/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NiF1KRN+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NiF1KRN+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21752C4CEF7;
	Tue, 17 Feb 2026 20:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361234;
	bh=ut2YQMkk6OLJjg6nDnyLVn93uVkgah8tuTb5U+Tz+00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NiF1KRN+IoHYskwmh7We5ZTT9L1NkXSj0gDcNiOfe6klUakJcd9xHBrtYViuEFX9v
	 D3jei9FJzLeEV8/0BkM/Onv7NuTYey3M8xdZsyl8saXy0yuwybsm99AFZbNMonZiAJ
	 donqQfF0DIApKoZHMO7lVk6VN2cj0NiiFjovRLE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 41/64] selftests: mptcp: pm: ensure unknown flags are ignored
Date: Tue, 17 Feb 2026 21:31:37 +0100
Message-ID: <20260217200009.044218946@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200007.505931165@linuxfoundation.org>
References: <20260217200007.505931165@linuxfoundation.org>
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

commit 29f4801e9c8dfd12bdcb33b61a6ac479c7162bd7 upstream.

This validates the previous commit: the userspace can set unknown flags
-- the 7th bit is currently unused -- without errors, but only the
supported ones are printed in the endpoints dumps.

The 'Fixes' tag here below is the same as the one from the previous
commit: this patch here is not fixing anything wrong in the selftests,
but it validates the previous fix for an issue introduced by this commit
ID.

Fixes: 01cacb00b35c ("mptcp: add netlink-based PM")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20251205-net-mptcp-misc-fixes-6-19-rc1-v1-2-9e4781a6c1b8@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Conflicts in pm_netlink.sh, because some refactoring have been done
  later on: commit 0d16ed0c2e74 ("selftests: mptcp: add
  {get,format}_endpoint(s) helpers") and commit c99d57d0007a
  ("selftests: mptcp: use pm_nl endpoint ops") are not in this version.
  The same operation can still be done at the same place, without using
  the new helpers.
  Also, commit 1dc88d241f92 ("selftests: mptcp: pm_nl_ctl: always look
  for errors") is not in this version, and create a conflict in the
  context which is not related to the modification here. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/pm_netlink.sh |    4 ++++
 tools/testing/selftests/net/mptcp/pm_nl_ctl.c   |   11 +++++++++++
 2 files changed, 15 insertions(+)

--- a/tools/testing/selftests/net/mptcp/pm_netlink.sh
+++ b/tools/testing/selftests/net/mptcp/pm_netlink.sh
@@ -124,6 +124,10 @@ id 8 flags signal 10.0.1.8" "id limit"
 ip netns exec $ns1 ./pm_nl_ctl flush
 check "ip netns exec $ns1 ./pm_nl_ctl dump" "" "flush addrs"
 
+ip netns exec $ns1 ./pm_nl_ctl add 10.0.1.1 flags unknown
+check "ip netns exec $ns1 ./pm_nl_ctl dump" "id 1 flags  10.0.1.1" "ignore unknown flags"
+ip netns exec $ns1 ./pm_nl_ctl flush
+
 ip netns exec $ns1 ./pm_nl_ctl limits 9 1
 check "ip netns exec $ns1 ./pm_nl_ctl limits" "$default_limits" "rcv addrs above hard limit"
 
--- a/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
+++ b/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
@@ -29,6 +29,8 @@
 #define IPPROTO_MPTCP 262
 #endif
 
+#define MPTCP_PM_ADDR_FLAG_UNKNOWN _BITUL(7)
+
 static void syntax(char *argv[])
 {
 	fprintf(stderr, "%s add|ann|rem|csf|dsf|get|set|del|flush|dump|events|listen|accept [<args>]\n", argv[0]);
@@ -814,6 +816,8 @@ int add_addr(int fd, int pm_family, int
 					flags |= MPTCP_PM_ADDR_FLAG_BACKUP;
 				else if (!strcmp(tok, "fullmesh"))
 					flags |= MPTCP_PM_ADDR_FLAG_FULLMESH;
+				else if (!strcmp(tok, "unknown"))
+					flags |= MPTCP_PM_ADDR_FLAG_UNKNOWN;
 				else
 					error(1, errno,
 					      "unknown flag %s", argv[arg]);
@@ -1018,6 +1022,13 @@ static void print_addr(struct rtattr *at
 				if (flags)
 					printf(",");
 			}
+
+			if (flags & MPTCP_PM_ADDR_FLAG_UNKNOWN) {
+				printf("unknown");
+				flags &= ~MPTCP_PM_ADDR_FLAG_UNKNOWN;
+				if (flags)
+					printf(",");
+			}
 
 			/* bump unknown flags, if any */
 			if (flags)


