Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062052;
	b=sA2YSF+Cx0JfBb6yirBLslVDzJm4QzDFv7ZcgfobMXeBSaBqAC673+BEi5efexroZGXb
	 lI148Q6J1o6PnsnlWm2LhkB4axip0GUHIiuZXKoJIlSMtvXmf4TkTiM5EOv2m3w8IA3u9
	 WwcQltb+NHXM88eg5tSJl+pcedXyr4xWWgc98ELy8BJcBLlCZw+RxFIxwiqa84Q5DxYYi
	 JY4sMmCwGvQrtcoI9Sft8Mu5QH3CnkBk5Efj2UtZB+1zKJGAV6WNM3H9e480UxGhjIIGI
	 wDzOPNlUV8YhEPljAHHfmvXO1xbCdr+e4dGQy6IWzcY6F0nnZ91qW2nu0OMihBtMnFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062052;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m6/uG+//wDUogXKunPLxTMj55WYoTtKRp4lybeuUVW0=;
	b=cam1jzO+TN78BDSn+Q+4dCeiayeUd9wmbVMR02Tca7RY1YkI3QbR/NoSaOzipBDq13fY
	 gTJIYDGI7BZvRc7jfVVvp9HeahiPnJJ2oLNLWtJsFsJAeasgIseMRU1iRvEgR6beUzPP3
	 w5W3M0rVz5POmzDZQAcYSPYBTpv/ql6wcTWDNeSlJRkQ+D8vQ1ujzo+4zamFQDYr0wovQ
	 MC9/1X0PhazAuVPFSpyopCfuoJvYcwGeeFQoAVTO71op2RKEJCsbl3eU8nPYFxqzVMOE+
	 3IuiFrh5dcVAVwyTtSphjfSN9vI/a1/s3eK13rdyBJ870Qsl8mc6UsFUvRAg+e34lOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CU+sfEnN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34392606A320;
	Thu, 19 Nov 2026 04:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CU+sfEnN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89DD61F000C4;
	Thu, 19 Nov 2026 04:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062052;
	bh=m6/uG+//wDUogXKunPLxTMj55WYoTtKRp4lybeuUVW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CU+sfEnNSLVHIfA/Q/f78Lmpoj1TshB5dpNFdO+fUj3p+GHtN0yJO/5P2b67kzdNg
	 6V8VPWaKMhJqKEwyCW45iCN+ZFL+cHrHRp8bRT+xEq+ICkBE2x277v9EFqwjPz9inU
	 5bSUAsTPtAf1ZlJ0Ny/FZ3dTdJQcJnnROdfO2nwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Yang <yangfeng@kylinos.cn>,
	Alexei Starovoitov <ast@kernel.org>,
	Mahe Tardy <mahe.tardy@gmail.com>,
	Alan Maguire <almagui@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1770/1848] bpf: Propagate btf_add_type() errors in btf_check_all_metas()
Date: Wed, 18 Nov 2026 16:03:28 +0100
Message-ID: <20261118150033.499047863@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5d9d6678d1a0d..37b9b5eeadc8c 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3823,6 +3823,7 @@ static int btf_check_all_metas(struct btf_verifier_env *env)
 	struct btf *btf = env->btf;
 	struct btf_header *hdr;
 	void *cur, *end;
+	int err;
 
 	hdr = &btf->hdr;
 	cur = btf->nohdr_data + hdr->type_off;
@@ -3837,7 +3838,10 @@ static int btf_check_all_metas(struct btf_verifier_env *env)
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



