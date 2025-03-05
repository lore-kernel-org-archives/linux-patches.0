Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4840D253345;
	Wed,  5 Mar 2025 18:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198833; cv=none; b=PB/EEgHG/AH9xNz90kJ7H+jvrJwq7mbs2F0+0bT4Wmu2BmYYmwjBV97LZZZDLm25zTdGZH4U130UP44PlSQGaRQtuK7ObKfKRQ3o+l4Z2GfK5bubxoi99rwlNrPcVmZKJfztx0ykDxm6cdt5LKCzsuo6KIyiFOE44UNlaLQt/jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198833; c=relaxed/simple;
	bh=ymKfdHHT1eTPavd8y8XXnGpCgJ0GKOyWPX5lQxPhNtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TmYgnIii0GnwgAcNl7ZPc4R+gCedcy55C675Dzv614whKwBPH+W/RHVfooDfHsourl+PTt4g0DhqxdJpnzxaG0MTCZisj8tWaNji9XY1vqXzte8ts3Q65P26GpTs7Kf8xbDHnOmohDFbkBEF9LRH1lzHXCFkWDsPqC6bhG4q30E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lJqmzhEc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lJqmzhEc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6212C4CED1;
	Wed,  5 Mar 2025 18:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198833;
	bh=ymKfdHHT1eTPavd8y8XXnGpCgJ0GKOyWPX5lQxPhNtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lJqmzhEcxLtXSsPx8d3Jq6y1FTxN/P8P39I+tNy6QHEREoGgoxaQP3i9AJP6Zyvf6
	 RNP6RBfGbGfeMYG0zV9eLHVuvBJCh5wzIpiO97/il2xXCn6EP0PZnyI9BvMoWqM5ca
	 dxheJUtxVO5OshVE4EdUwfikGCB1v77bZ6cGc8iI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 6.13 131/157] selftests/landlock: Test that MPTCP actions are not restricted
Date: Wed,  5 Mar 2025 18:49:27 +0100
Message-ID: <20250305174510.567645009@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>

commit 3d4033985ff508ef587ca11f1c8361ba57c7e09f upstream.

Extend protocol fixture with test suits for MPTCP protocol.
Add CONFIG_MPTCP and CONFIG_MPTCP_IPV6 options in config.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Link: https://lore.kernel.org/r/20250205093651.1424339-4-ivanov.mikhail1@huawei-partners.com
Cc: <stable@vger.kernel.org> # 6.7.x
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/landlock/config     |    2 +
 tools/testing/selftests/landlock/net_test.c |   44 ++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+)

--- a/tools/testing/selftests/landlock/config
+++ b/tools/testing/selftests/landlock/config
@@ -3,6 +3,8 @@ CONFIG_CGROUP_SCHED=y
 CONFIG_INET=y
 CONFIG_IPV6=y
 CONFIG_KEYS=y
+CONFIG_MPTCP=y
+CONFIG_MPTCP_IPV6=y
 CONFIG_NET=y
 CONFIG_NET_NS=y
 CONFIG_OVERLAY_FS=y
--- a/tools/testing/selftests/landlock/net_test.c
+++ b/tools/testing/selftests/landlock/net_test.c
@@ -310,6 +310,17 @@ FIXTURE_VARIANT_ADD(protocol, no_sandbox
 };
 
 /* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv4_mptcp) {
+	/* clang-format on */
+	.sandbox = NO_SANDBOX,
+	.prot = {
+		.domain = AF_INET,
+		.type = SOCK_STREAM,
+		.protocol = IPPROTO_MPTCP,
+	},
+};
+
+/* clang-format off */
 FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv4_udp) {
 	/* clang-format on */
 	.sandbox = NO_SANDBOX,
@@ -330,6 +341,17 @@ FIXTURE_VARIANT_ADD(protocol, no_sandbox
 };
 
 /* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_ipv6_mptcp) {
+	/* clang-format on */
+	.sandbox = NO_SANDBOX,
+	.prot = {
+		.domain = AF_INET6,
+		.type = SOCK_STREAM,
+		.protocol = IPPROTO_MPTCP,
+	},
+};
+
+/* clang-format off */
 FIXTURE_VARIANT_ADD(protocol, no_sandbox_with_unix_stream) {
 	/* clang-format on */
 	.sandbox = NO_SANDBOX,
@@ -390,6 +412,17 @@ FIXTURE_VARIANT_ADD(protocol, tcp_sandbo
 };
 
 /* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv4_mptcp) {
+	/* clang-format on */
+	.sandbox = TCP_SANDBOX,
+	.prot = {
+		.domain = AF_INET,
+		.type = SOCK_STREAM,
+		.protocol = IPPROTO_MPTCP,
+	},
+};
+
+/* clang-format off */
 FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_unix_stream) {
 	/* clang-format on */
 	.sandbox = TCP_SANDBOX,
@@ -399,6 +432,17 @@ FIXTURE_VARIANT_ADD(protocol, tcp_sandbo
 	},
 };
 
+/* clang-format off */
+FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_ipv6_mptcp) {
+	/* clang-format on */
+	.sandbox = TCP_SANDBOX,
+	.prot = {
+		.domain = AF_INET6,
+		.type = SOCK_STREAM,
+		.protocol = IPPROTO_MPTCP,
+	},
+};
+
 /* clang-format off */
 FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_unix_datagram) {
 	/* clang-format on */


