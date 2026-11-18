Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023223;
	b=iO3EfXf81Bkt3nM83/Ajy29GYznOMD4dUMugdoMkDs8mzqHFh8HEuYBK63xx8I0QvvQd
	 TzkYcz0gXAjBUqAwzxAd7slbNyqwvsbiYA3/RqSW8gVLEhECTmfx4WWQlzGJaWpFXYCOv
	 vTV5eFrqgApnhvYY6Wut+nKVWBL1RFSvEtG/vNB47oEcMF9S3hduJ1VcZzDByyrJZ2fbE
	 4NV80vO9PVQ6YysNttuP2NryYV7i14cU7JDaSGCCcXbO8hhTvbpyyeQ1W/F9HaDEKLN10
	 O2piZR9iFzeyK68QNTO8SeA+jgJiuqejUdTB3LptqGtymrON9UqPuscTcq+1Fp+1YyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023223;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GnIhAZeNPrsyNM7kzDxTCDtEpPU3UbhwmestdqlQDpY=;
	b=YDnH89yBCR3+qpRtaac4nbVI5mi61cHmuRI9KjluK1lAJeq+0/EyTU6F3UoKp4wOYMCM
	 tBaInGl0ORh6ncyolP0ni/dM+Qv5vhMqhJvnooygvGNTH1SI2kLxxpSYumlLjjebRcGNP
	 NLYITpDn74BLzp1eigx9h2pCGUxz0CtouQMRb+nXoUHYlr0CNWO5if+kZK90mBlGHgxIr
	 e02EZzB2561e9EGpIDdWECl+A4GmpMU2KDEai8G8+lutFS0WMBCVAJm/n5tM0Ei4ENEW8
	 of3ZhYJDF2rCdXN76UD4vX57eNXRMHPKbMTBjpqe/MmoABiOiopU3SJjQLCNor2HDVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="K1z/DHcm";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929D6606A320;
	Wed, 18 Nov 2026 17:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K1z/DHcm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E19981F000C5;
	Wed, 18 Nov 2026 17:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023223;
	bh=GnIhAZeNPrsyNM7kzDxTCDtEpPU3UbhwmestdqlQDpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K1z/DHcm2fYB/IT9rhw9tStuI36K06zgs5gyB58PAVdaoo3aRO1DkJzIMILfXx+rg
	 m627jA9GRBg09XZn3UCVWJpXge+2KcUZQMDY+Yu0p0wXhQN7lu2nZGKa7SGLvCh8La
	 gFXRpcD/DmyaR8rp1/hUxiLF76TbWOPdSt3Ytipg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingpei CAO <caomingpei@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0290/2151] libbpf: Fix array comparison in BTF dedup
Date: Wed, 18 Nov 2026 15:33:45 +0100
Message-ID: <20261118150132.467611235@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index f1ee53a07f17b..7f3b23aeaaba7 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -4455,7 +4455,7 @@ static bool btf_dedup_identical_types(struct btf_dedup *d, __u32 id1, __u32 id2,
 			return false;
 
 		a1 = btf_array(t1);
-		a2 = btf_array(t1);
+		a2 = btf_array(t2);
 
 		if (a1->index_type != a2->index_type &&
 		    !btf_dedup_identical_types(d, a1->index_type, a2->index_type, depth - 1))
-- 
2.53.0



