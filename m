Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4611863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:20:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE4AC433D2;
	Wed, 28 Dec 2022 15:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240807;
	bh=ThGqwRIglu+jMzIBYnKKxyVrJDe4gRSj6w7W2IUjUa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GpFtdnzT4H5FJC4tK1ZIlD40nAjnVPRi1IC8x7XONnIMCXVu63PbxvrJn+tiG9ONY
	 IN56EFmnseNbPAeVz2jTPotT7NGK/Mro7hNTm9sm6KovXkgjdYUq0x6zUfHk779Qco
	 oNtW++nUsDyPXEGWMq+5jkHlCirXbNi8fjPTKkC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Kuohai <xukuohai@huawei.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0205/1073] selftest/bpf: Fix error usage of ASSERT_OK in xdp_adjust_tail.c
Date: Wed, 28 Dec 2022 15:29:53 +0100
Message-Id: <20221228144333.586117195@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xu Kuohai <xukuohai@huawei.com>

[ Upstream commit cbc1c998da59687e8bbc4667154a72eead2daf2d ]

xdp_adjust_tail.c calls ASSERT_OK() to check the return value of
bpf_prog_test_load(), but the condition is not correct. Fix it.

Fixes: 791cad025051 ("bpf: selftests: Get rid of CHECK macro in xdp_adjust_tail.c")
Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://lore.kernel.org/bpf/20221011120108.782373-7-xukuohai@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
index 7efee9b047d9..8f2613267be2 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
@@ -18,7 +18,7 @@ static void test_xdp_adjust_tail_shrink(void)
 	);
 
 	err = bpf_prog_test_load(file, BPF_PROG_TYPE_XDP, &obj, &prog_fd);
-	if (ASSERT_OK(err, "test_xdp_adjust_tail_shrink"))
+	if (!ASSERT_OK(err, "test_xdp_adjust_tail_shrink"))
 		return;
 
 	err = bpf_prog_test_run_opts(prog_fd, &topts);
@@ -53,7 +53,7 @@ static void test_xdp_adjust_tail_grow(void)
 	);
 
 	err = bpf_prog_test_load(file, BPF_PROG_TYPE_XDP, &obj, &prog_fd);
-	if (ASSERT_OK(err, "test_xdp_adjust_tail_grow"))
+	if (!ASSERT_OK(err, "test_xdp_adjust_tail_grow"))
 		return;
 
 	err = bpf_prog_test_run_opts(prog_fd, &topts);
@@ -90,7 +90,7 @@ static void test_xdp_adjust_tail_grow2(void)
 	);
 
 	err = bpf_prog_test_load(file, BPF_PROG_TYPE_XDP, &obj, &prog_fd);
-	if (ASSERT_OK(err, "test_xdp_adjust_tail_grow"))
+	if (!ASSERT_OK(err, "test_xdp_adjust_tail_grow"))
 		return;
 
 	/* Test case-64 */
-- 
2.35.1



