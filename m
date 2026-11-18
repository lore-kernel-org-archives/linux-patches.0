Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057025;
	b=hPeUvqEtSGIsi4eKjzu6qSp9UEDYK8yZlVmn3YeCPo5k4wZGb84RsNLUjcZVZ7wLHzu0
	 j4KEf/y8wU45491nU2CSgxldnmSeTqX7H8nqKAUV20oOLoCjAd/BwRHeeQn6Lut5mpxve
	 3xfRR8qQa5WX2ZzbL6t7lLKc74FcWMH5IS9Pi7MWyNL0JuCJT4pL6mmPyWs85o9KG0+OJ
	 y8MxrY/pcLc31/nNpv6EG6h849+MpgjjR1k8PHfc8uUMM1UwFUHpX6D0PQtGEA1CuH7J2
	 FrxiU5Mzp669tB4OT6ggMwRwqyh5wb8vLM1Kpfc9qUpVh8sXKKVLGP1y23JR9L52JLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057025;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JQSH6dn0a+vGt5rFAfdp9pcLKDsnKo73Ie+XgFmVYAw=;
	b=dk63BBC27Th7tY2zngynNbe6tP4QQPMvQR5RCJnBvi3MeGJzisS2l+Wz75Wp4a/Zeasg
	 BEA67UK1d8aKuQZqpZRaiSAnEh1LzNxxtNU0e2k7CdYyGdFYZW510midnKd0bH/+IhHzH
	 kPfNuEUs74EAsz+O0D3emG7jmPHF643VfUEmy6jVTj4WnXOX3wIN2OcKO75dMW4ra1CCu
	 Evk2WfKu33k7PD0FstD0fnnFevXQSJnc3kTct7ZA7ASvHfZVHrJxfweCCfkSsJRiy4uVw
	 zS/1f0NCH6uCdVaQsXEdEkuSVR1h4TMes+BUkUqOFdq+l+aTBen90BhL2bPA0Qw4MrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DXkxTWZZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DCB0606A31C;
	Thu, 19 Nov 2026 02:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DXkxTWZZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B28A1F000C4;
	Thu, 19 Nov 2026 02:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057025;
	bh=JQSH6dn0a+vGt5rFAfdp9pcLKDsnKo73Ie+XgFmVYAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DXkxTWZZjZNbfqd3UUtKFBNgXqOv/AdY9fByIhlghpzqmS2MJOFXdR//zac+Lla5k
	 Ynr+VMJszK+ssZrxCrdF2IE4mu/Huu4dhgS9OOxKlGSoGSvZ+Aw84K83Zl4dHSRcUL
	 3EltJT3q+yP23VhwC3zpSItNBQJ9sMPaKUxyXPMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Maguire <almagui@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2196/2214] libbpf: fix cross-endian build with newer libbpf
Date: Wed, 18 Nov 2026 16:04:32 +0100
Message-ID: <20261118150138.157166085@linuxfoundation.org>
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

From: Dominique Martinet <asmadeus@codewreck.org>

commit 087f3964f4b3 ("libbpf: Support layout section handling in BTF")
added extra data to the BTF header.

This extra data is ignored in the native case, but when building with
different endianness the bswap code in old libbpf would check for strict
size equality, leading to build failures such as this when BTF data is
generated with a newer version of libbpf (through pahole)
    BTFIDS  vmlinux.unstripped
  libbpf: Can't load BTF with non-native endianness due to unsupported header length 32
  FAILED: load BTF from vmlinux.unstripped: Operation not supported
  make[2]: *** [../scripts/Makefile.vmlinux:72: vmlinux.unstripped] Error 255

Newer libbpf versions also properly ignore trailing data in the bswap
case, but the patch is too intrusive to backport, so take the header
length comparison fix from it instead.

Link: https://github.com/NixOS/nixpkgs/pull/570639
Fixes: 3289959b97ca ("libbpf: Support BTF loading and raw data output in both endianness")
Acked-by: Alan Maguire <almagui@kernel.org>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 4d29bd28520ae..f34a15536c16c 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -217,14 +217,14 @@ static int btf_parse_hdr(struct btf *btf)
 	struct btf_header *hdr = btf->hdr;
 	__u32 meta_left;
 
-	if (btf->raw_size < sizeof(struct btf_header)) {
+	if (btf->raw_size < offsetofend(struct btf_header, str_len)) {
 		pr_debug("BTF header not found\n");
 		return -EINVAL;
 	}
 
 	if (hdr->magic == bswap_16(BTF_MAGIC)) {
 		btf->swapped_endian = true;
-		if (bswap_32(hdr->hdr_len) != sizeof(struct btf_header)) {
+		if (bswap_32(hdr->hdr_len) < offsetofend(struct btf_header, str_len)) {
 			pr_warn("Can't load BTF with non-native endianness due to unsupported header length %u\n",
 				bswap_32(hdr->hdr_len));
 			return -ENOTSUP;
-- 
2.53.0



