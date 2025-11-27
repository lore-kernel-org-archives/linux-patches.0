Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E792882BB;
	Thu, 27 Nov 2025 14:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255066; cv=none; b=mR+xs+d+sDVEizfjU21hN43+Ur8EZJ/zFzNIqTZROR1sMatLtuhQFCuM8MlxyC7hXAvYH9WOt7S3yteoeGYUCaAEADwgX2qSOgK924ORWe8G2RpF1zOKiQCY6Sm46d+PAoFfZy5al69P1UhK14EUEkXS19zuOashn1iD8crHWHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255066; c=relaxed/simple;
	bh=OXfJW9QLDQS5MZlymYql1zu66K+CCMWzD0VYeN9dPcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lE7qTykW9woxt7J3KAJTQInj7pD7YGnAtGcMPvhMo7g4G2eEaCurjDVEjxUD76anJTb8X55F/A5dfjhiRFc4GL88eu9WPK5ac06N6ELLxySYYdW47++q3pcytTTYJS9EwcNlYjwNkLrhtdGgMMilwwGFTCSKnVjoLUZy3Huky18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VslVTJ78; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VslVTJ78"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B0B8C4CEF8;
	Thu, 27 Nov 2025 14:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255066;
	bh=OXfJW9QLDQS5MZlymYql1zu66K+CCMWzD0VYeN9dPcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VslVTJ78t2q4w5Oq2d7mTZv5ir+INIglFsT7v5OgEXaCVX1jpvSJWwGYWEoj3ZuVK
	 D24wyrefPkqtFwLUct04jqyQDdO2SyQr8+yWyJdCty0bbmYSjEY9SzG+jhqmh9xO8F
	 nOAPYPMABXX0VbxpSGS3GBkGRRU31qzRCMAjz6aE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 82/86] selftests: mptcp: join: endpoints: longer transfer
Date: Thu, 27 Nov 2025 15:46:38 +0100
Message-ID: <20251127144030.831924823@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144027.800761504@linuxfoundation.org>
References: <20251127144027.800761504@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -3741,7 +3741,7 @@ endpoint_tests()
 		pm_nl_set_limits $ns1 2 2
 		pm_nl_set_limits $ns2 2 2
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
-		speed=slow \
+		test_linkfail=128 speed=slow \
 			run_tests $ns1 $ns2 10.0.1.1 &
 		local tests_pid=$!
 
@@ -3768,7 +3768,7 @@ endpoint_tests()
 		pm_nl_set_limits $ns2 0 3
 		pm_nl_add_endpoint $ns2 10.0.1.2 id 1 dev ns2eth1 flags subflow
 		pm_nl_add_endpoint $ns2 10.0.2.2 id 2 dev ns2eth2 flags subflow
-		test_linkfail=4 speed=5 \
+		test_linkfail=128 speed=5 \
 			run_tests $ns1 $ns2 10.0.1.1 &
 		local tests_pid=$!
 
@@ -3845,7 +3845,7 @@ endpoint_tests()
 		# broadcast IP: no packet for this address will be received on ns1
 		pm_nl_add_endpoint $ns1 224.0.0.1 id 2 flags signal
 		pm_nl_add_endpoint $ns1 10.0.1.1 id 42 flags signal
-		test_linkfail=4 speed=5 \
+		test_linkfail=128 speed=5 \
 			run_tests $ns1 $ns2 10.0.1.1 &
 		local tests_pid=$!
 
@@ -3917,7 +3917,7 @@ endpoint_tests()
 		# broadcast IP: no packet for this address will be received on ns1
 		pm_nl_add_endpoint $ns1 224.0.0.1 id 2 flags signal
 		pm_nl_add_endpoint $ns2 10.0.3.2 id 3 flags subflow
-		test_linkfail=4 speed=20 \
+		test_linkfail=128 speed=20 \
 			run_tests $ns1 $ns2 10.0.1.1 &
 		local tests_pid=$!
 


