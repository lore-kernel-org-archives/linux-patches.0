Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED1C40803B;
	Tue, 21 Jul 2026 18:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659989; cv=none; b=GgZyU40Fi+7sDlOUrOa99ghKUJ3pcV2DgSWT/TDvOBDURsfwmNu5u7BNb351O6ikqCndFyOJcQG6GFXT8+iAhAjNwo2jX5H4PhsqjdgOJNAqw+xzq4h1YO1jJtJmObf+K+X6ZxQeFLrRO+AqjIhe56NRCQgUQurmjCjP3a8BMV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659989; c=relaxed/simple;
	bh=Cgy0T/yFANZyxribNS/Q0i12seULpV856U57ABragAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kmvTniE1HyV2y8URsBS2DhC1A9KrQwKATTHL0tSt03zt8EILhtyULKvfLFpfTwnjxvTb1viUqeA7g+vNE8QeB8ng1gfB2ym6QROUOry+OthyrYbbeMha/zm1S6n8xMY1VTzz/JfybAkAOU7ByFkMr5RSlc0rKKV2y5ysJf1Pa8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xFuOCjKv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xFuOCjKv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DFCD1F00A3A;
	Tue, 21 Jul 2026 18:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659987;
	bh=5KAtNPk0baTbTQkNJB44En6lWBL0YOgdYLwhwhFhET0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xFuOCjKvsM4l/91Gml2Eht9v5M3WnhpexAj41/jGzG2CnIE1nb+7CGIbECeXh658n
	 fglBZkdP/Z8Wp67Q3BgEtvDqwpKBbsuDrJf8KXtypDcd5mutEhMQjCVOjYswsEX3xF
	 w4lm/BcCzA4R/wVUsV/wiYbUJ8jGOmkk0A8z4DrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0782/2077] selftests/bpf: Initialize operation name before use
Date: Tue, 21 Jul 2026 17:07:35 +0200
Message-ID: <20260721152611.242505780@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit 55ffbe8a15b1254f44d56952fb425a10e3f15c31 ]

ASAN reports stack-buffer-overflow due to the uninitialized op_name.

Initialize it to fix the issue.

Fixes: 054b6c7866c7 ("selftests/bpf: Add verifier log tests for BPF_BTF_LOAD command")
Signed-off-by: Leo Yan <leo.yan@arm.com>
Acked-by: Ihor Solodrai <ihor.solodrai@linux.dev>
Link: https://lore.kernel.org/r/20260602-tools_build_fix_zero_init_bpf_only-v2-6-c76e5250ea1c@arm.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/verifier_log.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/verifier_log.c b/tools/testing/selftests/bpf/prog_tests/verifier_log.c
index c01c0114af1b74..4542bb586d723b 100644
--- a/tools/testing/selftests/bpf/prog_tests/verifier_log.c
+++ b/tools/testing/selftests/bpf/prog_tests/verifier_log.c
@@ -317,6 +317,7 @@ static void verif_btf_log_subtest(bool bad_btf)
 	res = load_btf(&opts, true);
 	ASSERT_EQ(res, -ENOSPC, "half_log_fd");
 	ASSERT_EQ(strlen(logs.buf), 24, "log_fixed_25");
+	strscpy(op_name, "log_fixed", sizeof(op_name));
 	ASSERT_STRNEQ(logs.buf, logs.reference, 24, op_name);
 
 	/* validate rolling verifier log logic: try all variations of log buf
-- 
2.53.0



