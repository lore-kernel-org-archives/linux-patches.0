Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060833;
	b=GLoohfPceYgdJqn+/zmVuYsa3fvWd45pJzB8U7nLfKqddVDvOMkSXYVs74DEEIB/8ogO
	 UOnHLTNMU5SmBcTIr46Xo9Btz6VYgzz5/udI6VhkqYKvjDkTEIDrKbCPSmaCVOjHd1raV
	 Q06iwrt3KMuNx/n8hWJtsYU3rR6NH/c+8M+5GoIGx90WlAGv86F2uWlFN5c8BzInq6MAJ
	 2UW7XORzV/QHu3EtOnMVAF5w+JKqNc3pDGahnhzStsXqSqS68808H8jfl5m5Rte9DbTE0
	 ktUcaMXhDp5hdHUKvNKNsQM5NbKZnMwfgD9J4Im4g9Z0WtVuZLVvfHMB10PbiJujVQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060833;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ODIPvrDNZYoXW28yJJC9hK9ZV+W644TBn+Akcpuk4Wo=;
	b=Gkgrzaf8cHyEhsgYGn6wPUPM9usygOxL7t6xxKF1VKFewwCsCFQTJqdR4h98CnB2toWy
	 SkLtArV57hMOy19cblNrKOkPbXSkmP1B/Q+U0JH9anmJNdTY80hz9V7O4lHbPx0zWv7CU
	 XDmJ/iEWYgllPZghOj96JS4kyZoC948J5j6cswQUri7zIGY0Mf565gSaQnVPLfQBB2Ed1
	 WjijFH/WlS6V6sMblIIIOJ18vSAj68RYGrlWikQ+bmrQMSe1/Q2pDVED0xsrphos3R2SM
	 f0FgKbNA4fRThNTcHolZPC8CIOEwGpujDCIcGAFt6kPNUqchRnq90z41tggI2zqGUpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wwYJia0U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07F16606A326;
	Thu, 19 Nov 2026 04:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wwYJia0U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E0A1F000C4;
	Thu, 19 Nov 2026 04:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060832;
	bh=ODIPvrDNZYoXW28yJJC9hK9ZV+W644TBn+Akcpuk4Wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wwYJia0Uwv9MpeR645U2/4UAFuzmuFcKPAdSMlQ4bVTP53V1J4mzEzZlViKnHRODr
	 FeBQcmNm743nWHP67q8a9VYVPOealqUlj6nmz9jom95vy8AeVl29R6YUVWu+SaKl1d
	 YGRDS7/pPXa7ElDHbOXosaCTfMVUFCMGNV0ajDA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <bolin.liu@seu.edu.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1341/1848] ASoC: fsl_asrc: check the second front-end DMA channel
Date: Wed, 18 Nov 2026 15:56:19 +0100
Message-ID: <20261118150015.834703293@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9b2a986ce4152..e88d2936c2073 100644
--- a/sound/soc/fsl/fsl_asrc_dma.c
+++ b/sound/soc/fsl/fsl_asrc_dma.c
@@ -230,6 +230,11 @@ static int fsl_asrc_dma_hw_params(struct snd_soc_component *component,
 
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



