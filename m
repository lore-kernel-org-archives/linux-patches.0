Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE9A1EE02F;
	Tue, 30 Sep 2025 15:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244572; cv=none; b=XscjVdTj9GLsf2tH/npRSclqQEd/NhTwJGfNSAxc9HODkgJHd8Fp5k5ZE/xasmYG8/l2VKqvSSulPgM5PlX8aRaLUMYb9sdeE+LIilgvHIm/q/qi9450uPFYSH/va/3wJAmAeBozlOKWgfmSP2x84xW9pBy3qUcl57zCQWaqHDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244572; c=relaxed/simple;
	bh=C4OKM1C5rHsxADLL5v3RRt48DXmhniIfmZsAotuQO4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t0bjg3+ht33QDiUKi2MTYAiMVsSeju4aZAb4x7C2gOiNJKfwv4Xv0RP0lDLGqtEYN1q03mj1n2Kt7X9xAKyegwkOi9clw3/xZ12nhSpqIozRgzCgOFY1sSPqetBGnyv7qAEBpX+4hFpLodcDkxUgc0GV+eo3pvrtvPfJb+/Cbc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jn64usJX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jn64usJX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C4EDC4CEF0;
	Tue, 30 Sep 2025 15:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244570;
	bh=C4OKM1C5rHsxADLL5v3RRt48DXmhniIfmZsAotuQO4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jn64usJXQgAseAmOenBRsCrrehmS75W6FkCgIcfGFq7Ew3xkEh6wZBGoPmbJwQqSS
	 lBe2yA8bAg89vEHlPqkg1QqNTKWPeX0eIxxJ7DBpSWfUQDz1/JUNRvrlCfSfS3xs8z
	 f5q8+pdUmvhygjVPc6rMZR3r36ezh2TiCv/daKCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	syzbot+a9ed3d9132939852d0df@syzkaller.appspotmail.com,
	Alexei Starovoitov <ast@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 047/143] bpf: Check the helper function is valid in get_helper_proto
Date: Tue, 30 Sep 2025 16:46:11 +0200
Message-ID: <20250930143833.110037491@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <olsajiri@gmail.com>

[ Upstream commit e4414b01c1cd9887bbde92f946c1ba94e40d6d64 ]

kernel test robot reported verifier bug [1] where the helper func
pointer could be NULL due to disabled config option.

As Alexei suggested we could check on that in get_helper_proto
directly. Marking tail_call helper func with BPF_PTR_POISON,
because it is unused by design.

  [1] https://lore.kernel.org/oe-lkp/202507160818.68358831-lkp@intel.com

Reported-by: kernel test robot <oliver.sang@intel.com>
Reported-by: syzbot+a9ed3d9132939852d0df@syzkaller.appspotmail.com
Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Paul Chaignon <paul.chaignon@gmail.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20250814200655.945632-1-jolsa@kernel.org
Closes: https://lore.kernel.org/oe-lkp/202507160818.68358831-lkp@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/core.c     | 5 ++++-
 kernel/bpf/verifier.c | 2 +-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 829f0792d8d83..17e5cf18da1ef 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -3013,7 +3013,10 @@ EXPORT_SYMBOL_GPL(bpf_event_output);
 
 /* Always built-in helper functions. */
 const struct bpf_func_proto bpf_tail_call_proto = {
-	.func		= NULL,
+	/* func is unused for tail_call, we set it to pass the
+	 * get_helper_proto check
+	 */
+	.func		= BPF_PTR_POISON,
 	.gpl_only	= false,
 	.ret_type	= RET_VOID,
 	.arg1_type	= ARG_PTR_TO_CTX,
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 4fd89659750b2..d6782efd25734 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -11206,7 +11206,7 @@ static int get_helper_proto(struct bpf_verifier_env *env, int func_id,
 		return -EINVAL;
 
 	*ptr = env->ops->get_func_proto(func_id, env->prog);
-	return *ptr ? 0 : -EINVAL;
+	return *ptr && (*ptr)->func ? 0 : -EINVAL;
 }
 
 static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
-- 
2.51.0



