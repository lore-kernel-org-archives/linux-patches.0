Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058540;
	b=IXDA2wRKBlHQkCuIGamh2X9Qf1DmQKuflIeD31yTMkiU1bghLywZA0sJGtijjqEiXn8e
	 +xDd/CwfvP8x/H5skQN4ed3tML2JK00gKqaqicU6Urz3lGyO94LoRKM0r+A8Ep0DA4KmH
	 M3qXnxc3hxZAQzOlePPpVLw/NIsBGhOIMznAkzkribaBL8Pgns/bFgfwnu4jxr/XHTxuP
	 goQgcpKnHjfJUmrG4FiO2+tEMtiN9TxOc4O256lha1OLGH+EcDJzP40q8z3QmvRLmTgrx
	 wEaDFTqcbDWjf/+uynJnV5Z4jP1P6dRud064mi5MtgYoOr+/kwacuh+8bFsvNj7Dtiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058540;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H8j+dTea/AMJF9pXEf3sv++C04lm/FJQmJPKs53HeL4=;
	b=bXRxy1f9m1ZDHOjvEvv6qV6KZHxz/n820xQSo72c99RQGQXffJScKrjp0DVe5OpdtT63
	 TmqDtaE1uw8fgeZw+5oWrfT/Je4ehv2nyatRYm3sUU3MaSyOWugBXT/tv/EfWJmx//h3u
	 aq0RO873tjwEEMGiX0x9xusfFRZ4bJ2PQDaPUEnDRYaD3YduMoWllMgary/le+zaM+K7p
	 ojcnPiyaRdtZKci1iq1NpjL04IRWYZ8+F9SCI5vX1Liey1ISO/PHwQC3+jhpBdVZuDldZ
	 f6gjyzV5VCQn1bqkaPcqHlwhC0ml9H46kg3QiI43dCgsxNyHk03BYNbgqn6khrECLwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=btanCGMk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B68B606A31C;
	Thu, 19 Nov 2026 03:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=btanCGMk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7711F000C4;
	Thu, 19 Nov 2026 03:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058540;
	bh=H8j+dTea/AMJF9pXEf3sv++C04lm/FJQmJPKs53HeL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=btanCGMk0fr+a3Zzx/pwisFlerUxaHrMZtn/OwR2owfAD0WiXxH8OVkqFWOfNi6gA
	 e3YmJpBEweOmsEle7/mVYudRHDhtlTTLT18J7+Te8r0JMfXirs+d2aQZlLvgtjZEAa
	 fdO6al8RJrDjLOoDIkCTUmLJznzxYzyd5UFqpxwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siwei Zhang <oss@fourdim.xyz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0521/1848] Bluetooth: L2CAP: Use default TxWindow for zero socket option
Date: Wed, 18 Nov 2026 15:42:39 +0100
Message-ID: <20261118145936.533445265@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

From: Siwei Zhang <oss@fourdim.xyz>

[ Upstream commit 226fa3b676cbf2236f803bccd347462433ffc2c8 ]

L2CAP_OPTIONS accepts a txwin_size of zero and
stores it in tx_win. The zero is then sent to the
peer in our configuration request, and if the
channel ends up in ERTM mode it is passed to
l2cap_seq_list_init().

Use the default TxWindow instead, as the mode can
still be changed to ERTM during configuration.

Fixes: 14b5aa71ec50 ("Bluetooth: Add sockopt configuration for txWindow on L2CAP")
Cc: stable@vger.kernel.org
Signed-off-by: Siwei Zhang <oss@fourdim.xyz>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_sock.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index ca131b2267d8b..60b14d2cf8edb 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -801,6 +801,10 @@ static int l2cap_sock_setsockopt_old(struct socket *sock, int optname,
 			break;
 		}
 
+		/* A zero TxWindow is invalid, use the default instead */
+		if (!opts.txwin_size)
+			opts.txwin_size = L2CAP_DEFAULT_TX_WINDOW;
+
 		if (!l2cap_valid_mtu(chan, opts.imtu)) {
 			err = -EINVAL;
 			break;
-- 
2.53.0



