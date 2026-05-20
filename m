Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57593D75AA;
	Wed, 20 May 2026 16:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294693; cv=none; b=LFYQgACgdaY1/j/87vS4XUKYYtG/K3KZUCHVJfkvAaSOH834dnJOR0SQe6b+20ui/adN4cKyV3sqwA5AxqOr6fvD/LyRDXid+wEZfP5nf4b1R8oCaJ/SvzBJQEKB1kz/klJE2Fz32YbNnp2J35XJu47veOduE7nJBdoLTBOngE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294693; c=relaxed/simple;
	bh=/L2wQ8NuD0cV2oZg/Uj5WrMbCER3/WKqQR/LPjlAwa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PFRuicw+mdo/iNL/AJs2YrrhPGH48NuegeHjqxJkQafcMSD6nJNiiUAfln3gNayuVx8ojYvW463wMdpzYbdFFZpTGWsA7cLPv0kATHJmlAK2pHEYID6unWOoMRXlDJOSbXb5VusHR8F+cJT45UDv3+2KxzAxe3WPbeT+7erSkoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SfYwXnlB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SfYwXnlB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 268AD1F000E9;
	Wed, 20 May 2026 16:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294692;
	bh=x3vSY9PUtCk1dsn0KdGLySeXQeD+a6XaQHT7HwGgGF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SfYwXnlBXv+nB+xJFe+W1achKpihF3UzLhN9jzOdCvru5UC0QD8rPorzeURraskC4
	 3VVPibb67NR+cWQ3PdtMBYmr8lieYoHtH52e4AvVYkKUfZHwkGldZCktSICjPCsmG8
	 unZxS7XvD66HZrWuhxsAfF23nAbGnz4fBs4ftMY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"haoyu.lu" <hechushiguitu666@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0137/1146] bpf,arc_jit: Fix missing newline in pr_err messages
Date: Wed, 20 May 2026 18:06:27 +0200
Message-ID: <20260520162151.418863397@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: haoyu.lu <hechushiguitu666@gmail.com>

[ Upstream commit b6b5e0ebd429d66ce37ae5af649a74ea1f041d92 ]

Add missing newline to pr_err messages in ARC JIT.

Fixes: f122668ddcce ("ARC: Add eBPF JIT support")
Signed-off-by: haoyu.lu <hechushiguitu666@gmail.com>
Link: https://lore.kernel.org/r/20260324122703.641-1-hechushiguitu666@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/net/bpf_jit_arcv2.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arc/net/bpf_jit_arcv2.c b/arch/arc/net/bpf_jit_arcv2.c
index 6d989b6d88c69..7ee50aeae5a45 100644
--- a/arch/arc/net/bpf_jit_arcv2.c
+++ b/arch/arc/net/bpf_jit_arcv2.c
@@ -2427,7 +2427,7 @@ u8 arc_prologue(u8 *buf, u32 usage, u16 frame_size)
 
 #ifdef ARC_BPF_JIT_DEBUG
 	if ((usage & BIT(ARC_R_FP)) && frame_size == 0) {
-		pr_err("FP is being saved while there is no frame.");
+		pr_err("FP is being saved while there is no frame.\n");
 		BUG();
 	}
 #endif
@@ -2454,7 +2454,7 @@ u8 arc_epilogue(u8 *buf, u32 usage, u16 frame_size)
 
 #ifdef ARC_BPF_JIT_DEBUG
 	if ((usage & BIT(ARC_R_FP)) && frame_size == 0) {
-		pr_err("FP is being saved while there is no frame.");
+		pr_err("FP is being saved while there is no frame.\n");
 		BUG();
 	}
 #endif
@@ -2868,7 +2868,7 @@ u8 gen_jmp_64(u8 *buf, u8 rd, u8 rs, u8 cond, u32 curr_off, u32 targ_off)
 		break;
 	default:
 #ifdef ARC_BPF_JIT_DEBUG
-		pr_err("64-bit jump condition is not known.");
+		pr_err("64-bit jump condition is not known.\n");
 		BUG();
 #endif
 	}
@@ -2948,7 +2948,7 @@ u8 gen_jmp_32(u8 *buf, u8 rd, u8 rs, u8 cond, u32 curr_off, u32 targ_off)
 	 */
 	if (cond >= ARC_CC_LAST) {
 #ifdef ARC_BPF_JIT_DEBUG
-		pr_err("32-bit jump condition is not known.");
+		pr_err("32-bit jump condition is not known.\n");
 		BUG();
 #endif
 		return 0;
-- 
2.53.0



