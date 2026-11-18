Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020728;
	b=3oDy591hlD1CeCAZ0xbBgMer+bTnAw/rtTwujKQt+0cVz3aSPDSHVePnOOEz3/hvzPPS
	 btNPi6/EFFn/0Mlvm9EIQl5MSg/f4SAtZbnYW4Anb+ZDi2JZgDcylE6Y4uVok1nfHtehQ
	 dz1DdOEb+LcAgbWKrL03ms4j7RwQMWwmZZc0h2QvZCnXldxPgR5IN88Sa6UbO6P3sUUJy
	 RYznxrb4zneJv9UmXDMR8Y0KH2SJn37TpEfCC2S/pPtRONQOrf6ud3qFn47ZqC9QQ/Q0f
	 /mbpH/kr/iujfdGFwjK4FH4fL6+Gm1kfmTKg+76F97tiism2+QBsVB5UeOuza6w4RMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020728;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9TzY6/FEuOjQPByux21ub2UYCEG5defgrhNxJDPpRew=;
	b=zg0cHvIiOXc9TPigkQTjcl1EmBtULbW9YTF2e85zz5qHV1mSatqK6z6xLCaIs3TrnNiX
	 P7Dn8u52JNeS5GcriVdTeVNN75G3xvUquMO86Fv0pmhoA4kAICq1EZuG1Fo4t5hXMPhWq
	 dyE2uu+QPMny1F1lrql9Wj+3WaiJWvGKod515UoAYqF4/GasEurDracK6f+sUMkyo2sTv
	 gi4eRjPfYXQhGcOiOJ6ApFyiYo1CkyDXqj71E5cUQGh05jqlO+HDfo45VsJQyhw0ryZbj
	 io1bSenOCoHIpLgp19/rZ+wLhDhzMDnjzpydxnYhtKa5i0qGnL1HW1w7fnvwSKHHt1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Ytr/jCfX";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67869606A33A;
	Wed, 18 Nov 2026 16:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ytr/jCfX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE4931F000C5;
	Wed, 18 Nov 2026 16:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020728;
	bh=9TzY6/FEuOjQPByux21ub2UYCEG5defgrhNxJDPpRew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ytr/jCfXupbrWxWPfEBHr94NsJRHbhdCDB5FsYARyvt71p1GFFL+o1iQmTzQNlMGM
	 8T64a5bjnffi/5tkK2TtcFqSB+uz16ApOLjffmN3fzgn8hxM/7uzz+JVktKu9p00Fz
	 N/JBWSkm6NwqCveQ67R/1JtqWF8wDzsDLPMBmQ5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	KaFai Wan <kafai.wan@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2015/2651] selftests/bpf: Fix prog_tests framework subtest count checks
Date: Wed, 18 Nov 2026 15:54:15 +0100
Message-ID: <20261118150358.784237670@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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



