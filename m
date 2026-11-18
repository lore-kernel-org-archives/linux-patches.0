Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041877;
	b=TGqvLVX0q/5BIxEZtxEmhDWZBE5Un4dpuFjzrHH5pyrxz0eQV+DlU2BhwUfJ6fmAIdZH
	 WUoy5oBw9umTV3AenYAGdIXr+slt8EQdkg63Y6JUbbmip4i0ewpo813f8++5DZIqsdRWy
	 LqOfj5W4053PyvbEeJKN3tEp/noveVupGYGCHwxwrHDZ90Vy0i0OudE+oPAzghd9//4r3
	 REqxeb+upOy/53ohhZ1r3jVYA44yBPvquPZKsFtTS1tFGK05BQtXo6JtqdnLWVZG+6AaL
	 hjNXK3A1ghq5AyuqMWV27bNVdcnskqVJjYF2bqj3/amJmuXVlMI9ajM+QL38mPw6c0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041877;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5h+7J9QUfQ2V3xf7LrV+dCnqVWpvWuyf3w6k7fdnoFM=;
	b=JyBsVFUU+5UK31vaBlrhEW7VaD5RhDucpRgPC93AXPShEiKDQmh3dDd1lRqoJbShd1aG
	 n15jB+tkwH+C5mW4qZ4dZnUHUbq5QIpkUKIOUhKIF5oUIv2KuBzPSQw0WVNONgj++zu7V
	 b+p8J/PU/faUZzD4nTVTYFQdHJ0UCPu18aqplPxQw5imRCKjKRg3Y90H4gGtFGeLEbimu
	 8GoZ2qies/xOV4wmjVsOCmp2lrf73mIZFfsiULgsN+sA7Sb+frsKsXZg4C+S7fHZC4sAW
	 kcs/9m/JTf0HrYtseC9hhbWMjTrbkyBe/hZIeb6R+S0MiRzPrSU8mu89egbsJg7F+Tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=srK5i3Pu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83DD0606A31C;
	Wed, 18 Nov 2026 22:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=srK5i3Pu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A28E71F000C4;
	Wed, 18 Nov 2026 22:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041877;
	bh=5h+7J9QUfQ2V3xf7LrV+dCnqVWpvWuyf3w6k7fdnoFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=srK5i3Pu+vB1cgP/y64NJnxjm6Wc2tVmSMgLcyZ0StK6eUUbVnVXpsoksU3hjkpkj
	 Xr9ZOlYquMQqNcw5tMDHN9zTMYq3PnvciZyoJXtlYkFa64rxq7kYCTXWatfmcK5Tis
	 a4S3kr0goompwBTu2/fmEY8DOWYQ0ZFplkGhn0nQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	KaFai Wan <kafai.wan@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2969/3318] selftests/bpf: Fix prog_tests framework subtest count checks
Date: Wed, 18 Nov 2026 15:59:51 +0100
Message-ID: <20261118150449.357201198@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: KaFai Wan <kafai.wan@linux.dev>

[ Upstream commit c87652656a55e5e8cf994364314a75fa95fb2d69 ]

The hardcoded expected skip_cnt/error_cnt in test_prog_tests_framework()
mismatch the real count when the binary is run with -t or -n filters,
since some subtests are not selected. Count the executed subtests and
compare against that value instead.

Fixes: 2324257dbd68 ("selftests/bpf: Refactor prog_tests logging and test execution")
Signed-off-by: KaFai Wan <kafai.wan@linux.dev>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261012140202.2754552-2-kafai.wan@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/prog_tests/prog_tests_framework.c    | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/prog_tests_framework.c b/tools/testing/selftests/bpf/prog_tests/prog_tests_framework.c
index 14f2796076e0c..8616cb4e17478 100644
--- a/tools/testing/selftests/bpf/prog_tests/prog_tests_framework.c
+++ b/tools/testing/selftests/bpf/prog_tests/prog_tests_framework.c
@@ -13,6 +13,7 @@ static void clear_test_state(struct test_state *state)
 void test_prog_tests_framework(void)
 {
 	struct test_state *state = env.test_state;
+	int subtest_cnt;
 
 	/* in all the ASSERT calls below we need to return on the first
 	 * error due to the fact that we are cleaning the test state after
@@ -30,25 +31,30 @@ void test_prog_tests_framework(void)
 		return;
 	clear_test_state(state);
 
+	subtest_cnt = 0;
 	if (test__start_subtest("test_skip_subtest")) {
 		test__skip();
 		test__end_subtest();
+		subtest_cnt++;
 	}
 	if (test__start_subtest("test_skip_subtest")) {
 		test__skip();
 		test__end_subtest();
+		subtest_cnt++;
 	}
-	if (!ASSERT_EQ(state->skip_cnt, 2, "skip_cnt_check"))
+	if (!ASSERT_EQ(state->skip_cnt, subtest_cnt, "skip_cnt_check"))
 		return;
 	if (!ASSERT_EQ(state->subtest_num, 3, "subtest_num_check"))
 		return;
 	clear_test_state(state);
 
+	subtest_cnt = 0;
 	if (test__start_subtest("test_fail_subtest")) {
 		test__fail();
 		test__end_subtest();
+		subtest_cnt++;
 	}
-	if (!ASSERT_EQ(state->error_cnt, 1, "error_cnt_check"))
+	if (!ASSERT_EQ(state->error_cnt, subtest_cnt, "error_cnt_check"))
 		return;
 	if (!ASSERT_EQ(state->subtest_num, 4, "subtest_num_check"))
 		return;
-- 
2.53.0



