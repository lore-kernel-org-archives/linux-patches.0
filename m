Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025579;
	b=L3UwSlkAp2/eyerACLoWBMSgdPvMufmE2pbuXtiRJMrsbKa5dc4bLl9vCoZffZD2H++8
	 hpNHK4J9O6mopWgt71/R0umOMkaLcDyW/3F3pQUs1UM28oNL93cE8MSc7GEoFn17D1Zfk
	 4kGQQg1VeLdEQw+iGcGybK25NrOt5sV4VlDUnIEsYHw0sv61x4m6PMGp6KvN7UsV7i5y4
	 WiI2AXUnudIGAeHSOqGbenQwRDRdr525I/fa6Lv6rBq++LB6BcRsuNDs+beyg4q4xwpOM
	 g8WMgBlYtquFUjyxQzcppdy8/H0CrsMBrnflAgFXGYWqDvIh22lA/VrN0yv7gq/X6dA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025579;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Nj7jhuFGofoVVRB5vXmJdviwoIBnoXexeD9TmaQqFB4=;
	b=RBkXrEk7ubQNs0flH75WmfJA4Z+DZFP53sdF6am39D5nhytZ0/OQbgkla5hY9hvRe91+
	 P1qt+jCglQ3scIgSBlnmmHO40qVVOEKd0Cj4nLtvEDNORUw4rssoUtDKcMZo8j4MOY5lL
	 gHC1YlWigaUAchDczt0VJHRE25PKuzTlA1vCZjcGx4/IX6nAuXKiqQ35yNHCSIR1INOCV
	 eBia/Z4TxjjE0bGe3S5OpKkjpaqJ+1mdBFrONhEGRr8sUoFRsPD6gAx2AsOYIXAnbZVxR
	 OaQmRMMavnIKk3JZpNYSIshC2wzXfODR+ZNjntFuzFCCNH2bSD1Zs5WHBRfIzppg5sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IKxhOKvJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF7760A2604;
	Wed, 18 Nov 2026 18:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IKxhOKvJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 884071F000C6;
	Wed, 18 Nov 2026 18:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025579;
	bh=Nj7jhuFGofoVVRB5vXmJdviwoIBnoXexeD9TmaQqFB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IKxhOKvJi3euZwnlGiquqY3X8V6+6X6zwSJVt0ejwYkS22Pw5vmILpck726cY9z20
	 KzU90Xk36uenTjZAYoamf/l0ROyJdBo49nGpKKG0u93Afn55fYkK+ZybBh6v5RQYe2
	 api74aMuytAyVDfwfYcE0hq0azNDZApnPyp6fJRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1129/2151] dmaengine: ste_dma40: Validate DMA specifier length
Date: Wed, 18 Nov 2026 15:47:44 +0100
Message-ID: <20261118150203.329764107@linuxfoundation.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 9f1064ebe17cf3ab65ac6eb166398e02678aea33 ]

The DMA40 binding requires three cells, but d40_xlate() reads args[0],
args[1], and args[2] without checking args_count. A malformed provider node
can specify fewer cells, leaving some of these values uninitialized when
the OF DMA core invokes the translation callback.

Reject specifiers that do not contain exactly three cells before reading
the argument array.

Fixes: fa332de5c6b3 ("dmaengine: ste_dma40: Supply full Device Tree parsing support")
Assisted-by: LLM
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260927-dma40-fixes-v7-17-89f595e8851d@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index d51b7c19d42dc..bc4e30d46bdc9 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2395,6 +2395,9 @@ static struct dma_chan *d40_xlate(struct of_phandle_args *dma_spec,
 	dma_cap_mask_t cap;
 	u32 flags;
 
+	if (dma_spec->args_count != 3)
+		return NULL;
+
 	memset(&cfg, 0, sizeof(struct stedma40_chan_cfg));
 
 	dma_cap_zero(cap);
-- 
2.53.0



