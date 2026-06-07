Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454F31E98E3;
	Sun,  7 Jun 2026 11:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780830182; cv=none; b=U6PQ5DQ7R+vd80V60XcVr6Q+tj1UsNR6r7VYw5lYnSP1vfMS4u26NAcNO9GlHFwBFd3MqcmfB8k2PDeTofPLh387dxOjZJZRAAUZkKVfVvsj6gFyGltcSY89DSUYFAGZdLqYXH55HRykIMnoxb3qez/BsvGBmelkNyGVBLmk2CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780830182; c=relaxed/simple;
	bh=b66/nYfEmOX04rx9NX13omDhHTiy1gvHd4Du4Ym6eTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s3tV5L1oeCGTz+2rpV0bRFjfPGDoVD94ZlY5h7PCepbBRrKlUP81oTreHBG+i9pnIlU+2CmM7AXF8DK0FVxv8tDZUgK/+q4ZGvqi8b13GjnywTzgpARzpDUVxq7ji/TypsCb7I+Loaabvku1a4b7ApHQEKzer12y/mrw7LEBCco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I4AWXzDd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I4AWXzDd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91CDE1F00893;
	Sun,  7 Jun 2026 11:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780830181;
	bh=kNy4m1J2oPTG3DoEet0zfuy4qmrNCWahuJuYllr6Flk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I4AWXzDdl/BGZFU1wuIQn4TFaxVU5nskyHXAKDDtyntcFgwkMmDuV97k7CSv8SyYW
	 1IINSr1UkMgBi7taVFVFdo7nXmkj0ZvsMGeE0ndxy+0oijh8VHGpMxUjDKGJEBdMHw
	 6IPfmWOMQ/zVmxkUMuouq8C+6zrdb1f6PBHx1xDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo Molnar <mingo@kernel.org>,
	Juergen Gross <jgross@suse.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 300/307] x86/alternatives: Rename apply_relocation() to text_poke_apply_relocation()
Date: Sun,  7 Jun 2026 12:01:37 +0200
Message-ID: <20260607095738.765216287@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

From: Ingo Molnar <mingo@kernel.org>

[ Upstream commit 023f42dd59203be8ad2fc0574af32d3b4ad041ec ]

Join the text_poke_*() API namespace.

Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Juergen Gross <jgross@suse.com>
Cc: "H . Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20250411054105.2341982-52-mingo@kernel.org
Stable-dep-of: a17dc12bfed8 ("x86/ftrace: Relocate %rip-relative percpu refs in dynamic trampolines")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/text-patching.h |    2 +-
 arch/x86/kernel/alternative.c        |    6 +++---
 arch/x86/kernel/callthunks.c         |    6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

--- a/arch/x86/include/asm/text-patching.h
+++ b/arch/x86/include/asm/text-patching.h
@@ -15,7 +15,7 @@
 
 extern void text_poke_early(void *addr, const void *opcode, size_t len);
 
-extern void apply_relocation(u8 *buf, const u8 * const instr, size_t instrlen, u8 *repl, size_t repl_len);
+extern void text_poke_apply_relocation(u8 *buf, const u8 * const instr, size_t instrlen, u8 *repl, size_t repl_len);
 
 /*
  * Clear and restore the kernel write-protection flag on the local CPU.
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -502,7 +502,7 @@ static void __apply_relocation(u8 *buf,
 	}
 }
 
-void apply_relocation(u8 *buf, const u8 * const instr, size_t instrlen, u8 *repl, size_t repl_len)
+void text_poke_apply_relocation(u8 *buf, const u8 * const instr, size_t instrlen, u8 *repl, size_t repl_len)
 {
 	__apply_relocation(buf, instr, instrlen, repl, repl_len);
 	optimize_nops(instr, buf, instrlen);
@@ -658,7 +658,7 @@ void __init_or_module noinline apply_alt
 		for (; insn_buff_sz < a->instrlen; insn_buff_sz++)
 			insn_buff[insn_buff_sz] = 0x90;
 
-		apply_relocation(insn_buff, instr, a->instrlen, replacement, a->replacementlen);
+		text_poke_apply_relocation(insn_buff, instr, a->instrlen, replacement, a->replacementlen);
 
 		DUMP_BYTES(ALT, instr, a->instrlen, "%px:   old_insn: ", instr);
 		DUMP_BYTES(ALT, replacement, a->replacementlen, "%px:   rpl_insn: ", replacement);
@@ -1865,7 +1865,7 @@ __visible noinline void __init __alt_rel
 static noinline void __init alt_reloc_selftest(void)
 {
 	/*
-	 * Tests apply_relocation().
+	 * Tests text_poke_apply_relocation().
 	 *
 	 * This has a relative immediate (CALL) in a place other than the first
 	 * instruction and additionally on x86_64 we get a RIP-relative LEA:
--- a/arch/x86/kernel/callthunks.c
+++ b/arch/x86/kernel/callthunks.c
@@ -180,7 +180,7 @@ static void *patch_dest(void *dest, bool
 	u8 *pad = dest - tsize;
 
 	memcpy(insn_buff, skl_call_thunk_template, tsize);
-	apply_relocation(insn_buff, pad, tsize, skl_call_thunk_template, tsize);
+	text_poke_apply_relocation(insn_buff, pad, tsize, skl_call_thunk_template, tsize);
 
 	/* Already patched? */
 	if (!bcmp(pad, insn_buff, tsize))
@@ -302,7 +302,7 @@ static bool is_callthunk(void *addr)
 	pad = (void *)(dest - tmpl_size);
 
 	memcpy(insn_buff, skl_call_thunk_template, tmpl_size);
-	apply_relocation(insn_buff, pad, tmpl_size, skl_call_thunk_template, tmpl_size);
+	text_poke_apply_relocation(insn_buff, pad, tmpl_size, skl_call_thunk_template, tmpl_size);
 
 	return !bcmp(pad, insn_buff, tmpl_size);
 }
@@ -320,7 +320,7 @@ int x86_call_depth_emit_accounting(u8 **
 		return 0;
 
 	memcpy(insn_buff, skl_call_thunk_template, tmpl_size);
-	apply_relocation(insn_buff, ip, tmpl_size, skl_call_thunk_template, tmpl_size);
+	text_poke_apply_relocation(insn_buff, ip, tmpl_size, skl_call_thunk_template, tmpl_size);
 
 	memcpy(*pprog, insn_buff, tmpl_size);
 	*pprog += tmpl_size;


