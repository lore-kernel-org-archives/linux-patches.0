Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831449;
	b=Mj7m4g50K0XMgd1Zf/byMJxxfkRGL4lIlut3De1P24DVSS5YTWWYzQPbT2ajNWe7KkjY
	 xjOu/WrsnzF/wBHjgnSfpTuzF0QeEgRmWdAjcvR6Ih9pc/H1wguFktbP9IfrnRP5th8kl
	 SJ2REZoE2oxxXQdj/TX7quTruyl6drk+TAw80FjyF2ASIcpwNPoxN2SGO9MElGL3lHekm
	 0hwKhveYM3u4iv+863Avz0XTgmGIt3TWL1YO3FDUtxGYyOm9dH+XFrlfxkiuDq4zPGSFW
	 /F8w1BOgIrn09Y2tI9oaCj792XqwRge3vNeUt7NEAN6F3NN4mIHUM4XSGm6V4U1WqDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831449;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cduQshO0MuV/sTnFm7630F+Qnr6rPxsndYhLUmO28B4=;
	b=x93K+YobguRiaBh6gcqKyqtC0E96Cmvd0SNBH1CjX9yqIYw8OWYt+eSp3H6acaiPpzrl
	 mVf6zRTvXrqClFmbACZZ6XGCaZuuXm+WJ0EAtqcCpSZRuxTbSlxFBjbGq8A7q2mIHfpSa
	 iy0nGKaRCLCZf95VwPFbR/k2LCkWlSQC+Nefw1h7VF2DJwJUMPJwV5du4p2kY4O56Q8X4
	 w2P1IF9q55uA7ryOdzuAHMl4/dGOpHeEwv4e2m8pwk/a6Q0kQouUWZGORX39SUn+ZUY8D
	 fAueiHxCgdLlCgAqztGwIfXchCvRP9qJpnbi7MxuKlDqDaGeizZOj49RJSameq2J7dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CyU+TLGV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D1E606A328;
	Wed,  4 Nov 2026 22:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CyU+TLGV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDE661F000C1;
	Wed,  4 Nov 2026 22:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831449;
	bh=cduQshO0MuV/sTnFm7630F+Qnr6rPxsndYhLUmO28B4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CyU+TLGVyyrw/6rhpTjdyzcWqqRUYeQeg9tOOO2GbqdbSwZoGgRx9gKjsHszUA+zo
	 GuugUlF5c+EAKcI0dpWQueRzI6orGDdEmkz02Ah1AGoYOBV7Pe71HOwdHofxN5vvn5
	 VbCvZaqSnxDLav0j6i34+QkJyZ7xOiVQAvrKWBmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 0708/1005] ASoC: amd: ps: fix snd_acp63_remove() teardown ordering
Date: Wed,  4 Nov 2026 16:07:21 -0500
Message-ID: <20261104211103.398705914@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Fan Wu <fanwu01@zju.edu.cn>

commit c53791d673ed4da6759d276078627ec4d0c6536b upstream.

The ACP IRQ handlers dereference the SoundWire, SoundWire DMA, and PDM
child platform devices, but snd_acp63_remove() unregisters them while
the interrupt is still held by devres, which frees it only after remove
returns. An interrupt in this window is a use-after-free.

Mask the ACP interrupt sources and call devm_free_irq() before the
first child device is unregistered. The masking goes through the new
acp_hw_ops->disable_interrupts callback, keeping the remove path
platform-agnostic. The interrupt line is shared, and acp_hw_deinit()
clears the sources only after the children are gone, which would
leave the line raised with no handler left to ack it. The window
predates the tagged refactor, which only reshaped the dereferences.

devm_free_irq() waits for in-flight handlers, but not for work the
hardirq has already queued: acp63_irq_handler() schedules
amd_sdw_irq_thread on the SoundWire manager. Draining that work in
the manager's remove path is a soundwire-side change and follows
separately.

This issue was found by an in-house static analysis tool.

Fixes: eaf825037d6d ("ASoC: amd: ps: refactor acp child platform device creation code")
Cc: stable@vger.kernel.org
Co-developed-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Reviewed-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://patch.msgid.link/20260929061349.3879-1-fanwu01@zju.edu.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/amd/ps/acp63.h     |    8 ++++++++
 sound/soc/amd/ps/pci-ps.c    |    2 ++
 sound/soc/amd/ps/ps-common.c |    2 ++
 3 files changed, 12 insertions(+)

--- a/sound/soc/amd/ps/acp63.h
+++ b/sound/soc/amd/ps/acp63.h
@@ -294,6 +294,7 @@ struct acp63_dev_data;
  * struct acp_hw_ops - ACP PCI driver platform specific ops
  * @acp_init: ACP initialization
  * @acp_deinit: ACP de-initialization
+ * @disable_interrupts: disable ACP interrupt sources
  * @acp_get_config: function to read the acp pin configuration
  * @acp_sdw_dma_irq_thread: ACP SoundWire DMA interrupt thread
  * acp_suspend: ACP system level suspend callback
@@ -304,6 +305,7 @@ struct acp63_dev_data;
 struct acp_hw_ops {
 	int (*acp_init)(void __iomem *acp_base, struct device *dev);
 	int (*acp_deinit)(void __iomem *acp_base, struct device *dev);
+	void (*disable_interrupts)(void __iomem *acp_base);
 	void (*acp_get_config)(struct pci_dev *pci, struct acp63_dev_data *acp_data);
 	void (*acp_sdw_dma_irq_thread)(struct acp63_dev_data *acp_data);
 	int (*acp_suspend)(struct device *dev);
@@ -395,6 +397,12 @@ static inline int acp_hw_deinit(struct a
 	return -EOPNOTSUPP;
 }
 
+static inline void acp_hw_disable_interrupts(struct acp63_dev_data *adata)
+{
+	if (adata && adata->hw_ops && adata->hw_ops->disable_interrupts)
+		ACP_HW_OPS(adata, disable_interrupts)(adata->acp63_base);
+}
+
 static inline void acp_hw_get_config(struct pci_dev *pci, struct acp63_dev_data *adata)
 {
 	if (adata && adata->hw_ops && adata->hw_ops->acp_get_config)
--- a/sound/soc/amd/ps/pci-ps.c
+++ b/sound/soc/amd/ps/pci-ps.c
@@ -728,6 +728,8 @@ static void snd_acp63_remove(struct pci_
 	int ret;
 
 	adata = pci_get_drvdata(pci);
+	acp_hw_disable_interrupts(adata);
+	devm_free_irq(&pci->dev, pci->irq, adata);
 	if (adata->sdw) {
 		amd_sdw_exit(adata);
 		platform_device_unregister(adata->sdw_dma_dev);
--- a/sound/soc/amd/ps/ps-common.c
+++ b/sound/soc/amd/ps/ps-common.c
@@ -248,6 +248,7 @@ void acp63_hw_init_ops(struct acp_hw_ops
 {
 	hw_ops->acp_init = acp63_init;
 	hw_ops->acp_deinit = acp63_deinit;
+	hw_ops->disable_interrupts = acp63_disable_interrupts;
 	hw_ops->acp_get_config = acp63_get_config;
 	hw_ops->acp_sdw_dma_irq_thread = acp63_sdw_dma_irq_thread;
 	hw_ops->acp_suspend = snd_acp63_suspend;
@@ -484,6 +485,7 @@ void acp70_hw_init_ops(struct acp_hw_ops
 {
 	hw_ops->acp_init = acp70_init;
 	hw_ops->acp_deinit = acp70_deinit;
+	hw_ops->disable_interrupts = acp70_disable_interrupts;
 	hw_ops->acp_get_config = acp70_get_config;
 	hw_ops->acp_sdw_dma_irq_thread = acp70_sdw_dma_irq_thread;
 	hw_ops->acp_suspend = snd_acp70_suspend;


