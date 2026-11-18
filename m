Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042397;
	b=ttuXglIy9dmE703AbVUQmyBtiD+/uMn+0WboUW1+zqBgSubEozjzE3cXK293iprxV6ys
	 9D48WiRwx6Gg2hrF3JGvX3MsiMcGcE7RxExpsWlPVZsz6Qtud71rcQqhnR+72bmISKroj
	 FmyVW17XXKRSTr5rvX3r6T4trmNSlgE30BnQ05Dk0V4pKXCQHLF0sPGet5DDQ2LbcRy8+
	 8WnDrI7DRwhG2JQpkxNXzrq/yFr7hqofLdzVtk98ABkwlB70jizB96lGnc+4FFcTPSijQ
	 OJAGsdGEzzP0WYlrNv28MqdK6KKSRr8i6m9ImUTKO+m42HwTrsQVwSIT/dvVqmCTgHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042397;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MbCcXBGW6/+7XKLE9oYkHcI68SAf5bQ2x2WkSHHSKl0=;
	b=uKofVZLbCNhfR1v3esJ0AcAdBF229is1qps0oUh/38XS1XhHuO0b+zQMQvRacpIehBx+
	 cVcodmpPaCVlshBB6gLE/zCtQPvXN/CVS64hBVeCIQ+OnB8cnOxwXmCojLkf2QScBlC/f
	 C+UoJapUMWXy3j9RtIeigUWFzxPb9lb7mLpUgVnGhpwE/Ox+pMxJ8jKXsTyyyNxSohkpT
	 FriMvIYHmpTQwd1g+Yl4Q5Wb0lpWS78m5k6qP/rvcy25QamK8RVN2KotrIb+bNR7jQ4kN
	 0BHJw5hz4yerZfc+FWArqAlraBkfS0nOl/23UQ0SQYdibBjfH8l3iIQRD58eKE6jTtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pUfHaMSG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E20606A31C;
	Wed, 18 Nov 2026 22:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pUfHaMSG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F2861F000C4;
	Wed, 18 Nov 2026 22:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042397;
	bh=MbCcXBGW6/+7XKLE9oYkHcI68SAf5bQ2x2WkSHHSKl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pUfHaMSGw7PD1n9I1rCxHPzz/kSi75aysOHXIEB/Y/NKUB8ZHA8Azc16Hil498uqO
	 pJO0vQrJSmF7b5kbyfNkyAi/LibOvAtY2nJJsEaV6dqKiNfisz+3DtVrpLQgsDBiQU
	 9EoeL3g43INRWhwdTwcc44pdcCGCXl6aZIkbl+Nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Yang <yangfeng@kylinos.cn>,
	Alexei Starovoitov <ast@kernel.org>,
	Mahe Tardy <mahe.tardy@gmail.com>,
	Alan Maguire <almagui@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3154/3318] bpf: Propagate btf_add_type() errors in btf_check_all_metas()
Date: Wed, 18 Nov 2026 16:02:56 +0100
Message-ID: <20261118150454.483126536@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 27d99d40af859..6e03ba710f11f 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5033,6 +5033,7 @@ static int btf_check_all_metas(struct btf_verifier_env *env)
 	struct btf *btf = env->btf;
 	struct btf_header *hdr;
 	void *cur, *end;
+	int err;
 
 	hdr = &btf->hdr;
 	cur = btf->nohdr_data + hdr->type_off;
@@ -5047,7 +5048,10 @@ static int btf_check_all_metas(struct btf_verifier_env *env)
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



