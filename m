Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598ED3DB8F
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FAadI5rw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7EB9C433CB;
	Wed, 15 Nov 2023 19:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078321;
	bh=HdJ9xkSnlvji5RJIZsRiSbsSaq6ulhRGJE44xFdlDQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FAadI5rwWJQlf1YHjjFiZgAnG006cjnRe7tgOYGrF0BpF+gak/cqo1JDmejNbi1LV
	 bfuZtUv5zziqi0PCBBjRhYNowch6JKckdRjzIsmeZt213mLc5VFmHpi4plyNXuuI8m
	 hCRQy1fIIvQ0oLi7YRjK3RIfp/wGzaSTgHmsm2Bo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 216/379] ASoC: fsl: mpc5200_dma.c: Fix warning of Function parameter or member not described
Date: Wed, 15 Nov 2023 14:24:51 -0500
Message-ID: <20231115192657.890222923@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit 4a221b2e3340f4a3c2b414c46c846a26c6caf820 ]

This patch fixes the warnings of "Function parameter or member 'xxx'
not described".

>> sound/soc/fsl/mpc5200_dma.c:116: warning: Function parameter or member 'component' not described in 'psc_dma_trigger'
   sound/soc/fsl/mpc5200_dma.c:116: warning: Function parameter or member 'substream' not described in 'psc_dma_trigger'
   sound/soc/fsl/mpc5200_dma.c:116: warning: Function parameter or member 'cmd' not described in 'psc_dma_trigger'

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202310061914.jJuekdHs-lkp@intel.com/
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Fixes: 6d1048bc1152 ("ASoC: fsl: mpc5200_dma: remove snd_pcm_ops")
Link: https://lore.kernel.org/r/87il7fcqm8.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/mpc5200_dma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/fsl/mpc5200_dma.c b/sound/soc/fsl/mpc5200_dma.c
index 9014978100207..3f7ccae3f6b1a 100644
--- a/sound/soc/fsl/mpc5200_dma.c
+++ b/sound/soc/fsl/mpc5200_dma.c
@@ -100,6 +100,9 @@ static irqreturn_t psc_dma_bcom_irq(int irq, void *_psc_dma_stream)
 
 /**
  * psc_dma_trigger: start and stop the DMA transfer.
+ * @component: triggered component
+ * @substream: triggered substream
+ * @cmd: triggered command
  *
  * This function is called by ALSA to start, stop, pause, and resume the DMA
  * transfer of data.
-- 
2.42.0



