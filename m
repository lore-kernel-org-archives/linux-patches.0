Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31EAC1EB5FD;
	Sat, 12 Sep 2026 07:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197755; cv=none; b=IV0jqWQT8N4FNM9+MyeClkj/cd5trY/kQ+ZKbYOIMHedn1hRvM1wqSi7LBiuBWfsf7GR5qhnX37HQJW6S8wsGz0k6MR/29ULrJtyyRiXRUA4hWSCqcmts/6cBAWLswmX+dEQmlYRmAnH1VgqNsQ9mU8D1zamkonHzzXB+QXgmz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197755; c=relaxed/simple;
	bh=NCdR2RL42J75Cj8nMoXfIP5/5os10yEpnx3Go35Ie24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jxqS+YomAxz6B12k3wBOM70hshgdArEfuL0zauzIahsyd/j+0fk9KrHykt+M6KiR9XuD6po+dqWJ3oJ1HFkd2ogCqSkOuMWTQYyY47SxSNCDHLX6QsDQvfzh6i9AVvVN5AshTz/9lc77z/ARKibDExavbEiRzgSvB7W7adbkCZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DaghqtZO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DaghqtZO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 014531F000FF;
	Sat, 12 Sep 2026 07:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197754;
	bh=A3gOrA4yILMJwIN0V9Xsdx/M3BqxR6gVtN2j6R6NZDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DaghqtZOSgEVGsDXuTdh3T6rs8yRqGjC0F0wCQCloJ9eASjUC5FEtQHEWjrlqx6V0
	 Npia74v/zX5olZefmGQ9mZLAwuF7TkJ4IP+7WVZlvQGym0DHP1QbAqaTp64pCIxuCg
	 W2f+dIiBuoEjiwZ/8aY4HtnW/O0+YbQ1pcmkYGiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Khmelevskii <max@linux.ibm.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0241/1815] s390/bpf: Replace ly instruction with llgf
Date: Sat, 12 Sep 2026 08:33:11 +0200
Message-ID: <20260912065654.647284345@linuxfoundation.org>
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

From: Maxim Khmelevskii <max@linux.ibm.com>

[ Upstream commit 5f6cc299938b561cb01e343bab7042611fcee12a ]

cpu_nr is a 32 bit value and BPF_REG_0 is a 64 bit register, when ly loads
the cpu_nr into BPF_REG_0 it does not zero the upper bits, but llgf does.

Fixes: 9012cf2491e3 ("s390/bpf: Inline smp_processor_id and current_task")
Signed-off-by: Maxim Khmelevskii <max@linux.ibm.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Ilya Leoshkevich <iii@linux.ibm.com>
Link: https://sashiko.dev/#/patchset/20260414142930.528751-1-max%40linux.ibm.com
Link: https://lore.kernel.org/bpf/20260703125648.919196-5-max@linux.ibm.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/net/bpf_jit_comp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
index 31749c0362ca2..9ddd89f71f282 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -1783,8 +1783,8 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp,
 		    insn->imm == BPF_FUNC_get_smp_processor_id) {
 			const u32 *cpu_nr = &get_lowcore()->cpu_nr;
 
-			/* ly %b0, cpu_nr */
-			EMIT6_DISP_LH(0xe3000000, 0x0058, BPF_REG_0, REG_0, REG_0,
+			/* llgf %b0, cpu_nr */
+			EMIT6_DISP_LH(0xe3000000, 0x0016, BPF_REG_0, REG_0, REG_0,
 				      (unsigned long)cpu_nr);
 			break;
 		}
-- 
2.53.0



