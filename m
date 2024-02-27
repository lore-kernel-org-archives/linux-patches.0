Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A45D1419B3;
	Tue, 27 Feb 2024 14:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042435; cv=none; b=TqwRVqMW8GcQHIeRbwCtudrpNmSBHi9nJ0dSXDje3XdLo9J4BiTKGb3CViRPxpJpnfKw9/bEhOy3LW2kDuzK7jHRuy3eEENGC0CmcTiPYQpWvMZFu/ybCgQUM20/KEdgwQvZLhNQXYk3j0AUghfv+C+j+R7vsWVQhbJSlAtK/wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042435; c=relaxed/simple;
	bh=x5+6jh+vVf53uo3fzm/2lISI4qCWlIHHh5nFP7ne0Rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q657SvYtBWcV7OLLmlBxjUDWw5Vc5D10rLpvwt7wOLJHVA3syB9OHTI2bsxD8Eqjg3yaXBJetWxEOYVjfzVPj6aXsXiYrMGqS6Xhm/e5tQG/8PW+RkKJEGn4aWZahH+NhxzEC8j7E4yNBA/v4fxwaUF5Z7rjx2PgCQaBAWmNtj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oH/zLD4O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oH/zLD4O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7A90C433C7;
	Tue, 27 Feb 2024 14:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042435;
	bh=x5+6jh+vVf53uo3fzm/2lISI4qCWlIHHh5nFP7ne0Rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oH/zLD4O9eekOTYN/gqTELrCgVbHjL3GfGQOtJdsCFIpy3jYNbzumbJrq5i8Z+0jm
	 YrLnPCOnR7mncAlviqBQG4qdAP/ghgNfZh7XIH67aFBHbc1B60iqAh0LgvqoSjIcxy
	 ZlpO4gYY4A6Umk0FlGQyeV9FvyZja7BB3aUJh8ds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Geliang Tang <geliang@kernel.org>
Subject: [PATCH 6.6 294/299] selftests: mptcp: join: stop transfer when check is done (part 2)
Date: Tue, 27 Feb 2024 14:26:45 +0100
Message-ID: <20240227131635.129703038@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 04b57c9e096a9479fe0ad31e3956e336fa589cb2 upstream.

Since the "Fixes" commits mentioned below, the newly added "userspace
pm" subtests of mptcp_join selftests are launching the whole transfer in
the background, do the required checks, then wait for the end of
transfer.

There is no need to wait longer, especially because the checks at the
end of the transfer are ignored (which is fine). This saves quite a few
seconds on slow environments.

While at it, use 'mptcp_lib_kill_wait()' helper everywhere, instead of
on a specific one with 'kill_tests_wait()'.

Fixes: b2e2248f365a ("selftests: mptcp: userspace pm create id 0 subflow")
Fixes: e3b47e460b4b ("selftests: mptcp: userspace pm remove initial subflow")
Fixes: b9fb176081fb ("selftests: mptcp: userspace pm send RM_ADDR for ID 0")
Cc: stable@vger.kernel.org
Reviewed-and-tested-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://lore.kernel.org/r/20240131-upstream-net-20240131-mptcp-ci-issues-v1-9-4c1c11e571ff@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -688,13 +688,6 @@ kill_events_pids()
 	mptcp_lib_kill_wait $evts_ns2_pid
 }
 
-kill_tests_wait()
-{
-	#shellcheck disable=SC2046
-	kill -SIGUSR1 $(ip netns pids $ns2) $(ip netns pids $ns1)
-	wait
-}
-
 pm_nl_set_limits()
 {
 	local ns=$1
@@ -3463,7 +3456,8 @@ endpoint_tests()
 		pm_nl_set_limits $ns2 2 2
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
 		speed=slow \
-			run_tests $ns1 $ns2 10.0.1.1 2>/dev/null &
+			run_tests $ns1 $ns2 10.0.1.1 &
+		local tests_pid=$!
 
 		wait_mpj $ns1
 		pm_nl_check_endpoint "creation" \
@@ -3478,7 +3472,7 @@ endpoint_tests()
 		pm_nl_add_endpoint $ns2 10.0.2.2 flags signal
 		pm_nl_check_endpoint "modif is allowed" \
 			$ns2 10.0.2.2 id 1 flags signal
-		kill_tests_wait
+		mptcp_lib_kill_wait $tests_pid
 	fi
 
 	if reset "delete and re-add" &&
@@ -3487,7 +3481,8 @@ endpoint_tests()
 		pm_nl_set_limits $ns2 1 1
 		pm_nl_add_endpoint $ns2 10.0.2.2 id 2 dev ns2eth2 flags subflow
 		test_linkfail=4 speed=20 \
-			run_tests $ns1 $ns2 10.0.1.1 2>/dev/null &
+			run_tests $ns1 $ns2 10.0.1.1 &
+		local tests_pid=$!
 
 		wait_mpj $ns2
 		chk_subflow_nr "before delete" 2
@@ -3502,7 +3497,7 @@ endpoint_tests()
 		wait_mpj $ns2
 		chk_subflow_nr "after re-add" 2
 		chk_mptcp_info subflows 1 subflows 1
-		kill_tests_wait
+		mptcp_lib_kill_wait $tests_pid
 	fi
 }
 


