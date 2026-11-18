Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034138;
	b=hXgnwONmX/6CPnjRzEIEupoFgHlf/Lqs/EuODhTQ9GfXbyzAttvM6KtNcL9VIsbiSWcM
	 dKI1KYxYt7p+o6pXlh15HZjQL/eZu/Ssl8qXk0kKzLWqRviNV4ggW8WDEIiM6epikE0yR
	 MEAgZRdhxEJhpABUOi0KZZAuc96npXaiblqwEnbtRra8zL9g2u2meQwAEO7akTufkBlLM
	 z+A35gPr4SqObNF6rQUg1e2e1ACRJEX/aZ6frtr9GdM2PAzrzsPe2lBX3U04nJRPJejIe
	 dPNvXttee57VWOjurIg/4KSNWDQSbgNaR3bQZulUsSmXASio1Sn21EsjaVi/esBUa/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034138;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XLfxLoCQCA6DWHGDpj31q/rRm2btM9Srmwmln1od01k=;
	b=ZgBMSUkp0SVCTR18L5SZ3rIxBsFaQ+NYDFT8xT2cS7u+QCkA6ZpSjRKz8q6q3Hitb+xh
	 QpmPlFHFXaALTRH1yhU7MSB/5xu70/uyuX+qAoq8vHCS+2bwxfCLOvQ9/BjKxFZ3wxD3X
	 qVKJUcwanghkEZyGLpcjpV8cLAZoGxMsMu7hAnG3odbPnAJiGI2Pi5v5vV47UbNsYBV3R
	 mkG3whS0IhZRdvpwQ/tf+E9UID97tnI0x/LO4Zyrz20cCRA3rb0RqrCli8RJP0BYEd6e0
	 qT/dCIsgiKSRq9sbNLhBqkXgfz3xRM40CvR55FD3yKUb/wiBPNKIfQSGQO8RU8MmZlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XpTsx2tc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368BA606A32C;
	Wed, 18 Nov 2026 20:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XpTsx2tc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 890301F000C4;
	Wed, 18 Nov 2026 20:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034138;
	bh=XLfxLoCQCA6DWHGDpj31q/rRm2btM9Srmwmln1od01k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XpTsx2tcxz2o8M3/G7XA+BNQYXHdVfnTFDduKZaChe8DOdEH0hXj4KdOSX0QKg911
	 mNlIoG0059DMiZScpImgMuTkw/KLiqj/mS+IBNB5FF5Cb+SkUTZUrUkRTCiNwMYYK0
	 HKAlfkXwDn6Y32JtfzBaZ+MXyrSn5EXGib21f3eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rongguang Wei <weirongguang@kylinos.cn>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0264/3318] tap: fix incorrect variable used for USO check in set_offload()
Date: Wed, 18 Nov 2026 15:14:46 +0100
Message-ID: <20261118150323.317407664@linuxfoundation.org>
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

From: Rongguang Wei <weirongguang@kylinos.cn>

[ Upstream commit fac7973f004de6dd51fb15a33e33ed37718e58bb ]

The USO features in set_offload() incorrectly uses feature_mask and
features argument.

The USO feature was written to the local features variable instead of
feature_mask. All other offload bits (TSO, TSO_ECN) are stored in
feature_mask which becomes tap->tap_features and is used by
tap_handle_frame() for GSO segmentation. Without NETIF_F_GSO_UDP_L4
in tap->tap_features, making USO on tap effectively non-functional.

Keeping the USO handling inside the TUN_F_CSUM block avoids enabling
GRO/LRO when userspace requests USO without CSUM.

This has not worked since the beginning, so
commit 399e0827642f ("driver/net/tun: Added features for USO.")

Signed-off-by: Rongguang Wei <weirongguang@kylinos.cn>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260807070914.112698-1-clementwei90@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tap.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 9ce26a60dac39..44687d833f22c 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -967,7 +967,7 @@ static int set_offload(struct tap_queue *q, unsigned long arg)
 
 		/* TODO: for now USO4 and USO6 should work simultaneously */
 		if ((arg & (TUN_F_USO4 | TUN_F_USO6)) == (TUN_F_USO4 | TUN_F_USO6))
-			features |= NETIF_F_GSO_UDP_L4;
+			feature_mask |= NETIF_F_GSO_UDP_L4;
 	}
 
 	/* tun/tap driver inverts the usage for TSO offloads, where
@@ -978,8 +978,7 @@ static int set_offload(struct tap_queue *q, unsigned long arg)
 	 * When user space turns off TSO, we turn off GSO/LRO so that
 	 * user-space will not receive TSO frames.
 	 */
-	if (feature_mask & (NETIF_F_TSO | NETIF_F_TSO6) ||
-	    (feature_mask & (TUN_F_USO4 | TUN_F_USO6)) == (TUN_F_USO4 | TUN_F_USO6))
+	if (feature_mask & (NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_GSO_UDP_L4))
 		features |= RX_OFFLOADS;
 	else
 		features &= ~RX_OFFLOADS;
-- 
2.53.0



