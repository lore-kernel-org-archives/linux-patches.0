Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016187;
	b=bEW5I8ZHQo+tp+JZJhAro30UcyousW+NM4tP5GgCyaiJQKq3us/Or/3FFMfCRDzgJmZ9
	 EmXuZ/tthOp+EJUUmjEW7n/dfwg61Pf1cKzJdYxSc/iX+ineZr/kw6IqB4TrR4O5jX5Uj
	 SHsXp25wwIF8ooG75GBEpF1k5+b7i15OwYxQssvEd+rLoeuv2iCMTYjgi92ZAocb9ZIQc
	 BPmh/qJi8TgUGwOfiyk19KIIprHr+pSLwQgHo40bduDiOitbRL4d4Do6SEcm/W7j2xwof
	 w9rAbZkZH9Qzbk0+QNAREcWLi9IZmfwsnyHZYV3YqDpSvCplA/coutg7Y0ypoQ/PgRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016187;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H5LpKUkjqRbeIeTUbvISCOJ0/VB+kL+0fgXIOECsII4=;
	b=YIb9Rn0QmA55I5cFHlzbOvxS1OkrAlQYHMcDOcZG4F0enzqM881aiBeh1zeF/NWzAYbq
	 jUNoH6qNVSYBi/nzqlYmAf5Rc5jF2exzKDHdvqQdG683OVvF08sptutnFZ5HTSGhJ92D3
	 jy+Ou0Rj6+Yc7ox9GokxiM/rSiHH6WbY7P31nuRgPyJs9zWuAFawQRFHIrLwWR4tZuqoo
	 4WSTdVVVUO582nVzcpCX5Fntjb9dbUqGIkxt417x1OFezYHgYNklJYIyL7rMHt2Mi7vOw
	 DdCx2ytgMLHLKVwfzIIKr89VG1/QBrFcxGcaFDPtyfKDPSZuDl4BO0UaeN/7+6DGt6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QvXp2iQU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07286606A32C;
	Wed, 18 Nov 2026 15:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QvXp2iQU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57A901F000C4;
	Wed, 18 Nov 2026 15:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016186;
	bh=H5LpKUkjqRbeIeTUbvISCOJ0/VB+kL+0fgXIOECsII4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QvXp2iQUbW6rxsiFDXxIVi+xKExwoXbGF40IOpNYpcPzPGcPzh9SOYkRPfrV3kray
	 24JuXxh2qVB3INv6tBp+JALhy0GEWcmsg08kx010ShDrJBGP5KgJLokw9u8zqmQ0E6
	 C6cRNgbKx+hL9bmbDWyHYem0ePMFnnSKWcVKsmWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0441/2651] bpf: Read a kfuncs __sz argument only when it is in a register
Date: Wed, 18 Nov 2026 15:28:01 +0100
Message-ID: <20261118150303.696720775@linuxfoundation.org>
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

From: Yonghong Song <yonghong.song@linux.dev>

[ Upstream commit afe897e89918434be8600250dbdda977aa99f53d ]

Commit e0b7b91c72db ("bpf: Support stack arguments for kfunc calls")
supported stack arguments for kfunc's. In bpf_kfunc_stack_access_bytes(),
the size of a ptr + __sz pair is read from const_reg_vals[] at index
'BPF_REG_1 + arg + 1'. Past the fifth argument that index leaves the
argument registers and reaches 6 through 9, which are the callee saved
registers R6 through R9. The verifier does record constants for those,
so a __sz argument passed on the stack can take the value of an
unrelated register as its size.

Fix it by guard size_reg which has to be less than or equal to
MAX_BPF_FUNC_REG_ARGS.

Fixes: e0b7b91c72db ("bpf: Support stack arguments for kfunc calls")
Signed-off-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/r/20260912195201.982215-1-yonghong.song@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index bc87b15d4556c..729dc8e072ea3 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13600,13 +13600,14 @@ s64 bpf_kfunc_stack_access_bytes(struct bpf_verifier_env *env, struct bpf_insn *
 		goto out;
 	}
 
-	/* ptr + __sz/__szk pair: size is in the next register */
+	/* ptr + __sz/__szk pair: the size follows the pointer */
 	if (arg + 1 < nargs &&
 	    (btf_param_match_suffix(btf, &args[arg + 1], "__sz") ||
 	     btf_param_match_suffix(btf, &args[arg + 1], "__szk"))) {
 		int size_reg = BPF_REG_1 + arg + 1;
 
-		if (aux->const_reg_mask & BIT(size_reg)) {
+		if (size_reg <= MAX_BPF_FUNC_REG_ARGS &&
+		    (aux->const_reg_mask & BIT(size_reg))) {
 			size = (s64)aux->const_reg_vals[size_reg];
 			goto out;
 		}
-- 
2.53.0



