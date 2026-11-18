Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043092;
	b=Onitg8DLxyUfvqbBHgo7OAbUt3+jsYYrN5NdOllQwaPYz9xXnmGnvxNpvYTHWDGvLWqN
	 mtvTdKGVyLQ0PYH6zplGlz07cAlWIaLPtywuEiHogKrCN2T3p9obIF23dv9OA1eRDHRlY
	 /rzhMzOMsYf+jsijRIMJPZJm/UfD8Ifesi30c0dkcekeLgByOjVDQlu2EWTZyTQdAylcq
	 vXhz2XiTe4sQfIAU5g2UtZsq9RW+UA9s4OsuTeXpYJKO03+OOGhVF2NMB63Ctz5OBu9nw
	 BwRS66MLIiwTER9WbCoFNOH4wR71PG1yPscexm3is+aI4jlT47xxJboY1O5PuptzCuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043092;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gLMgBzp2Ev1hH3kk03TtWg6srqvF46EqYzTNFKWvfiA=;
	b=LX6Hz7rwaP4mJa7GERJEkyAf+/CQVffR0pMCFsoGECJa9gys5AZ8L8N0q+rh4uxrgdL2
	 sVF/vUW1ICu3yipDuFZ92dD4Sll1KO/wYtDI97rLqdfqrRFa1x8Ep2XUZ1RAmAyXhYPfP
	 EWqhcqAs7a0KGvAzV86t3VbHJm35ubBk6bVf6kM2ctsQEDDAIVHpNEEPenO/VmbC6xHVL
	 eJsIFdybcdh2nt1BKaOtlgB2VqBuwgM8RKVZ/H1Esj9Azp6YRO32kv/5CxENN6Bo0xTdj
	 fmgy+JiFJWcrQSf9X61gDUxe9F4Sh+i54zVxQkjt8uB9qFYzv1/gl2Jo5hCi1L3MLYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="wqEY/6wi";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02CF3606A320;
	Wed, 18 Nov 2026 23:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wqEY/6wi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5820D1F000C4;
	Wed, 18 Nov 2026 23:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043091;
	bh=gLMgBzp2Ev1hH3kk03TtWg6srqvF46EqYzTNFKWvfiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wqEY/6wifVIXieIyowTgnh68+2ptjgUU6nYiaMosxhwkKDaUvR0ocCGwa9DhLM59g
	 6P32hAf+Xu5GBiqHeuhB4Q+PukxvBlNXY08u9dXysvoylFG6JHsTOpWLM74Hm30JwD
	 raIsQ4nma4LLuFRMIYqdy+tg97c+9xGfbuxaLwus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Gmeiner <cgmeiner@igalia.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0087/2857] drm/etnaviv: check all modules for idle after reset
Date: Wed, 18 Nov 2026 15:18:41 +0100
Message-ID: <20261118150204.418085680@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c0410e314dfab..dd1c1391acfcd 100644
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



