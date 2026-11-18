Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032412;
	b=P0vn+JRSXpnS3uhszt7Bg9i66gb5cRDzhO3Ni3IRnv6yGqHqnCzBvE/mz1Z42XMfPe0h
	 WXwzNCi+zt0eus+saqY1b0fucjlfwZjNtp/aSiGZfzxCNfxKttv4c2DX98l+KMHeReg/A
	 O5s4/kHmAcfnOX+BZBeKTctprDcNsmoYk8wibMd+exoKTdYTWi4z6f+Wc6Rs3VhgqHLAS
	 724Ror1LMhn1EDaNfnO87ZEcEptZfE5N8dMryYxAVJq2rnSBHz1s5k6mLXBjUCwwAchUI
	 o5xp0eEsRxPKHlS+EXW1dCcoMyfsGJYwHhtif6NY9f72X2Lltz3wEX9cRxyWEmIKVuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032412;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tLn4qbfBIla++o7LyVdcDN8Z6deXUl8FUoX+mgS/lsQ=;
	b=pw5rhlKomDmzHISz5kDKojOl4driwYIoS1UzMLUr4FumTk8UDw4EoU1zn47FSAk58qQO
	 rhDi6eA2ojte2uqCQyqLVYQWt8SF3Gh8XpDTbjq9WhEn3RCDOqD12HvwdutBXn1ycwNsu
	 A7Yr4zv9Vx5k7aXmMeBlkBIJvEOFddR7zYWmiJ7eOjuCk9vsY4JNm2j6m6rVAONdjB6eo
	 Bc8V1j2Wn9yfM26WfNsCrZ5VOvkekjBo/pPuQUQU0XeGSgMJG/Cnyg8PFnNFrJzW6Bgxr
	 S4dbn8vSO3DuURhF+0zb4rCLiXjDOwAW20sd8ywsTxW8NssZ8yAoV1e3MnK0bE+c5iQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P7vCITCS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D4B60A261F;
	Wed, 18 Nov 2026 20:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P7vCITCS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 785461F000C4;
	Wed, 18 Nov 2026 20:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032412;
	bh=tLn4qbfBIla++o7LyVdcDN8Z6deXUl8FUoX+mgS/lsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P7vCITCS66USHW4gsE/1IHhMXNi3QgEPxdUItakf0mqa1tbhZoMUN3gTCoBOlPCVy
	 agcIy6pgpVU4RmjJRNX3gUAb58PVanwuxJtQC2Dy18JmpAFoKAD+ySeMewdj+8dYvr
	 embTxpLuI8ShmreQjOrq94ICq4vwJusVYvB9qyz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	KaFai Wan <kafai.wan@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1402/1756] selftests/bpf: Use _exit() in uprobe_multi_test clone-ed child
Date: Wed, 18 Nov 2026 15:58:49 +0100
Message-ID: <20261118150105.003537817@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: KaFai Wan <kafai.wan@linux.dev>

[ Upstream commit ce42271dc517baa880352d76548d301850e7385b ]

child_func() terminates with exit(), but spawn_child_flag() also starts
it via clone(CLONE_VM), which shares the parent's address space. That
exit() then runs atexit handlers and static destructors against globals
the parent is still using.

LLVM commit `3c3ed59c6a2a ("[llvm] Add format check for
MCSubtargetFeatures")` [1], included in the LLVM 23.1 releases, added
Target::isValidFeatureListFormat() with a function-local static holding
the compiled regex:

	static const llvm::Regex pattern("^([+-][^,]+)(,[+-][^,]+)*,?$");
	return pattern.match(Features);

The child exit destroys that static while its guard variable still marks
it as initialized, so the regex is never rebuilt in the parent. From that
point on, get_jited_program_text() gets NULL from
LLVMCreateDisasmCPUFeatures(), so every jited program text check in the
tests running after filter_clone_vm fails, e.g. "verifier_jit_convergence",
"verifier_private_stack", "verifier_tailcall_jit" and "verifier_jit_inline".

Use _exit(), which runs neither atexit handlers nor static destructors, as
uprobe_syscall.c already does for its own CLONE_VM child.

[1] https://github.com/llvm/llvm-project/pull/180943

Fixes: d2520bdb1932f ("selftests/bpf: Add uprobe multi pid filter test for clone-ed processes")
Signed-off-by: KaFai Wan <kafai.wan@linux.dev>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261018005348.2195130-5-kafai.wan@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/uprobe_multi_test.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/uprobe_multi_test.c b/tools/testing/selftests/bpf/prog_tests/uprobe_multi_test.c
index 02a484b22aa69..6dbf9816fa3c1 100644
--- a/tools/testing/selftests/bpf/prog_tests/uprobe_multi_test.c
+++ b/tools/testing/selftests/bpf/prog_tests/uprobe_multi_test.c
@@ -80,14 +80,14 @@ static int child_func(void *arg)
 	/* wait for parent's kick */
 	err = read(child->go[0], &c, 1);
 	if (err != 1)
-		exit(err);
+		_exit(err);
 
 	uprobe_multi_func_1();
 	uprobe_multi_func_2();
 	uprobe_multi_func_3();
 	usdt_trigger();
 
-	exit(errno);
+	_exit(errno);
 }
 
 static int spawn_child_flag(struct child *child, bool clone_vm)
-- 
2.53.0



