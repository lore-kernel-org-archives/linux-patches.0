Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36EAC42DA53;
	Tue, 21 Jul 2026 19:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662268; cv=none; b=gIlJ4uKGufMtQRIch3c1VFMRbhtV9aJhSPB3hOwmRFCgZYMLlBrFiXnB7FAgLSX/mbjsn4u/rkIER9wML0glE1M98I1nnAGwNLz0MIR01Fspfhetisf0CmI0VjAM6b0KGYPPXEik5+gdUiItqfLvc+1zpbNZlMY8yYgxz66HLFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662268; c=relaxed/simple;
	bh=dijFlJ7bV3a1Jt/LuiMqCQbrOXSUQ3y67BPt84kiyEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XFgB+As0kyrL/HJyy2puHtXaDew/v5EHIu57uVwypuyzjdDlFzxDdfASY7Nyh9XFAwFgLN6/tI7NwagQzmIvZ6Hg/sSmki/laOn/kP+EljmNAMC5K/dwC3vq/AY5VV4Fw140Xqyz+AeUBVoC0GhfLOZEFHTImMivRajcE3Jqtzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LiV5kw5Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LiV5kw5Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CFBA1F000E9;
	Tue, 21 Jul 2026 19:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662267;
	bh=fMpxVKP1HVQVg9js1Ox8qyrO9HUQ3/pnSWcHs7IDNQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LiV5kw5Q/c817lLhgv2/Ayuq2/IGm0CsOHAeMGQXCQJYBZGW/lvQvgXj6/HjloX1C
	 u5jzqTwH8z7kTVpGJfj9sw7M87ofbWHLA/Hub5XvkExKMCOLgGNRcAq3qg+L898qE5
	 DJhgVMwCQH+uF0znp74md/95dA7r2oG/B2AcHkPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0381/1276] selftests/bpf: Initialize operation name before use
Date: Tue, 21 Jul 2026 17:13:44 +0200
Message-ID: <20260721152454.631601238@linuxfoundation.org>
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
index 8337c6bc5b95b6..abc473c3741f53 100644
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



