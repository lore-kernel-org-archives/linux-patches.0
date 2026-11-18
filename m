Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051075;
	b=E5vuhWksINGq9NeKw7BFVv0n1XQZpO4vat4KkoJHWy4fVjc2X7yIemGKnZoiT2Y6k2bk
	 JjsULAft6PUnhqs1P9725OWIPlx4T1283S2v9yccTsPzpNO+ESY1uQxO374C7IsLIKz/4
	 CBm7/B5UUwNJaQdj7X4hljb7rvG0mAhRlpu7d54/73DqwzVBww5E0VshkCv4sBU/b6gCN
	 gETgTWHkaQxFvzJygJy8/+3x1nL9jPDktdDB+CN6CkY4fSpYLuyutqrjl/rh8ZYPzO+7v
	 fNjzj7MuH7dHNGBNTpH8qcY24fXzVPcGaxDR1zzDBb1Pm4Eu2zoUaUMTk74zoGtaX0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051075;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HU6WVE0x5i5YOS74X/LNgWVc7LGoXpPnHuYRKl7jJi0=;
	b=2cnxbTqyjkJIs7byRUMVgQadbVoJWKV9v6NL8LNgK9hok8rNFIq2Ro6n3UuYL/GIFSYI
	 pHOkXTvUHh40kLVYK9Ug18xt5Aft9n7FHFXKXSyqUPb7fNwifvZwhbxsQpXd/LLKB/IuF
	 ovFOccZBfNScosOfZuSZQht7ZPBEo1zcdAsbJk9K+8l9USmcmwT6YW2DSU8pe1xnOsP4k
	 hUkoh4WdyfOGMXl3Pb0TF7gRN+2QKpcjoHLzMnzgWLy0BSp7BrIkzBl+KjPxEnRHrily+
	 RK6MY3n7p0hV0tXlf3nDHfHLMyWtoNNlxXtsYPC3eSSeNxEeIJ801wprfNEVy9r3r/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YTHNPnJb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA43D606A320;
	Thu, 19 Nov 2026 01:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YTHNPnJb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DD851F000C4;
	Thu, 19 Nov 2026 01:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051075;
	bh=HU6WVE0x5i5YOS74X/LNgWVc7LGoXpPnHuYRKl7jJi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YTHNPnJbBwIJHCIILzO7HoYAtjiVPvAGF8zxZubN8FACcbIUc1Gyzjw+Fzusqbpgj
	 Uy4hMWtkY/cKhky0p4BQafAqD5TFp7ooa1d1p6MEID5jHlYf2A/rc+qh8/CgbTKAFT
	 V46AsnBwNLiCRFAiXl4FnELNx+Cy7yIKftkkeV/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Gmeiner <cgmeiner@igalia.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0078/2214] drm/etnaviv: check all modules for idle after reset
Date: Wed, 18 Nov 2026 15:29:14 +0100
Message-ID: <20261118150013.096030858@linuxfoundation.org>
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
index 0fff51dc97755..ed8f5f8439f78 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
@@ -537,9 +537,9 @@ static int etnaviv_hw_reset(struct etnaviv_gpu *gpu)
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



