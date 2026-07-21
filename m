Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FFB042DFEC;
	Tue, 21 Jul 2026 19:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662265; cv=none; b=nbB7eh6KmYvlxD5ESIqrT8by9N6gI6YztHII5TNQdtyBTbbKL0bo6HwqXBFoI2xteMUBylzX0ivXK3OVaexu/78w3U8nHjiLHnkMkvTCZR+NtCtWf252DFWL2lkmWsH+OiFh2UoR0rhGeAUPRUPBhKLP2FLp4npjTV/6Zj4yPe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662265; c=relaxed/simple;
	bh=oiksjmdxSGpMQyrl8HOredcvc22rbzzzyXUM9vQv9uQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DHu+RuOLWrfb3+aDgC16zpRaQJzkviOk1kawT2v4q2HU565aiT0eMumbo9/5Sqgm9S+gDU2wFtY2KGKVUtXhzVdSFuOzo3uAX7BzMdemZDMFlinQqlrixFRyM8Y+tD2earxbhvgsO6XexoIwouNkRNtRZO5A0F/mxfVwlzbgEyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bETZVBSb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bETZVBSb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02BCA1F000E9;
	Tue, 21 Jul 2026 19:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662264;
	bh=6muS9XVMlzPCjOdxjkxJ/W2b3lQd30Bmq95B/VpuHao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bETZVBSbj0GyYccwIJPXj3myYmwpGxmNz+/VkjA2GPJdyBFFreAdZM884VyTOSvhj
	 QbjEMmoOkShCsqe26TH2W1Mz+XGUOGWCBtPGV4enpz5QhvrMWyLcMGGoUkcE/w3aWs
	 fpoQuoLFzZ4HHwDOC6y/0O1hnacejrInb2Eyy4p8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0380/1276] selftests/bpf: Fix typo in verify_umulti_link_info
Date: Tue, 21 Jul 2026 17:13:43 +0200
Message-ID: <20260721152454.608630062@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e59af2aa660166..d6b50f73bae2bd 100644
--- a/tools/testing/selftests/bpf/prog_tests/fill_link_info.c
+++ b/tools/testing/selftests/bpf/prog_tests/fill_link_info.c
@@ -455,7 +455,7 @@ verify_umulti_link_info(int fd, bool retprobe, __u64 *offsets,
 
 		ASSERT_EQ(info.uprobe_multi.pid, getpid(), "info.uprobe_multi.pid");
 		ASSERT_EQ(info.uprobe_multi.count, 3, "info.uprobe_multi.count");
-		ASSERT_EQ(info.uprobe_multi.flags & BPF_F_KPROBE_MULTI_RETURN,
+		ASSERT_EQ(info.uprobe_multi.flags & BPF_F_UPROBE_MULTI_RETURN,
 			  retprobe, "info.uprobe_multi.flags.retprobe");
 		ASSERT_EQ(info.uprobe_multi.path_size, strlen(path) + 1, "info.uprobe_multi.path_size");
 		ASSERT_STREQ(path_buf, path, "info.uprobe_multi.path");
-- 
2.53.0



