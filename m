Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020731;
	b=mvRurMLt2882RNWrBV4FTvOyBLXNqtib5AURpUifj1uoJ2yr0ihu2rgtvlmZBBIdv9rP
	 OeMRkMdzhZLJXuXIBz0MgdpEYV/qKWGrisaMDy+g0xbX/C1/v60Qglj5c5Ynig0Pmfprh
	 Vh8mEURJNZ14ip1qXiu7xyGLhG8+d6yxxXRPfK9ewOf03mkiBmNMlCBvCylB5wlEwfcP5
	 bajGr/qjX+cew9AH/L1tEdlHwTrMslMaX/CaVUK5MoYHuiL3ZkhTtZ1WdI6dw08T0kvQv
	 1QqIqmwv6x1TM1FRvwDInMoPxbmvaarkGL3JQvKKtx41HVw8SS3DfkCJoAgjju5CCIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020731;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LbKr94biLp6PzmTCfn2Px14PeJH6cTqu2igk03hqAOs=;
	b=B+wTaJqGQv9mSdeb43YmhPFDtnNyiacVhTQd+YHq3NzzcnE0RYD/ZIIWoxCbU3TyDGUe
	 nxmBjEgWjeSgKJ3ofTuxc8YR7mzqNG7semHWhK4lrhHg8Zp6YCmHijXJf5LJPN+VkOqt1
	 tj2KxuShl5P6tKkogAkxIwVUGh6rYThGukntBixkWpoBDT/GIfAlukFUtOLo+ZvKw5Onh
	 qs8OjT5jdgW7V93xjzMsQKxhYHgx7t2EUZbff1dKP9jqbAiHu1jFkkEhY4WzxZzdrmNbc
	 OOkS/gBFnD9JpSpLxYs6RfDFxeWP5JDMleslIOXfk1igb69diNxeXH+VxQ+NBpV4cgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FJfrzDvS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23FFE60A2604;
	Wed, 18 Nov 2026 16:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FJfrzDvS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B3A61F000C4;
	Wed, 18 Nov 2026 16:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020731;
	bh=LbKr94biLp6PzmTCfn2Px14PeJH6cTqu2igk03hqAOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FJfrzDvSr769X8wuXI4OC8xhRbOd0eBKOHm9s+eHDb1MYo3Q+sQWRIaVR/Zgu1DOT
	 4dg7y6uBNpO74Xlfw4QOks0/TSdqTkqUOgxKFWJCcQ3AEpq0i3fEDlB4Z34cuKyJKR
	 foD71bdRN4AzyVcUn2mkOWhaz2mG5HUbDN1x+UuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	KaFai Wan <kafai.wan@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2016/2651] selftests/bpf: Skip expected_msgs subtests when stdout is not saved
Date: Wed, 18 Nov 2026 15:54:16 +0100
Message-ID: <20261118150358.814422055@linuxfoundation.org>
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

[ Upstream commit cc4b1c161d92992544cc571a2475baa5b072e120 ]

stdio_hijack_init() does not set subtest_state->stdout_saved when
running with -v in non-parallel mode, since output goes straight to
stdout. In that case subtest_state->log_buf is left NULL, so the
expected-messages subtests crash when inspecting it. Skip them when
stdout was not saved.

Fixes: 34c513be3dad ("selftests/bpf: __not_msg() tag for test_loader framework")
Signed-off-by: KaFai Wan <kafai.wan@linux.dev>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261012140202.2754552-3-kafai.wan@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/bpf/prog_tests/prog_tests_framework.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/prog_tests_framework.c b/tools/testing/selftests/bpf/prog_tests/prog_tests_framework.c
index 1dc112e5b9719..274568abc052b 100644
--- a/tools/testing/selftests/bpf/prog_tests/prog_tests_framework.c
+++ b/tools/testing/selftests/bpf/prog_tests/prog_tests_framework.c
@@ -169,6 +169,12 @@ void test_prog_tests_framework_expected_msgs(void)
 
 	for (i = 0; i < ARRAY_SIZE(cases); i++) {
 		if (test__start_subtest(cases[i].name)) {
+			if (!env.subtest_state->stdout_saved) {
+				test__skip();
+				test__end_subtest();
+				continue;
+			}
+
 			error_cnt = env.subtest_state->error_cnt;
 			msgs.patterns = cases[i].pats;
 			msgs.cnt = 0;
-- 
2.53.0



