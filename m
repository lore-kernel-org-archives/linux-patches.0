Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036596;
	b=RQtkSc7iVPhDB69cBJoQ7Q+SSfivmDVGV2rRC906CCZOjI2EVl7/4nXt4r8fKE9nvT5W
	 vdmeWsFQq+YdVqxRnjxooyDHl1S40o2uNz51zznLEePz7+ULrVOgc40JXiTdF24FYJnfk
	 WQ1b4wvhqdyDu9rgphtFzqHGqhjbwdhP5mKK60SV6QHxvh7XgSPIeKIM+jtus9spgcY/r
	 HZrdwKDl43om12DUV6kGBHUkpi4iowkJSuzufrkGp+nAeLXQ4rLVHpTPF8/xSqRlPqWEq
	 iULvMKuKISBYwzM5NIThTgdhiB1eM7UBL5E0HKsair7bPsov1D5lZCoyugv4NBlj+Nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036596;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XAA55+C7M9jnP0vJPZYU3BKmxGlOij/yDV3A9WdQKxM=;
	b=31mc8rgS+OHmIG5Z3+yVKDlQ0dZI44YQedYrYS+3FOT3duczzEYQ41PLVdr6KLxDx13r
	 3TFKgqgoCpyVJLksKPaHdHF2Dm7xgiloMEnPO91PpHEB9cUn45sE1lBY/f0cWhVDaPRRO
	 L0xLrW9lYBanxd0sMKgpc0XiMpaMgIYrmE9iPb2teDuqy6gyj4cWvgcgu9030+66eCpfp
	 D/tzM4scq97E0mr1YLByS30a5dYLmNrrENnl6GcANtlVous9rkxoZl3VA5yN4rJPYGmvV
	 a/76ALBO+9vtFSJA6TY8Ll5d3bFZIFCGrgmExIFPASoA35afcAA8JC2EWePtMX5SULw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ws+HV07y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A955606A31C;
	Wed, 18 Nov 2026 21:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ws+HV07y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E06571F000C4;
	Wed, 18 Nov 2026 21:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036596;
	bh=XAA55+C7M9jnP0vJPZYU3BKmxGlOij/yDV3A9WdQKxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ws+HV07yx2qJeUqG0XPe61ebsmvWWwZ3V6skAebhtcpH3SAzStQN9UNIU3kVfw9z4
	 vs+pSY8umueUmJ4lJxEPF2lf2SWJEyb2r+Drl7/1+SKpnKAiTF8zqa7MVHFNBusqlg
	 bAbJ0ydKGDZGecJ5QckuTlj1UINRhg50aiYC3Q1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siwei Zhang <oss@fourdim.xyz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1117/3318] Bluetooth: L2CAP: Use default TxWindow for zero socket option
Date: Wed, 18 Nov 2026 15:28:59 +0100
Message-ID: <20261118150353.524184512@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7d2e59e97c2c1..e4312e7d17c20 100644
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



