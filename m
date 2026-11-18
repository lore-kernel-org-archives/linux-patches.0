Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024453;
	b=gLubqy9rdy3xt7IBAYJ5QzqQOLQGaTVafBsjXBB+7lb/QMyItyJx0wSWCxyLBJ6rucu4
	 tVmBIo9oajhsEdtiXMNdI7cjA5eD2ty5om3S02HCZHjriuT4r0cTE/RnQAM1WqAnl3V10
	 JJnUblFQVFwxPrf/o0sShjyXpA2XcylJ4BU55Uu7A4/q+moCB4aXNvu7tRVupWIg7OByP
	 m7rzPxPWV+W5VPuxRW/RMeaYAlh3WKxywTw0HS8ofGZxeYrEFTc7NmJi2oQmdcMmnJRBv
	 PNDc5ivW8ju8IXl0JwJMCIvfEPHQl6EwMEE5AZUIxw4jrzy5TlsXUL98qnKn3Ij8g4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024453;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UveWj8/sh/1GTVYfMz+ffbkfLfJDThz4aAV875ztzL4=;
	b=P8RNhXUraFs4VzdDpeEAfotCkDBl/ZrIwqyL7SIP+eLhCMiXRV9vZsGja3gKiqVwI1wG
	 mXJWT2apFvt0CwVZKUJsRZCBhGjGb3wvOSbyXIvA/mYhdR9spg1LJNxA0V4CZ8t6z7hm3
	 ka4+nAGGqMrvmiLdlZWhFV8njRjO/oLyL2cZOnwAZ8soxelCbiQWxxHZujoUYIfsDe1ok
	 /xfc/PqOMAj1t4R0qpkOLkthhvyVQ+wcKhUTs3y5QvhR08cxhiqRNvCpqQqKMBkpxKV2i
	 qvpxb4ymxbhIqZkeBktnsHvU/Zhkx753Q5kl3R0PFnCN4WbJ8iEQdCt3XyZ1GzIBVJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A8iBlwfN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91EA606A320;
	Wed, 18 Nov 2026 17:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A8iBlwfN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAF781F000C4;
	Wed, 18 Nov 2026 17:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024453;
	bh=UveWj8/sh/1GTVYfMz+ffbkfLfJDThz4aAV875ztzL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A8iBlwfNroOc7DZ9UJxhLcPFMVbWLXQDbaX1311lTVx9mBAjzwfSkwSipjO+Fevx+
	 U9yDC3zzFUbcAb2iZMOjUbmagfmvIVbqgxtaBghN+8exBS8J75+km9D1bQv3vFmKzS
	 DAbOLOpkiSnkJ2Ac38LRTaxB0taN1V2J9rpgoV1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <bolin.liu@seu.edu.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0694/2151] ASoC: fsl_asrc: check the second front-end DMA channel
Date: Wed, 18 Nov 2026 15:40:29 +0100
Message-ID: <20261118150147.065469205@linuxfoundation.org>
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
index c96369da6aec9..aba20404c7d71 100644
--- a/sound/soc/fsl/fsl_asrc_dma.c
+++ b/sound/soc/fsl/fsl_asrc_dma.c
@@ -246,6 +246,11 @@ static int fsl_asrc_dma_hw_params(struct snd_soc_component *component,
 
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



