Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D67260585;
	Thu, 27 Nov 2025 15:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255719; cv=none; b=pJUAOJNqJ7qLJuXQO2iON4oFB8gH5pL22LqVVJovKTKXv0NjEK35Th2VkGGcJSHYo939u6zC9Fh+RprPvCL7Lo4pZ/QwwK7HG97NnRiFdT7FWR4WUxOei3myQb5eMkLajwYYBaJmknOIyVqu6mFsITFOr8T3NqU7eUk2d4WZL/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255719; c=relaxed/simple;
	bh=/KshH6ZuAoCLFHePeUV2LRV9+6euJHGygq2Z+VtXtrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KyVQaMfy3ssC+3ZGao6Xci9TW0UzgfSM+pIW8rT79iONRLXe0TDMP3pRUG3fZHgmZ0IGyneToRjvIokbeVFnVNRwpDGIEE1Lwdlir4NpwS5OWENtDQLOdNdUq7mfGLa2EupHZZJTUbV7JajgRmlwdgd2RWvCY//cnNvS7vNB7Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=igsK2cIH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="igsK2cIH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ED45C4CEF8;
	Thu, 27 Nov 2025 15:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255719;
	bh=/KshH6ZuAoCLFHePeUV2LRV9+6euJHGygq2Z+VtXtrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=igsK2cIHHCnYEeA855wBHzSpA27f48dec4t8xNEcszitpi58E2uCnHq/XLQmq25+L
	 lAhnTdElRDROsbiF2aSdFhvIMy2LTQ4JtrEk4F9FYgEs/GZeQZu85r4EXriBwChfOz
	 0yDMVo9d6kC2B4wGJvtymEvoJN1YZgzWN+oodgjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.17 063/175] selftests: mptcp: join: endpoints: longer timeout
Date: Thu, 27 Nov 2025 15:45:16 +0100
Message-ID: <20251127144045.268957448@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit fb13c6bb810ca871964e062cf91882d1c83db509 upstream.

In rare cases, when the test environment is very slow, some endpoints
tests can fail because some expected events have not been seen.

Because the tests are expecting a long on-going connection, and they are
not waiting for the end of the transfer, it is fine to have a longer
timeout, and even go over the default one. This connection will be
killed at the end, after the verifications: increasing the timeout
doesn't change anything, apart from avoiding it to end before the end of
the verifications.

To play it safe, all endpoints tests not waiting for the end of the
transfer are now having a longer timeout: 2 minutes.

The Fixes commit was making the connection longer, but still, the
default timeout would have stopped it after 1 minute, which might not be
enough in very slow environments.

Fixes: 6457595db987 ("selftests: mptcp: join: endpoints: longer transfer")
Cc: stable@vger.kernel.org
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Reviewed-by: Geliang Tang <geliang@kernel.org>
Link: https://patch.msgid.link/20251118-net-mptcp-misc-fixes-6-18-rc6-v1-8-806d3781c95f@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -3757,7 +3757,7 @@ endpoint_tests()
 		pm_nl_set_limits $ns1 2 2
 		pm_nl_set_limits $ns2 2 2
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
-		{ test_linkfail=128 speed=slow \
+		{ timeout_test=120 test_linkfail=128 speed=slow \
 			run_tests $ns1 $ns2 10.0.1.1 & } 2>/dev/null
 		local tests_pid=$!
 
@@ -3784,7 +3784,7 @@ endpoint_tests()
 		pm_nl_set_limits $ns2 0 3
 		pm_nl_add_endpoint $ns2 10.0.1.2 id 1 dev ns2eth1 flags subflow
 		pm_nl_add_endpoint $ns2 10.0.2.2 id 2 dev ns2eth2 flags subflow
-		{ test_linkfail=128 speed=5 \
+		{ timeout_test=120 test_linkfail=128 speed=5 \
 			run_tests $ns1 $ns2 10.0.1.1 & } 2>/dev/null
 		local tests_pid=$!
 
@@ -3862,7 +3862,7 @@ endpoint_tests()
 		# broadcast IP: no packet for this address will be received on ns1
 		pm_nl_add_endpoint $ns1 224.0.0.1 id 2 flags signal
 		pm_nl_add_endpoint $ns1 10.0.1.1 id 42 flags signal
-		{ test_linkfail=128 speed=5 \
+		{ timeout_test=120 test_linkfail=128 speed=5 \
 			run_tests $ns1 $ns2 10.0.1.1 & } 2>/dev/null
 		local tests_pid=$!
 
@@ -3935,7 +3935,7 @@ endpoint_tests()
 		# broadcast IP: no packet for this address will be received on ns1
 		pm_nl_add_endpoint $ns1 224.0.0.1 id 2 flags signal
 		pm_nl_add_endpoint $ns2 10.0.3.2 id 3 flags subflow
-		{ test_linkfail=128 speed=20 \
+		{ timeout_test=120 test_linkfail=128 speed=20 \
 			run_tests $ns1 $ns2 10.0.1.1 & } 2>/dev/null
 		local tests_pid=$!
 


