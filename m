Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061856;
	b=RcV5K8vgKx30mt01+MNJ+TwAuKZlJM+wX9Vb1/H0Mez18frt4VTIK7R1KkZceLG+/PB9
	 +L179RMkWSSWly/lMZgoZpzoI5eIGFtZCj10OIW9ep9DWQIKlpT0waJs15SQ1D+/gWm8C
	 qlqZxJH6JQ34kcX7h9uN+mBItvF0xbmxujyPns7QQswQ/oHqAThbAlTbsLLJkrGw7d2bS
	 twWwK8Tp6vaAUOPsY7HZunXzOQ7fO6LZqaYkb4ULD4Xrnx8eD5EBwS6mIa3GuJjt2/VxZ
	 l2XIuoQ9buJLxwBS5HIRFW6c1xByY64v4eKjA1tG4gSyP/J4N3eJCdcE23JKtIiAMgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061856;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7k0ja8Y9A3TsxhOjPkhrg2DL+OYmadytppQnMApUVoI=;
	b=nfsszTY/ChT+vd6ZeBA3H2ql9I+YT9wzk6SZEID5knkpGEStcO1lk6J99TXpGmIKxQD6
	 EO9eS62SOj8pM9iBFSS1sKrkqVoQSd80rJ19+1+wUMFAApAZikQjUM083PU4QkD4vKJLw
	 2tTKwYEI4spGWpNu8IFjgbFZ3OBCkkiEE7eaHr9rGcEG2Xk0IZgUdKDO2L2Jx+JEH6/JF
	 KoJAwj7nZrLmDZIQQo6U037CaiM0M4dILVgomQ3wIaGf742cAq6cb796BeImaISwsWYDD
	 iuxeAZr2qMqbM7LwxRSLAHP4mmOkU6oAlg0s8VuF5kPGaSIlqmKpA9cSxtZg89qIJvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F9EaSyXu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C509606A32D;
	Sat,  7 Nov 2026 14:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F9EaSyXu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE9DA1F0089F;
	Sat,  7 Nov 2026 14:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061856;
	bh=7k0ja8Y9A3TsxhOjPkhrg2DL+OYmadytppQnMApUVoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F9EaSyXu3V2xoTytPLUTfJGRGXVYSETEImfUd/aIekzl4bnjpAFWW43e3Iio6E6PF
	 6dhR+iVO479MgGyMDxtR4j6BH4IEPgk7IrM3UTLXiovjS4VDvGZWSpCY34umuPeGAt
	 pQ8ineTBq8oWOSVVv52Gggm5xxSd++msU0zTWYhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchu Chen <flynnnchen@tencent.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0874/1536] staging: rtl8723bs: fix protected RX frame validation in decrypt path
Date: Sat,  7 Nov 2026 08:48:10 -0500
Message-ID: <20261107135022.095850805@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Tianchu Chen <flynnnchen@tencent.com>

[ Upstream commit 495cb31c791bdf3f9efef255a9587b05b0526c9d ]

The RX software decrypt path mishandles crafted protected frames from a
malicious AP in two ways:

1) decryptor() never checks that a protected frame is long enough to
hold the 802.11 header plus the per-cipher trailer.  All of
rtw_wep_decrypt(), rtw_tkip_decrypt() and rtw_aes_decrypt() compute

	length = hdr.len - hdrlen - iv_len;

and act on the result, and recvframe_chkmic() similarly computes

	datalen = hdr.len - hdrlen - iv_len - icv_len - 8;

for TKIP (the 8-byte Michael MIC is not accounted for in icv_len).
A frame shorter than hdrlen + iv_len + icv_len (+ 8 for TKIP) underflows
these unsigned subtractions, turning into a ~4 GiB iteration count in
aes_decipher()/arc4_crypt()/rtw_seccalctkipmic() or a ~4 GiB crc32_le()
length, causing out-of-bounds reads/writes of up to ~4 GiB starting from
the rx skb.  Reject such frames in decryptor() before touching the IV;
this covers all three ciphers and the TKIP MIC check, and also keeps the
unconditional iv[3] access within the frame.

2) validate_80211w_mgmt() keeps using the frame - two memcpys through
the stale rx_data pointer and a pkt_len update - before checking
whether decryptor() returned NULL.  On decrypt failure (e.g. a unicast
protected deauth/disassoc/action frame with a bad MIC, which this path
always software-decrypts) the skb has already been freed, so this is a
use-after-free read/write, and the caller's error path frees the frame
a second time, drifting free_recvframe_cnt.  Bail out immediately when
decryptor() fails, freeing the temporary mgmt_DATA buffer first.

Discovered by Atuin - Automated Vulnerability Discovery Engine.

Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")
Assisted-by: LLM
Cc: stable@vger.kernel.org
Signed-off-by: Tianchu Chen <flynnnchen@tencent.com>
Link: https://patch.msgid.link/8ee3bdd1c45034200cb1aa9a7e9b575b9584643a@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8723bs/core/rtw_recv.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8723bs/core/rtw_recv.c b/drivers/staging/rtl8723bs/core/rtw_recv.c
index f43429c72298e..96630315d46a7 100644
--- a/drivers/staging/rtl8723bs/core/rtw_recv.c
+++ b/drivers/staging/rtl8723bs/core/rtw_recv.c
@@ -386,8 +386,21 @@ static union recv_frame *decryptor(struct adapter *padapter, union recv_frame *p
 	u32  res = _SUCCESS;
 
 	if (prxattrib->encrypt > 0) {
-		u8 *iv = precv_frame->u.hdr.rx_data + prxattrib->hdrlen;
+		u8 *iv;
+		u32 min_len = prxattrib->hdrlen + prxattrib->iv_len + prxattrib->icv_len;
 
+		/* TKIP appends an 8-byte Michael MIC that icv_len doesn't account for */
+		if (prxattrib->encrypt == _TKIP_)
+			min_len += 8;
+
+		/* a protected frame must be long enough to hold the IV and ICV/MIC */
+		if (precv_frame->u.hdr.len < min_len) {
+			rtw_free_recvframe(precv_frame,
+					   &padapter->recvpriv.free_recv_queue);
+			return NULL;
+		}
+
+		iv = precv_frame->u.hdr.rx_data + prxattrib->hdrlen;
 		prxattrib->key_index = (((iv[3]) >> 6) & 0x3);
 
 		if (prxattrib->key_index > WEP_KEYS) {
@@ -1371,6 +1384,10 @@ static signed int validate_80211w_mgmt(struct adapter *adapter, union recv_frame
 			if (!mgmt_DATA)
 				goto validate_80211w_fail;
 			precv_frame = decryptor(adapter, precv_frame);
+			if (!precv_frame) {
+				kfree(mgmt_DATA);
+				goto validate_80211w_fail;
+			}
 			/* save actual management data frame body */
 			memcpy(mgmt_DATA, ptr + pattrib->hdrlen + pattrib->iv_len, data_len);
 			/* overwrite the iv field */
@@ -1378,8 +1395,6 @@ static signed int validate_80211w_mgmt(struct adapter *adapter, union recv_frame
 			/* remove the iv and icv length */
 			pattrib->pkt_len = pattrib->pkt_len - pattrib->iv_len - pattrib->icv_len;
 			kfree(mgmt_DATA);
-			if (!precv_frame)
-				goto validate_80211w_fail;
 		} else if (is_multicast_ether_addr(GetAddr1Ptr(ptr)) &&
 			(subtype == WIFI_DEAUTH || subtype == WIFI_DISASSOC)) {
 			signed int BIP_ret = _SUCCESS;
-- 
2.53.0



