Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC732566D3;
	Mon, 23 Mar 2026 15:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278784; cv=none; b=kSPZjA5B/65Xd/B3DR9I83kS51bbRR4ZNo2xfFYbPvbN3l7aeEGwcS7XrtO2yC+Iu3qEWeGMPknVckG7Zx+jzsOc2e/dHQKBp2kdYSqQbDPni8Wk0uFrm2ffLQm72swFBVGPkPb5+K57ITkHpHjzmiMwT1el7256XyBWmSXY2nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278784; c=relaxed/simple;
	bh=UTfAzS5hQ/Rpr7w9FLUjsOGlaKl199O42ueOEFfvsU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rLhfZLgZPyA6WmON7bSReboKJDiAOZKlyoVRRZSyQb1VYXu21aeZi78nFgwxTRSnSYSvRGqooe8CKVNE7I8j6AYFnxobUZiSakEjbFT/ZOXBTtuCEvoD6JsBbAD/StoELlmjARmPTaX3pgIIJ0PnJI+IjZRSFp5FjSzPq2mdxLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2lFwvCYB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2lFwvCYB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 184C0C4CEF7;
	Mon, 23 Mar 2026 15:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278784;
	bh=UTfAzS5hQ/Rpr7w9FLUjsOGlaKl199O42ueOEFfvsU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2lFwvCYBswZN03y6d0zV9ma9zDc0rPChqNcj7EZBeIZM6TiDwv/pRil6k/UpNmHcX
	 tqYx2UxFV7jRy3O7lOEBXKAHoHaiCTJ+LBjNF54ix08I9UixJ0Cj+q8q5VtR2QNjDx
	 i8g1ealYDbQiLsPjMIug//xaoPw174vZB385PJDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gang Yan <yangang@kylinos.cn>,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 376/567] selftests: mptcp: add a check for add_addr_accepted
Date: Mon, 23 Mar 2026 14:44:56 +0100
Message-ID: <20260323134543.138424580@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gang Yan <yangang@kylinos.cn>

[ Upstream commit 0eee0fdf9b7b0baf698f9b426384aa9714d76a51 ]

The previous patch fixed an issue with the 'add_addr_accepted' counter.
This was not spot by the test suite.

Check this counter and 'add_addr_signal' in MPTCP Join 'delete re-add
signal' test. This should help spotting similar regressions later on.
These counters are crucial for ensuring the MPTCP path manager correctly
handles the subflow creation via 'ADD_ADDR'.

Signed-off-by: Gang Yan <yangang@kylinos.cn>
Reviewed-by: Geliang Tang <geliang@kernel.org>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20251118-net-mptcp-misc-fixes-6-18-rc6-v1-11-806d3781c95f@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 560edd99b5f5 ("selftests: mptcp: join: check RM_ADDR not sent over same subflow")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -3934,38 +3934,45 @@ endpoint_tests()
 			$ns1 10.0.2.1 id 1 flags signal
 		chk_subflow_nr "before delete" 2
 		chk_mptcp_info subflows 1 subflows 1
+		chk_mptcp_info add_addr_signal 2 add_addr_accepted 1
 
 		pm_nl_del_endpoint $ns1 1 10.0.2.1
 		pm_nl_del_endpoint $ns1 2 224.0.0.1
 		sleep 0.5
 		chk_subflow_nr "after delete" 1
 		chk_mptcp_info subflows 0 subflows 0
+		chk_mptcp_info add_addr_signal 0 add_addr_accepted 0
 
 		pm_nl_add_endpoint $ns1 10.0.2.1 id 1 flags signal
 		pm_nl_add_endpoint $ns1 10.0.3.1 id 2 flags signal
 		wait_mpj $ns2
 		chk_subflow_nr "after re-add" 3
 		chk_mptcp_info subflows 2 subflows 2
+		chk_mptcp_info add_addr_signal 2 add_addr_accepted 2
 
 		pm_nl_del_endpoint $ns1 42 10.0.1.1
 		sleep 0.5
 		chk_subflow_nr "after delete ID 0" 2
 		chk_mptcp_info subflows 2 subflows 2
+		chk_mptcp_info add_addr_signal 2 add_addr_accepted 2
 
 		pm_nl_add_endpoint $ns1 10.0.1.1 id 99 flags signal
 		wait_mpj $ns2
 		chk_subflow_nr "after re-add ID 0" 3
 		chk_mptcp_info subflows 3 subflows 3
+		chk_mptcp_info add_addr_signal 3 add_addr_accepted 2
 
 		pm_nl_del_endpoint $ns1 99 10.0.1.1
 		sleep 0.5
 		chk_subflow_nr "after re-delete ID 0" 2
 		chk_mptcp_info subflows 2 subflows 2
+		chk_mptcp_info add_addr_signal 2 add_addr_accepted 2
 
 		pm_nl_add_endpoint $ns1 10.0.1.1 id 88 flags signal
 		wait_mpj $ns2
 		chk_subflow_nr "after re-re-add ID 0" 3
 		chk_mptcp_info subflows 3 subflows 3
+		chk_mptcp_info add_addr_signal 3 add_addr_accepted 2
 		mptcp_lib_kill_group_wait $tests_pid
 
 		kill_events_pids


