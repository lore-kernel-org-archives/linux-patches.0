Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41DAB3A8F4
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NdGuC6u/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D0CC433CB;
	Wed, 15 Nov 2023 19:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077924;
	bh=XDI1cmjpdgTEcNq7SSvn4vEqgiFVjqZc7A5N1YNJwmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NdGuC6u/swPPFVazzLM4oMWK95Yndp1licspOGOeayhoq2D/s55bh+kCg1HxP6LNn
	 CmHp7aF9sYQTy4eo84wGc3K8YBBfCcqWpj7LM0RvispFRnl8OhEHcklLMVkkYcqb8S
	 7pSDhssBcsWsqzh2hdWnpZULrMyRXmDckotzHL+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Baerts <matttbe@kernel.org>,
	Geliang Tang <geliang.tang@suse.com>,
	Mat Martineau <martineau@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 596/603] selftests: mptcp: run userspace pm tests slower
Date: Wed, 15 Nov 2023 14:19:01 -0500
Message-ID: <20231115191652.369812085@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

From: Geliang Tang <geliang.tang@suse.com>

commit f4a75e9d11001481dca005541b6dc861e1472f03 upstream.

Some userspace pm tests failed are reported by CI:

112 userspace pm add & remove address
      syn                                 [ ok ]
      synack                              [ ok ]
      ack                                 [ ok ]
      add                                 [ ok ]
      echo                                [ ok ]
      mptcp_info subflows=1:1             [ ok ]
      subflows_total 2:2                  [ ok ]
      mptcp_info add_addr_signal=1:1      [ ok ]
      rm                                  [ ok ]
      rmsf                                [ ok ]
      Info: invert
      mptcp_info subflows=0:0             [ ok ]
      subflows_total 1:1                  [fail]
                         got subflows 0:0 expected 1:1
Server ns stats
TcpPassiveOpens                 2                  0.0
TcpInSegs                       118                0.0

This patch fixes them by changing 'speed' to 5 to run the tests much more
slowly.

Fixes: 4369c198e599 ("selftests: mptcp: test userspace pm out of transfer")
Cc: stable@vger.kernel.org
Reviewed-by: Matthieu Baerts <matttbe@kernel.org>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <martineau@kernel.org>
Link: https://lore.kernel.org/r/20231025-send-net-next-20231025-v1-1-db8f25f798eb@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -3417,7 +3417,7 @@ userspace_tests()
 	   continue_if mptcp_lib_has_file '/proc/sys/net/mptcp/pm_type'; then
 		set_userspace_pm $ns1
 		pm_nl_set_limits $ns2 1 1
-		speed=10 \
+		speed=5 \
 			run_tests $ns1 $ns2 10.0.1.1 &
 		local tests_pid=$!
 		wait_mpj $ns1
@@ -3438,7 +3438,7 @@ userspace_tests()
 	   continue_if mptcp_lib_has_file '/proc/sys/net/mptcp/pm_type'; then
 		set_userspace_pm $ns2
 		pm_nl_set_limits $ns1 0 1
-		speed=10 \
+		speed=5 \
 			run_tests $ns1 $ns2 10.0.1.1 &
 		local tests_pid=$!
 		wait_mpj $ns2


