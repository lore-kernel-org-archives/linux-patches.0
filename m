Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015766;
	b=ew1lKOL5rHH0+QBel/ay5x0FuzfyuGCEROvSpb0SsXYbTzQhouuT2h5dEfsz3zU7Sxl8
	 Ewx3GXYJn4hDPgxWVAeFzOwxAzfj3HjJkoSLnV2BqrJssfpW/YaXzn4hX+hCgD7r3UINM
	 6s3f/7+Sfp2ieveJl2WowPsPDIhEy8GuM3bBmDm91J+nxiTVithaR6IEGYl/Dee+Vx9CX
	 GyEo+eWyKWRKEsGLZdR+Fu6hDSzzwRJG8YNN5pp/QAg26muRcUJtMvs+CBcabFNIRsoHl
	 642ENgOkFfOZKI3DBjYNcCvkypMoQp3qAqwbRHqRnGMfTBttEvkje2Yjc62WOmTcM2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015766;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0JiuSSquWrN2hCFiO4ltGUNPeHJupis5DNiFLIvgFo0=;
	b=mi1lnbkzO6eiUn0YzZoQyKL5FTmCGSn+ldXCBj3gZuApFQPnZazyfmNBsUNm3te4UrB0
	 /8igZ8g4XxVillqrqNDjdYWMNhe9p40wqB/XtV7wJXAzcnh8fYLkCMgye1p4LsLyx8/SZ
	 cLDjLAZkUQhPHNLM+gRgu7KG4jkO6XNvpZDwkZ1Yuq5KlMqzoR93BnY6UnEKWcILjNZda
	 LQor/4rCwzFXYIFZDGlxMCtcW9Iyc2mswoUEX1pFhBIwQmiwu6CsPlS5qj/fMyIQWqmgM
	 6UeHc95e+92ehMp4oGTrDNK73XphhNISUfDO8fU5y78BBgedMvsQP8Om480eVLcHJDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="unPXr/gN";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 933A5606A31C;
	Wed, 18 Nov 2026 15:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=unPXr/gN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30E61F000C4;
	Wed, 18 Nov 2026 15:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015766;
	bh=0JiuSSquWrN2hCFiO4ltGUNPeHJupis5DNiFLIvgFo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=unPXr/gNACRrnptLtabhAcRguB2NfWVOeGO6lB4qKIuIKo2Sz84Vo8IguJRq3XuF4
	 9Okn2dgb0er4/gaPCzDciYJLL+5ZKmig8y3JdBvm1gdcDf0060L1Ukg0vfwh4AbDnH
	 bUhJs1RbgEPLbJeA5vqv1VCUpLvHnoPzgJb2OSYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingpei CAO <caomingpei@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0288/2651] libbpf: Fix array comparison in BTF dedup
Date: Wed, 18 Nov 2026 15:25:28 +0100
Message-ID: <20261118150258.276069209@linuxfoundation.org>
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

From: Mingpei CAO <caomingpei@gmail.com>

[ Upstream commit e62c5b97d6c4c657d6fad7dd3523fda33a936979 ]

btf_dedup_identical_types() reads both array descriptors from t1,
skipping comparisons of their referenced types. This can incorrectly
merge distinct structs and corrupt CO-RE relocation metadata.

Read the second descriptor from t2.

Fixes: 62e23f183839 ("libbpf: Improve BTF dedup handling of "identical" BTF types")
Closes: https://lore.kernel.org/bpf/CABzjXVz3iBuump-pXFkefZ5v+2uu4fG61zqRyWD4xmz3PuBycw@mail.gmail.com/
Signed-off-by: Mingpei CAO <caomingpei@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20260908164920.108074-2-caomingpei@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index c783359977b46..908bd344229d5 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -4831,7 +4831,7 @@ static bool btf_dedup_identical_types(struct btf_dedup *d, __u32 id1, __u32 id2,
 			return false;
 
 		a1 = btf_array(t1);
-		a2 = btf_array(t1);
+		a2 = btf_array(t2);
 
 		if (a1->index_type != a2->index_type &&
 		    !btf_dedup_identical_types(d, a1->index_type, a2->index_type, depth - 1))
-- 
2.53.0



