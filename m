Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617994;
	b=gE6c+DDW1cQLtuIjaRl14vspMC5PGBlu9rgA71RFJbtK2CNCO8x2Jnynrh7wjBXxwlIi
	 xQQPsjp1O9LL3br6QtuxUreu+D0L2AGjwvelRspsSN25s1uzxMC3ppXaaz3+c3cSVO37q
	 5MXybEmQErTnH0LCoQswJ0tDv9VWWzmCw1zx/nokdyGcvfcZpmf8hXBx496P4w8818Z12
	 c7jGg9l7Y9b7ERco6hpoSVI+gF7T3ifEWLk4TbKwKlE04invSa/C01X/Qnv5l0JU4jRss
	 Fvu8yt1FQ39oodJo4++D4cGSG1yGLzR8Ti9kxn6qoFRjz62CEeUmnXsmOe6IzE+LU+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617994;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Lr4ZUyInfTxb94qg8o2JevEwX3JyBf1xCURiBeB9XXc=;
	b=sklyqpj+7imN35uwYWnNnEBTWzfbCTz6YIfKXvX/DM76BHqLx6jQYN6Mnkzf2NpBBwNh
	 qs6RkSbv/je+zINTs2yHzbZtL5Av4law2hNdRN5iGUzomuoGRTPgJM/jPs+MbfllG+m+S
	 qacmibTyLMDSLyYpFf0pGh+Dj2ld7/f5Ba8ps48aZVeudPfc+k6GBabdnXJbrzp7cU3bj
	 ePpaU7zqR4RaHd6GyCM/cJ6BWKpiJv9L7tHP7oiyc2KxWlMb1yKbzB/NRAo6elZc0rtwg
	 ugHqP3Cfp9SCIVXfG+lApUKQdkRW+7Ks4rnaQ/Vqh7NBSatYXhJnpZ7mvEQcvapR3JA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hkCY8cO3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D65606A32C;
	Wed, 25 Nov 2026 14:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hkCY8cO3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6F11F000C6;
	Wed, 25 Nov 2026 14:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617993;
	bh=Lr4ZUyInfTxb94qg8o2JevEwX3JyBf1xCURiBeB9XXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hkCY8cO3+PefYEciSJK3F48XvwsexK/SeShTXImLXS2gvVDfnbIAwy+HS+VMUHaqc
	 4YdgeLnzkiGMKi8ZpBqWn5UyBWSWTDvV+PQi+4xwU0I6IJLify9ZGa7FVCxj9EpzGH
	 RosEohjdesABrs82bJN54oGiFdf1PtFl1KWC6Aqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0139/1005] net: stmmac: copy XDP metadata in AF_XDP zero-copy RX
Date: Wed, 25 Nov 2026 15:24:37 +0100
Message-ID: <20261125143824.995554445@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

[ Upstream commit 41d78e9ac0984f0e9577e5312e62400b5a6760c8 ]

stmmac_construct_skb_zc() reserves headroom for the XDP metadata and
records the length reported by the XDP program, but only copies the
packet data starting at xdp->data. The bytes in
[xdp->data_meta, xdp->data) are never copied into the new skb, so the
skb advertises metadata that is not there: after eth_type_trans()
anchors mac_header, data_meta points at uninitialized headroom instead
of what the program wrote.

Copy the metadata together with the packet data starting at
xdp->data_meta, leaving skb->data at the start of the frame and the
metadata immediately before it, and record its length. This keeps
data_meta valid for the stack and TC BPF after eth_type_trans() anchors
mac_header.

Fixes: bba2556efad6 ("net: stmmac: Enable RX via AF_XDP zero-copy")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Link: https://patch.msgid.link/20261027-stmmac-xdp-fixes-v2-4-10eae8a093a8@oss.qualcomm.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 519b166b58c37..c115ddfad5892 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5418,7 +5418,8 @@ static struct sk_buff *stmmac_construct_skb_zc(struct stmmac_channel *ch,
 		return NULL;
 
 	skb_reserve(skb, xdp->data - xdp->data_hard_start);
-	memcpy(__skb_put(skb, datasize), xdp->data, datasize);
+	__skb_put(skb, datasize);
+	memcpy(skb->data - metasize, xdp->data_meta, datasize + metasize);
 	if (metasize)
 		skb_metadata_set(skb, metasize);
 
-- 
2.53.0



