Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA142B9D2;
	Tue, 23 Jan 2024 00:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970713; cv=none; b=WF5xGx/sQhIa2CCZa2JIYhagJzT75GH8mUAWTYuqvCEA8MpQc60wHekInmbZShOh81otb5Y6CGDFxhWgxNvATaslFoc6bqT2wrj2vRB97UjYLAisD2QIbW+Ctrf6ffvzzOjVreYvjX/CAYtdUAaT/OGF2vePho5R63dP/R0S+U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970713; c=relaxed/simple;
	bh=UVeUWIpbDec+uBSA3KkuQg7zLrIq0Qa7sZSP5EDmy+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OKjGvU2oD4u5KSNeZVfcWIaQLeLuUbWTeDDtpqsm67Xb3Z2QMjU8BtsTN8JUhw8Ly0qdjtndgZ4DeGHQb5f/4wlqyHx4YiLL0gCp+NbiCMMbOIP0rRHfRSQBcevHZd/L3v19YbjqF4vZQJN7Q4b7do+lLKuYHs3RifX92JKN5dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=frxg5l0g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="frxg5l0g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07BE3C433F1;
	Tue, 23 Jan 2024 00:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970713;
	bh=UVeUWIpbDec+uBSA3KkuQg7zLrIq0Qa7sZSP5EDmy+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=frxg5l0ggliQieaktLee19/au3dUXZRq5ni84Asnsxxxp0VBc/3vnM/pECI92d791
	 QYQO6tjdKlGP/3iozn1T1dv+vdEDq7j7ZaeFP3KUlDOER/+etIL3N7Vy0oE/j2hqAa
	 nIu7/RXlZDt1R1emOnPFI4rruMNzmIZ4/AW++HYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 097/417] selftests/net: specify the interface when do arping
Date: Mon, 22 Jan 2024 15:54:25 -0800
Message-ID: <20240122235755.052178839@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 7f770d28f2e5abfd442ad689ba1129dd66593529 ]

When do arping, the interface need to be specified. Or we will
get error: Interface "lo" is not ARPable. And the test failed.
]# ./arp_ndisc_untracked_subnets.sh
    TEST: test_arp:  accept_arp=0                                       [ OK ]
    TEST: test_arp:  accept_arp=1                                       [FAIL]
    TEST: test_arp:  accept_arp=2  same_subnet=0                        [ OK ]
    TEST: test_arp:  accept_arp=2  same_subnet=1                        [FAIL]

After fix:
]# ./arp_ndisc_untracked_subnets.sh
    TEST: test_arp:  accept_arp=0                                       [ OK ]
    TEST: test_arp:  accept_arp=1                                       [ OK ]
    TEST: test_arp:  accept_arp=2  same_subnet=0                        [ OK ]
    TEST: test_arp:  accept_arp=2  same_subnet=1                        [ OK ]

Fixes: 0ea7b0a454ca ("selftests: net: arp_ndisc_untracked_subnets: test for arp_accept and accept_untracked_na")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/arp_ndisc_untracked_subnets.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/arp_ndisc_untracked_subnets.sh b/tools/testing/selftests/net/arp_ndisc_untracked_subnets.sh
index c899b446acb6..327427ec10f5 100755
--- a/tools/testing/selftests/net/arp_ndisc_untracked_subnets.sh
+++ b/tools/testing/selftests/net/arp_ndisc_untracked_subnets.sh
@@ -150,7 +150,7 @@ arp_test_gratuitous() {
 	fi
 	# Supply arp_accept option to set up which sets it in sysctl
 	setup ${arp_accept}
-	ip netns exec ${HOST_NS} arping -A -U ${HOST_ADDR} -c1 2>&1 >/dev/null
+	ip netns exec ${HOST_NS} arping -A -I ${HOST_INTF} -U ${HOST_ADDR} -c1 2>&1 >/dev/null
 
 	if verify_arp $1 $2; then
 		printf "    TEST: %-60s  [ OK ]\n" "${test_msg[*]}"
-- 
2.43.0



