Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5E9374178;
	Tue, 17 Feb 2026 20:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771360922; cv=none; b=O6Sj5ccJbexZP+wP8JL5IoKL+c9Dbu1UDESWe+DsRJzl7MVPpQ+X1mZ44tRHMjx4DNdjVzmC7XUyfODB3W0a77o+3mn3XUp9Armn7ejy8yHlXNCepDIVWiHYxTibHDMWeIOF+GKgwBUoc+mrUx9gypmxjFM70YElajPJbYrjI8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771360922; c=relaxed/simple;
	bh=9PyMFJmIe8SFM58rZhCMkTaGM7o+swAQpmGSS9GUytQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BEvnS4LecC9OXu0c+tKH5GVJdQ3Pg93Ys8/4ubElzZxfld5Y0HDTBBUem4UHZ222+a9UMFmu1Hvc0TWxgd5krjEpb5Gbjems+1YsDjPHEDzW4Ji+cNkRQfOnr/egW2D+6+fEH3+BfX6PlV8eGEiAP5K9ESLhkXsiDa3VpgpJm70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oPcWDlPG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oPcWDlPG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94719C4CEF7;
	Tue, 17 Feb 2026 20:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771360922;
	bh=9PyMFJmIe8SFM58rZhCMkTaGM7o+swAQpmGSS9GUytQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oPcWDlPGNBrQV36P2N7iONAw3vEkc5V4+nM9EWRt2Fe9e4v6PMfGTBa5bKvFuteF4
	 F5Cs/bYO+St+Vxfj4fLc6N/qtEIbSrXE3idQrBhh2kN6xq+N51Cxqxd/V/eC4HkPOt
	 JsWkKamVkpGMS0ENYWQYH+s3HCYrNGNW2ZCHpsV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 15/24] selftests: mptcp: pm: ensure unknown flags are ignored
Date: Tue, 17 Feb 2026 21:31:28 +0100
Message-ID: <20260217200001.298835428@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200000.708219618@linuxfoundation.org>
References: <20260217200000.708219618@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
  context which is not related to the modification here.
  In v5.10, endpoints couldn't be re-used directly, so the flag is
  tested before.
  Conflicts in pm_nl_ctl.c, because commit 69c6ce7b6eca ("selftests:
  mptcp: add implicit endpoint test case") and commit 371b90377e60
  ("selftests: mptcp: set and print the fullmesh flag") are not in this
  version, and caused a conflict in the context which is not related to
  the modification here. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/pm_netlink.sh |    2 +-
 tools/testing/selftests/net/mptcp/pm_nl_ctl.c   |   11 +++++++++++
 2 files changed, 12 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/net/mptcp/pm_netlink.sh
+++ b/tools/testing/selftests/net/mptcp/pm_netlink.sh
@@ -80,7 +80,7 @@ if mptcp_lib_expect_all_features; then
 subflows 0" "defaults limits"
 fi
 
-ip netns exec $ns1 ./pm_nl_ctl add 10.0.1.1
+ip netns exec $ns1 ./pm_nl_ctl add 10.0.1.1 flags unknown
 ip netns exec $ns1 ./pm_nl_ctl add 10.0.1.2 flags subflow dev lo
 ip netns exec $ns1 ./pm_nl_ctl add 10.0.1.3 flags signal,backup
 check "ip netns exec $ns1 ./pm_nl_ctl get 1" "id 1 flags  10.0.1.1" "simple add/get addr"
--- a/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
+++ b/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
@@ -22,6 +22,8 @@
 #define MPTCP_PM_NAME		"mptcp_pm"
 #endif
 
+#define MPTCP_PM_ADDR_FLAG_UNKNOWN _BITUL(7)
+
 static void syntax(char *argv[])
 {
 	fprintf(stderr, "%s add|get|del|flush|dump|accept [<args>]\n", argv[0]);
@@ -236,6 +238,8 @@ int add_addr(int fd, int pm_family, int
 					flags |= MPTCP_PM_ADDR_FLAG_SIGNAL;
 				else if (!strcmp(tok, "backup"))
 					flags |= MPTCP_PM_ADDR_FLAG_BACKUP;
+				else if (!strcmp(tok, "unknown"))
+					flags |= MPTCP_PM_ADDR_FLAG_UNKNOWN;
 				else
 					error(1, errno,
 					      "unknown flag %s", argv[arg]);
@@ -372,6 +376,13 @@ static void print_addr(struct rtattr *at
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


