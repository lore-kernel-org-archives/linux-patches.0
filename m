Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209099;
	b=NTBVOQjegPkHfSBod8yTP/wzGHyGac48zzLYnmvxR2NYn8A82lvH+anVR28jfB0ZbUzG
	 tybpz2ZB258UGHo31CQpnzU5wgpQOkSWtK9jSRCVqL/s4H+bfDJ4wYOF4p0wLEzL8ZNJq
	 7Edcd1/U6hvZpNfNaEbdrxlm7h23QONPNMz7UyijHvBNRaWZt95q0l8TV62o4YsmQegk0
	 Zsv1QeMLW++8t9aKW8MsLRVUwZu79BuUaK/ERILzHvS/hczce6so4BFkouE1qWvervVHb
	 uOieflU+jBq4rVWxWClYmxADlxv/iv57uCetPkb6zaxBw48H5AoDSYaf+oC7xHBZBuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209099;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CXP19pMq7Vv3pYHZwLcyAOESmnHC754AQ4G3rdANkzc=;
	b=e9ieFrAfaMV9NyFvE2FzMicjL5kv7lh8qHJlqjCW4mhnXA4TFTTtl54rtwms4NKgX5ED
	 eRc+8DmWEvGlz5MF9rbD8BVUGPdy3UyRjJd9W4pVteY12ItxtMcn9I49FJMcNodyo6YL1
	 QXQX4eULRkEBsbsRPA2rUrsvK5L2EHUidOf1jZekRmZNbzKaOXMglm6UhbN8m3Cgjz8v8
	 fYTg1UszQDN1GUBQJkRwU1s0EBc5u2zL1n9K2aAVRrhWIcU/ZmDkdrSiPQSyxH7f+2q8X
	 dtDnpAw09UEVleOaI7EPsvVH1aQpNjqaTx7x88B4SdtYHGxlALJsbnsZXDhr6rTh2hA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HeBx0Rwa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80CCB60A260D;
	Wed, 28 Oct 2026 17:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HeBx0Rwa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF3B1F01825;
	Wed, 28 Oct 2026 17:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209099;
	bh=CXP19pMq7Vv3pYHZwLcyAOESmnHC754AQ4G3rdANkzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HeBx0Rwaa5Eyw1hZiQ47xyqn+MO5MtJKW+aTcwtXjaZfy/XN+Ih29otbfgU8nOsmq
	 6aFWcM+aT2nVHvDTRC7Uq/L3YEIRrJ4XBtXN6McIqP8GbKIq9ml087xG7/A+y10ffr
	 SOFy9IxkE76RV5wZDyOoFFR8Xr4KdnQRBh5YWBjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alexandru Hossu <hossu.alexandru@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>,
	Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>
Subject: [PATCH 5.10 352/516] staging: rtl8723bs: fix OOB read in OnAssocRsp() IE loop
Date: Wed, 28 Oct 2026 17:58:24 +0100
Message-ID: <20261028170011.828918244@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

From: Alexandru Hossu <hossu.alexandru@gmail.com>

commit f9654207e92283e0acac5d64fe5f8835383b5a23 upstream.

The IE parsing loop in OnAssocRsp() advances by (pIE->length + 2) each
iteration but only guards on i < pkt_len. When a malicious AP sends an
AssocResponse whose last IE has only one byte remaining in the frame
(the element_id byte lands at pkt_len-1), the loop reads pIE->length
from pframe[pkt_len], which is one byte past the allocated receive buffer.

Additionally, even when the header bytes are in bounds, pIE->length
itself can extend the data window beyond pkt_len, silently passing a
truncated IE to the handler functions.

Add two guards at the top of the loop body:
  1. Break if fewer than sizeof(*pIE) bytes remain (can't read header).
  2. Break if the IE's declared data extends past pkt_len.

Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Alexandru Hossu <hossu.alexandru@gmail.com>
Reviewed-by: Luka Gejak <luka.gejak@linux.dev>
Link: https://patch.msgid.link/20260522004531.1038924-6-hossu.alexandru@gmail.com
[ mdmitrichenko: adapt to 5.10: struct ndis_80211_var_ie still has the
  CamelCase Length field and a one-element data[1] array here, so
  sizeof(*pIE) is 3 rather than the 2-byte IE header. Use the explicit
  header size 2, as the existing i += (pIE->Length + 2) does, so that a
  valid IE ending exactly at pkt_len is not dropped. ]
Signed-off-by: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/core/rtw_mlme_ext.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c
@@ -1682,7 +1682,11 @@ unsigned int OnAssocRsp(struct adapter *
 	/* to handle HT, WMM, rate adaptive, update MAC reg */
 	/* for not to handle the synchronous IO in the tasklet */
 	for (i = (6 + WLAN_HDR_A3_LEN); i < pkt_len;) {
+		if (i + 2 > pkt_len)
+			break;
 		pIE = (struct ndis_80211_var_ie *)(pframe + i);
+		if (i + 2 + pIE->Length > pkt_len)
+			break;
 
 		switch (pIE->ElementID) {
 		case _VENDOR_SPECIFIC_IE_:


