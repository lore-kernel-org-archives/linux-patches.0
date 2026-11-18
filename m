Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015902;
	b=hpeoH4HI9lF+eyvz8IDt/Jin7qrNzojHsisgwRSFJ0inNy6A35H2gi2lXehxvKB52tPp
	 w7/tKM5AYMvniOk0FAvAM6edqlGkgpD5/l0zr5deAEc1ISaS8z2/NBGxutsdWBj7vig6c
	 +8jgBBMhVU43onnRFmDFRdxU2jlAe3oo1Z42Gkd6+/3MQ3zYCo1RBjczbLDY3/Yg/zj/k
	 /MP6RcJb0hj9Jyt0EJ9+6jfpN8JYIholiX4ttzZ4o5y2EHILlCqV2egf+yc/giBlkhIyh
	 mTZdRSGIOJ1XJI612iebB1h0wZcToBFB7L5IjB32TWOielLBQbFyZbAGy5F7QFmRBFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015902;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iNo/XgRHTKj/cyfIjbiNDhwxQE3AYH9b8OlX8YCs0xw=;
	b=2c0Ukhket6LbObKTu6TunbqUOzUIfJfBGtfHKbpvr+sGgUQdvgKmp4K+At+s06x6va37
	 fIPetvfAuIfOiQUYxe14JLaD7kBxQDot+L5Dba0i0R/u3jU5+1UhtQLjyrdgjH4HMBCXx
	 8DDkC6G5GrmtPbrDu5joqG6s9Lakxjlf1rAX4eQF9bn3gEeZIM/N8Jugzclg1zD6KxU7S
	 fngJmG9F2ymZvzQDtyXACgR9KMUTz1Ail+kvSvC/MoNOawmfLhbHhyn8Iu7QMUw6PBqQL
	 Li7AoKMQocaowPiNJttx9n+6M9yRJp/5SmOblzRJOYmPNM3rymkUcL/VmUx9gjBB4GQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UDZX+SuR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B666606A333;
	Wed, 18 Nov 2026 15:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UDZX+SuR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF58C1F000C7;
	Wed, 18 Nov 2026 15:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015902;
	bh=iNo/XgRHTKj/cyfIjbiNDhwxQE3AYH9b8OlX8YCs0xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UDZX+SuRFGd02nYO7eNhhbedJtEPfG/0TF2jkpab8Aq6Tng9Ce8kwPVd1x8ETRhQf
	 zXVsmZnJNhqxlr0lPRUZHuPKbzcR61qAlfEwyfAofRJZ87iBtWgSr2B3IWCA6oTWpk
	 6Ci/jxPgL4CCBiD1Y2ByH/+sDe+l9UiWnm8N3OQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0297/2651] dmaengine: img-mdc: Fix runtime PM usage counter leak
Date: Wed, 18 Nov 2026 15:25:37 +0100
Message-ID: <20261118150258.598516469@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 4a1a2d8b8529cc569b769b92fcd71c53805cbeb2 ]

pm_runtime_get_sync() leaves the IMG MDC device's usage counter
incremented when runtime resume fails. mdc_alloc_chan_resources() returns
that error to the DMA core, so the channel's client count is not
incremented and mdc_free_chan_resources() is not called to drop the
reference. Repeated allocation attempts can therefore accumulate usage
references and prevent runtime suspend.

Use pm_runtime_resume_and_get() so a failed resume does not retain a
usage reference while successful allocations remain paired with
mdc_free_chan_resources(). DMA core only treats negative return values as
allocation failures, so the helper's zero success return preserves
behavior.

This issue was found by a static analysis checker and confirmed by manual
source review.

Fixes: 56d355e6f586 ("dmaengine: img-mdc: Add runtime PM")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260813153143.3953303-1-ruoyuw560@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/img-mdc-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/img-mdc-dma.c b/drivers/dma/img-mdc-dma.c
index b3765ba158030..a3192d49b6c86 100644
--- a/drivers/dma/img-mdc-dma.c
+++ b/drivers/dma/img-mdc-dma.c
@@ -738,7 +738,7 @@ static int mdc_alloc_chan_resources(struct dma_chan *chan)
 	struct mdc_chan *mchan = to_mdc_chan(chan);
 	struct device *dev = mdma2dev(mchan->mdma);
 
-	return pm_runtime_get_sync(dev);
+	return pm_runtime_resume_and_get(dev);
 }
 
 static void mdc_free_chan_resources(struct dma_chan *chan)
-- 
2.53.0



