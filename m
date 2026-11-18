Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021677;
	b=K/5/EocQ+S515RTPLoj5UwZOFjSuscY1wEp0BJJryQ3ndfwULSIQUiyu4eJb09DT9ekY
	 gLabfIw984ivsgxNMhbNYoEpDphXYDGBIQMFQ8jyT5NNR9IfnZV4Sk13+hHW87wc9JzzY
	 P+0J3cCj/M2Gapp2hzsPonFCrpkVX64dNGzh02msRgY5s9Oe4IfIoNyHo4oZKXp6pEHI0
	 g25/6Wek22vcOrcyxFR9QnNrQZgRCk5o9VRa37+5rzGiN5Ey2I7hMCgDKgJdbD4YQhfbJ
	 Io/mRx2Vhk6f5KutE6av0/GpE12I+4C5Y4qkPuoBL6vFeydOf/IWe0fZcLzxC86DdXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021677;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ss0tZ2VmTGLHKWGWic6GsnEweNvTN7RzkhZqG6d/QBU=;
	b=eOyA/VpIzNrVgjSqTwnnA1Fbd1JqOFUUZeDab3tzYuJC75IvDKG5puJZlr3cb+fNwwH/
	 Gfx6exs1QWWWWi7tT6jfMYfw5r8RoNmx/RqNOyy7OFJXMnu9gBAlsy+g91CMzltqwzyMu
	 6xsKGjnVbyvaCtb4r8R+JjSY13L05CJYzJfxoLZCVLdqIMv19bJy+VAfpnC9NpEBnSBOo
	 R+30kB0vKyWti02IxjzrI2F10ZJVdvMK5v1q5tergRV3Y0gik76+Qjl35F6fIZeYTQ2/V
	 QXcPmYl4U3SZoJeRmZjdBFnBnG3kpYYpknkh/8YQA+WwURY7/HJRi+f6iFrkrogvyew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ehhlPU4s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D57606A330;
	Wed, 18 Nov 2026 17:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ehhlPU4s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F9EB1F000C9;
	Wed, 18 Nov 2026 17:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021676;
	bh=ss0tZ2VmTGLHKWGWic6GsnEweNvTN7RzkhZqG6d/QBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ehhlPU4seWr1/plSHJzU5nFdgRXZ33DMCu+Fl2C52ijPQm2uPZbWwRnGMbkF9S1iX
	 EytDnRp9+hDJ7l8YjndXwlnjeZk2PxiEizcbTQAOPf1qEHXv2+Na7clywzy50xCXgR
	 RNuYufPwRqAxMmMyODSVc8HHb5WV9qoE0OK/qXA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Yang <yangfeng@kylinos.cn>,
	Alexei Starovoitov <ast@kernel.org>,
	Mahe Tardy <mahe.tardy@gmail.com>,
	Alan Maguire <almagui@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2391/2651] bpf: Propagate btf_add_type() errors in btf_check_all_metas()
Date: Wed, 18 Nov 2026 16:00:31 +0100
Message-ID: <20261118150411.477828671@linuxfoundation.org>
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
index b1adb52e2f310..85b8a667dd547 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5471,6 +5471,7 @@ static int btf_check_all_metas(struct btf_verifier_env *env)
 	struct btf *btf = env->btf;
 	struct btf_header *hdr;
 	void *cur, *end;
+	int err;
 
 	hdr = &btf->hdr;
 	cur = btf->nohdr_data + hdr->type_off;
@@ -5485,7 +5486,10 @@ static int btf_check_all_metas(struct btf_verifier_env *env)
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



