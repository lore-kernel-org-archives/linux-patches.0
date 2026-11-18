Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031388;
	b=owY1Miq3Z7IV8LvESN3Kc6gN1wtxcFrQiCHDZqPJZddtFBHk9W1I0dMhveX2sp6WFZ6H
	 zXRK2DfZxPzkgBZVtMRpk3H6X9HE/MVNOyBb7nD2YvSVWFDYgC6tz6JkY7+3OkeyN5BC1
	 ijGU91ssxxl6yC4MbOcuoWnOBUnZDlacmE+QaCymbjIXqZqq9rYh3E5b3aHuTUe7DTYtx
	 T+CE/RWKhrZYOfieguxYfBytPwgjChktI8KNXsb51v6CGotTvVO4sUsHEOMUdXV7Opxjr
	 qf+BQ2YiJomEvOMAdOgyjyHqaSnh4V2wB0avMP9gn7TjFCQcvqxrNx1i5/WBsWpK0dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031388;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7VRawNFIR9IWs3h1vArAcFBoGkIpUOieunXQSgmbVzE=;
	b=n794OiAJZp+PhiJnANAY8bFhGMHUwIOOI5nVkfNlxVTxLtvX3McKE/LV0IJJrUsKwWHa
	 yJlzHQfuF3h6YuQr5xJmKQepqlFjq9hn4H723wfQsT1/p5FBlqT4TygpaGAI703zWTXKu
	 A6Oqfk271TBEwh7o7+9pLq49bjGPG8aFMjeKKSc/LGjNWB/YGc15rREmWbUUMBj6zRdRi
	 92dLMNtTPM7xRGl06WFuNZ+ybEgMZFSaDySPKU2m0TBOQgm8mrMEB1xz66N8ej5+AG7oj
	 x8ZTU79WYYCCCf3VSfcnzs0nNtzCCuy9buM5asAojriY99O0GfPAQFET2jpgiNNLxaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DDbeziaJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB7E606A31C;
	Wed, 18 Nov 2026 19:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DDbeziaJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF1591F000C4;
	Wed, 18 Nov 2026 19:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031388;
	bh=7VRawNFIR9IWs3h1vArAcFBoGkIpUOieunXQSgmbVzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DDbeziaJBjRUjvDaBfsmVtseAGbjnG6k6cnX3Fqdnbsu5jeAyKrUnpkyStYqro3Jj
	 eA05uwPj/oMhrbzRJFBlKcEtVc1L9lBfLmY9GxsyrKEXrtnKifMT6GoY7OhOHLsPBb
	 zb5SGj3uZ6msiaez1cRsDi15mLsdlIPrhd6L5zBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1014/1756] gpu: buddy: Drop the stale @p line from the gpu_buddy_print() kernel-doc
Date: Wed, 18 Nov 2026 15:52:21 +0100
Message-ID: <20261118150050.508647454@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit b7027ff72c2fd4f7697a00b854c882445e9150b5 ]

gpu_buddy_print() takes only the allocator since commit ba110db8e1bc
("gpu: Move DRM buddy allocator one level up (part two)"), but the
kernel-doc still describes a printer argument and kernel-doc warns about
the excess parameter on every docs build.

Drop the line.

Fixes: ba110db8e1bc ("gpu: Move DRM buddy allocator one level up (part two)")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
Signed-off-by: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
Link: https://patch.msgid.link/20260907012125.21209-1-kmehltretter@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/buddy.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/buddy.c b/drivers/gpu/buddy.c
index bf5920bd22580..158f54e82547b 100644
--- a/drivers/gpu/buddy.c
+++ b/drivers/gpu/buddy.c
@@ -1291,7 +1291,6 @@ EXPORT_SYMBOL(gpu_buddy_block_print);
  * gpu_buddy_print - print allocator state
  *
  * @mm: GPU buddy manager
- * @p: GPU printer to use
  */
 void gpu_buddy_print(struct gpu_buddy *mm)
 {
-- 
2.53.0



