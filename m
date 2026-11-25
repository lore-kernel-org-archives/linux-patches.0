Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617941;
	b=4F91CXO8v/Tf4rE8eaDpq8LgB6+jBqGQ8En1+0dLtn6qc7Of2KXx4uErJCAwwiM9leJC
	 0AlTLjn77ZJVwH3YYe2wYJymu70UVe6GccOZHydGHK6z91Y5i+tBeWZ79Hgo0eqFpxo/m
	 GPqFgiNTfwx7usyFScjIeFHiAhRsxAFD/Rifp8cjHgQGJIIYfs4yil25LZDqHf3WH04ED
	 2yErJazhVjOxSyk2Ld08kcYPkPzJiiiR6+RcVtX5GdtbVuzmgY2rVtT0COu1owJVYdPI3
	 xNYzh6s9D6w+B05xsQEKvkeP+eTZ+XZ7ZFc7ldOWUm2ek8logBSjZQ24EIavLEywImw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617941;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XITXt2F5q3u08+sk6bJhNxcG5cgyKtecLRsjd0VAwH8=;
	b=q7ZSVEiZ1WSCelyI1rTLwyqFOoP7V3VTST0d1I9UuEWAqdYQ33VUWE3uQMDE71D/qf2E
	 JIwMFKileRxZmq3c7JlUsbZ4H4omUep9bovgavhqQUS9c24Qx+tUjCsrIN9NMYcsy2ZY6
	 iYnQ9W4uTeBlXq6mIJ9iqHVhUTkIxA114EMUTIe9SNHae+aw0klDEp26MagxpbmQGqpV7
	 Pn2KzEi8T22IngSoUdFpzqUZsqEK/ryxkifLaRxxi7TNl9vu2Bjn5plh7vYAWvWsQKDcG
	 KPxhT7Nla1CNtoiS1oeqiwbyIoJXryGHY9SRVKJT0OF5ACosOxmn+Tg/1EllwnL3x+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EbkT90ps;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32546606A326;
	Wed, 25 Nov 2026 14:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EbkT90ps
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79CE01F000C0;
	Wed, 25 Nov 2026 14:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617941;
	bh=XITXt2F5q3u08+sk6bJhNxcG5cgyKtecLRsjd0VAwH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EbkT90ps41ZsUOcNI5fDaenH3y9gzi7fCKs+9frePKe7m7AQV5Ij2xb/RRFTCNlub
	 fpFQjc1civJ29GU0P0oBW6K+fKQTt+wzKuZzkVd/+kxGQ4KVGwKf/IvdJpTKsGN0OI
	 YEnEHECk5Q7C9JvG17YUao9EHCuzTI/SijDf+FYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	"Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0068/1005] bpf: Fix jited line info off by the CFI preamble
Date: Wed, 25 Nov 2026 15:23:26 +0100
Message-ID: <20261125143823.337553556@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>

[ Upstream commit 3e4279dc5144a5afcda101df23792b13e94c3859 ]

With CONFIG_CFI=y, every jited line info entry after a function's
first is cfi_get_offset() bytes too high on x86-64, riscv64 and arm64,
so tools that use it show the wrong source line.

The JITs count the insn_to_jit_off[] offsets from the start of the
image. Since the CFI commits below, prog->bpf_func starts
cfi_get_offset() bytes into the image, and bpf_prog_fill_jited_linfo()
adds the offsets to prog->bpf_func. s390 corrects its offsets before
the call, the other three JITs do not.

Subtract cfi_get_offset() once in bpf_prog_fill_jited_linfo() and drop
the s390 correction. jited_linfo[0] stays prog->bpf_func, the
function's ksym address. Without CONFIG_CFI, cfi_get_offset() is 0 and
nothing changes.

Fixes: 4f9087f16651 ("x86/cfi,bpf: Fix BPF JIT call")
Fixes: e63985ecd226 ("bpf, riscv64/cfi: Support kCFI + BPF on riscv64")
Fixes: 710618c760c0 ("arm64/cfi,bpf: Support kCFI + BPF on arm64")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Reported-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261030-b4-arm64-bpf-linfo-cfi-v2-1-4eac83435d4b@linux.dev
Closes: https://lore.kernel.org/all/20260904014748.C04AA1F000E9@smtp.kernel.org/
Closes: https://lore.kernel.org/all/DLNXZ2WK7TPD.2RZBUNRS4FA4L@gmail.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/net/bpf_jit_comp.c | 2 --
 kernel/bpf/core.c            | 8 +++++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
index 1b2566012b63a..cddea4580843b 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -2452,8 +2452,6 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_verifier_env *env, struct bpf_pr
 	fp->jited_len = jit.size - cfi_get_offset();
 
 	if (!fp->is_func || extra_pass) {
-		for (int i = 0; i < fp->len; i++)
-			jit.addrs[i] -= cfi_get_offset();
 		bpf_prog_fill_jited_linfo(fp, jit.addrs + 1);
 free_addrs:
 		kvfree(jit.addrs);
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index f4682bcaea9d0..37f6cbfac5113 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -210,7 +210,9 @@ void bpf_prog_jit_attempt_done(struct bpf_prog *prog)
  * here is relative to the prog itself instead of the main prog.
  * This array has one entry for each xlated bpf insn.
  *
- * jited_off is the byte off to the end of the jited insn.
+ * jited_off is the byte off to the end of the jited insn, counted from
+ * the start of the jited image, which is cfi_get_offset() bytes before
+ * prog->bpf_func.
  *
  * Hence, with
  * insn_start:
@@ -224,7 +226,7 @@ void bpf_prog_jit_attempt_done(struct bpf_prog *prog)
  *
  * For i > linfo_idx,
  *
- * jited_linfo[i] = prog->bpf_func +
+ * jited_linfo[i] = prog->bpf_func - cfi_get_offset() +
  *	insn_to_jit_off[linfo[i].insn_off - insn_start - 1]
  */
 void bpf_prog_fill_jited_linfo(struct bpf_prog *prog,
@@ -252,7 +254,7 @@ void bpf_prog_fill_jited_linfo(struct bpf_prog *prog,
 		/* The verifier ensures that linfo[i].insn_off is
 		 * strictly increasing
 		 */
-		jited_linfo[i] = prog->bpf_func +
+		jited_linfo[i] = prog->bpf_func - cfi_get_offset() +
 			insn_to_jit_off[linfo[i].insn_off - insn_start - 1];
 }
 
-- 
2.53.0



