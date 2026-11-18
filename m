Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018146;
	b=AyMCGrCAsKdBNRPHi+JUGb0gaSyvokOa6Kbo8o6ictbTrFl9L07ARJzy3ijCMH0napYr
	 1w1Pipu4WlgIlfGRV/B3Lh01J5IAnh+jrHlx5PqUvVPv64EL3cgkJBehn7Gswdf3NYdpa
	 A1ysW1H/b1giHIzmn+oKU7yn9eZFAuS8j6+wXbAV3Y5XiB0yYQENa5g7GhRamhV02xO5K
	 hEinGj9fFWq1UGWz+XCD9Xb77ViKzRk9SRiEbPUhCQW1o1kZZ5mJ9jg9JGHjtSN2hMEaI
	 khmhSowpV7oeWZA/uR0AVdNxrV82UYcB2Ef+sjqlQpQRvncolNU/2BI5E02s5WNXddw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018146;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hddxXSngRISwhB6bRjtpzKwXWNnQc9qZarJheJdqbAQ=;
	b=mPj4JLvNaNpQc6OyY/gEvvGQOGMYQnEN0lqe1DHVYkvkbfBCMM7Hru4h4KcQ5qq+JGtg
	 2ivPwtVM7xwEpiP24++TpGV7O5qO6WUv8MFFRJqyZpESf2U0IDU7W2H3KM3Xn1T331ZPT
	 AjyDhGQaEXY4nZQKLG7/STFGl+R3RihWt3MzP3xKj0eMB2Jok4rAVrU3iHorALywYXMIA
	 Fz8cDl2K9DYhlaStT379LYDPGzlf2V7vVPY+I/44ry5Ahzg8Slw5h+Tia662Q0iGXuoBX
	 OkfkE3bST1+o2tcMWnv2HRnGI5hbxxYqH1PrY+wMgBNmLVSe/r1eS5DR0dSHfvSj6Fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cj2wUK8D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440CF606A32C;
	Wed, 18 Nov 2026 16:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cj2wUK8D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 958C11F000C4;
	Wed, 18 Nov 2026 16:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018146;
	bh=hddxXSngRISwhB6bRjtpzKwXWNnQc9qZarJheJdqbAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cj2wUK8D6HcHn7myayrhzBz7fBIk2jvSo7P8GeB2VtALwrskxErKph2f6xulZgvC1
	 CDuPVgkorXJL5l4LTKLo4r9Z8EO6oRZfU8ijtdss2YC4nymiWw43IyQgt8aIbuqbym
	 53PcKwxbV/Khrk1GSipyhgyuuSMWObNO+g+oFpA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Omar Ramadan <omar@blockcast.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1112/2651] amt: pull the AMT header behind the transport header in amt_parse_type()
Date: Wed, 18 Nov 2026 15:39:12 +0100
Message-ID: <20261118150328.030087857@linuxfoundation.org>
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

From: Omar Ramadan <omar@blockcast.net>

[ Upstream commit eb0c18404c8943356f4aa164e5db9067b79ea93c ]

A gateway's encap socket passes ICMP errors to amt_err_lookup(), which
calls amt_parse_type() on the quoted datagram to see which AMT message
failed. On that path skb->data points at the quoted IP header and the
transport header at the quoted UDP header, and icmp_socket_deliver()
only guarantees the quoted IP header plus 8 bytes, that is, up to the
end of the UDP header.

amt_parse_type() pulls sizeof(struct udphdr) + sizeof(struct amt_header)
bytes from skb->data, which on this path stays inside the quoted IP
header, and then reads the AMT header behind udp_hdr(skb). An ICMP error
that quotes only the IP and UDP headers of a Request, the minimum RFC 792
asks for, therefore makes it read past the pulled data, and past the end
of the packet when nothing follows.

Pull up to the transport header plus the UDP and AMT headers, as
vxlan_err_lookup() does. amt_rcv() is called with the transport header
at skb->data, so the pull on the receive path does not change.

Fixes: cbc21dc1cfe9 ("amt: add data plane of amt interface")
Signed-off-by: Omar Ramadan <omar@blockcast.net>
Reviewed-by: Eric Dumazet <edumazet@@google.com>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/20260928181557.85796-1-omar@blockcast.net
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/amt.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index b53f8ec556615..faa21015b34de 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -1292,8 +1292,12 @@ static int amt_parse_type(struct sk_buff *skb)
 {
 	struct amt_header *amth;
 
-	if (!pskb_may_pull(skb, sizeof(struct udphdr) +
-			   sizeof(struct amt_header)))
+	/* skb->data is the UDP header on receive, but the quoted IP header
+	 * when amt_err_lookup() parses an ICMP error, so pull up to the
+	 * transport header rather than from skb->data.
+	 */
+	if (!pskb_may_pull(skb, skb_transport_offset(skb) +
+			   sizeof(struct udphdr) + sizeof(struct amt_header)))
 		return -1;
 
 	amth = (struct amt_header *)(udp_hdr(skb) + 1);
-- 
2.53.0



