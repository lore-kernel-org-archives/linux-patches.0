Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021029;
	b=KNtnBiy7xBjXG6YsU5tBYhwUe0BJ+ISDYCPMAizbU0XU4fuIOy0EKNXv2y+bNHGHhZ9E
	 xblvsmHD2S76UFU4AIXIdkIH6uthNlUBwUKamfxcmVN13Oosik918ckulLHHxuv0PYAHF
	 252o3lHogTLSCG1k1WAvQxWtXtejcOFYyFED2kTAN/iDEOPA5SQfjDcLpx1/1lehsgOBX
	 KlE+NSvDWtGLmshIWjHmjPKT/LNU1YV9GHvPL+zFGE7gk3f7dMqFBzpeCAYyeTMnOeuZ2
	 TCx9t8X26p7yVmfp+j1JCOGByn+qvX4+FnTpEk0qzbMePIBCjWTDT0u4cCPsg6PowTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021029;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=C088xyeXSLVrD4hmcveEg9PBI3Qqsoc5giKQyHSE7lU=;
	b=k6HOJdb5tk65b9DuoW+BpW+iVi7HazrsohdkFw8TCDTQqdGRqJ7gjA7aMdgUQEHw0x3f
	 k5k/lumt7Fo30DDWzmPiNDl/7hKtoLTWbN1Ja3Y/eL97/k8hVuGhyjhUSBlsz4RQml5WN
	 WiafJ+hP6F8G3XCW+k2w5vdUkPgvv4//vHVPO8+jcOPOBnq3pgZmhUQdgDU3DspVQsm1P
	 ZvjJ3BDJP7G6M6y//LobWWHrj9KqmwHdga8XUklHkrm6HiWTxeS1x8motBPDM48uPcbhd
	 zOV2UicRv8s821c+4aPUVupzjiocRapQKt1+rxdrJCxxSQ/2zqvbAMVotU+M+L5sSIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZNmlkSg1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76EA1606A325;
	Wed, 18 Nov 2026 16:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZNmlkSg1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBEE81F000D2;
	Wed, 18 Nov 2026 16:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021029;
	bh=C088xyeXSLVrD4hmcveEg9PBI3Qqsoc5giKQyHSE7lU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZNmlkSg1fB2G95jQ/j0srf2V4Q2gPfF0p9H0J9F9Xh212MwH/Q2TmFXqZG7pzeIa3
	 sl5r3NRgpVSkOjTyojPiPanwSFBWCk+S1JoLOKNCGq2qK7qOgXdqcjqOkun7Yh9iSe
	 IbizH+5pPwdMxmMr7tn2e0D1dvKTQKw35xOBSL9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2162/2651] netfilter: nft_set_rbtree: narrow down range completion to anonymous sets
Date: Wed, 18 Nov 2026 15:56:42 +0100
Message-ID: <20261118150403.648606799@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 86d47d4c84a1b8470ba3fc16df13ea2a220b74ff ]

For anonymous sets, when adjacent ranges are found, the end element is
not added to the set to pack the set representation. Use next start
element to complete this interval.

Jérémy Jean says:

Consider two ranges in a netfilter verdict map:
* keys 10-19 accept packets, and
* keys 30-39 jump to chain 'victim'.
Now, delete the end marker at 20. The lookup array now uses element 30
as the first range's end, so an INTERVAL_END query for key 15 returns
element 30, including its jump verdict and chain pointer. This can make
KASAN reports a UAF after the GC releases reference chain for 30 that
has expired:

  BUG: KASAN: slab-use-after-free in nft_verdict_dump+0xdd/0x110
  Read of size 8 at addr ff110000009dfb58 by task repro/50
  ...
  Call Trace:
  ...
   nft_verdict_dump+0xdd/0x110
   nft_data_dump+0x4d/0x80
   nf_tables_fill_setelem+0x30b/0x8a0
   ? __asan_memcpy+0x3c/0x60
   nf_tables_fill_setelem_info+0x1b0/0x200
   nft_get_set_elem+0x3fd/0x4b0
  ...
  Freed by task 24:
  ...
   kfree+0x1a5/0x280
   nf_tables_trans_destroy_work+0x2cb/0x520

Fixes: 2aa34191f06f ("netfilter: nft_set_rbtree: use binary search array in get command")
Reported-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Link: https://patch.msgid.link/netfilter-devel/20261005200404.3544062-2-Jeremy.Jean@oss.cyber.gouv.fr/
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_rbtree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 12431b55752fb..fbe1750f1ca23 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -1091,7 +1091,8 @@ static void nft_rbtree_commit(struct nft_set *set)
 		 * representation. Use next start element to complete this
 		 * interval.
 		 */
-		if (nft_rbtree_interval_start(rbe) &&
+		if (nft_set_is_anonymous(set) &&
+		    nft_rbtree_interval_start(rbe) &&
 		    nft_rbtree_interval_start(prev_rbe) &&
 		    priv->array_next->intervals[num_intervals].from)
 			priv->array_next->intervals[num_intervals++].to = &prev_rbe->ext;
-- 
2.53.0



