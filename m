Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056812;
	b=J4JwOG57o/Ixjy9+3xlsGtjLkJ80fFndmJFDKAjpr61lCyLaQEZGm10R2rAu6nHRzDHQ
	 HUpgDM30d3AHcfqHrgYSnhlACv1mqp5vP5+15ZGYrn0Ub4CJfGPs3JwTBVqde5lBGmMD7
	 6zz6fAitCon1Pzk+o+cPV+wpLVaQszDWzvEPWKOxAHwsMbfyFtcQc1ZrKAckr3VHyETpp
	 gqg3au29hKeYWkgi0OX9S2rQXtAd1JJsADUBLyIXqcR11M7RRBmWImI9JKNuyVq2L7RAJ
	 5h2x/+jJDrCUQms7osIJEC8mAJizL38nAxfRS/vFRu+ucD5LH9FZdKXvfqz1a121+QA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056812;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZxtYDXQr960ImMl1vqUh68YIUo42ORNAsWkXzxpUyPU=;
	b=tVN6MFWDUiFVQVk+uDPNy9dEBNRi8GVfJbejxWVPJIEV/dwm0uNO3km9NaTlU5hAjnsf
	 /nxZAc25JJNOAilI3m6GdtueicsoX1OUIkHQEh2Zl24RzWoGcw4l7MfbTeRHljsHAdnPi
	 TD3Sttnrj/6A6Qv9wLZiiBKvtDF6qhPQxE5YynwkOaf7V7y63KA7G+8uTDydH5mQQKGXC
	 VLTkbOlCoSEMMMR4t6cGCdUUu+G1YzZei/dejkzqCUZQwsl/D26jGztFlLAY0a/UsT0RS
	 mGIjPhhms9TjOk9Ctuh62fgXZKszgEW6oaz2QuBwxyDBCgyvqm5EPHHgUUBu6yAW2qw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bUihb7lQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8C5606A320;
	Thu, 19 Nov 2026 02:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bUihb7lQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 441111F000C4;
	Thu, 19 Nov 2026 02:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056812;
	bh=ZxtYDXQr960ImMl1vqUh68YIUo42ORNAsWkXzxpUyPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bUihb7lQTuMtPvgjG+N7jf3s1VdABdD0I8h2aHF1CB0hQp96fBfHlJ6O9xEm2smNw
	 T+qV559OUjNvYXBeaAocXvRV25lWXkU+mo4/6uFMOSyESazoFUJ0XitRqgr4EJgZ0k
	 Dju9W+IWhFwGzpd4sDv8br1OXJuJ4Mh6PQVHk6D4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Yang <yangfeng@kylinos.cn>,
	Alexei Starovoitov <ast@kernel.org>,
	Mahe Tardy <mahe.tardy@gmail.com>,
	Alan Maguire <almagui@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2119/2214] bpf: Propagate btf_add_type() errors in btf_check_all_metas()
Date: Wed, 18 Nov 2026 16:03:15 +0100
Message-ID: <20261118150135.351038668@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 98cf5bf367362..8e9674f625c97 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4022,6 +4022,7 @@ static int btf_check_all_metas(struct btf_verifier_env *env)
 	struct btf *btf = env->btf;
 	struct btf_header *hdr;
 	void *cur, *end;
+	int err;
 
 	hdr = &btf->hdr;
 	cur = btf->nohdr_data + hdr->type_off;
@@ -4036,7 +4037,10 @@ static int btf_check_all_metas(struct btf_verifier_env *env)
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



