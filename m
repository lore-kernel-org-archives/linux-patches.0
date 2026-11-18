Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048569;
	b=lA3xtFHKYphIYcY8re9sWqCar4Wrr3BAG7+JRQyGLJKUoHKWu4sB2uKgtrqndgcQyUaL
	 pA4XNafKnMgvK0+b28qadIuZnlX4bRp2wZSLPHomZcpmwGqBZYmAxFfANwpmAzlSpfcil
	 w0sLVovTDFgfmd3luvENWRxlYozVCR7/qj7UUp2FShrOZkBJ6I2GtPSDILFdY1k4JU7h8
	 +3qem/WuGFb8Yy8p0rpRFBWfV7m/fm+qv81937P9lNY9AeZmxr3OOvF2xiRzZQLyJSGcz
	 1pWmQHZPs3R0j+LGZs0UYHzysn/JUB39h/lCUTGrVxK2GHqeYlMtH3b4PpACfxlaDyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048569;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0Xtd88gKiP9SaCgy53PmZgS0RnqJWSuI8B7N9u5ngjw=;
	b=Kshu87CuMd5xbrWdnkhH8Nuwlq7SOK8GvNU0iC2tgQlEaNIXbS+cgqYmvDcKJjRhLU+z
	 704ypWeb6FttOguKD0Qtt1g6mXHLqKHbSdknZjRDN/sQvkXm6+cfYvFg9Z83ne22pvSFI
	 Z7WwwTD3SUsVvyGKUeSm0HM2QMnUYbNpp4bP9yJ4D5Y/ChQgqaC05E2acGtunzylwoaMh
	 bmDIpuswX+5k40X7hfcXv7QHBL/dnh8JkOrrKThvsL51KMc1YlJhB8QkBzxxzwjSGV36j
	 GnpsiVRYD4GbH/fnIfPbmUMMTNzXsb0NeKh8uzkQGlNtIwLkmBTVVRXueCLGB21BDDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=09VqFev+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E7D606A31C;
	Thu, 19 Nov 2026 00:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=09VqFev+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4E511F000C4;
	Thu, 19 Nov 2026 00:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048569;
	bh=0Xtd88gKiP9SaCgy53PmZgS0RnqJWSuI8B7N9u5ngjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=09VqFev+w3yrvXpc8G6okjCIUMID/Zp885v7ZDU2Q//KYjlPLw5S5C2mG6BQCg8cW
	 GMZiDTeVwTIGhuk4dMr0kX0RCUcELqkc4+Dn3ARXWq/oiDCCX/L1oW6TY5bmb6Q33g
	 IdmhC1qdJiZ/yf9n0lMY3GfCRcMZj+QkbnbVahDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <bolin.liu@seu.edu.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2042/2857] ASoC: fsl_asrc: check the second front-end DMA channel
Date: Wed, 18 Nov 2026 15:51:16 +0100
Message-ID: <20261118150314.937641669@linuxfoundation.org>
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
index 91dd85153e83e..7c6f12816deda 100644
--- a/sound/soc/fsl/fsl_asrc_dma.c
+++ b/sound/soc/fsl/fsl_asrc_dma.c
@@ -233,6 +233,11 @@ static int fsl_asrc_dma_hw_params(struct snd_soc_component *component,
 
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



