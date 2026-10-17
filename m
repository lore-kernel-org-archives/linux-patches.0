Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69AA3B388C;
	Sat, 17 Oct 2026 18:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260222; cv=none; b=PFc+wy4UI2nGd3TA9pJAHmH4wFIRcYhRCzFBMdwBqwdT6l/oEJbBLFjZghpJemGpsBiBevn+QCOdd33qbrwV5NatG3nNvusXX3f5hHqD/gnJ+GG6UWhv4yqIdBDDoU2Qj4c7ioS7wu1FhHRQ9v7544w59Ynr8D1JzY+JZVmDxgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260222; c=relaxed/simple;
	bh=8PxRxX96HlHpTqo24gwg+zJACQYnPoTf+ae8TJ3zy80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BqqTX1It/vmCke+mG9JcRQlZHjp4rIdmUiY8h3dxlhJkVybaKvo2pL+FoawPr3RU6gO6VmcEoUVGnX6sSRFe2BTz+Mrw0WRqz6cI4JoY35CGdDYEfYngJ3nfHjsU+UCSg/HMquyQSzgfkIbjjmxbMQlV8YUPCnFVlxNndoTkknc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aN0w4bzS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aN0w4bzS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D56F1F000C4;
	Sat, 17 Oct 2026 18:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260220;
	bh=KxLdBdnCU+IpvtgGwVCmwWPqC6fiTA5mW4OQZ1dpjO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aN0w4bzSRtJ7F3EsHysdJsszOSddrJiUBpjd6qR1c8bdMq/jSYYaf5ufgH75TRpQP
	 vzTOzUzncLiBgsrN+pLL1XuNwoNlh0v2KCcI8d67DsdJdyOIdhONzPfnuJpOKEqz99
	 lXKXY9N/quWkqghRZvNXZtvPZJqsyBCbwzfVcroM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rafael Passos <rafael@rcpassos.me>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1473/1674] bpf: remove unused parameter in bpf_jit_binary_pack_finalize
Date: Sat, 17 Oct 2026 18:02:25 +0200
Message-ID: <20261017160508.973272882@linuxfoundation.org>
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

From: Rafael Passos <rafael@rcpassos.me>

[ Upstream commit 9919c5c98cb25dbf7e76aadb9beab55a2a25f830 ]

Fixes a compiler warning. the bpf_jit_binary_pack_finalize function
was taking an extra bpf_prog parameter that went unused.
This removves it and updates the callers accordingly.

Signed-off-by: Rafael Passos <rafael@rcpassos.me>
Link: https://lore.kernel.org/r/20240615022641.210320-2-rafael@rcpassos.me
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: 369e4635d048 ("riscv, bpf: Fix memory leak in bpf_jit_free")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/net/bpf_jit_core.c | 5 ++---
 arch/x86/net/bpf_jit_comp.c   | 4 ++--
 include/linux/filter.h        | 3 +--
 kernel/bpf/core.c             | 3 +--
 4 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/riscv/net/bpf_jit_core.c b/arch/riscv/net/bpf_jit_core.c
index 8d8c5eb2e8dac..c459ad46739e1 100644
--- a/arch/riscv/net/bpf_jit_core.c
+++ b/arch/riscv/net/bpf_jit_core.c
@@ -176,8 +176,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 	prog->jited_len = prog_size;
 
 	if (!prog->is_func || extra_pass) {
-		if (WARN_ON(bpf_jit_binary_pack_finalize(prog, jit_data->ro_header,
-							 jit_data->header))) {
+		if (WARN_ON(bpf_jit_binary_pack_finalize(jit_data->ro_header, jit_data->header))) {
 			/* ro_header has been freed */
 			jit_data->ro_header = NULL;
 			prog = orig_prog;
@@ -269,7 +268,7 @@ void bpf_jit_free(struct bpf_prog *prog)
 		 * before freeing it.
 		 */
 		if (jit_data) {
-			bpf_jit_binary_pack_finalize(prog, jit_data->ro_header, jit_data->header);
+			bpf_jit_binary_pack_finalize(jit_data->ro_header, jit_data->header);
 			kfree(jit_data);
 		}
 		hdr = bpf_jit_binary_pack_hdr(prog);
diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 3d33aafa2cc26..8fc949efb89f5 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -2949,7 +2949,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 			 *
 			 * Both cases are serious bugs and justify WARN_ON.
 			 */
-			if (WARN_ON(bpf_jit_binary_pack_finalize(prog, header, rw_header))) {
+			if (WARN_ON(bpf_jit_binary_pack_finalize(header, rw_header))) {
 				/* header has been freed */
 				header = NULL;
 				goto out_image;
@@ -3016,7 +3016,7 @@ void bpf_jit_free(struct bpf_prog *prog)
 		 * before freeing it.
 		 */
 		if (jit_data) {
-			bpf_jit_binary_pack_finalize(prog, jit_data->header,
+			bpf_jit_binary_pack_finalize(jit_data->header,
 						     jit_data->rw_header);
 			kvfree(jit_data->addrs);
 			kfree(jit_data);
diff --git a/include/linux/filter.h b/include/linux/filter.h
index cb6c3f20b22f9..bc6ea33171202 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1083,8 +1083,7 @@ bpf_jit_binary_pack_alloc(unsigned int proglen, u8 **ro_image,
 			  u8 **rw_image,
 			  bpf_jit_fill_hole_t bpf_fill_ill_insns,
 			  bool was_classic);
-int bpf_jit_binary_pack_finalize(struct bpf_prog *prog,
-				 struct bpf_binary_header *ro_header,
+int bpf_jit_binary_pack_finalize(struct bpf_binary_header *ro_header,
 				 struct bpf_binary_header *rw_header);
 void bpf_jit_binary_pack_free(struct bpf_binary_header *ro_header,
 			      struct bpf_binary_header *rw_header);
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 5dee9d2c0420f..175ef2a64cb13 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1191,8 +1191,7 @@ bpf_jit_binary_pack_alloc(unsigned int proglen, u8 **image_ptr,
 }
 
 /* Copy JITed text from rw_header to its final location, the ro_header. */
-int bpf_jit_binary_pack_finalize(struct bpf_prog *prog,
-				 struct bpf_binary_header *ro_header,
+int bpf_jit_binary_pack_finalize(struct bpf_binary_header *ro_header,
 				 struct bpf_binary_header *rw_header)
 {
 	void *ptr;
-- 
2.53.0



