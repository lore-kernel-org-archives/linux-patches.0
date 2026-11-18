Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032190;
	b=z6wJ39AL6EL1ybKRcPzH3bUDS3ZPiIGFiQP/b8B/5PsxGtAS9bmFu3d/w8a07Mq8qMVP
	 o1bbA+80eu6cbz1zSXC7qEH67KPK4ISW5rKGN7KNZBGQOSWYcCNxuLAt0UmWHHhu6QtrO
	 Or+oaQAal4VD4/l0iFHAryf6FyOL8l5uddkmwxslUoM2jg4aIyIbljdPRIGo9SJtTciBz
	 biZCHghCeYCyl372trsnyLQoQPW/8PBHkS8jk2Sr341CrsgODQe6RBYTdBESiWn2nlnW9
	 F+r2ZbvLiWt+i0JoOwmW2ERsy9cKoRspvBACC1Djr+hOMHZz3/CeW0LMA4ONmjn0P6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032190;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+5CpJVZA9xdZg/n0tVuuv1eWeQo6StriMmvXdrqYShE=;
	b=XfDejaGUNg9ejzyHuwNb6A9XDPoVuIqq9qCe4QkRn+j7PrbRAIM2v1kC8zxI4ty3iFr7
	 t/BkkjK11jb1apehw+AvNiCMw9AqV53AixfdOZO9Nr3Iv2/QA1Zn2z8v/j3VTo2vW7iQR
	 s0OkOUZtht+T2oH8ifakKkYUwNURA7/YQO+vN7D35MxhDIQBcA9dsHZWhQCXr30QDpSVR
	 dksZc4tPEK6i2y/v+JOhEGQKZkTY2oiiAvVsXljanLuBpOVvQ9O59j8ES2T7DNjqQfcXK
	 94d11Vmz9ccbaFRVD7RoqNtExw4AcvG3o/e4lvkuKMLAkqDxIdlGDAS9FmhRKWHUJEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HOJgaRv8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C97606A31C;
	Wed, 18 Nov 2026 20:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HOJgaRv8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 322A41F000C4;
	Wed, 18 Nov 2026 20:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032190;
	bh=+5CpJVZA9xdZg/n0tVuuv1eWeQo6StriMmvXdrqYShE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HOJgaRv8YVY9zddqxwWLUYYI7R98CDsp4Hlx/UW7TiIwzQ4CGj5qZWj6Dms99Kxd5
	 eUc4KN6SKH1ASFm4joNKWprfmM6Qp69i2IV3S2jSHCTSJSb/rUvE9ttTnURyCHFSkO
	 IJlBR3Yg0lV9J2wl0Zt6EZ2yIlfNAZV3k7euuNyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	KaFai Wan <kafai.wan@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1322/1756] selftests/bpf: Fix prog_tests framework subtest count checks
Date: Wed, 18 Nov 2026 15:57:29 +0100
Message-ID: <20261118150102.057004695@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



