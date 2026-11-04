Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830883;
	b=1HuSUHl8YfBNwaJH5oUdRvb3aCC/qoB0n5kzTIeRpS19vjR72oZtM+/RVbtybDX+NwIw
	 iWFfqI/I+0SYiNLZwKpf7HPBpLZm8phtadtfqn0cUlWWOVy+xiCK32KyahBwsfBRU+lQ6
	 RlC+9mNvQikxBz3S35/8uw/y0tRk68l3oYuwkNW2Ag8Q6CUbwnW8rhvt8+YM1RVAyaj2y
	 S5JOim9P03SUF3Qvx63AqibGr5uxQ42pm+J2tT3dP/94R4bNWddrv/XN/EtKwqEhCNJ3e
	 3uzcqlPNX+i1hyAxfmHOdNSrxK/tUbPqJHgCKxhJZ6J1MeArR+cu/TqTfJ9pjI+LEQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830883;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rcC4g2ndXRkAdydo/8L4XSbVpSFvYkZAUaDLSW54lZw=;
	b=cyyE1/LA2iQkDwdsg0hnKJpyWXTXlQZ9FHhi+N/d6FFs2Xh46b5h54ipQXhU2KkCZCk4
	 4/sCCy5kAuUf+nX/2i95IAGnhLEZpfUr7cnQlNswa9ezxr64VzUHqMpuoXk1QhZYMNRZA
	 bMUazq3dNUxI7Lk1myLSWuLFdtNiFv9rYmOpMRZeAjGllBakMcLFgLJv3Uhl463GaCE/L
	 1wJChhWL7v4kySNSMNEZYxcyFZUKt/mQ94CHHBZp2Ob7uOw60ptZfx3lv+cKvds2jXXmR
	 XGLoMvtPBPV73dwQl8ZQaVttPrVrzIrpv0ntp2qms6C4/gs8AUzUu/S+nyCmxBmtIOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SsVlugAh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7A9606E831;
	Wed,  4 Nov 2026 22:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SsVlugAh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 469CD1F0093A;
	Wed,  4 Nov 2026 22:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830882;
	bh=rcC4g2ndXRkAdydo/8L4XSbVpSFvYkZAUaDLSW54lZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SsVlugAhKz38V90MnhhDljjo0E/JMoc9ScA/sVvCiDp8NpqoED1H2H9Z9tKhV30NI
	 YOLXxQtQYZdydo38+S7S+9gvB6pXFi9cKRW9+VF4uz7fKB95dO1WmNVGbsSXKty1Sr
	 nysJnFrnWqBwbG0a7L5+YfJuNqZNz1APcoZALTdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rongguang Wei <weirongguang@kylinos.cn>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0378/1005] tap: fix incorrect variable used for USO check in set_offload()
Date: Wed,  4 Nov 2026 16:01:51 -0500
Message-ID: <20261104211054.682833922@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
index 1aeaecd4030fa..9eea418afe2fc 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -883,7 +883,7 @@ static int set_offload(struct tap_queue *q, unsigned long arg)
 
 		/* TODO: for now USO4 and USO6 should work simultaneously */
 		if ((arg & (TUN_F_USO4 | TUN_F_USO6)) == (TUN_F_USO4 | TUN_F_USO6))
-			features |= NETIF_F_GSO_UDP_L4;
+			feature_mask |= NETIF_F_GSO_UDP_L4;
 	}
 
 	/* tun/tap driver inverts the usage for TSO offloads, where
@@ -894,8 +894,7 @@ static int set_offload(struct tap_queue *q, unsigned long arg)
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



