Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057259;
	b=1CIjoeXR76l3Dqm51BJQ75xR0qQaxFVVZaXMWoascWX3oySJucBb3nDk/Q9F8Xr6aHxs
	 tPFzNfSndIBonYcaSqUnYs705abB5/MSiypfE4iqSKyyC3Wym5uBmV+7CSTnBnSnK4Ajl
	 Tij1oG2w4eKRP4CY1hQL2I88+rEx34YAxASlYxEj2KYkoqsPJ4LayRKTRt4Xcgm+ywNT4
	 Lhgag2MfRXyhSMrvGI1RMyNaXLE563OEl3kjoBmxFSR0pW+4iDJyavQyLuOLUj/Sc1Iyg
	 E/IoxJ3US1a4Zl6XKD+jpzettAJSrhrT8cn+SxP9fU/Urt5SwBH3pL3A9h8X83zk/BA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057259;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/r1tnlnEjn7Z+Fj2z6IQpmKTqyRXg+e3s8bQ4V3OrUg=;
	b=wrr+Hn1dZ+yyszcEW7SGZwoOQDZF9c+WASV3IXj2X+R+fjlY2PY/cqvsijaOlvX+x1Il
	 9VyQeFZf22lKJTWA4LpLcuPkFQ9bwXRG7AR6y9AjjSyZ/nCg/VadPkJKZ872chOksuzbN
	 TFGVsDO7/gzCr1WYSr16VauUqULflmETBwQ69osLUJ39EDi2lHIIC8Q9jCmWMXmAtIx3w
	 dB7l6qSKmh0Vv+h994oORrN1eE4Crc431D4UBC5/u9QfFsVywVnsFGVq36j0KoA5XBHBf
	 41+4XjC7UxA/61n4F2qvWrlNHXeTxv+4zW342sJZqEwJIexUbEEtrAIB0B1mlTT/zRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yoGKIyTF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F66060A261E;
	Thu, 19 Nov 2026 03:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yoGKIyTF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC5C1F000C5;
	Thu, 19 Nov 2026 03:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057259;
	bh=/r1tnlnEjn7Z+Fj2z6IQpmKTqyRXg+e3s8bQ4V3OrUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yoGKIyTFAIaU3AI9MUfFlEh8XqJh5/ZvqbMzxMRh0x+09FcOS/UcZbC4sJjaM1YOP
	 6LFbYzVsj1LCU6qgdtT3VE2eOybX9kMxkQxmCAAGQd/AseQaClHFYC1bqUe3NWyuse
	 HkPkNfs73K7I3ANI59Xil/v5rA/mN+mRjzu7WuZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Gmeiner <cgmeiner@igalia.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0068/1848] drm/etnaviv: check all modules for idle after reset
Date: Wed, 18 Nov 2026 15:35:06 +0100
Message-ID: <20261118145913.965609960@linuxfoundation.org>
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

From: Lucas Stach <l.stach@pengutronix.de>

[ Upstream commit 1006d1f7c03d92b28c252333836635df8e165401 ]

While the FE is an important part of the GPU, which needs to be idle
after reset, all other modules should be idle after a proper reset.
Check all present modules for being idle to determine whether the
reset was successful.

Reviewed-by: Christian Gmeiner <cgmeiner@igalia.com>
Link: https://patch.msgid.link/20260511085148.652256-1-l.stach@pengutronix.de
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
index 407a15e1469f2..b9464240835d7 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
@@ -525,9 +525,9 @@ static int etnaviv_hw_reset(struct etnaviv_gpu *gpu)
 		/* read idle register. */
 		idle = gpu_read(gpu, VIVS_HI_IDLE_STATE);
 
-		/* try resetting again if FE is not idle */
-		if ((idle & VIVS_HI_IDLE_STATE_FE) == 0) {
-			dev_dbg(gpu->dev, "FE is not idle\n");
+		/* try resetting again if any module is not idle */
+		if ((idle & gpu->idle_mask) != gpu->idle_mask) {
+			dev_dbg(gpu->dev, "GPU modules not idle\n");
 			continue;
 		}
 
-- 
2.53.0



