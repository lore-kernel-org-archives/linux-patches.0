Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619509;
	b=U5yI6GdmnRe4EpcR8ZVR1NUsYoXUU+rDcbYN3vbp6LWsmMgSkg2bAdC3lAQAnW4HqFf1
	 E5S93X1hZGSrdeSTT8nHhoGomHAgALVsr5fToPtggFZQbaXJ1MY7YBvnTTroh2GFrD+0D
	 8gB7wC6d4x2jZGn/PP2auwvn4/0SdlIJ16TeNK0M1BQgD4gt6XqKHtGiwsXyPH6siVr+6
	 CeEid/fpgeAnk6sWthIcSt1l/43E62jIeGUXFrA6qiap+w/XrX/rQL3y51PEYxr8OZzjn
	 LW5lk4TPhCzHKRKgpa/dYRUQqvEZ402YlodS3TwORkOT7JIojGyNa6x/wMV5olJE0eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619509;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aB/hgfsC+qrCqE6YutfgkHQy3/ZSBkDP3SDG14+eQLE=;
	b=bkr3YT4jKsmRLmnBJ8f4pXkKnwCJkbPzE1QIZddvut2+fcIwr0vrETFUYH0fSOazmjGT
	 g71v0tuMrg2+rcc1Oua7mwa83YD+gvAF2sXA6iyRxCd2uN8DD3VY7PkmjiPRveJt/TZpj
	 L7QvsASxCNR7ghlgvqDy5EzW6Io1i6+IgvE4GWziiNNHQCHPl7T0BQcClcyVMpTa/R6G2
	 Mtl0PfHgZ/twjatd2MfTUQHpDXeqihDZE5YMjqLPU8DLYGnL3KxWiaW560s+5RtX4NxWB
	 Ys+0ho9i2uBOTd8rj7AlpRMO1CnFcLWxUc3WfZ3S79ayAbzs7cUtSPyQsMdMQjby7Ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ONRWsxR0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43DAE606A31E;
	Wed, 25 Nov 2026 15:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ONRWsxR0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4225D1F000C6;
	Wed, 25 Nov 2026 15:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619508;
	bh=aB/hgfsC+qrCqE6YutfgkHQy3/ZSBkDP3SDG14+eQLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ONRWsxR0w544a95UIEgJgrSXJxk7lnzdPV2coUdeq9czZAtxTaAFvbsqXqnWN6qrb
	 05+WIWvdXZCKBulV79WAjwU2D6VzUYOeOgaTUcn62T1KIHqi/3IMIMSzsgPhaxgMBy
	 Qk7RYZVKEDxarsSkTDaWwlFUWVkK6B9vG78N0zEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Subject: [PATCH 7.3 0619/1005] macsec: reject frames that decapsulate into runt Ethernet frames
Date: Wed, 25 Nov 2026 15:32:37 +0100
Message-ID: <20261125143836.248537493@linuxfoundation.org>
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

From: Kyle Zeng <kylebot@openai.com>

commit 1d5e2c57e9ffc134e14b3f837c8d7c53b508bd22 upstream.

When an SCI is unknown and the C bit is clear, macsec_handle_frame()
removes the SecTAG and the default ICV without checking how much of the
frame remains. A short frame can therefore become an skb shorter than
ETH_HLEN. eth_type_trans() cannot pull its Ethernet header, and a second
stacked MACsec device can copy stale skb headroom into a packet delivered
to a packet socket.

The matched-SCI path has a related hole: macsec_validate_skb() accepts a
short_length of one, so a frame that passes the existing length check can
still become a 13-byte Ethernet frame.

Require enough bytes for the MACsec overhead and a complete Ethernet
header before decapsulating an unknown-SCI frame. Apply the same bound
in macsec_validate_skb(), using the selected SecY's ICV length, to cover
the no-SA, synchronous-decrypt and asynchronous-decrypt delivery paths.
Leave other unknown-SCI handling unchanged.

Fixes: c09440f7dcb3 ("macsec: introduce IEEE 802.1AE driver")
Cc: stable@vger.kernel.org
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/macsec.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -407,8 +407,10 @@ static bool macsec_validate_skb(struct s
 	int len = skb->len - 2 * ETH_ALEN;
 	int extra_len = macsec_extra_len(!!(h->tci_an & MACSEC_TCI_SC)) + icv_len;
 
-	/* a) It comprises at least 17 octets */
-	if (skb->len <= 16)
+	/* a) It comprises at least 17 octets. The SecTAG and ICV must
+	 * also leave a complete Ethernet header.
+	 */
+	if (skb->len < ETH_HLEN + extra_len)
 		return false;
 
 	/* b) MACsec EtherType: already checked */
@@ -1330,9 +1332,12 @@ drop_direct:
 nosci:
 	/* 10.6.1 if the SC is not found */
 	cbit = !!(hdr->tci_an & MACSEC_TCI_C);
-	if (!cbit)
-		macsec_finalize_skb(skb, MACSEC_DEFAULT_ICV_LEN,
-				    macsec_extra_len(macsec_skb_cb(skb)->has_sci));
+	if (!cbit) {
+		len = macsec_extra_len(macsec_skb_cb(skb)->has_sci);
+		if (skb->len < ETH_HLEN + len + MACSEC_DEFAULT_ICV_LEN)
+			goto drop_nosc;
+		macsec_finalize_skb(skb, MACSEC_DEFAULT_ICV_LEN, len);
+	}
 
 	list_for_each_entry_rcu(macsec, &rxd->secys, secys) {
 		struct sk_buff *nskb;


