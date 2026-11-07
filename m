Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063397;
	b=xhck4cpAiTt71p6SReCSrTyhXrRzHkRbifQ+2d1lbDsL1586wq7wvIHcUWj6Vyq1PZFY
	 dY6D3Pv2kClJ6hszdjQC4zkAjGEOC9zfWnl18pQkP7SPRQj02WAMKlsUS0M/rCHbYZa8Q
	 uk9CRfHTE8gIMsuMB5THZ7GUtPu0RkxTZtX0KgpeDRwK2Js15uYTPjKScCdWZahycST8K
	 Wn9VKliffV4Lv9qlQHev/O/W6incSgznHv04iixl+IjhY4DkKYhjLDvPtocUkEY8Y3URJ
	 dBFjLVuoa7ZkdtUFHVbAcVe+NEhAYm5XRL5RGnuvf0m8bMYzIN6s9kHFVNU/0mjmwog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063397;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oTyOKmqTrKUO6NCfRzgXzW5jmoCrv4yE0OY//fl7Zts=;
	b=rrJF3nH6hGBmiLf0gtHA+agRoMYg0IXh4Hiyj1fiaV8IrYyXux0w0xOYaaUXed06CLCH
	 cdKHuvz5i8DDEN2X7D+0xiCTd/OXZTedeVjxqYo188MMLyC96Rkl7KxPwyfMK129bWEQH
	 qOdiwbZHoidtzlsvSgoDhit2w7gOdwWh7UJMUKICadoOTwYYjNG+iyrqxPy07v9EomGUH
	 D/h2u44PMFuR0U65yw+BX8W8okVJmfQsF3slGu7oYWJUvzalLtpwrg1mgXOkwELHfyUMi
	 Yz8JmQDS0Pt8kfwnTqWCpgbOz9clcy/WoDMQnauG8muJ/FqbKegJM31/4yoeqGEmGtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FbO+uAVg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319C0606D83C;
	Sat,  7 Nov 2026 14:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FbO+uAVg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 980F31F008A1;
	Sat,  7 Nov 2026 14:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063396;
	bh=oTyOKmqTrKUO6NCfRzgXzW5jmoCrv4yE0OY//fl7Zts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FbO+uAVg+i2nAGH+F38PvePo73c5h+7skj8T4wbsYw5vgPinpPgdnTY6rabgSiqlg
	 h3JFW3KO8GQmGOIWtM43W4z6PnYnQQLCIufXnN9+Lhyt38bpFYCbz7it1buJFGnFSy
	 U7znQ0k+c3axqiBp9FsSQD4ChPdeUtcpG96TmQjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siwei Zhang <oss@fourdim.xyz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 569/869] Bluetooth: L2CAP: Use default TxWindow for zero socket option
Date: Sat,  7 Nov 2026 08:54:11 -0500
Message-ID: <20261107134912.545749562@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index bb383ee188bbc..b85c6a11334ee 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -805,6 +805,10 @@ static int l2cap_sock_setsockopt_old(struct socket *sock, int optname,
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



