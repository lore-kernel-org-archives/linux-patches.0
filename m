Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A59053909BC;
	Sat, 17 Oct 2026 18:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260711; cv=none; b=dxltpr0+KIGJRjvfhYORzLmox9bGXmqkPT/0u2R6rqddSkFbZTvjOjGM84kmiSZz7Wj4hPXmTKuC4BXTrUeT+7PrMSoN6n1K4OoFlrnSmiviD+rR+5ZacCGXut1RRYDy6InoUDB8hfZSMk99XY5/TKs1v5nDgx6dKRUFcQNti1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260711; c=relaxed/simple;
	bh=LZFdJExtztFmak8WJR9uzEigQGvu1kCW3ynf2LljFnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n8EabwpTsuW+jzdi6cVfWh1D6XJQhr4a0nlVPcys8CLCU1gJ+6TcpjdMU1bdoNdblkFYBonA1XuNMlLdu6eFQYmbypVp237D7aOrv18NLA26sFcJ1u4haPNmuNwS3L7k2CKMzi6htSRZYZm4CPfg+FGefVhiRvix7HyjzYV/zGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jrhFC0Sf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jrhFC0Sf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C441F000C4;
	Sat, 17 Oct 2026 18:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260710;
	bh=eMilPC1palebldFGokefb694YIhWFlan5uNAS3IMw3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jrhFC0SfkcwtyNNUwwIo7YzPeGw2/nuTaHX71bwO0G41RBtG4wxTxHWsCNjCOFRjo
	 Ut0rLeYjUVlQB+wbmeKfEghnQoi4F/TyDoQdgeaDGwU5T9fRWjFPM4jq/I0QMarDeR
	 XJWFZbkW5zPjtg+QkDaq23Xg5zxOtIsQNeIOafWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1628/1674] bpf: rename is_branch_taken reg arguments to prepare for the second one
Date: Sat, 17 Oct 2026 18:05:00 +0200
Message-ID: <20261017160512.870519732@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit c2a3ab094683ddc154879a1364fc7cb0228f96a6 ]

Just taking mundane refactoring bits out into a separate patch. No
functional changes.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Link: https://lore.kernel.org/r/20231102033759.2541186-12-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: e51179a4e098 ("bpf: Don't predict JMP32 pointer vs zero comparisons")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 108 +++++++++++++++++++++---------------------
 1 file changed, 54 insertions(+), 54 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 4493df7e837e5..30751a16f186b 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -14076,26 +14076,26 @@ static void find_good_pkt_pointers(struct bpf_verifier_state *vstate,
 	}));
 }
 
-static int is_branch32_taken(struct bpf_reg_state *reg, u32 val, u8 opcode)
+static int is_branch32_taken(struct bpf_reg_state *reg1, u32 val, u8 opcode)
 {
-	struct tnum subreg = tnum_subreg(reg->var_off);
+	struct tnum subreg = tnum_subreg(reg1->var_off);
 	s32 sval = (s32)val;
 
 	switch (opcode) {
 	case BPF_JEQ:
 		if (tnum_is_const(subreg))
 			return !!tnum_equals_const(subreg, val);
-		else if (val < reg->u32_min_value || val > reg->u32_max_value)
+		else if (val < reg1->u32_min_value || val > reg1->u32_max_value)
 			return 0;
-		else if (sval < reg->s32_min_value || sval > reg->s32_max_value)
+		else if (sval < reg1->s32_min_value || sval > reg1->s32_max_value)
 			return 0;
 		break;
 	case BPF_JNE:
 		if (tnum_is_const(subreg))
 			return !tnum_equals_const(subreg, val);
-		else if (val < reg->u32_min_value || val > reg->u32_max_value)
+		else if (val < reg1->u32_min_value || val > reg1->u32_max_value)
 			return 1;
-		else if (sval < reg->s32_min_value || sval > reg->s32_max_value)
+		else if (sval < reg1->s32_min_value || sval > reg1->s32_max_value)
 			return 1;
 		break;
 	case BPF_JSET:
@@ -14105,51 +14105,51 @@ static int is_branch32_taken(struct bpf_reg_state *reg, u32 val, u8 opcode)
 			return 0;
 		break;
 	case BPF_JGT:
-		if (reg->u32_min_value > val)
+		if (reg1->u32_min_value > val)
 			return 1;
-		else if (reg->u32_max_value <= val)
+		else if (reg1->u32_max_value <= val)
 			return 0;
 		break;
 	case BPF_JSGT:
-		if (reg->s32_min_value > sval)
+		if (reg1->s32_min_value > sval)
 			return 1;
-		else if (reg->s32_max_value <= sval)
+		else if (reg1->s32_max_value <= sval)
 			return 0;
 		break;
 	case BPF_JLT:
-		if (reg->u32_max_value < val)
+		if (reg1->u32_max_value < val)
 			return 1;
-		else if (reg->u32_min_value >= val)
+		else if (reg1->u32_min_value >= val)
 			return 0;
 		break;
 	case BPF_JSLT:
-		if (reg->s32_max_value < sval)
+		if (reg1->s32_max_value < sval)
 			return 1;
-		else if (reg->s32_min_value >= sval)
+		else if (reg1->s32_min_value >= sval)
 			return 0;
 		break;
 	case BPF_JGE:
-		if (reg->u32_min_value >= val)
+		if (reg1->u32_min_value >= val)
 			return 1;
-		else if (reg->u32_max_value < val)
+		else if (reg1->u32_max_value < val)
 			return 0;
 		break;
 	case BPF_JSGE:
-		if (reg->s32_min_value >= sval)
+		if (reg1->s32_min_value >= sval)
 			return 1;
-		else if (reg->s32_max_value < sval)
+		else if (reg1->s32_max_value < sval)
 			return 0;
 		break;
 	case BPF_JLE:
-		if (reg->u32_max_value <= val)
+		if (reg1->u32_max_value <= val)
 			return 1;
-		else if (reg->u32_min_value > val)
+		else if (reg1->u32_min_value > val)
 			return 0;
 		break;
 	case BPF_JSLE:
-		if (reg->s32_max_value <= sval)
+		if (reg1->s32_max_value <= sval)
 			return 1;
-		else if (reg->s32_min_value > sval)
+		else if (reg1->s32_min_value > sval)
 			return 0;
 		break;
 	}
@@ -14158,79 +14158,79 @@ static int is_branch32_taken(struct bpf_reg_state *reg, u32 val, u8 opcode)
 }
 
 
-static int is_branch64_taken(struct bpf_reg_state *reg, u64 val, u8 opcode)
+static int is_branch64_taken(struct bpf_reg_state *reg1, u64 val, u8 opcode)
 {
 	s64 sval = (s64)val;
 
 	switch (opcode) {
 	case BPF_JEQ:
-		if (tnum_is_const(reg->var_off))
-			return !!tnum_equals_const(reg->var_off, val);
-		else if (val < reg->umin_value || val > reg->umax_value)
+		if (tnum_is_const(reg1->var_off))
+			return !!tnum_equals_const(reg1->var_off, val);
+		else if (val < reg1->umin_value || val > reg1->umax_value)
 			return 0;
-		else if (sval < reg->smin_value || sval > reg->smax_value)
+		else if (sval < reg1->smin_value || sval > reg1->smax_value)
 			return 0;
 		break;
 	case BPF_JNE:
-		if (tnum_is_const(reg->var_off))
-			return !tnum_equals_const(reg->var_off, val);
-		else if (val < reg->umin_value || val > reg->umax_value)
+		if (tnum_is_const(reg1->var_off))
+			return !tnum_equals_const(reg1->var_off, val);
+		else if (val < reg1->umin_value || val > reg1->umax_value)
 			return 1;
-		else if (sval < reg->smin_value || sval > reg->smax_value)
+		else if (sval < reg1->smin_value || sval > reg1->smax_value)
 			return 1;
 		break;
 	case BPF_JSET:
-		if ((~reg->var_off.mask & reg->var_off.value) & val)
+		if ((~reg1->var_off.mask & reg1->var_off.value) & val)
 			return 1;
-		if (!((reg->var_off.mask | reg->var_off.value) & val))
+		if (!((reg1->var_off.mask | reg1->var_off.value) & val))
 			return 0;
 		break;
 	case BPF_JGT:
-		if (reg->umin_value > val)
+		if (reg1->umin_value > val)
 			return 1;
-		else if (reg->umax_value <= val)
+		else if (reg1->umax_value <= val)
 			return 0;
 		break;
 	case BPF_JSGT:
-		if (reg->smin_value > sval)
+		if (reg1->smin_value > sval)
 			return 1;
-		else if (reg->smax_value <= sval)
+		else if (reg1->smax_value <= sval)
 			return 0;
 		break;
 	case BPF_JLT:
-		if (reg->umax_value < val)
+		if (reg1->umax_value < val)
 			return 1;
-		else if (reg->umin_value >= val)
+		else if (reg1->umin_value >= val)
 			return 0;
 		break;
 	case BPF_JSLT:
-		if (reg->smax_value < sval)
+		if (reg1->smax_value < sval)
 			return 1;
-		else if (reg->smin_value >= sval)
+		else if (reg1->smin_value >= sval)
 			return 0;
 		break;
 	case BPF_JGE:
-		if (reg->umin_value >= val)
+		if (reg1->umin_value >= val)
 			return 1;
-		else if (reg->umax_value < val)
+		else if (reg1->umax_value < val)
 			return 0;
 		break;
 	case BPF_JSGE:
-		if (reg->smin_value >= sval)
+		if (reg1->smin_value >= sval)
 			return 1;
-		else if (reg->smax_value < sval)
+		else if (reg1->smax_value < sval)
 			return 0;
 		break;
 	case BPF_JLE:
-		if (reg->umax_value <= val)
+		if (reg1->umax_value <= val)
 			return 1;
-		else if (reg->umin_value > val)
+		else if (reg1->umin_value > val)
 			return 0;
 		break;
 	case BPF_JSLE:
-		if (reg->smax_value <= sval)
+		if (reg1->smax_value <= sval)
 			return 1;
-		else if (reg->smin_value > sval)
+		else if (reg1->smin_value > sval)
 			return 0;
 		break;
 	}
@@ -14245,11 +14245,11 @@ static int is_branch64_taken(struct bpf_reg_state *reg, u64 val, u8 opcode)
  * -1 - unknown. Example: "if (reg < 5)" is unknown when register value
  *      range [0,10]
  */
-static int is_branch_taken(struct bpf_reg_state *reg, u64 val, u8 opcode,
+static int is_branch_taken(struct bpf_reg_state *reg1, u64 val, u8 opcode,
 			   bool is_jmp32)
 {
-	if (__is_pointer_value(false, reg)) {
-		if (!reg_not_null(reg))
+	if (__is_pointer_value(false, reg1)) {
+		if (!reg_not_null(reg1))
 			return -1;
 
 		/* If pointer is valid tests against zero will fail so we can
@@ -14269,8 +14269,8 @@ static int is_branch_taken(struct bpf_reg_state *reg, u64 val, u8 opcode,
 	}
 
 	if (is_jmp32)
-		return is_branch32_taken(reg, val, opcode);
-	return is_branch64_taken(reg, val, opcode);
+		return is_branch32_taken(reg1, val, opcode);
+	return is_branch64_taken(reg1, val, opcode);
 }
 
 static int flip_opcode(u32 opcode)
-- 
2.53.0



