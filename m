Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623830;
	b=ObFnB83vAU03oSP9tDvC0iJhaUkHHGbC7D3vsw1SsM0loWyAc2dcObOJjFjmZfaS5s8S
	 bCX526SP0jBzBa8YytANnf9zrJFFUW2qj92lpm7ufpaDjxfv32/+CoAgjnpQHj+FmYmq5
	 tX8gqM041XeSGQX/Vq4Ux0+Hp3DPbOC07C85/IfG/d4DjQVJIPXoSbvZdeVLKwYXEj2k8
	 vZASvE3mgWeUi8uvFn/ntB39TyGRT5YWyLwQuc8ExuOvgwxJSEXpGjr6ez4+AUG4H8GJF
	 psIRLNF1e7lf0hcErh1mg+GvhiEhEM8dLcBbGHw+8XqJjnLEuUimbFugFiu/jjjHfZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623830;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8Y7bNt8HndZcpzN47tsu8e+IQk9s9PYk5awEdY8rjBE=;
	b=wSSIf7zw4SDlDm/SqXzo+VaK/1LOoGoHpIgYexTXMrL1JS/dE8fbDa/mEw0pt8I+OrEr
	 yd55s01ysaaxopWJSQq5ak47YBVZ3Nmdl+IOZPSk2z8wr3VZITpC9YxQ2O9KQ7M4b8sWm
	 TonOcOdOVvGv+39JFbBbJt03hKbLV3AliNsh5CoSQjaRhrhKFqKK/RIMPBmKZ6sOrAjxv
	 uI6J3yRSfEfTTOxpIx5ud8joLN428HK2FA+LA8uGOppBeSB5yuN0hWMCXQ1R+7iM9rWKc
	 FLxMakBEIZxWiQ/kCUV5z71y4tDXkoZ0NC+lWz/URoORz6XuFqqB+dy0s7w5jv9fSZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CKolJ+LG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6977C606A321;
	Wed, 25 Nov 2026 16:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CKolJ+LG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1D731F000C4;
	Wed, 25 Nov 2026 16:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623830;
	bh=8Y7bNt8HndZcpzN47tsu8e+IQk9s9PYk5awEdY8rjBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CKolJ+LG7mZLZmnrc69m1iG4cErcGOCjF2qYyybdHrm2ml+Q4/4b3fPG5dykED4oG
	 epIeXyTlimbqEULGybwBiBFM66XRWAeJX0CGseEgsj6LwRpwAHqBV6TuqkANiBjpCw
	 PgG8yamHNj6tOVXJ1suhjoscIxDoQfJk/cSt9C7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Mayer <andrea.mayer@uniroma2.it>,
	Yuya Kusakabe <yuya.kusakabe@gmail.com>,
	Justin Iurman <justin.iurman@gmail.com>,
	Gabriel Goller <g.goller@proxmox.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 986/990] net: ipv6: keep room for the mac header in dst_dev_overhead()
Date: Wed, 25 Nov 2026 15:39:13 +0100
Message-ID: <20261125143845.073041484@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Yuya Kusakabe <yuya.kusakabe@gmail.com>

commit 87cd6b717e4069dca34e0866e57eaeb44d3b173e upstream.

The seg6, ioam6 and rpl lwtunnels size their skb_cow_head() request as
the length they are about to push plus dst_dev_overhead(), then push the
new headers and rebuild the mac header below them with
skb_mac_header_rebuild().  That rebuild needs skb->mac_len of headroom,
but dst_dev_overhead() leaves LL_RESERVED_SPACE() of the egress device,
16 bytes for plain Ethernet.

Where the mac header is longer than that, as it is on ingress through a
VLAN device with reorder_hdr off, the rebuild runs out of room:
skb_set_mac_header(skb, -skb->mac_len) computes a negative offset,
stores it unchecked in the u16 skb->mac_header, and the memmove that
follows writes skb->mac_len bytes about 64 KB past skb->head.
Forwarding plain ping6 traffic through such a device reproduces it on
all five seg6 encapsulation modes and on the rpl and ioam6 inline paths;
skb->mac_header comes back as 65534 on a 704-byte head.

Return the larger of the two.  The helper already returns skb->mac_len
when it has no dst, so this only makes the other branch agree, and it
covers every caller rather than each call site in turn.

Fixes: 40475b63761a ("net: ipv6: seg6_iptunnel: mitigate 2-realloc issue")
Fixes: dce525185bc9 ("net: ipv6: ioam6_iptunnel: mitigate 2-realloc issue")
Fixes: 985ec6f5e623 ("net: ipv6: rpl_iptunnel: mitigate 2-realloc issue")
Suggested-by: Andrea Mayer <andrea.mayer@uniroma2.it>
Signed-off-by: Yuya Kusakabe <yuya.kusakabe@gmail.com>
Reviewed-by: Justin Iurman <justin.iurman@gmail.com>
Reviewed-by: Gabriel Goller <g.goller@proxmox.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Andrea Mayer <andrea.mayer@uniroma2.it>
Link: https://patch.msgid.link/20260922-seg6-maclen-headroom-v3-1-7b2f982ef79d@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/dst.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -455,7 +455,8 @@ static inline unsigned int dst_dev_overh
 					    struct sk_buff *skb)
 {
 	if (likely(dst))
-		return LL_RESERVED_SPACE(dst->dev);
+		return max_t(unsigned int, skb->mac_len,
+			     LL_RESERVED_SPACE(dst->dev));
 
 	return skb->mac_len;
 }


