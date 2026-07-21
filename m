Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED92E3E49CA;
	Tue, 21 Jul 2026 18:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656837; cv=none; b=hbAPWx0UmgFlP2uG8/FiqjPY7lUJLQbCxThgyQRGMubKyPDfH96b/X2DoJ32WgoVMcymLj7P3L4GJ7/BvO1SBPP2HxLmKntB8vbKZnCPTFHVFzSMoeOaTAlv73ixhAmc0HJKqGjf+y2JQaOPaztvjz6wc+BhyGKk9HAOLD/Kqak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656837; c=relaxed/simple;
	bh=hC2oXH0sROBcsD+5H0z87hWegbXyNDTy9lv/BDM+4LY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d/FTrGTC3G6eU68MhX48D6E17ouH00dwt9YcYUTsTl8/5ttFRbgi1uEMVvhDfuUswvYY0vYKym4qUJNwF0K6bny8mZKd5J8KZMFTNXZjLMm7MxX/I+YwafujzcqAw7F/H64DZgRadYhD3zwYnhQtwBAor/M/NHG6/jUMRKvKZsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fTWZ8iYA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fTWZ8iYA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A53D1F00A3A;
	Tue, 21 Jul 2026 18:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656835;
	bh=+ribn7oL7QH4TizcBjDDSOLIh9ojSzHpVDmDp2aSuTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fTWZ8iYAEElF8KmTPKSZeKjBaBwRxkCmL37ZbAOD2Mt1T+YO1BP39YWt40uAHAWlL
	 cCckLv/wyTwWf1aB/huUNiwLqNmuLJyjKzyFO1hY6SOeLV5mh/eroD8G6WcbyJCaPf
	 gjC08dVesVrX72jUffGjhFs0+791q7LyeOZd+o0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0537/1611] selftests/bpf: Fix typo in verify_umulti_link_info
Date: Tue, 21 Jul 2026 17:10:53 +0200
Message-ID: <20260721152527.440852087@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit df29003c55115737a8fb4f8a60c6c2bba4c4a484 ]

We verify info.uprobe_multi.flags against wrong kprobe-multi flag
(BPF_F_KPROBE_MULTI_RETURN). It's the same value as the correct
flag (BPF_F_UPROBE_MULTI_RETURN), so there's not functional change.

Fixes: 147c69307bcf ("selftests/bpf: Add link_info test for uprobe_multi link")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20260611114230.950379-8-jolsa@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/fill_link_info.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/fill_link_info.c b/tools/testing/selftests/bpf/prog_tests/fill_link_info.c
index e401146207510a..f589eefbf9fbd5 100644
--- a/tools/testing/selftests/bpf/prog_tests/fill_link_info.c
+++ b/tools/testing/selftests/bpf/prog_tests/fill_link_info.c
@@ -469,7 +469,7 @@ verify_umulti_link_info(int fd, bool retprobe, __u64 *offsets,
 
 		ASSERT_EQ(info.uprobe_multi.pid, getpid(), "info.uprobe_multi.pid");
 		ASSERT_EQ(info.uprobe_multi.count, 3, "info.uprobe_multi.count");
-		ASSERT_EQ(info.uprobe_multi.flags & BPF_F_KPROBE_MULTI_RETURN,
+		ASSERT_EQ(info.uprobe_multi.flags & BPF_F_UPROBE_MULTI_RETURN,
 			  retprobe, "info.uprobe_multi.flags.retprobe");
 		ASSERT_EQ(info.uprobe_multi.path_size, strlen(path) + 1, "info.uprobe_multi.path_size");
 		ASSERT_STREQ(path_buf, path, "info.uprobe_multi.path");
-- 
2.53.0



