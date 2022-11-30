Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C2079C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:45:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78802C433D6;
	Wed, 30 Nov 2022 18:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833943;
	bh=uG6c1lc/og1fvW/1KyWnWBfb2fg1Q1t6nyDYTdGjZoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sjcd0m6DlfHEONxGA1uqnS7Rlf4+2mQMV5I1yivvENyJnxDtVgouNGdRNoOGsW8mA
	 dCMgoHe4WQ77ZhSezI/8SWv9TpWIkBhvPJ8ahplXZU/ZF2hicpylJbjvEtephgyxe6
	 X8SPgDDVgjuqc2a3WtPWr2y/4iwHIGKw60uD3hxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <mathew.j.martineau@linux.intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 071/289] selftests: mptcp: gives slow test-case more time
Date: Wed, 30 Nov 2022 19:20:56 +0100
Message-Id: <20221130180545.747100752@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 22b29557aef3c9d673c887911b504c6d47009de4 ]

On slow or busy VM, some test-cases still fail because the
data transfer completes before the endpoint manipulation
actually took effect.

Address the issue by artificially increasing the runtime for
the relevant test-cases.

Fixes: ef360019db40 ("selftests: mptcp: signal addresses testcases")
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/309
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index ff83ef426df5..e52b79440123 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -2105,7 +2105,7 @@ remove_tests()
 		pm_nl_set_limits $ns2 1 3
 		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 		pm_nl_add_endpoint $ns2 10.0.4.2 flags subflow
-		run_tests $ns1 $ns2 10.0.1.1 0 -1 -2 slow
+		run_tests $ns1 $ns2 10.0.1.1 0 -1 -2 speed_10
 		chk_join_nr 3 3 3
 		chk_add_nr 1 1
 		chk_rm_nr 2 2
@@ -2118,7 +2118,7 @@ remove_tests()
 		pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
 		pm_nl_add_endpoint $ns1 10.0.4.1 flags signal
 		pm_nl_set_limits $ns2 3 3
-		run_tests $ns1 $ns2 10.0.1.1 0 -3 0 slow
+		run_tests $ns1 $ns2 10.0.1.1 0 -3 0 speed_10
 		chk_join_nr 3 3 3
 		chk_add_nr 3 3
 		chk_rm_nr 3 3 invert
@@ -2131,7 +2131,7 @@ remove_tests()
 		pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
 		pm_nl_add_endpoint $ns1 10.0.14.1 flags signal
 		pm_nl_set_limits $ns2 3 3
-		run_tests $ns1 $ns2 10.0.1.1 0 -3 0 slow
+		run_tests $ns1 $ns2 10.0.1.1 0 -3 0 speed_10
 		chk_join_nr 1 1 1
 		chk_add_nr 3 3
 		chk_rm_nr 3 1 invert
-- 
2.35.1



