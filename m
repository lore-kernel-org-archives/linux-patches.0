Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 704851EB5FD;
	Sat, 12 Sep 2026 07:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197557; cv=none; b=nXHdahO/k26Im+XUMjiBUiFn1ZGTqo308mcgInqtc5Yzq0fxQ3UCrKiNf9MPD/vH3Gb7F1V4oY0OIofu/jYTr5Wu7n/SKBM2QKvmgqaGCwb/KTHLhp9WJUyWaojkJcRiA6m5tgfa/J3SGLyt7PXKkWWH8f8kTwqkNUl7i+/6m2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197557; c=relaxed/simple;
	bh=y5ywHsoecaUrq0MaP15l9U+WauMDz85C/a1eVYaueE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OkC6KmYbzB17yK2AnCaF1RXvQ/xTWSUbrAlGxyCkemBxgwhlhwm0iP6hIvKIjG+vgrS+9x39QLbE/9DtBAdCz4XrIQovLbdYWxNdhb1Ka5qapj2iEy9aXEDz5JN9xRvigQIyoWmyQeJkSmfW+fmBdYumrWq5zjW+2YebYxddPwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=asbklWUB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="asbklWUB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1011B1F000FF;
	Sat, 12 Sep 2026 07:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197556;
	bh=EK7w9O/+Y3B0iscx8aFfQmUgtD0ui8BnCddaO4HRvZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=asbklWUBbUun7K/HllUAnqIJhTbyPba0AgsIZTw9tQiVCHCjM5D0cGabJciVGuGyY
	 UkySeM8HNsiMi7XjmtLdKXtNlYMQAykaz0taHL4kBdtjBw3qg91vfQblxljgo2Gw+U
	 hE3nGM7TnbdAnUBgkvim5YMbVOqqsJyha+6scJcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0182/1815] libbpf: Detect uprobe syscall with new error
Date: Sat, 12 Sep 2026 08:32:12 +0200
Message-ID: <20260912065653.277691750@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 8cae54c586084c81ab80f6ab020192eb2ce7aa0b ]

In the previous optimized uprobe fix we changed the syscall
error used for its detection from ENXIO to EPROTO.

Changing related probe_uprobe_syscall detection check.

Fixes: 05738da0efa1 ("libbpf: Add uprobe syscall feature detection")
Fixes: 554ba38456da ("uprobes/x86: Move optimized uprobe from nop5 to nop10")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://patch.msgid.link/20260703114917.238144-8-jolsa@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/features.c                                | 4 ++--
 tools/testing/selftests/bpf/prog_tests/uprobe_syscall.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/features.c b/tools/lib/bpf/features.c
index b7e388f99d0bb..e5641fa601637 100644
--- a/tools/lib/bpf/features.c
+++ b/tools/lib/bpf/features.c
@@ -577,10 +577,10 @@ static int probe_ldimm64_full_range_off(int token_fd)
 static int probe_uprobe_syscall(int token_fd)
 {
 	/*
-	 * If kernel supports uprobe() syscall, it will return -ENXIO when called
+	 * If kernel supports uprobe() syscall, it will return -EPROTO when called
 	 * from the outside of a kernel-generated uprobe trampoline.
 	 */
-	return syscall(__NR_uprobe) < 0 && errno == ENXIO;
+	return syscall(__NR_uprobe) < 0 && errno == EPROTO;
 }
 #else
 static int probe_uprobe_syscall(int token_fd)
diff --git a/tools/testing/selftests/bpf/prog_tests/uprobe_syscall.c b/tools/testing/selftests/bpf/prog_tests/uprobe_syscall.c
index 955a37751b52d..c944136252c6d 100644
--- a/tools/testing/selftests/bpf/prog_tests/uprobe_syscall.c
+++ b/tools/testing/selftests/bpf/prog_tests/uprobe_syscall.c
@@ -762,7 +762,7 @@ static void test_uprobe_error(void)
 	long err = syscall(__NR_uprobe);
 
 	ASSERT_EQ(err, -1, "error");
-	ASSERT_EQ(errno, ENXIO, "errno");
+	ASSERT_EQ(errno, EPROTO, "errno");
 }
 
 static void __test_uprobe_syscall(void)
-- 
2.53.0



