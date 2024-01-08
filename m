Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8438653E00;
	Mon,  8 Jan 2024 15:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QZm5UtPC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00111C433CD;
	Mon,  8 Jan 2024 15:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728585;
	bh=ok0gyfGjB4PGorKJErDpKAt0evjL6dJIyQSIoAgj4CA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QZm5UtPC8Nvyhpx8QNivtx0CGkWIFqxWo/FA5T5ashqd7NyUH1Wi07X53ZTYIkEGd
	 Y6ZvoVmnXkOIDOlKnFSf58f/MtRfQwpz0acYsB366j7ihNPyJ1876zI8MnFTZfw4hq
	 Vz8wV5dHrNrNWRbJYKtaS/VwQpn/Vm61Of7OZ4Ls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Geliang Tang <geliang.tang@suse.com>,
	Mat Martineau <martineau@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 095/150] selftests: mptcp: set FAILING_LINKS in run_tests
Date: Mon,  8 Jan 2024 16:35:46 +0100
Message-ID: <20240108153515.589384415@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geliang Tang <geliang.tang@suse.com>

[ Upstream commit be7e9786c9155c2942cd53b813e4723be67e07c4 ]

Set FAILING_LINKS as an env var with a limited scope only when calling
run_tests().

Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <martineau@kernel.org>
Link: https://lore.kernel.org/r/20230623-send-net-next-20230623-v1-3-a883213c8ba9@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 7cefbe5e1dac ("selftests: mptcp: fix fastclose with csum failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 9d8dde3b5c332..2107579e2939d 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -2167,9 +2167,9 @@ link_failure_tests()
 		pm_nl_set_limits $ns1 0 2
 		pm_nl_add_endpoint $ns1 10.0.2.1 dev ns1eth2 flags signal
 		pm_nl_set_limits $ns2 1 2
-		FAILING_LINKS="1"
 		pm_nl_add_endpoint $ns2 10.0.3.2 dev ns2eth3 flags subflow,backup
-		run_tests $ns1 $ns2 10.0.1.1 1
+		FAILING_LINKS="1" \
+			run_tests $ns1 $ns2 10.0.1.1 1
 		chk_join_nr 2 2 2
 		chk_add_nr 1 1
 		chk_link_usage $ns2 ns2eth3 $cinsent 0
@@ -2183,8 +2183,8 @@ link_failure_tests()
 		pm_nl_add_endpoint $ns1 10.0.2.1 dev ns1eth2 flags signal
 		pm_nl_set_limits $ns2 1 2
 		pm_nl_add_endpoint $ns2 10.0.3.2 dev ns2eth3 flags subflow,backup
-		FAILING_LINKS="1 2"
-		run_tests $ns1 $ns2 10.0.1.1 1
+		FAILING_LINKS="1 2" \
+			run_tests $ns1 $ns2 10.0.1.1 1
 		chk_join_nr 2 2 2
 		chk_add_nr 1 1
 		chk_stale_nr $ns2 2 4 2
@@ -2199,8 +2199,8 @@ link_failure_tests()
 		pm_nl_add_endpoint $ns1 10.0.2.1 dev ns1eth2 flags signal
 		pm_nl_set_limits $ns2 1 3
 		pm_nl_add_endpoint $ns2 10.0.3.2 dev ns2eth3 flags subflow,backup
-		FAILING_LINKS="1 2"
-		run_tests $ns1 $ns2 10.0.1.1 2
+		FAILING_LINKS="1 2" \
+			run_tests $ns1 $ns2 10.0.1.1 2
 		chk_join_nr 2 2 2
 		chk_add_nr 1 1
 		chk_stale_nr $ns2 1 -1 2
-- 
2.43.0



