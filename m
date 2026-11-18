Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032817;
	b=OZ7VvTDYLM5WOnCPc8QmLGgy7kkRZztMSVu/cNsjoNvOiXzqn2F+fDjRQK6S7kqSyWUG
	 FZYOuTJZYCbhMhPz43m0yVV4MXoP1Cw9TsalZSIMg5qIbdvuuiiyfEmNrVEwjC492VRtj
	 deEyjYHHNUnu+kCYy/IFKeuBpilpKtpkltVE7z+hzuXlOlXxYncjIJPldgjCSrlzkeX89
	 sPrKTbPycHYnBye2+jZ4bQuyqip/dcYpqDIeARRjD7ikk5hv4pFfZq4p0gnbxgjzhbEUQ
	 biXZk8okOh7RqKP0E/tWgwDbGsUn7U6j0XetqkLxw3oECtBzDiWs4VN9+r1jmMaddTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032817;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gGXAHQ6L76cvrFvqFPJ+ypQpDezXCUQ1j6dHz82S20Q=;
	b=WTfU8BaU5RxDTIYWzKD+H6XugRR4n1SKa8wukLb57cut8IIPnDw2eTV+IMJG/uDfmjib
	 egzIuKcFpNpRFH08otCzqATiGQDWwarn2blu6etmL4Je37/tq8RhC1sib2gEdawNHQrIV
	 xETIatOEtAdKJVSupQ6sbqWdX0J2rzkOz+G+uK8j7gof/MV9LCLDhsq7yAphqQf7hUhOo
	 mYhqfbDC+AEyrJDZ8htrGSGJhGhz8vIryLuvDbdYRLnYUpttMFXax0Yd8mqChpCoZouIM
	 SeE1SfD6gvOVaKiTTguO8R9GRqEx8ZeghWo2zEHyiRtzZCFd/oOu9UX151LYRCkAw+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="MLKcu/6r";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5C1606A32A;
	Wed, 18 Nov 2026 20:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MLKcu/6r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B40FD1F000C4;
	Wed, 18 Nov 2026 20:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032817;
	bh=gGXAHQ6L76cvrFvqFPJ+ypQpDezXCUQ1j6dHz82S20Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MLKcu/6rordry3U+9ythjaFQ371Yfvm/zjPiZPVLlb7+zewwNwNZ+jITKoVsJGcwb
	 N+ikqNSBMp7Smq5+Rzgmuo/KtQjSpBPb5VFnXHpawXYTjcJDKWGhaEtcV31guOZhtH
	 am9rPuFBX0AjP85gwBNyY3umMwyBh0ykBQtZyjlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Yang <yangfeng@kylinos.cn>,
	Alexei Starovoitov <ast@kernel.org>,
	Mahe Tardy <mahe.tardy@gmail.com>,
	Alan Maguire <almagui@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1545/1756] bpf: Propagate btf_add_type() errors in btf_check_all_metas()
Date: Wed, 18 Nov 2026 16:01:12 +0100
Message-ID: <20261118150110.433202725@linuxfoundation.org>
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

From: Feng Yang <yangfeng@kylinos.cn>

[ Upstream commit fb2b27d214c3b88d926a303267dd83cfdb428b13 ]

btf_check_all_metas() ignores the return value of btf_add_type(), so a
type that could not be registered is silently dropped while the loop
keeps walking over the type section.

Both failure modes are reachable:

  - -E2BIG.  Once the types array reaches its capacity (BTF_MAX_TYPE),
    every following btf_add_type() fails the same way, so
    btf_check_all_metas() still returns 0 and the BTF object is created
    with btf->nr_types capped while hdr->type_len claims more records.

  - -ENOMEM.  btf->nr_types is not incremented and the array is not
    grown, so the next type is recorded at the slot of the dropped one
    and btf->types[] stays off by one with respect to the type ids for
    all remaining types.  btf_type_by_id() then returns the wrong type
    for those ids for the whole lifetime of the object, and the last
    type is silently left unresolved.

Propagate the error so that the object is rejected instead.

Fixes: 69b693f0aefa ("bpf: btf: Introduce BPF Type Format (BTF)")
Signed-off-by: Feng Yang <yangfeng@kylinos.cn>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Mahe Tardy <mahe.tardy@gmail.com>
Acked-by: Alan Maguire <almagui@kernel.org>
Link: https://patch.msgid.link/20261022064727.747304-1-yangfeng59949@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index eff94cebfedd9..8956f2fd0c57d 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5268,6 +5268,7 @@ static int btf_check_all_metas(struct btf_verifier_env *env)
 	struct btf *btf = env->btf;
 	struct btf_header *hdr;
 	void *cur, *end;
+	int err;
 
 	hdr = &btf->hdr;
 	cur = btf->nohdr_data + hdr->type_off;
@@ -5282,7 +5283,10 @@ static int btf_check_all_metas(struct btf_verifier_env *env)
 		if (meta_size < 0)
 			return meta_size;
 
-		btf_add_type(env, t);
+		err = btf_add_type(env, t);
+		if (err)
+			return err;
+
 		cur += meta_size;
 		env->log_type_id++;
 	}
-- 
2.53.0



