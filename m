Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023362;
	b=cHfhb1wWA+n6SALAsWpGSrh34vutIGCXoqb6elwlYMxM5mzrFZwpunZtkG6pYzWAqMTM
	 MW+OYJ2F5RtirniVh4bmoQlSvjkPnHgsFMGzXZV4jEcOhljuUsYRnrpWwdDKOD2GEHb4k
	 uRhLSD/nBBYpOkqH0sfgTR96yJUybuVV4I7nNdwCjaWaGX0Cns643rBcKUDc31PpxskeG
	 7NPssMkkg2jUd6AfJTEX+FsP38cZXoyT47S2BSR31Tk0L7IBglwwhzO29x7f5vWWKAXEB
	 74adeP7XLVv33yq49mwWvr+01xfO4MA1Fek1hrx3rq1Yvfu3Oku/xiTZIL7h6DTlcjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023362;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WQ22gx2ToTPGRYHByO84FVbEh8oxEqTSQVX5bZ1NV80=;
	b=mWf83mdX4lcA7HPuJEfCt2lfPhdel6h/ZBWLRmK/SC9CUuBSpJ3h2B/PHvCiR/VdW8Gw
	 xoKOnw+CmPI4X2NXJYhNeivxEwR3kAgRvuuv5Wmh0Fc74xfYIkj/x2P6FajoNgYTU0+yz
	 N12SP6VAAhTigfukYEnN68NufYcBathw/C1XVvmEVjCzpm2ZH0aOcm6ZVyd1PhYpSG+n0
	 OcWATvvsLiZm3IKTaHkY6nH4+Bim1PO50T5yW4hsjc6GsK9qq1pooMp9ZRoj86A7i0+Fp
	 uXMh9hx/E8M2oavoLJMqG4TmEIkPTYkXVjDrSTFBdjKw2/LwsCTqAhNvaFZdnK4xF+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wOU5aqeQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1EE3606CA67;
	Wed, 18 Nov 2026 17:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wOU5aqeQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 084B41F000CD;
	Wed, 18 Nov 2026 17:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023361;
	bh=WQ22gx2ToTPGRYHByO84FVbEh8oxEqTSQVX5bZ1NV80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wOU5aqeQO5PEXojBqmnLDdWU/ACBOJ83sGcwVzCK4+6jdAOHCJqRvyByl6RLI/J3W
	 ukfGLvQre9qyflZ4Uo2wmGXd3IfYFRIP8uIoG0YT7dxJjpRJI9WMG9OvbEy6Y00HND
	 O0NCvtvPvOHR7iWTil/uNVATOkCvnNnqBzP30B+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0299/2151] dmaengine: img-mdc: Fix runtime PM usage counter leak
Date: Wed, 18 Nov 2026 15:33:54 +0100
Message-ID: <20261118150132.807579193@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index fd55bcd060ab8..be5c10e83af5c 100644
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



