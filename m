Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055382;
	b=j0MAxHieYktFtW5sqKuhCOuz3pvS1vtAI3qeH9jTISHuENfLyb/smLkRjEutNoi+JC2m
	 6FNVwCt3ad4fzDJ8woPftUlCwTy5RaR1YsKvxZJopPApBp1i6FkC/gRiXR9h5LojIZIcu
	 xolG1xix6THrJFJzkZ6R2o6YeuE2nyxax+4bH2JuNXo+0PNouVWaGIEJYJE3JpXWzGk9u
	 Gjl1nfq3IuuXkRJdJUxY3RjelW6wTQnGnuW7oyRQ3WTft/XpbbSXx/Y59vaDl4eON+qWL
	 Rkyy8yz2o/RAYZ18HcSsH3Vac9v7PiT2gi+8l006dRqmqvEr+wuu5clizM+CD2jv7mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055382;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zsuOjXu65lmZOtZVPMsPVHlwe1Omy1C+qZdzmUgSZjc=;
	b=qCR8qy685/WEsZMm78xsuqRzNFjIh8zTsYlhbGO9weldTxsYphK3OHU4HcqmJfAU/ogs
	 ZlzCYfP6X+bq4LrrMJ3WQPeuf0QlYZ0F2hpPqbciI6/YRX7yq/qJcIIMjisFNuamS9Xs4
	 RUQXV/DsS31eFHUNXAEbQvVK2aLXfFExed72HyFfJwWbNvtQ54k169ftSQOXCQH22X29J
	 NpMiRnYDOU6+VbTYNJZvhj/gWxiiBmGoLcCuWMuN3/7OUtnJNB44nHCVa/PnW3GG55ZYw
	 JHHSVXbe15s2LQceK6t1ccw3bEziMtMqD6jdqy/asaMOApN528LDvchu+Aau4BFlCUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="mIVG/8Mf";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF72606A332;
	Thu, 19 Nov 2026 02:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mIVG/8Mf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C503C1F000C9;
	Thu, 19 Nov 2026 02:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055382;
	bh=zsuOjXu65lmZOtZVPMsPVHlwe1Omy1C+qZdzmUgSZjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mIVG/8Mf1DDimbUGT/iMfpSUDjcchincsqTKA5U+OhkHSf9iToHj7dLs2ZDUO0uJp
	 KZF2OBTC0aF1jpQ8fKdg0AY+q+uSLycXgyny9PyrkUGgaIM/XzrcxOyZiVVqOGSJnK
	 GpjP+U4opVTd84e7ClySq4o5plxRdG25jwjE8h4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <bolin.liu@seu.edu.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1594/2214] ASoC: fsl_asrc: check the second front-end DMA channel
Date: Wed, 18 Nov 2026 15:54:30 +0100
Message-ID: <20261118150115.744345266@linuxfoundation.org>
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
index 79dd5a9b8f481..e547e2e10cab2 100644
--- a/sound/soc/fsl/fsl_asrc_dma.c
+++ b/sound/soc/fsl/fsl_asrc_dma.c
@@ -231,6 +231,11 @@ static int fsl_asrc_dma_hw_params(struct snd_soc_component *component,
 
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



