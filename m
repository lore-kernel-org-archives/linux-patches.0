Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027058;
	b=eFvGeodtF9vuxa5iofmWDfPpHZrQTx2AoCa/ZfZIFkITHPTV6vWgt7rcoNsNfwrLSwUP
	 Sak8pmlJIbM1TxK6Lp+mlyQGBheQLtsQyeta8OtkEF70d9qxLyOxUYAWqp0E64RjrxRO7
	 W/jtor8x54wT2uYy0XBJN7xfWmMLnYI+s2yv744qc8qU96wPyHF+ZusPfnBdvlZp1m0Ur
	 27KQPz/SvX5zH+YumJTDGmDTV1iD5GpCTxPyWKjK/SHeAeL6y2zLdRkOpXmGu8hPyoQQc
	 8y73JFwnZM7f83AMjYeK8f5WT9f81EjUzgFOpbjlzWc3W6+fSXwjCbD8rq21+sfvSqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027058;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LZ1AOD8YVKITQByHXMYiLknK8ARf6IHGSuj7ixVDgg4=;
	b=OepDnYOL0ciTTdhw/zwwFB01E6+hGxO1+GMzO4v5ywIEWTjSFNznZ5J1sWSkm8SNT5vk
	 kimlwDNjPgcOZi4rqNvBlb5Fr9EsfVwbk8gINJHJQ/puApFSh7zknbOq5Ye3IHgAa+zHg
	 3AfQqy515lCBnFrtuDcPlFpYxu/Vh3u/XLkcmzegHZaUOYn+m/iSPCKzd6mcHzHUvcHDh
	 /hyOlBRqkXkhBF1isixJ5CLK3nRe2Ekf9LLeXPCDeqT8FyOsFsvcpjRcdXhCvx5biojoD
	 a8SLCGjkCN/R2e51RMm+c1nRRZc0YPatrZBHWXeggb3quwojiEpGTJ+kRYvb+IgoNDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IjjDIdJD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9364606A330;
	Wed, 18 Nov 2026 18:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IjjDIdJD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E78491F000C4;
	Wed, 18 Nov 2026 18:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027058;
	bh=LZ1AOD8YVKITQByHXMYiLknK8ARf6IHGSuj7ixVDgg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IjjDIdJDh/C+T+jvKVplgBcNwf6TTBfhsKqljpdfVU45KwegwY2c7pcW+kf/nx/Ql
	 puhAC+bgiXyeXzrDmIon1KzxknpWRLRiZsLQd7EmmRZZ81b1qB5Uw5tqudB1Q4EidE
	 TS1YR0JLKl8RXO/KsAZwVjszNXEJDXQyg3a6WirA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	KaFai Wan <kafai.wan@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1656/2151] selftests/bpf: Skip expected_msgs subtests when stdout is not saved
Date: Wed, 18 Nov 2026 15:56:31 +0100
Message-ID: <20261118150222.167532724@linuxfoundation.org>
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



