Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017168;
	b=klXT+2XLSY1F+bLacKcl3iwLnmi/2l1FLNR/N+R/yVzOQoNuzeE0w+LS1mC5AAQtjOGW
	 4676NidDTVVwZxGyNTJUgoff5t+GBoG6gVNa6pZbq5Id4gHxQSjQxgkFJUen4s1825usA
	 oXv2/frgcYsEM2cl9RRA0DPoi3r410XK3P0H2di+sdHqKFQkbr2EninorTOnoYlf6NAru
	 dAr8TnUC2WaTD0AyUO1TywsE8vr9v+sK+yRVvIsXM1MJ59MNJ18OZn29OWw2PdNIAj25P
	 YKr1E+gdIXN4I4ofhC660m1PindXXFEP2JT2sFZPkQLG0DrY1ryHxoXNPODr02FqH3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017168;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Fl7rJOiduvNQpCyxYfGDVYUCrPJUpmkmpWjDeR27uRw=;
	b=g8SxCyDwLoi1CQM7OkIaxkOr6fsHU2hnf+FLUbqWWdYqT8L/pqEvn+6ogm8oscK43VUQ
	 K571M3h3CTe4uMCLK+UXgMfeeP/3ZPc719vFGYMGkHIg65mrV1UQ8vMKpoMgvwXy/AQ8k
	 baWslVWGTV7T5gYMTirqClttHZXdjEoQjy42DPWNjLxNl1+V2ONRAW3mRJ1UoFF65JVjB
	 zqEMY1wGzDmsbUr9G7uJbRZKn0olhUihFHFNsco7NTURuap3CBogNcnleFSaOlJCg6Nis
	 rZn6dlHhGGj/Ij1+ehPKhDvzrjVQ3yTBzmTyPPaxeqguLSJH6O7Iyfnk24gf5R9oOQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xMMnJU2K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8B7606A320;
	Wed, 18 Nov 2026 15:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xMMnJU2K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFD9C1F000C4;
	Wed, 18 Nov 2026 15:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017168;
	bh=Fl7rJOiduvNQpCyxYfGDVYUCrPJUpmkmpWjDeR27uRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xMMnJU2Kd6vuTK0KBhdG611vy1LfVPI4srlvbDzCZCvXXT5LxQJM4cLd1e1I8ZM7O
	 UELqkHWRRAJnMvVag7FQoNB2WKLx1lRrCbXKdvO0JoIzmnxi8OISn9OmQVX5/sJb5I
	 jXQL97bKEDvr08Lva0M72sKj46OvuMdUxON7F344=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <bolin.liu@seu.edu.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0789/2651] ASoC: fsl_asrc: check the second front-end DMA channel
Date: Wed, 18 Nov 2026 15:33:49 +0100
Message-ID: <20261118150316.291694628@linuxfoundation.org>
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

From: Slavin Liu <bolin.liu@seu.edu.cn>

[ Upstream commit b4136c0d69ead737197af741e20edd1c3574f6b4 ]

The temporary Front-End DMA request can fail independently of the
persistent channel acquired earlier in fsl_asrc_dma_hw_params(). The
returned NULL pointer is immediately used to read its private data.

Check the temporary channel and release the previously acquired
persistent Front-End channel on failure. Clear its slot so a later
hw_free cannot release it twice. ASoC marks a component's hw_params
only after success and skips unmarked components during rollback, so
returning an error alone would leak the earlier channel.

Detected by static analysis and reviewed with AI-assisted source auditing.

Fixes: 3117bb3109dc ("ASoC: fsl_asrc: Add ASRC ASoC CPU DAI and platform drivers")
Assisted-by: LLM
Signed-off-by: Slavin Liu <bolin.liu@seu.edu.cn>
Link: https://patch.msgid.link/20260913125147.109920-1-bolin.liu@seu.edu.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_asrc_dma.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/soc/fsl/fsl_asrc_dma.c b/sound/soc/fsl/fsl_asrc_dma.c
index 2f662bdf14d07..64f2b06122743 100644
--- a/sound/soc/fsl/fsl_asrc_dma.c
+++ b/sound/soc/fsl/fsl_asrc_dma.c
@@ -248,6 +248,11 @@ static int fsl_asrc_dma_hw_params(struct snd_soc_component *component,
 
 		/* Get DMA request of Front-End */
 		tmp_chan = asrc->get_dma_channel(pair, dir);
+		if (!tmp_chan) {
+			dma_release_channel(pair->dma_chan[!dir]);
+			pair->dma_chan[!dir] = NULL;
+			return -EINVAL;
+		}
 		tmp_data = tmp_chan->private;
 		pair->dma_data.dma_request2 = tmp_data->dma_request;
 		pair->dma_data.peripheral_type = tmp_data->peripheral_type;
-- 
2.53.0



