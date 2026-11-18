Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027055;
	b=nHpIXDO6JhpqNw5AX+HQ88ZnRUX1T+0xzWJYz+kjxF6JNF39xmFhM/szwMEiwJKk1bWK
	 M75OSDWidm5YXXfAB+32waG+HYv/bf17A3l1BwLUC0cp+y3nnStwRDQDwTJIdacGsykKA
	 UHMsAK3gIoV+AuYyUZ8r5BJGefybPfqfJx0UgVzp1x1kyFcvZMBSuRpSmEx5yf06oP5cR
	 WKw9i08KvPxrNJ/dSs6J3CDPsw6wJp5ghvNlowQMAFfiMyYJCN+TM8bxA4iWDtqZMKoGZ
	 JzbeN2q7GIiI39kQ0rD7t648VryLZ2gnxhmKAP+D5k33KTn1pAxnXn+RnQiUM4a9gxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027055;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YXnk2x07Gzm8r3esSRO8k1Xrk34KRMODh1iCh9Irtds=;
	b=4Swb3T5+2qrBWmIWRn/gQrNr3DANCLIPrXgdbsqhgt0O4E0Ylb4pvnFVEP5FmJCd6+K8
	 vr+7gip+WTvP+Zm6pnJKCH5AJSdqYws61ll5wA0bN7Ap8juI1ZYs6zAj5gn3cFRYGYFxx
	 iG+4kwVF3MxwgqNBVntTs7pjU8JyssWMVNwK8KklD33ICXVOUINzPPEp9KJHAHEHvi481
	 NMUa8gAjgjPsOOO+Qmr5dCNzhZ29zamdIKzW9sdBwf/LuLKbC6Z+QtYwN2rjTzGNOzr8f
	 0KpeiNmSnjg14oz94G3tLuMljdqpsTfI5g7pRLz1YyJPl8bxE5Ssq9uYOdySeXQ+1Hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gOgxxjRD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA91606A330;
	Wed, 18 Nov 2026 18:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gOgxxjRD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 225F01F000C4;
	Wed, 18 Nov 2026 18:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027055;
	bh=YXnk2x07Gzm8r3esSRO8k1Xrk34KRMODh1iCh9Irtds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gOgxxjRDgyyKEAI1m3KzvDq9PUHxbtg58liotAdFe3s5UYVsT1Gafl4cDsRIIEUlx
	 muKo36trEmSXSdJ/oKfjlWneZ+edSLpIVtT5UMXhQijmdZjiLZslhRfVTZxMOmVmmG
	 97Zgy2SBAWWqNotYnj6Tx5YdaXozp44r90V7LzxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	KaFai Wan <kafai.wan@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1655/2151] selftests/bpf: Fix prog_tests framework subtest count checks
Date: Wed, 18 Nov 2026 15:56:30 +0100
Message-ID: <20261118150222.131345058@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 7607cfc2408c2..1dc112e5b9719 100644
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



