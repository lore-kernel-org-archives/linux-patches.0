Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017446;
	b=hLtx178ADgh+p9wswg8UBhdEpuq5iV5rX//mTp3iaPBOyNilZKSXdvXLQ0fr1qfJ9Y9+
	 JL+WC2UuEWtLv070xangjHqg2Jx+YYgW/lzdPiXIUfoBgQRft1ZpNb+f5km+SIasV9iJ3
	 w+x5NI6Tm9av/dFMh5Qs9WDvD2y9JcYa9WZhMn5/IAS+64ybRif7FeM5Tvznggn1R6D3G
	 WhSGX2taLUISR7Po+347SdugAbnklwVSZszcakRv9Kn8BAsNU7jBEOL5jbQqRBnU4mzMT
	 opY9zPZs7EMVSuabHtsB4oABMUtx2oRz6o48gZNPaZuPq6R7tz9fhD43zIqGLOplrkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017446;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iZWEBS5/nCAg8dqaaMTgHZD7DpuMTUDp4J0+48Y5tJY=;
	b=OnbqjOwAK8n5bs+yeveLbvu5PKvXENtwdUb6nuakaVk1jbzFvDcDlBp/JvQpZGvtCJbz
	 ozX3wB0c/jnxt9Jryo7iE6N6eCdgmn3hrLNLwqBtZe3oCSWOrmIFQv3pH+ZbQ5fnxHFOO
	 RXUcU7Tlvbd/krHQmBUyqFtx5weMLJCG7UeXWvxYBiiAjrQb3aNO1wk42LSTPi9bRquYu
	 3N1SrxS83N7GfPzgOGf7QenIiKbroVfeMioBfyKJqvW8BLF57J61ROj0XcXwGJ1vKLK6E
	 rMp1MVuWjXKhHYXalxVoxK2Fe+pguUnMb0wnjnw32pF3uAXc81Ei5owf89qweORwKDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0njZJjSA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94563606A325;
	Wed, 18 Nov 2026 15:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0njZJjSA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB4C61F000C4;
	Wed, 18 Nov 2026 15:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017446;
	bh=iZWEBS5/nCAg8dqaaMTgHZD7DpuMTUDp4J0+48Y5tJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0njZJjSAI03FFWEGbzl6wE0lUyaqYyZvPggYNcSu9qMP77NvtCit8niKElQXpxkeH
	 3OHV0FKtLjBBwtDk5puh1h4/R3LBe0054MWMPVrd9LsdPEoHk+fi6N8accJRWS3qAN
	 kvsL6STJVx+d/Hbhy2ZhYyH9YIas1lDKi9ZJkZrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sandipan Roy <saroy@redhat.com>,
	James Burton <jamesburton@meta.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Anton Protopopov <a.s.protopopov@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0887/2651] bpf: Dont remove indirect jump targets in the nop removal pass
Date: Wed, 18 Nov 2026 15:35:27 +0100
Message-ID: <20261118150319.793493042@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit c48a91c049fd98fcde54880a24c51b9a05f7e185 ]

bpf_opt_remove_nops() drops every ja +0 and may_goto +0 unconditionally.
A gotox target may itself be such a transparent nop: it is a verified
entry of an insn array jump table that is reachable at run time through
the indirect jump. bpf_insn_array_adjust_after_remove() marks it as
INSN_DELETED instead, and bpf_insn_array_ready() skips INSN_DELETED
entries, so the program loads with a hole in its jump table. The x86
JIT, for example, lowers gotox to a raw indirect jump, so executing
that index jumps to the zeroed ips[] slot, that is, to address 0.
Fix by keeping an indirect jump target in place.

Fixes: 493d9e0d6083 ("bpf, x86: add support for indirect jumps")
Reported-by: Sandipan Roy <saroy@redhat.com>
Reported-by: James Burton <jamesburton@meta.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Anton Protopopov <a.s.protopopov@gmail.com>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://patch.msgid.link/20260925175244.1136329-8-daniel@iogearbox.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/fixups.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/bpf/fixups.c b/kernel/bpf/fixups.c
index f8d9b30815f69..6f2c15b47c329 100644
--- a/kernel/bpf/fixups.c
+++ b/kernel/bpf/fixups.c
@@ -679,6 +679,7 @@ int bpf_opt_remove_dead_code(struct bpf_verifier_env *env)
 
 int bpf_opt_remove_nops(struct bpf_verifier_env *env)
 {
+	struct bpf_insn_aux_data *aux = env->insn_aux_data;
 	struct bpf_insn *insn = env->prog->insnsi;
 	int insn_cnt = env->prog->len;
 	bool is_may_goto_0, is_ja;
@@ -690,6 +691,8 @@ int bpf_opt_remove_nops(struct bpf_verifier_env *env)
 
 		if (!is_may_goto_0 && !is_ja)
 			continue;
+		if (aux[i].indirect_target)
+			continue;
 
 		err = verifier_remove_insns(env, i, 1);
 		if (err)
-- 
2.53.0



