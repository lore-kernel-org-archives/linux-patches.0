Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251FB2D5412;
	Wed,  3 Dec 2025 16:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778576; cv=none; b=mFVRV0Ea60XHMInSSpfaGhrGkcqwMm7ppMq7pKXJnl/4NFwuptf/Kks6jejjPcqto8aTALQpMzD9qfwX4QqNuRaIbM+11nqiN0LOqWl7/zv+GpS8+Z/uvxnCO5d3JnSN2pCi/qab12HIHmK0FencFVS6PZJ6v57WaqJ0LHD5vGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778576; c=relaxed/simple;
	bh=mGgOYhMghHS5rZ0mOemEhn01g/4qdgTuGNoMsDvdnik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F6qKFgeUTKbnUJdt3jRXKAxdyn03dK2L7L7XiySaPAf/G1UZZtqRnjnrX/hkm89FYknwbEj0HdyIBspv6o9137xX348folijmiXuB5TKxqww6ZFoHLtNdKxf8sVFG1xVGeVeSf4TbdT6qig0EazKhDi21OLXhs0qJ9oYqMWYrNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EjR6HeVo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EjR6HeVo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F2FC4CEF5;
	Wed,  3 Dec 2025 16:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778576;
	bh=mGgOYhMghHS5rZ0mOemEhn01g/4qdgTuGNoMsDvdnik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EjR6HeVoKQMLnVIhTnhWuCL+vyvl0Tb7adDRzJMM05rkUJEVXj25UUpZcBZy1kXNQ
	 xnnfaEzYPaUgMBziR9b34YcN6Te/HkLXav0UyPsXJpg+Ifmey8oJmIRdKLvytBloEH
	 zHcyb48jQLeCEXxU7NB8dyNkVR2sjM8w3CZFukk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 380/392] selftests: mptcp: join: rm: set backup flag
Date: Wed,  3 Dec 2025 16:28:50 +0100
Message-ID: <20251203152428.167193996@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

commit aea73bae662a0e184393d6d7d0feb18d2577b9b9 upstream.

Some of these 'remove' tests rarely fail because a subflow has been
reset instead of cleanly removed. This can happen when one extra subflow
which has never carried data is being closed (FIN) on one side, while
the other is sending data for the first time.

To avoid such subflows to be used right at the end, the backup flag has
been added. With that, data will be only carried on the initial subflow.

Fixes: d2c4333a801c ("selftests: mptcp: add testcases for removing addrs")
Cc: stable@vger.kernel.org
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20251110-net-mptcp-sft-join-unstable-v1-2-a4332c714e10@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ The subtests structure has changed quite a bit in newer versions, see
  commit c7d49c033de0 ("selftests: mptcp: join: alt. to exec specific
  tests") and commit ae7bd9ccecc3 ("selftests: mptcp: join: option to
  execute specific tests") for example.
  To resolve the conflicts, the same principle has been applied: adding
  ',backup' for each non-ID0 endpoint in remove_tests. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |   54 ++++++++++++------------
 1 file changed, 27 insertions(+), 27 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -1269,7 +1269,7 @@ remove_tests()
 	reset
 	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
 	ip netns exec $ns2 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow,backup
 	run_tests $ns1 $ns2 10.0.1.1 0 0 -1 slow
 	chk_join_nr "remove single subflow" 1 1 1
 	chk_rm_nr 1 1
@@ -1278,8 +1278,8 @@ remove_tests()
 	reset
 	ip netns exec $ns1 ./pm_nl_ctl limits 0 2
 	ip netns exec $ns2 ./pm_nl_ctl limits 0 2
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.2.2 flags subflow
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.2.2 flags subflow,backup
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow,backup
 	run_tests $ns1 $ns2 10.0.1.1 0 0 -2 slow
 	chk_join_nr "remove multiple subflows" 2 2 2
 	chk_rm_nr 2 2
@@ -1287,7 +1287,7 @@ remove_tests()
 	# single address, remove
 	reset
 	ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal,backup
 	ip netns exec $ns2 ./pm_nl_ctl limits 1 1
 	run_tests $ns1 $ns2 10.0.1.1 0 -1 0 slow
 	chk_join_nr "remove single address" 1 1 1
@@ -1297,9 +1297,9 @@ remove_tests()
 	# subflow and signal, remove
 	reset
 	ip netns exec $ns1 ./pm_nl_ctl limits 0 2
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal,backup
 	ip netns exec $ns2 ./pm_nl_ctl limits 1 2
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow,backup
 	run_tests $ns1 $ns2 10.0.1.1 0 -1 -1 slow
 	chk_join_nr "remove subflow and signal" 2 2 2
 	chk_add_nr 1 1
@@ -1308,10 +1308,10 @@ remove_tests()
 	# subflows and signal, remove
 	reset
 	ip netns exec $ns1 ./pm_nl_ctl limits 0 3
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal,backup
 	ip netns exec $ns2 ./pm_nl_ctl limits 1 3
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 flags subflow
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow,backup
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 flags subflow,backup
 	run_tests $ns1 $ns2 10.0.1.1 0 -1 -2 slow
 	chk_join_nr "remove subflows and signal" 3 3 3
 	chk_add_nr 1 1
@@ -1320,9 +1320,9 @@ remove_tests()
 	# addresses remove
 	reset
 	ip netns exec $ns1 ./pm_nl_ctl limits 3 3
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal id 250
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.3.1 flags signal
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.4.1 flags signal
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal,backup id 250
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.3.1 flags signal,backup
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.4.1 flags signal,backup
 	ip netns exec $ns2 ./pm_nl_ctl limits 3 3
 	run_tests $ns1 $ns2 10.0.1.1 0 -3 0 slow
 	chk_join_nr "remove addresses" 3 3 3
@@ -1332,10 +1332,10 @@ remove_tests()
 	# invalid addresses remove
 	reset
 	ip netns exec $ns1 ./pm_nl_ctl limits 3 3
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.12.1 flags signal
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.12.1 flags signal,backup
 	# broadcast IP: no packet for this address will be received on ns1
-	ip netns exec $ns1 ./pm_nl_ctl add 224.0.0.1 flags signal
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.3.1 flags signal
+	ip netns exec $ns1 ./pm_nl_ctl add 224.0.0.1 flags signal,backup
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.3.1 flags signal,backup
 	ip netns exec $ns2 ./pm_nl_ctl limits 2 2
 	run_tests $ns1 $ns2 10.0.1.1 0 -3 0 slow
 	chk_join_nr "remove invalid addresses" 1 1 1
@@ -1345,10 +1345,10 @@ remove_tests()
 	# subflows and signal, flush
 	reset
 	ip netns exec $ns1 ./pm_nl_ctl limits 0 3
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal,backup
 	ip netns exec $ns2 ./pm_nl_ctl limits 1 3
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 flags subflow
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow,backup
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 flags subflow,backup
 	run_tests $ns1 $ns2 10.0.1.1 0 -8 -8 slow
 	chk_join_nr "flush subflows and signal" 3 3 3
 	chk_add_nr 1 1
@@ -1358,9 +1358,9 @@ remove_tests()
 	reset
 	ip netns exec $ns1 ./pm_nl_ctl limits 3 3
 	ip netns exec $ns2 ./pm_nl_ctl limits 3 3
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.2.2 flags subflow id 150
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
-	ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 flags subflow
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.2.2 flags subflow,backup id 150
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow,backup
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 flags subflow,backup
 	run_tests $ns1 $ns2 10.0.1.1 0 -8 -8 slow
 	chk_join_nr "flush subflows" 3 3 3
 	chk_rm_nr 3 3
@@ -1368,9 +1368,9 @@ remove_tests()
 	# addresses flush
 	reset
 	ip netns exec $ns1 ./pm_nl_ctl limits 3 3
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal id 250
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.3.1 flags signal
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.4.1 flags signal
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal,backup id 250
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.3.1 flags signal,backup
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.4.1 flags signal,backup
 	ip netns exec $ns2 ./pm_nl_ctl limits 3 3
 	run_tests $ns1 $ns2 10.0.1.1 0 -8 -8 slow
 	chk_join_nr "flush addresses" 3 3 3
@@ -1380,9 +1380,9 @@ remove_tests()
 	# invalid addresses flush
 	reset
 	ip netns exec $ns1 ./pm_nl_ctl limits 3 3
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.12.1 flags signal
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.3.1 flags signal
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.14.1 flags signal
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.12.1 flags signal,backup
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.3.1 flags signal,backup
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.14.1 flags signal,backup
 	ip netns exec $ns2 ./pm_nl_ctl limits 3 3
 	run_tests $ns1 $ns2 10.0.1.1 0 -8 0 slow
 	chk_join_nr "flush invalid addresses" 1 1 1


