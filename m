Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB90313546;
	Wed,  3 Dec 2025 16:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780448; cv=none; b=ROKCDMy3DlwjYnRNvCMZclbNy3lWFvhbJcRuDxRxFrGOvn6Ur2N4+U9J0YzW0hco5lLwfpAzsb2BVWeCjL/1sPtCEUXOpbfjPwyvzfmesiIKA0gMd9d+1Ai/WNI2LYAwiGEBV2q37CMaWbtyCTZjSLEcxVAtHsJ8V5ZTOn3WQIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780448; c=relaxed/simple;
	bh=41rZlCvZ1TjE+8aTYVXBe7V2Iu9D6Bo27SI2AirKwYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SFUhELPFDYvsaM31PK7/mJtiv10Sq8F2GqPml8g3JN3tpMHrCRjuFUdEk6Bs/hJoO7q754VSIcKhrA6H36vuTjyaEuEyhyWzStlm0mb6jShbPY+9EvMnofoPvGlycei8EfIjUOH03Rhq/Iqf74v36wOt+iHQRr6w/GXkwT7FNIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G3O/W+qt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G3O/W+qt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39EB5C4CEF5;
	Wed,  3 Dec 2025 16:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780447;
	bh=41rZlCvZ1TjE+8aTYVXBe7V2Iu9D6Bo27SI2AirKwYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G3O/W+qtEsd0HGz7n+L2s1VW+CVT5ORZmDJ+XgR7wT/kxJP4V4PxPubnIHxVMifnq
	 BFUqOjLF4A7RdIrKAVBsgBBRbNByGkivb5GAi7FVpkzHILQZOf/Hc+uNn/1Dv2phRX
	 FzGEpjnjVMcGSzUt92UmU4Dgmmm7yV1j5daVa92M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 558/568] selftests: mptcp: join: endpoints: longer transfer
Date: Wed,  3 Dec 2025 16:29:20 +0100
Message-ID: <20251203152501.148157090@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

[ Upstream commit 6457595db9870298ee30b6d75287b8548e33fe19 ]

In rare cases, when the test environment is very slow, some userspace
tests can fail because some expected events have not been seen.

Because the tests are expecting a long on-going connection, and they are
not waiting for the end of the transfer, it is fine to make the
connection longer. This connection will be killed at the end, after the
verifications, so making it longer doesn't change anything, apart from
avoid it to end before the end of the verifications

To play it safe, all endpoints tests not waiting for the end of the
transfer are now sharing a longer file (128KB) at slow speed.

Fixes: 69c6ce7b6eca ("selftests: mptcp: add implicit endpoint test case")
Cc: stable@vger.kernel.org
Fixes: e274f7154008 ("selftests: mptcp: add subflow limits test-cases")
Fixes: b5e2fb832f48 ("selftests: mptcp: add explicit test case for remove/readd")
Fixes: e06959e9eebd ("selftests: mptcp: join: test for flush/re-add endpoints")
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20251110-net-mptcp-sft-join-unstable-v1-3-a4332c714e10@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ removed curly braces and stderr redirection ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
[ Conflicts in mptcp_join.sh because commit 0c93af1f8907 ("selftests:
  mptcp: drop test_linkfail parameter") is not in this version. It moved
  the 4th parameter to an env var. To fix the conflicts, the new value
  simply needs to be added as the 4th argument instead of an env var. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -3313,7 +3313,7 @@ endpoint_tests()
 		pm_nl_set_limits $ns1 2 2
 		pm_nl_set_limits $ns2 2 2
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
-		run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow 2>/dev/null &
+		run_tests $ns1 $ns2 10.0.1.1 128 0 0 slow 2>/dev/null &
 
 		wait_mpj $ns1
 		pm_nl_check_endpoint 1 "creation" \
@@ -3336,7 +3336,7 @@ endpoint_tests()
 		pm_nl_set_limits $ns2 0 3
 		pm_nl_add_endpoint $ns2 10.0.1.2 id 1 dev ns2eth1 flags subflow
 		pm_nl_add_endpoint $ns2 10.0.2.2 id 2 dev ns2eth2 flags subflow
-		run_tests $ns1 $ns2 10.0.1.1 4 0 0 speed_5 2>/dev/null &
+		run_tests $ns1 $ns2 10.0.1.1 128 0 0 speed_5 2>/dev/null &
 		local tests_pid=$!
 
 		wait_mpj $ns2
@@ -3401,7 +3401,7 @@ endpoint_tests()
 		# broadcast IP: no packet for this address will be received on ns1
 		pm_nl_add_endpoint $ns1 224.0.0.1 id 2 flags signal
 		pm_nl_add_endpoint $ns1 10.0.1.1 id 42 flags signal
-		run_tests $ns1 $ns2 10.0.1.1 4 0 0 speed_5 2>/dev/null &
+		run_tests $ns1 $ns2 10.0.1.1 128 0 0 speed_5 2>/dev/null &
 		local tests_pid=$!
 
 		wait_mpj $ns2
@@ -3464,7 +3464,7 @@ endpoint_tests()
 		# broadcast IP: no packet for this address will be received on ns1
 		pm_nl_add_endpoint $ns1 224.0.0.1 id 2 flags signal
 		pm_nl_add_endpoint $ns2 10.0.3.2 id 3 flags subflow
-		run_tests $ns1 $ns2 10.0.1.1 4 0 0 speed_20 2>/dev/null &
+		run_tests $ns1 $ns2 10.0.1.1 128 0 0 speed_20 2>/dev/null &
 		local tests_pid=$!
 
 		wait_attempt_fail $ns2


