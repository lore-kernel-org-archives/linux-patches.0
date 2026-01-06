Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBFE2355043;
	Tue,  6 Jan 2026 17:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720344; cv=none; b=eklexGKAe254tugTimm+qdbkwV8exWLDh34DteSC0BjLDjctd2CJToJeTnYrp24rRfl6PWN3hMLYPd2xBbTNlGnxF+rKTv+0jNdpXQnO9zwqsGvXUEE4MWie2rEUHeikkpEs0qpyVlvxmQMBZUuibktcieFqNyWoVd/bwuQctBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720344; c=relaxed/simple;
	bh=64u+BPaoLYLPFTt04NNlwkgGBY+zyCEGB7wxRq2jHWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pCejHBNT5kHY2Ktu1dmo3u0RGdfzl2zjhvHS5iuD+qAx7I0tcCbvETVMC7V1q1o595wLyqwjIO8od9mb+qBxpC7Ry2BzZBIXsPgXdo891NWbJUnCb3hTRVHMiYX+0zwNImoWD6pVGYNs1MfylNyI6q7db/HHG9ocdEsAi8XA+To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=inhHJm+h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="inhHJm+h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AA79C116C6;
	Tue,  6 Jan 2026 17:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720344;
	bh=64u+BPaoLYLPFTt04NNlwkgGBY+zyCEGB7wxRq2jHWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=inhHJm+hzQOlfpRfl+HZdx5epMBsekN8sv/qQmUSRumX0EgXhWJ3QZgWrOVwlRJ52
	 PAE6I/YPU2QrhQ+/dulU59fAUcymlk2GRFV/c/+MfrO+7eNQnj/MhCjQt08KBiVZTB
	 oPh9Hh+o2muu0vkW9Hvxt9zva+MMfUgLUSZJJRb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 175/567] selftests: mptcp: pm: ensure unknown flags are ignored
Date: Tue,  6 Jan 2026 17:59:17 +0100
Message-ID: <20260106170457.799707189@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/pm_netlink.sh |    4 ++++
 tools/testing/selftests/net/mptcp/pm_nl_ctl.c   |   11 +++++++++++
 2 files changed, 15 insertions(+)

--- a/tools/testing/selftests/net/mptcp/pm_netlink.sh
+++ b/tools/testing/selftests/net/mptcp/pm_netlink.sh
@@ -191,6 +191,10 @@ check "show_endpoints" \
 flush_endpoint
 check "show_endpoints" "" "flush addrs"
 
+add_endpoint 10.0.1.1 flags unknown
+check "show_endpoints" "$(format_endpoints "1,10.0.1.1")" "ignore unknown flags"
+flush_endpoint
+
 set_limits 9 1 2>/dev/null
 check "get_limits" "${default_limits}" "rcv addrs above hard limit"
 
--- a/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
+++ b/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
@@ -23,6 +23,8 @@
 #define IPPROTO_MPTCP 262
 #endif
 
+#define MPTCP_PM_ADDR_FLAG_UNKNOWN _BITUL(7)
+
 static void syntax(char *argv[])
 {
 	fprintf(stderr, "%s add|ann|rem|csf|dsf|get|set|del|flush|dump|events|listen|accept [<args>]\n", argv[0]);
@@ -827,6 +829,8 @@ int add_addr(int fd, int pm_family, int
 					flags |= MPTCP_PM_ADDR_FLAG_BACKUP;
 				else if (!strcmp(tok, "fullmesh"))
 					flags |= MPTCP_PM_ADDR_FLAG_FULLMESH;
+				else if (!strcmp(tok, "unknown"))
+					flags |= MPTCP_PM_ADDR_FLAG_UNKNOWN;
 				else
 					error(1, errno,
 					      "unknown flag %s", argv[arg]);
@@ -1031,6 +1035,13 @@ static void print_addr(struct rtattr *at
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


