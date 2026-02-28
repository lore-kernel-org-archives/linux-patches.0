Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8274133AD85
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302772; cv=none; b=sfpOELel6+L2St76PUYvqKnyleTqhQn8TytT6OJ9yANzqr1rWxyz6tEIHjNHdE8Q1dEL0PQ8O9hUTxDeADOp5m8ly07e+OnoPeiZvFHENhl37KRH3wBvkOfhhN6tkidyQyFtHis6V2iXZZnaLOfjo754mSuYBtmBD56DVZJd3NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302772; c=relaxed/simple;
	bh=jOGnZqMBFZtj5M54n+pHE6VfnZDd8H65XWdd1pvbKKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P+aj/PsAMJr6mK+g15/0nK2SmSQYh+3zUD41OWnD4mGz9ElEF4fgTZhMZ+c255B7LVuW1BbF+cgpipTgM4txWt0pVM/nHaQBCIY81hkaPdTR0u94xkH8TUI0+xiK8uLEnLG6udkSS2qAa8koUu8eeNrSsFiJQMucvErbAD6wpiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ryCvy7zQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ryCvy7zQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1FC3C2BCF7;
	Sat, 28 Feb 2026 18:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302772;
	bh=jOGnZqMBFZtj5M54n+pHE6VfnZDd8H65XWdd1pvbKKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ryCvy7zQCL8z18Ytz42SiTuLd04/DoqrkTkaVn11iX542uqOAeczP1XeMu4t+US9u
	 HvJ9Judci51TwvISdw29cOrc1gxMAiIiW2+DfGDhEl9Bt3KgHi1nJr4UT8oFMQ+3zG
	 tV4zh8b7Sq8Xw8ER34Q3m+NP+MEBgaw4S/KgeEJ+AmV2hRixThjX3xFHt/gzoc2W8c
	 RfQyqIMQizeNKDXbVTLtl03vUTSPxKCgEVlUWCbk8TGKg5wExe1wSDTg3eE8pNJsuy
	 e4XacfJCjO343Vn8xzcE5UN2gVB1wgb0fkQIWhbCcNPGNvHRd1OBT0rPKkHwycB87v
	 MRgovlPKPKcxw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Davide Caratti <dcaratti@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 145/147] selftests: forwarding: tc_actions: cleanup temporary files when test is aborted
Date: Sat, 28 Feb 2026 13:17:33 -0500
Message-ID: <20260228181736.1605592-145-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Davide Caratti <dcaratti@redhat.com>

[ Upstream commit f58531716ced8975a4ade108ef4af35f98722af7 ]

remove temporary files created by 'mirred_egress_to_ingress_tcp' test
in the cleanup() handler. Also, change variable names to avoid clashing
with globals from lib.sh.

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Link: https://lore.kernel.org/r/091649045a017fc00095ecbb75884e5681f7025f.1676368027.git.dcaratti@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 32b70e62034a ("selftests: tc_actions: don't dump 2MB of \0 to stdout")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/net/forwarding/tc_actions.sh       | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/tc_actions.sh b/tools/testing/selftests/net/forwarding/tc_actions.sh
index 1e27031288c81..9c2aca8a4b8de 100755
--- a/tools/testing/selftests/net/forwarding/tc_actions.sh
+++ b/tools/testing/selftests/net/forwarding/tc_actions.sh
@@ -155,10 +155,10 @@ gact_trap_test()
 
 mirred_egress_to_ingress_tcp_test()
 {
-	local tmpfile=$(mktemp) tmpfile1=$(mktemp)
+	mirred_e2i_tf1=$(mktemp) mirred_e2i_tf2=$(mktemp)
 
 	RET=0
-	dd conv=sparse status=none if=/dev/zero bs=1M count=2 of=$tmpfile
+	dd conv=sparse status=none if=/dev/zero bs=1M count=2 of=$mirred_e2i_tf1
 	tc filter add dev $h1 protocol ip pref 100 handle 100 egress flower \
 		$tcflags ip_proto tcp src_ip 192.0.2.1 dst_ip 192.0.2.2 \
 			action ct commit nat src addr 192.0.2.2 pipe \
@@ -174,11 +174,11 @@ mirred_egress_to_ingress_tcp_test()
 		ip_proto icmp \
 			action drop
 
-	ip vrf exec v$h1 nc --recv-only -w10 -l -p 12345 -o $tmpfile1  &
+	ip vrf exec v$h1 nc --recv-only -w10 -l -p 12345 -o $mirred_e2i_tf2  &
 	local rpid=$!
-	ip vrf exec v$h1 nc -w1 --send-only 192.0.2.2 12345 <$tmpfile
+	ip vrf exec v$h1 nc -w1 --send-only 192.0.2.2 12345 <$mirred_e2i_tf1
 	wait -n $rpid
-	cmp -s $tmpfile $tmpfile1
+	cmp -s $mirred_e2i_tf1 $mirred_e2i_tf2
 	check_err $? "server output check failed"
 
 	$MZ $h1 -c 10 -p 64 -a $h1mac -b $h1mac -A 192.0.2.1 -B 192.0.2.1 \
@@ -195,7 +195,7 @@ mirred_egress_to_ingress_tcp_test()
 	tc filter del dev $h1 egress protocol ip pref 101 handle 101 flower
 	tc filter del dev $h1 ingress protocol ip pref 102 handle 102 flower
 
-	rm -f $tmpfile $tmpfile1
+	rm -f $mirred_e2i_tf1 $mirred_e2i_tf2
 	log_test "mirred_egress_to_ingress_tcp ($tcflags)"
 }
 
@@ -224,6 +224,8 @@ setup_prepare()
 
 cleanup()
 {
+	local tf
+
 	pre_cleanup
 
 	switch_destroy
@@ -234,6 +236,8 @@ cleanup()
 
 	ip link set $swp2 address $swp2origmac
 	ip link set $swp1 address $swp1origmac
+
+	for tf in $mirred_e2i_tf1 $mirred_e2i_tf2; do rm -f $tf; done
 }
 
 mirred_egress_redirect_test()
-- 
2.51.0

