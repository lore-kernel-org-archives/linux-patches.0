Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3E8E555;
	Sat, 17 Oct 2026 17:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257633; cv=none; b=U6przlVq0ksvfp3XsJCtFY3yiKYAIwBDU1egfrKvzYPHDXsGrMW3X86F3Hv0JcGU9nI/xnORQIiG8KXzyI2OO348CU4oQupy4F3xwN4zubeZ73GOhnhhnpUt3wMV7CzleBHskWbd1lOj/2wH7Gr1nCi3I0D/KiTKucGTo9D9AGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257633; c=relaxed/simple;
	bh=XtpI69kwcihyMfMnmMlaSCuYIiXNj6oPkw9q7HmOTmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DLcNgdeUOaWdgWZ8jEgKGj9IUxJjt/R1cKSVai9bUigad2YR3XJl4A/pUS3bBNjp8C0l6WQofk6/vG7ncSSLiNXri+PdpEbLwrRNDlit7UrW17uu+TdGvvH0P646MJJjvqeTASjfo9/rVAIYt9b3l+nrUlz1E5xgNTuAGFpxxu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MPPbtq7R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MPPbtq7R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A91E1F000C4;
	Sat, 17 Oct 2026 17:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257631;
	bh=y8/iY67vf/TkeBYxBCVciHVsKuanOPkV8pNo74crOwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MPPbtq7RNLVTaO7yObUfuda0PR11xCuJz39wXAmtfA/lLlyrc6o4jTVbcq0RI1w1F
	 SKCiieHgv+++kxAUVJb+xZIC5hon/IRbX3ljp3qr39hPEyGeZTwee5CpzCrxF228LN
	 uTIsmu8d0EnLY3EMwxhDN9hd7QBNPhvkfsGeOiIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Puranjay Mohan <puranjay12@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH 6.6 0622/1674] bpf: Take return from set_memory_rox() into account with bpf_jit_binary_lock_ro()
Date: Sat, 17 Oct 2026 17:48:14 +0200
Message-ID: <20261017160447.045374196@linuxfoundation.org>
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

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit e60adf513275c3a38e5cb67f7fd12387e43a3ff5 ]

set_memory_rox() can fail, leaving memory unprotected.

Check return and bail out when bpf_jit_binary_lock_ro() returns
an error.

Link: https://github.com/KSPP/linux/issues/7
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: linux-hardening@vger.kernel.org <linux-hardening@vger.kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Puranjay Mohan <puranjay12@gmail.com>
Reviewed-by: Ilya Leoshkevich <iii@linux.ibm.com>  # s390x
Acked-by: Tiezhu Yang <yangtiezhu@loongson.cn>  # LoongArch
Reviewed-by: Johan Almbladh <johan.almbladh@anyfinetworks.com> # MIPS Part
Message-ID: <036b6393f23a2032ce75a1c92220b2afcb798d5d.1709850515.git.christophe.leroy@csgroup.eu>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/net/bpf_jit_32.c        | 25 ++++++++++++-------------
 arch/arm64/net/bpf_jit_comp.c    |  8 +++++++-
 arch/loongarch/net/bpf_jit.c     | 22 ++++++++++++++++------
 arch/mips/net/bpf_jit_comp.c     |  3 ++-
 arch/parisc/net/bpf_jit_core.c   |  8 +++++++-
 arch/powerpc/net/bpf_jit_comp.c  |  8 +++++++-
 arch/s390/net/bpf_jit_comp.c     |  6 +++++-
 arch/sparc/net/bpf_jit_comp_64.c |  6 +++++-
 arch/x86/net/bpf_jit_comp32.c    |  3 +--
 include/linux/filter.h           |  5 +++--
 10 files changed, 65 insertions(+), 29 deletions(-)

diff --git a/arch/arm/net/bpf_jit_32.c b/arch/arm/net/bpf_jit_32.c
index 2292245cfe7a9..8adc45ad1b2a7 100644
--- a/arch/arm/net/bpf_jit_32.c
+++ b/arch/arm/net/bpf_jit_32.c
@@ -1988,28 +1988,21 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 	/* If building the body of the JITed code fails somehow,
 	 * we fall back to the interpretation.
 	 */
-	if (build_body(&ctx) < 0) {
-		image_ptr = NULL;
-		bpf_jit_binary_free(header);
-		prog = orig_prog;
-		goto out_imms;
-	}
+	if (build_body(&ctx) < 0)
+		goto out_free;
 	build_epilogue(&ctx);
 
 	/* 3.) Extra pass to validate JITed Code */
-	if (validate_code(&ctx)) {
-		image_ptr = NULL;
-		bpf_jit_binary_free(header);
-		prog = orig_prog;
-		goto out_imms;
-	}
+	if (validate_code(&ctx))
+		goto out_free;
 	flush_icache_range((u32)header, (u32)(ctx.target + ctx.idx));
 
 	if (bpf_jit_enable > 1)
 		/* there are 2 passes here */
 		bpf_jit_dump(prog->len, image_size, 2, ctx.target);
 
-	bpf_jit_binary_lock_ro(header);
+	if (bpf_jit_binary_lock_ro(header))
+		goto out_free;
 	prog->bpf_func = (void *)ctx.target;
 	prog->jited = 1;
 	prog->jited_len = image_size;
@@ -2026,5 +2019,11 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 		bpf_jit_prog_release_other(prog, prog == orig_prog ?
 					   tmp : orig_prog);
 	return prog;
+
+out_free:
+	image_ptr = NULL;
+	bpf_jit_binary_free(header);
+	prog = orig_prog;
+	goto out_imms;
 }
 
diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 9fd0b658e4602..c66fe02acc605 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -1697,7 +1697,13 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 			prog->jited_len = 0;
 			goto out_off;
 		}
-		bpf_jit_binary_lock_ro(header);
+		if (bpf_jit_binary_lock_ro(header)) {
+			bpf_jit_binary_free(header);
+			prog->bpf_func = NULL;
+			prog->jited = 0;
+			prog->jited_len = 0;
+			goto out_off;
+		}
 	} else {
 		jit_data->ctx = ctx;
 		jit_data->image = image_ptr;
diff --git a/arch/loongarch/net/bpf_jit.c b/arch/loongarch/net/bpf_jit.c
index 54661cffd654f..f1ad46e233215 100644
--- a/arch/loongarch/net/bpf_jit.c
+++ b/arch/loongarch/net/bpf_jit.c
@@ -1222,16 +1222,19 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 	flush_icache_range((unsigned long)header, (unsigned long)(ctx.image + ctx.idx));
 
 	if (!prog->is_func || extra_pass) {
+		int err;
+
 		if (extra_pass && ctx.idx != jit_data->ctx.idx) {
 			pr_err_once("multi-func JIT bug %d != %d\n",
 				    ctx.idx, jit_data->ctx.idx);
-			bpf_jit_binary_free(header);
-			prog->bpf_func = NULL;
-			prog->jited = 0;
-			prog->jited_len = 0;
-			goto out_offset;
+			goto out_free;
+		}
+		err = bpf_jit_binary_lock_ro(header);
+		if (err) {
+			pr_err_once("bpf_jit_binary_lock_ro() returned %d\n",
+				    err);
+			goto out_free;
 		}
-		bpf_jit_binary_lock_ro(header);
 	} else {
 		jit_data->ctx = ctx;
 		jit_data->image = image_ptr;
@@ -1261,6 +1264,13 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 
 
 	return prog;
+
+out_free:
+	bpf_jit_binary_free(header);
+	prog->bpf_func = NULL;
+	prog->jited = 0;
+	prog->jited_len = 0;
+	goto out_offset;
 }
 
 /* Indicate the JIT backend supports mixing bpf2bpf and tailcalls. */
diff --git a/arch/mips/net/bpf_jit_comp.c b/arch/mips/net/bpf_jit_comp.c
index a40d926b65139..e355dfca44008 100644
--- a/arch/mips/net/bpf_jit_comp.c
+++ b/arch/mips/net/bpf_jit_comp.c
@@ -1012,7 +1012,8 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 	bpf_prog_fill_jited_linfo(prog, &ctx.descriptors[1]);
 
 	/* Set as read-only exec and flush instruction cache */
-	bpf_jit_binary_lock_ro(header);
+	if (bpf_jit_binary_lock_ro(header))
+		goto out_err;
 	flush_icache_range((unsigned long)header,
 			   (unsigned long)&ctx.target[ctx.jit_index]);
 
diff --git a/arch/parisc/net/bpf_jit_core.c b/arch/parisc/net/bpf_jit_core.c
index 7b9cb3cda27ee..06cbcd6fe87b8 100644
--- a/arch/parisc/net/bpf_jit_core.c
+++ b/arch/parisc/net/bpf_jit_core.c
@@ -167,7 +167,13 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 	bpf_flush_icache(jit_data->header, ctx->insns + ctx->ninsns);
 
 	if (!prog->is_func || extra_pass) {
-		bpf_jit_binary_lock_ro(jit_data->header);
+		if (bpf_jit_binary_lock_ro(jit_data->header)) {
+			bpf_jit_binary_free(jit_data->header);
+			prog->bpf_func = NULL;
+			prog->jited = 0;
+			prog->jited_len = 0;
+			goto out_offset;
+		}
 		prologue_len = ctx->epilogue_offset - ctx->body_len;
 		for (i = 0; i < prog->len; i++)
 			ctx->offset[i] += prologue_len;
diff --git a/arch/powerpc/net/bpf_jit_comp.c b/arch/powerpc/net/bpf_jit_comp.c
index 37043dfc1addd..c8e74a3bb1f9e 100644
--- a/arch/powerpc/net/bpf_jit_comp.c
+++ b/arch/powerpc/net/bpf_jit_comp.c
@@ -205,7 +205,13 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
 
 	bpf_flush_icache(bpf_hdr, (u8 *)bpf_hdr + bpf_hdr->size);
 	if (!fp->is_func || extra_pass) {
-		bpf_jit_binary_lock_ro(bpf_hdr);
+		if (bpf_jit_binary_lock_ro(bpf_hdr)) {
+			bpf_jit_binary_free(bpf_hdr);
+			fp->bpf_func = NULL;
+			fp->jited = 0;
+			fp->jited_len = 0;
+			goto out_addrs;
+		}
 		bpf_prog_fill_jited_linfo(fp, addrs);
 out_addrs:
 		kfree(addrs);
diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
index 491789420d7c0..eba2b42ff329c 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -2015,7 +2015,11 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
 		print_fn_code(jit.prg_buf, jit.size_prg);
 	}
 	if (!fp->is_func || extra_pass) {
-		bpf_jit_binary_lock_ro(header);
+		if (bpf_jit_binary_lock_ro(header)) {
+			bpf_jit_binary_free(header);
+			fp = orig_fp;
+			goto free_addrs;
+		}
 	} else {
 		jit_data->header = header;
 		jit_data->ctx = jit;
diff --git a/arch/sparc/net/bpf_jit_comp_64.c b/arch/sparc/net/bpf_jit_comp_64.c
index fa0759bfe498e..73bf0aea8baf1 100644
--- a/arch/sparc/net/bpf_jit_comp_64.c
+++ b/arch/sparc/net/bpf_jit_comp_64.c
@@ -1602,7 +1602,11 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 	bpf_flush_icache(header, (u8 *)header + header->size);
 
 	if (!prog->is_func || extra_pass) {
-		bpf_jit_binary_lock_ro(header);
+		if (bpf_jit_binary_lock_ro(header)) {
+			bpf_jit_binary_free(header);
+			prog = orig_prog;
+			goto out_off;
+		}
 	} else {
 		jit_data->ctx = ctx;
 		jit_data->image = image_ptr;
diff --git a/arch/x86/net/bpf_jit_comp32.c b/arch/x86/net/bpf_jit_comp32.c
index 429a89c5468b5..f2fc8c38629b5 100644
--- a/arch/x86/net/bpf_jit_comp32.c
+++ b/arch/x86/net/bpf_jit_comp32.c
@@ -2600,8 +2600,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 	if (bpf_jit_enable > 1)
 		bpf_jit_dump(prog->len, proglen, pass + 1, image);
 
-	if (image) {
-		bpf_jit_binary_lock_ro(header);
+	if (image && !bpf_jit_binary_lock_ro(header)) {
 		prog->bpf_func = (void *)image;
 		prog->jited = 1;
 		prog->jited_len = proglen;
diff --git a/include/linux/filter.h b/include/linux/filter.h
index f2e351cc543d6..3fee2723709f3 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -877,10 +877,11 @@ static inline void bpf_prog_lock_ro(struct bpf_prog *fp)
 #endif
 }
 
-static inline void bpf_jit_binary_lock_ro(struct bpf_binary_header *hdr)
+static inline int __must_check
+bpf_jit_binary_lock_ro(struct bpf_binary_header *hdr)
 {
 	set_vm_flush_reset_perms(hdr);
-	set_memory_rox((unsigned long)hdr, hdr->size >> PAGE_SHIFT);
+	return set_memory_rox((unsigned long)hdr, hdr->size >> PAGE_SHIFT);
 }
 
 int sk_filter_trim_cap(struct sock *sk, struct sk_buff *skb, unsigned int cap);
-- 
2.53.0



