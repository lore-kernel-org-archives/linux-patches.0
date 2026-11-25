Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622664;
	b=zLIORjlgXwI1MtDUWq7jZcRB5jVRQ7twwmOB+rfHAQWLu6H0DU5RO8H6g6T72BaiWCX2
	 1mBhETjPoaiyw6EYa3ixPMap2LAkOFEv5CyCiVOwaDBZMijIDT+efUR3IthgNv/HT5NZA
	 3t5RnoS9kbZOGsckvL84dEco83FSZvXLcBVSSiH9I/wFRMp0ThTBkVOAZ/+ZsZYO6B3Y9
	 U2PS2lvhEt+iXIPXvkMhX1X5ROa0xq0qr9QVPC3UGfElTUbB9j0pbQpsVEb9SlaVyehOl
	 0i2a/CAIUuFgcrgUbExLYnmOiMyJa7n7d//96NlOLP8VTjO+bQgxjS1nxQqfSdWTQQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622664;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EcOYwbqFI3YcgNtvWZyd2va1bTRcfJeo6a6Ln+wmDEw=;
	b=omKyvuYF8nqnPz92SsbAPsAPhDmowHv6UjY05L8EQRO+3IOM8O92RvhjkTND31wJREg8
	 MF5Uq/6B1l+pRVtzXhhV3HWXAIHqAUhGPkG9gkdsqbmYjqc1Fkb8qwaykKgsXF4SdMgu5
	 +65V1TRL2P8fgEE/tPiHx5H6U67wt0t9w0SItgx57M/IijZ9s1snMMKUq7J9vSqjs1I+F
	 5hAq4AYIuI+KcZGWV17DTp6kBfR0P/n6sI56D6TKKc+Rrdcn8uQktnHeiCsgsuzr32+Jk
	 GXq3XplWKpxJK5nUOhm9v0K8iUsDQqyqqF/Z+3wRLqu5/HUkzgcGk/r22PKFYTqyMLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EZwAOFnn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B6C606A31E;
	Wed, 25 Nov 2026 16:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EZwAOFnn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FFB61F000CA;
	Wed, 25 Nov 2026 16:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622663;
	bh=EcOYwbqFI3YcgNtvWZyd2va1bTRcfJeo6a6Ln+wmDEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EZwAOFnnlEUJD6gTb1nVBcvujuj4ttyp8vvU3l3D3oGQkRqWG2EFUudYhLI52B4sx
	 4rmK/tguqYPgS90pLRlXFJ6quPQzm+/6X8iUEdZ0yE2yFYcgXhjQDX7pDCI4d0QndM
	 xIqVh1dzzGxS/buLEK0VPOT9nCEYa/+MPIjwNAtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Woojin Ji <random6.xyz@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 610/990] bpf: Zero-extend the index in inlined bpf_get_func_arg()
Date: Wed, 25 Nov 2026 15:32:57 +0100
Message-ID: <20261125143836.381556949@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Woojin Ji <random6.xyz@gmail.com>

[ Upstream commit 1c1dda9ba9f3af9cd511a197dcc86de2465d8fe5 ]

bpf_get_func_arg() takes a u32 index, but the inlined expansion compared
only the low 32 bits of R2 with the argument count and then shifted the
full 64-bit register to compute the context address. R2 is ARG_ANYTHING,
so nothing guarantees that its upper bits are zero: an index of
1ULL << 32 passes the bounds check as index zero while the load is
performed at ctx + (1ULL << 35).

Shift the index as a 32-bit value. When the 32-bit bounds check passes,
the low 32 bits of R2 are below R0, and R0 is at most 255: the trampoline
arm masks the argument count with 0xFF and the raw_tp arm uses the BTF
argument count minus one, which the verifier caps at MAX_BPF_FUNC_ARGS.
The 3-bit shift therefore cannot overflow and it clears the upper bits of
the register. Widening the comparison instead would reject indices whose
low 32 bits are valid. The check itself is unchanged, so this cannot
change which programs are accepted, only the address that is computed.

Fixes: f92c1e183604 ("bpf: Add get_func_[arg|ret|arg_cnt] helpers")
Signed-off-by: Woojin Ji <random6.xyz@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261018-get-func-arg-v2-1-048848b3eddf@gmail.com
[ sashal: Replaced a 64-bit shift with a 32-bit one in the inlined bpf_get_func_arg() code in verifier.c, since the fixups code isn't split into its own file here. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 0d93bcdcef81a..a004c95969636 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -23475,7 +23475,7 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 			/* Load nr_args from ctx - 8 */
 			insn_buf[0] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8);
 			insn_buf[1] = BPF_JMP32_REG(BPF_JGE, BPF_REG_2, BPF_REG_0, 6);
-			insn_buf[2] = BPF_ALU64_IMM(BPF_LSH, BPF_REG_2, 3);
+			insn_buf[2] = BPF_ALU32_IMM(BPF_LSH, BPF_REG_2, 3);
 			insn_buf[3] = BPF_ALU64_REG(BPF_ADD, BPF_REG_2, BPF_REG_1);
 			insn_buf[4] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_2, 0);
 			insn_buf[5] = BPF_STX_MEM(BPF_DW, BPF_REG_3, BPF_REG_0, 0);
-- 
2.53.0



