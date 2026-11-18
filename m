Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033696;
	b=kZzB2Idik583oCZ0x14nJSQgccBdcXTTOZD1QW3Ys+xvDA7vDMwUAU4hYV6LuI1LHAYW
	 hXhJ7SkFRJpGV94oqfKcIt4sQqBKOIsq67lXuLaa26naDUQ1v2H7ollop6IaVFJQxJ3KR
	 ejci+HgDft/Gy4MPnNW3CqQHSadfKVZk0TvEhQGWeRaEJlqJ6G3Lw2e6Qf5V9CK8eqG6b
	 EqB11/MfIRC8kzLuVZhsz9v7aapdteHbOaJTDINv4HZANBYoG9JNx9fqJh9CrejFW1Jh3
	 knnQ1U3DJyLlmE7va5GMB7t8clKkleLpEcW+UfYGF1axvebWWW1r2ZJ9wcB3e3deRIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033696;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ochCe3CdpEJswxw2/+yaoRrVtsceiBBCwqPCTOtByyQ=;
	b=HMP4v8upCdTI3StL6y4MyIw85i0aZVmd1K0rw4lsxETnSll+q8s0LfOPhQgIGyvuQisN
	 GS6jLGACgglWabaw8NUum5V54NIefTLI+QMLI4EFXb1W+uKRNRiJMsb/l2MlRdSUB+lDP
	 3cPU/unDdPqsg5D+AZWifwNuzW0z+fYBrhmknEvCWDOYYZMQNmA+OjQnXPgtk0XRvz1Qb
	 xRRJlR+phMYft24sRd++T73guuoihY1etK1ZgfGRJgZQ1jRupc+H+dggl4KsDLiubYF1p
	 cpNFCJQZK20NYu8zrtTmlhdcV36zogumAH271VQBUSAM//VWaj5+G6ozQo7LnqhLJOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QA5skwaa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67AA3606A325;
	Wed, 18 Nov 2026 20:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QA5skwaa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F661F000C9;
	Wed, 18 Nov 2026 20:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033696;
	bh=ochCe3CdpEJswxw2/+yaoRrVtsceiBBCwqPCTOtByyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QA5skwaa4e3jaxMXDtZ8an0c3C9g6K4qiQJjefs6616x16M25LBcdJlus69tYVu2D
	 WLFtUcp9KOJgPaNHs2n6jsEUfnY7jKgIe2RRD6oh1kGYv9XlY0fi7mKzEXvX+eeNfz
	 /5uThMPqvlBCjt2TbOeEkPNYrmj4wREmQG4GSUKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Gmeiner <cgmeiner@igalia.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0105/3318] drm/etnaviv: check all modules for idle after reset
Date: Wed, 18 Nov 2026 15:12:07 +0100
Message-ID: <20261118150317.396971094@linuxfoundation.org>
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
index ad543a7cbf073..5108bf28f73fb 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
@@ -545,9 +545,9 @@ static int etnaviv_hw_reset(struct etnaviv_gpu *gpu)
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



