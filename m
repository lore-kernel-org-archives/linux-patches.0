Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052657;
	b=mJ9nhHisgeJ/E79KUD22Cp/rrgZnDkabKSoDsJ6gg1pTXoDFMq9DNKmVs77kU2Zf2ksC
	 a21d/CRHPVDQ3KkH/+caLz7gr56ygf732/vR7DCdU2Oi9xxgJ5EmaAScw2KLnwjmF3v1f
	 +O3dnXqJOukeZN3VjMypAeaY0Uy6I9hE5xq4ilY1jQSZQ3/91P58DvaDU3vk/AK+NYFqy
	 TcyJmPhJY3o2rvEZwE4qez2C8K3yCxLObCzWQJbb3Jr9L2XWgWSBhmnKAFq02Kp7R+QG0
	 YsEVNGwGPUoc03IHDdKWo/OEA3VoFzO9xabgot8CjBC904zjNWBDzZmSFkm3mUvY1LQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052657;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y4C5+45OkTQdhayXI/GO5wummvnExChoB+Hk7d19fcM=;
	b=JyQ3+QPKRKxu7cjDNy3mPn61DhfS6A+BlkCu/jr9u2Jobso7Hbq74AZY/mfnoTd345PU
	 LulgDYvC0eAImeMEttfJYjtLY2xQttKfTqAak0HplKHy/47gwgfd8up+bMJqPQDHbASEY
	 TNSDDPzDBImRMs3cqioBL3P7XmXv54q6x97dZd9PTlEf9OrCnY+EBvn4zH8KtQK4fTzO7
	 /PI98BxY9Dl1BBrRdPGhBmBwa00fTPRax6PwRNwRMqE+4wi9M4T4I2xR7+5Jk0w8rrfGN
	 a3nO0+QPpvCnvu8beXz2LFjkX5RWDK2EsI1sEmPL0GAGT47gn8HL9+UVGqlO+g1Eiig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QJ5G4FSQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C44DA606A325;
	Thu, 19 Nov 2026 01:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QJ5G4FSQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F0E1F000C6;
	Thu, 19 Nov 2026 01:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052657;
	bh=y4C5+45OkTQdhayXI/GO5wummvnExChoB+Hk7d19fcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QJ5G4FSQ1WBaWcS9+0uRDhWxl1Y1zntoki8dT9gQu9Dn5nS0DBUBuehAlRRdoYB2o
	 IHw7pKHvSGtBS4MYcYEyvKp1VOzk4bU17j1+ZN/ggIOniBCyTfn0IpooMgWCDEqiJH
	 06H9T47GuIQWD4UY8gmpfxbOOKTe1662LTlMgQBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siwei Zhang <oss@fourdim.xyz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0643/2214] Bluetooth: L2CAP: Use default TxWindow for zero socket option
Date: Wed, 18 Nov 2026 15:38:39 +0100
Message-ID: <20261118150037.054165074@linuxfoundation.org>
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
index 0cc0508298b96..3beb6e5a27cc0 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -803,6 +803,10 @@ static int l2cap_sock_setsockopt_old(struct socket *sock, int optname,
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



