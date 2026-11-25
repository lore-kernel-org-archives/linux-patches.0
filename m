Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618868;
	b=nbivnmU2zIWK3pHxoGUnevi4vQmwPpXdBjIzBU5Vi8Wdr+wdxTY8fnmRyr7oWPqipxpu
	 5oo4R3Uvi35gYUz4j741HX3O+Zi7NK+3rcP0GfB8cDhwaAI9KFrshhhgDnZmLIlNOBVvj
	 pbrbevvuETi6r1DiGd/ho5sROap8q/5UXnVn90/LdUVOpEsOwpUTSXmNGID83q+qgygJG
	 uftPvwV4kf43qOMhy4GkQivTIM6ogiNudiEgkRKshFl4RFhVUJPDDI2juIB2mvkiIi6Dn
	 Px7SfqShX80BYF4S20Pk1tJxTQk/doNhWFE209NGyTjHAI8wOZ4TByAzWYtNGmwWnvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618868;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=scsMGrPqZSHXUD3eurHFXbo93OG34wCYM0k2mRTcbuk=;
	b=zBoNS+z4ZSkrjrocGDjugNMLSvh450Q87xxe+PVFQ5OBwCzshsWoLXWhkAqgng8uWAr/
	 mSGYSW6jX+iMRDhTsIqvSmAf75JKznu2JUcE/lMtiZg7kQwcuVEgfltAQcxYE5wWxq1I/
	 0s+Movbft/5p6WxRvvlcVWitZfSY627efov1WSHQPiTVxKWUfbtj/pTroM5Mo0aiS3T4Y
	 7xZKN7/5h1srqgZTMDkLDD1RQjKoUbcMa81/s73+vaJq2mpqo0dhhlCIKZuXKesCIyd3e
	 JkpG9w9zI0OqO6331ZKJIIqMJZRpGTD9zIu3Ixt+SaP0AfTP/SivDY4vF0dbJLt7iYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YlyKSCJk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12129606A329;
	Wed, 25 Nov 2026 15:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YlyKSCJk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 527471F000C0;
	Wed, 25 Nov 2026 15:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618867;
	bh=scsMGrPqZSHXUD3eurHFXbo93OG34wCYM0k2mRTcbuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YlyKSCJk16hevu2LRIh0HimEMwAGkbqpo6UDdmDENfJyYWeO+F5b+Y6+r7rSP5zjJ
	 jSt6fuuAoXC5Tn5mx7ScAobc0g2ktKfuNpFwoA658RiHVr+8k7hQj1JeAwHEUADbsZ
	 ORJoCN4gkGNOiNbYcvz3ZwfSO3zxeYA+xge1hPXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0415/1005] ASoC: SOF: amd: guard adata->sdw dereferences with NULL check in IRQ handler
Date: Wed, 25 Nov 2026 15:29:13 +0100
Message-ID: <20261125143831.474682182@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit 34ea81a7f284a13d825279fdede36b7f793f9936 ]

The ACP external IRQ handler is registered before sdw_amd_probe() assigns
adata->sdw, so a stray interrupt in the probe window could reach the
adata->sdw->pdev[i] dereference with adata->sdw still NULL.

The same window exists on the teardown side: after sdw_amd_exit() frees
the context but before adata->sdw is cleared by the caller.

Add NULL checks for adata->sdw in acp_irq_handler() before dereferencing
->pdev[0] and ->pdev[1], and in amd_sof_handle_acp70_sdw_wake_event() for
the same reason.  The interrupt-status register write that acknowledges the
IRQ is kept outside the guard so the hardware bit is always cleared
regardless of whether the SoundWire context is live.

Fixes: 96eb81851012 ("ASoC: SOF: amd: add interrupt handling for SoundWire manager devices")
Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Fixes: 1f41bf67bfe3 ("ASoC: SOF: amd: add soundwire wake irq handling")
Link: https://patch.msgid.link/20261107175339.3547918-3-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/amd/acp.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/sound/soc/sof/amd/acp.c b/sound/soc/sof/amd/acp.c
index 5570f3d1348dd..7656f9bb6f165 100644
--- a/sound/soc/sof/amd/acp.c
+++ b/sound/soc/sof/amd/acp.c
@@ -430,16 +430,20 @@ static void amd_sof_handle_acp70_sdw_wake_event(struct acp_dev_data *adata)
 	struct amd_sdw_manager *amd_manager;
 
 	if (adata->acp70_sdw0_wake_event) {
-		amd_manager = dev_get_drvdata(&adata->sdw->pdev[0]->dev);
-		if (amd_manager)
-			pm_request_resume(amd_manager->dev);
+		if (adata->sdw) {
+			amd_manager = dev_get_drvdata(&adata->sdw->pdev[0]->dev);
+			if (amd_manager)
+				pm_request_resume(amd_manager->dev);
+		}
 		adata->acp70_sdw0_wake_event = 0;
 	}
 
 	if (adata->acp70_sdw1_wake_event) {
-		amd_manager = dev_get_drvdata(&adata->sdw->pdev[1]->dev);
-		if (amd_manager)
-			pm_request_resume(amd_manager->dev);
+		if (adata->sdw) {
+			amd_manager = dev_get_drvdata(&adata->sdw->pdev[1]->dev);
+			if (amd_manager)
+				pm_request_resume(amd_manager->dev);
+		}
 		adata->acp70_sdw1_wake_event = 0;
 	}
 }
@@ -531,10 +535,12 @@ static irqreturn_t acp_irq_handler(int irq, void *dev_id)
 
 	val = snd_sof_dsp_read(sdev, ACP_DSP_BAR, desc->ext_intr_stat);
 	if (val & ACP_SDW0_IRQ_MASK) {
-		amd_manager = dev_get_drvdata(&adata->sdw->pdev[0]->dev);
 		snd_sof_dsp_write(sdev, ACP_DSP_BAR, desc->ext_intr_stat, ACP_SDW0_IRQ_MASK);
-		if (amd_manager)
-			schedule_work(&amd_manager->amd_sdw_irq_thread);
+		if (adata->sdw) {
+			amd_manager = dev_get_drvdata(&adata->sdw->pdev[0]->dev);
+			if (amd_manager)
+				schedule_work(&amd_manager->amd_sdw_irq_thread);
+		}
 		irq_flag = 1;
 	}
 
@@ -560,11 +566,13 @@ static irqreturn_t acp_irq_handler(int irq, void *dev_id)
 	if (desc->ext_intr_stat1) {
 		val = snd_sof_dsp_read(sdev, ACP_DSP_BAR, desc->ext_intr_stat1);
 		if (val & ACP_SDW1_IRQ_MASK) {
-			amd_manager = dev_get_drvdata(&adata->sdw->pdev[1]->dev);
 			snd_sof_dsp_write(sdev, ACP_DSP_BAR, desc->ext_intr_stat1,
 					  ACP_SDW1_IRQ_MASK);
-			if (amd_manager)
-				schedule_work(&amd_manager->amd_sdw_irq_thread);
+			if (adata->sdw) {
+				amd_manager = dev_get_drvdata(&adata->sdw->pdev[1]->dev);
+				if (amd_manager)
+					schedule_work(&amd_manager->amd_sdw_irq_thread);
+			}
 			irq_flag = 1;
 		}
 		switch (adata->pci_rev) {
-- 
2.53.0



