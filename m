Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619995;
	b=xIAllPD4pBhc6DODRybFMk3gIDydiysJEjCNp+C9ehshDEEY8vLfGv1bT7nB5tahnLny
	 K6QPGVovm5JJb/wdBik++e3LLe83/klu/PKNA2SO16C6C9KuHgUNeKSnUt9AkOiY7Gqlv
	 hn+CNQEGtU6mtT4r8nMaqOW6cmq1gSUg3JNqMAnySAkIh3FztUjFnGSi66lZkwmB0k8M7
	 v+i+x2wOkEwTN+1emFqvvJQK1hJNOHiktJ+cwTVV+n1buZ0vuOxto0M5b76TcFk35sYMt
	 VsjJAqVZuNkPkQyTRQpcbcDNCqX/E63ragq8qsQskCdoWIHFddym7/UBdksMx641R7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619995;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gqpIrQ7KL5Pk92pSqbZulfmTDquM/rS6tt/bxDqrKZo=;
	b=H9zdXka3tEIGinSRnEtTFKe9GouchoEY3PD14ZfNrSQqcTatiEGvcAdZ3MsYbPM7Bzme
	 38Ujy7etZHXh8fXj7w9DUMpTC9wUollpasJd8NAFPKts6yCOhITX4lxxpxhAzhZaXPe3m
	 xd4EG172ksupKM+XgYZDLvr+FUVXnl8S22vIkFsm0gOoQ0p5TwQscmIIqHuLV5NuNIeis
	 U8t7Y9f+I6GXFbGRjxF89aWRKvo2z/w8ghoi0/YK7id9sQ17Nol0cOxwauTjT0bntU6fw
	 dWrq29JSFm8xyyZJg+/g2MX91hTLn4ZaUkUNMHTN9NIlBFKq5EA4FdV0kcZxRPpqzKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VKCiNHj2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7186C606A31E;
	Wed, 25 Nov 2026 15:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VKCiNHj2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6632F1F000C6;
	Wed, 25 Nov 2026 15:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619994;
	bh=gqpIrQ7KL5Pk92pSqbZulfmTDquM/rS6tt/bxDqrKZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VKCiNHj2m+yVSqRTI5FyefqVoKznToh5Bg/0p7dSsGBtsA/HkEm+ZNQcHlsZNhpEi
	 E8uqJqkhGU2u22tKUfzqrIk2bZlybJO18hJq5LyzlnQBH93tU7So2GfsZmBbjiXsfN
	 ESMGGKoi0ujMF9XAvH8eEALd07RpbfQq4NXHfXT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 7.3 0773/1005] LoongArch: BPF: Make arena support depend on 128-bit cmpxchg
Date: Wed, 25 Nov 2026 15:35:11 +0100
Message-ID: <20261125143839.852490270@linuxfoundation.org>
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

From: Tiezhu Yang <yangtiezhu@loongson.cn>

commit 9496832b824ab5f570c86d65e3b6f08163e6908b upstream.

When testing bpf selftest "jit_insns/cast_to_user", there are different
behaviors on different Loongson machines.

(1) Loongson-3A6000
  $ sudo ./test_progs -a jit_insns/cast_to_user
  ...
  Summary: 1/1 PASSED, 0 SKIPPED, 0/0 FAILED

(2) Loongson-3A5000
  $ sudo ./test_progs -a jit_insns/cast_to_user
  ...
  libbpf: map 'arena': failed to create: -ENOMEM
  run_subtest:FAIL:unexpected_load_failure unexpected error: -12 (errno 12)
  ...
  Summary: 0/0 PASSED, 0 SKIPPED, 1/1 FAILED

This is because the arena range tree uses kmalloc_nolock() API, which
requires 128-bit atomic cmpxchg. This feature is provided by not only
hardware SCQ extension but also assembler support on LoongArch. On CPUs
without the SCQ extension, or if the older versions of assembler do not
support the sc.q instruction, arena map creation fails with a misleading
-ENOMEM error.

Since system_has_cmpxchg128() and arch_cmpxchg128() are only available
when CONFIG_AS_HAS_SCQ_EXTENSION is enabled (need assembler support), we
guard bpf_jit_supports_arena() with an #ifdef block to preserve compile-
time robustness first, and then safely return system_has_cmpxchg128() if
defined, otherwise falling back to false. This ensures that arena map
creation cleanly fails with a -EOPNOTSUPP on the systems without either
the assembler support or the hardware SCQ extension.

With this patch, here is the test result on Loongson-3A5000 without SCQ
extension:

  $ sudo ./test_progs -a jit_insns/cast_to_user
  ...
  libbpf: map 'arena': failed to create: -EOPNOTSUPP
  run_subtest:FAIL:unexpected_load_failure unexpected error: -95 (errno 95)
  ...
  Summary: 0/0 PASSED, 0 SKIPPED, 1/1 FAILED

It is better to mark the test status as SKIPPED rather than logging a
false-alarm failure if the feature is not supported, but this belongs
to a separate bpf selftest patch.

This is similar to commit 536b523b4073 ("bpf, riscv: Make arena support
depend on ZACAS").

Note that BPF should not depend on a SLUB debug-mode escape hatch, so no
need to consider the slub_debug exception.

Cc: stable@vger.kernel.org
Fixes: 4fdb5dd8aeba ("LoongArch: BPF: Implement bpf_addr_space_cast instruction")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/net/bpf_jit.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/arch/loongarch/net/bpf_jit.c
+++ b/arch/loongarch/net/bpf_jit.c
@@ -2436,7 +2436,16 @@ bool bpf_jit_bypass_spec_v4(void)
 
 bool bpf_jit_supports_arena(void)
 {
-	return true;
+	/*
+	 * The arena range tree uses kmalloc_nolock(), which requires
+	 * 128-bit atomic cmpxchg; this is provided by not only hardware
+	 * SCQ extension but also assembler support on LoongArch.
+	 */
+#ifdef system_has_cmpxchg128
+	return system_has_cmpxchg128();
+#else
+	return false;
+#endif
 }
 
 bool bpf_jit_supports_fsession(void)


