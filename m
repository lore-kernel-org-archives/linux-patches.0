Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061864;
	b=EM9AR8o9oddy+LLvEvtmeqBbHQCvNooax4HotUbgqUkpF7r6BG+H2/5xS/4laLEtCfuX
	 m3TX1PHE5wtcuQJy+rowemvU44ylR2spXVW/+gsgeh0fNRmNPrfb+LvSJ64HN3tNZVxj1
	 sbDBkCtmJwIaK7iB9q+oce/wpKnHXAcycuRIdOujGSxJRQFUh7y8Ee9433BcRt+8rEVoY
	 zLPW/zFOzVIGPldCfS0shUST/ZKdOLKaztLUkmGTfOPeUiVifU6MkkwQ8XzjBAPtSH6c/
	 4isCdqPkTn7hTq1OSV2FLr6Zl+Oty1LzymNsPQb8DajGCtgjTOkzZ8oryZ4oZoTMItg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061864;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZZslalt/RF1cbATMAA4wnwV38phRVqZ6ZlLBrF6/+Zs=;
	b=OppDAWmlje7U8smb6MgTFO7lo5EJnAEKSzI/m7weBCyF/NcQNvycQn3gwcTNiPe5aKq1
	 YUKWY1M9EVfPnazvV7f1tqfOc+5SUI8WwzIQMqFr/8GIkHnqz3CnfnBlWqdVpXNcn0wvd
	 xg0sP93p6GmqYkjoT2NsEgD74EaCsX7gSwlsR0K8ZrXPUoFlrUKvXvVre/O8eSGYIAT/9
	 S/x9A2zHm80I5BPzIuIrais28tmf9md+5l/ru1TBWs6lGYNUuSHDHHwE9Sza9wLctRye5
	 jGo3ArvekJ/41U36WhG1fPbYIC1h53XivoYKeCvMXGI4GJPZRH4SJwr5ootcl3Tu1rQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yn1GcO4X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC5E606A326;
	Sat,  7 Nov 2026 14:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yn1GcO4X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC1B1F0089F;
	Sat,  7 Nov 2026 14:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061864;
	bh=ZZslalt/RF1cbATMAA4wnwV38phRVqZ6ZlLBrF6/+Zs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yn1GcO4Xlp/m4xe/tiXyoBGp2S037bvSOdmNO1lydLgI4lR/CPdQpj4La7yoREUEs
	 UYMDmTtULAsUMGn5Pk8RE9Y1CxpjUssxlFyftq8H/DBIKGai/WnA1oq5qCFoDWcxXE
	 EOw/tBVIy5RsxmgNuv5Eb/yDl4WBnPwcpcxto6PI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0881/1536] ASoC: amd: ps: fix snd_acp63_remove() teardown ordering
Date: Sat,  7 Nov 2026 08:48:17 -0500
Message-ID: <20261107135022.369648504@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

[ Upstream commit c53791d673ed4da6759d276078627ec4d0c6536b ]

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
[ sashal: Replaced acp_hw_disable_interrupts() with the existing acp63_disable_interrupts() helper because the hardware operations framework is absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/ps/pci-ps.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/amd/ps/pci-ps.c b/sound/soc/amd/ps/pci-ps.c
index eb4b552c94241..8875989d63651 100644
--- a/sound/soc/amd/ps/pci-ps.c
+++ b/sound/soc/amd/ps/pci-ps.c
@@ -724,6 +724,8 @@ static void snd_acp63_remove(struct pci_dev *pci)
 	int ret;
 
 	adata = pci_get_drvdata(pci);
+	acp63_disable_interrupts(adata->acp63_base);
+	devm_free_irq(&pci->dev, pci->irq, adata);
 	if (adata->sdw) {
 		amd_sdw_exit(adata);
 		platform_device_unregister(adata->sdw_dma_dev);
-- 
2.53.0



