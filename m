Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B9C366DA5;
	Tue, 21 Jul 2026 15:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649256; cv=none; b=tOpZAowfATW5Wl+fBTvrvqKGmO1xrP9Jlw1Nenfv9Nf6EYMUMqx8jvryrmeq4QYpHArwdCYHMfdnxvPLB1ROCJc9r1XD4BtBpCICQmzm01tBfgUEjVdhcm4ILooMbciQct6fTXs+en/bamLzUjmXxJIuP/u2assdwN6vaFmQGtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649256; c=relaxed/simple;
	bh=YNpHwd5UoVlPPFr74IunjwHc8SxisozDlRasPblNRT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HP4KmA4xE1F5dkUEkWIpb189mHaz5nlthuK/DBveKz9EHZFR5KzJH2EFFNScBfqD81gh9FrMTwxK/o7tk6sygdTJnmz2i4KxW8ye+V6dTkxwFxDcZ7ZWQIUeMZgW0rIHd3q0G5jNYUEq4zRCklaiasZG5q0SNLxsULz9dhi58Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ZhtVKIF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ZhtVKIF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB241F000E9;
	Tue, 21 Jul 2026 15:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649255;
	bh=ah/6138DT2zEM4XnHc5YikVSuXmx2dwe65LFE2gJs+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1ZhtVKIFAEiZMOvIBb+xB9NEYWvjerxGKuB4zCQ8/SaeYUJy/lVje4+QG1tdrvmOD
	 BOYACau8sdQNWScb30CnaNa6E83i5YRfzOMQWaqTTUXareWEfowmKLfdemWhnL3c7w
	 jnpHOgihyagTPAnxTmxxXkRKXml30csdAoMBNavc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0510/2077] selftests/bpf: Fix flaky file_reader test
Date: Tue, 21 Jul 2026 17:03:03 +0200
Message-ID: <20260721152604.843632954@linuxfoundation.org>
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

From: Mykyta Yatsenko <yatsenko@meta.com>

[ Upstream commit aa22d619ba22177f430693cf5e9495052d996644 ]

file_reader/on_open_expect_fault test expects page fault
when reading pages from the test harness executable.
It is not guaranteed that those are paged out, even
after madvise(MADV_PAGEOUT).
Relax the condition in the test to succeed with both
0 and -EFAULT returned.

Fixes: 784cdf931543 ("selftests/bpf: add file dynptr tests")
Reported-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Closes: https://lore.kernel.org/all/ah6g7JSYOWGp2oAG@u94a/
Signed-off-by: Mykyta Yatsenko <yatsenko@meta.com>
Tested-by: Ihor Solodrai <ihor.solodrai@linux.dev>
Link: https://lore.kernel.org/r/20260603-file_reader_flake-v1-1-7f3f52d1e388@meta.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/file_reader.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/progs/file_reader.c b/tools/testing/selftests/bpf/progs/file_reader.c
index 462712ff3b8a0b..aa2c05cce2b302 100644
--- a/tools/testing/selftests/bpf/progs/file_reader.c
+++ b/tools/testing/selftests/bpf/progs/file_reader.c
@@ -50,7 +50,7 @@ int on_open_expect_fault(void *c)
 		goto out;
 
 	local_err = bpf_dynptr_read(tmp_buf, user_buf_sz, &dynptr, user_buf_sz, 0);
-	if (local_err == -EFAULT) { /* Expect page fault */
+	if (local_err == -EFAULT || local_err == 0) { /* Expect page fault or success */
 		local_err = 0;
 		run_success = 1;
 	}
-- 
2.53.0



