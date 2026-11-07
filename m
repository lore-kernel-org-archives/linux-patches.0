Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060955;
	b=FzXpFJlaJ3a7Z7wFQQzEUIAPX4oaM7jcB9P2mp1psTc9sl/0GDDl24wl9lVUEJNcMxgU
	 +sF1TCnTePjvQTp6okIMoeiV+QMheDkfjNhRXBfMfIRKRmSHaPYXE+D4TqZKfsOXjQqDa
	 pMPsymyIEVFQqOQz5trHwh81HcbmG72fXxIFxZZqTN91sd63kKJYy9A3/Q7gLLqORa3oz
	 7J11BhydYtxvJMuhMOiOvCXJ07nxA/kz7HaIa2TBWQbPm32taz2wYDXCqmFfJRtRlRJ2F
	 gtJF2d9ib9QmVwnlYSwziECT1ZTohYfgYvRVIgnpjB1ka5wRbU6wTqz9vT7hfnXQaKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060955;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y/JjkWVJMfqToQvSZAgUv6O89Fp87vUP/oCMPi9uFiA=;
	b=IJx/oaoQJhqL9wn1jo/gU3d7xzH57hmHzO4GKYK599moBgoR5yWt+PWatmbnkCFiZfqW
	 YG+1vdtacxUxloElAhryADE/eNvxYtGXnTgYLXf7VIlAKHCsH3MjZjIOjLZDuwNmvwmZq
	 amf1++mP4RmY0Uni4U92kPNKA2b9yQpLRaVO1eHVeOtKGzRJbvcEYq2Dx5c+KNIjX5SAN
	 vDErAuWTalkmupjEoSphQxYv5bl2OZ0Vhb+37QT8rSDrhu+XwLxmYhnirz+yWVy6BvAp3
	 JepKx24g0JgFIHvLi7Szudmf/FJ3Tlua740Q3U91XSz7TJOMpuCWSdF5V6J7+D6+czw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MkIEKR8C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B35A606D80C;
	Sat,  7 Nov 2026 14:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MkIEKR8C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 489281F0089F;
	Sat,  7 Nov 2026 14:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060955;
	bh=y/JjkWVJMfqToQvSZAgUv6O89Fp87vUP/oCMPi9uFiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MkIEKR8CRsXmER79v8jIXtZviH2IIY6eCMoKYnLTU/o/brVelLl4bFZJIZeqbbdvk
	 hgrt8ps2BL12feUmi5AYKCN27e3i0CUGM0njRYqzUR9I8FAzaVE7Ve2gb3+pD26vax
	 t9xJT65kqtospTDEiODqogw1Cns01XGIWDZxiqGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rongguang Wei <weirongguang@kylinos.cn>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0313/1536] tap: fix incorrect variable used for USO check in set_offload()
Date: Sat,  7 Nov 2026 08:38:49 -0500
Message-ID: <20261107135006.512146806@linuxfoundation.org>
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
index fcc9d135c5fc2..bc69e5b5ce46d 100644
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



