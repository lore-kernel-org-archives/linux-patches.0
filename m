Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040897;
	b=osbOr9EGVjZYA3Z6k8rPQtWvk5oDaFfUVw9EDDwgO8y/Ib8Z17ilts1wySNHgbVLNi27
	 YWm7mT6mByen7XM26Kcai8IGiJmf0V5sfB9VHQ0VjxETLHULJtUyrumzc74xRQ9H9NJf3
	 Pz8gNoVotIOXKNkSejE8TkUi4135pc9Q6Hbnl83meqB28prOhGJA0WKDK+JMcv9CnMjkn
	 fjDyZKowDKRHLjD+hMwJP2WYJ5nH2oN9i7xz/GaQTjUpxVTovMpd9Oi6gjFFGFVeC7V2E
	 73OhAD4Ywcz6fgdqla5t1UZd1TpJGD1Z3e7dWw6KYCeZt9g/54NaB5Z90lsP92FKrdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040897;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Kkni7O004+3giP4/6A8ga2hKEInPm49AsvErw6cXz7Q=;
	b=FQD0NbLcxz57wFDkr4rcib489TNwp68EKzyataAdIYR3N+4LsC/VZ5nSeNjsEhD9KO1k
	 FNGa7n5rGwaz6zkJvxvzYtszh9Kj3uzzS0yxzJsHouHQJZ73GYak+lwXUO5FOW7SSYAAx
	 oDijOFJkBmYBXE9Fc0tsnpjDO5nBqwByV8B2ssrjIkF+qQd286rmdlHtaBXm6UH+8uVx/
	 3lUDwVAb8B9xEg1kT7sskaHQT4OqBD0f+rFIkCRsm4z9BNaKdfJfRjsx7BZTDoPfR/7JS
	 //JOI+/Ofw8PRakJDA447+hFg1jx4J9Qm9+AtYP7uFWXHWvSgkijysHVaqBHboORI6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="zy1WRzo/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13713606A31C;
	Wed, 18 Nov 2026 22:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zy1WRzo/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62EE71F000C4;
	Wed, 18 Nov 2026 22:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040896;
	bh=Kkni7O004+3giP4/6A8ga2hKEInPm49AsvErw6cXz7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zy1WRzo/xFzU+p14Hn26iPznqwuTk/Mz5C0NjtLoPDY/zgQhOoOywVce2UnLTXMhL
	 sQD9+n1/ieYDq43seMpGHDzRYSwbk9+QRsHDl4eU1VRBW7yEjBFpe0eQaevoyR7OEQ
	 T0V+9v+arQ64UrOTbfiSQUD3JJ/XOYZbDB2dG4rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2619/3318] dmaengine: ste_dma40: Validate fixed physical channel indexes
Date: Wed, 18 Nov 2026 15:54:01 +0100
Message-ID: <20261118150439.684877734@linuxfoundation.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 884e01160bc727509b4fdf04e763a86b936df464 ]

Fixed physical memcpy allocation uses dma_cfg.phy_channel directly as an
index into phy_res when use_fixed_channel is set. d40_validate_conf()
validates dev_type but not the fixed physical channel, allowing an invalid
configuration to access memory outside the array.

Validate the fixed physical channel centrally before accepting the channel
configuration.

Fixes: f000df8c5a0e ("dmaengine: ste_dma40: support fixed physical channel allocation")
Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/dmaengine/20260819225008.5F9651F000E9@smtp.kernel.org/
Assisted-by: LLM
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260927-dma40-fixes-v7-23-89f595e8851d@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 4000335cd4211..2bca7b5de308c 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1787,6 +1787,14 @@ static int d40_validate_conf(struct d40_chan *d40c,
 		res = -EINVAL;
 	}
 
+	if (conf->use_fixed_channel &&
+	    (conf->phy_channel < 0 ||
+	     conf->phy_channel >= d40c->base->num_phy_chans)) {
+		chan_err(d40c, "Invalid physical channel (%d)\n",
+			 conf->phy_channel);
+		res = -EINVAL;
+	}
+
 	if (conf->dir == DMA_DEV_TO_DEV) {
 		/*
 		 * DMAC HW supports it. Will be added to this driver,
-- 
2.53.0



