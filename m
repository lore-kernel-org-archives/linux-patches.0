Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619007;
	b=NItou8E+ryy9QJHGL9noTy1pO9UIakOsd5k3g+IvPBJa0iCeBMLeCrZixq33/NVq+9cD
	 sh+b/86+PMCLFcv+44ciGsd/OBQj+R27q3TPxaxNdx4IQRpU+RxAm163FvwJ1uR59HimX
	 rYAlsIyq/K1Srm0qTwyVyGnI+Ffzks7nx0X+2vdtv92uV7smw5sKYTXu3qv218Eh+lSBz
	 N5HQ/3QCNIM2jyA55MqNtTxYwKFDoUE0GM0i89g6uRI6g6//vGzQyRpjaPWsNhmOwpUoN
	 IcpB9t7tv/3SFgMUf6z3ZJc4xK4BZjUfqgS+AIzj63rItt2k8fFUDmeYUp7U0HRO+jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619007;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7Nwq+oPJSPXdhaXt+hwSuNddLfbblngR/IzrNnuDnig=;
	b=trXrDirSE0YcSHVoQPHqL23vpMv4mmjtcOTk/CX3mqWs94+rrRk2qifwK1iqjxngPx12
	 XMtve1aQrlUJ+veepayX7krUjRyPjiQULmLZG+Hh7++BOke03cTsYXCWiqdCzRFSo6z7j
	 JBZfBTCAx2HAVShIVqW2rnENPP00CwluFN0o+WccR44QGLuu2DysYAMmOOm0UucifAHuG
	 aYP/2gYriDw2MGpP/d/UeEKFUuyOOhOg5lSLnxysIXCE1JfRjenhmlFGzdPxpooEp4/7+
	 3ACPwsdzBfJPPk6fIQMqU6dgXgM7I9j2T7xeZA4NSuiYnBPk1xPhvIeKUYRKJQUINFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YNL96TzN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A842C606A334;
	Wed, 25 Nov 2026 15:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YNL96TzN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEC951F000CF;
	Wed, 25 Nov 2026 15:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619007;
	bh=7Nwq+oPJSPXdhaXt+hwSuNddLfbblngR/IzrNnuDnig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YNL96TzNnTGlX2BQjAZUSxGrXsIr+1swypudbfbHfw7t51vgkN6uC17MYG7/VEL5R
	 JxZ8aL4Vcll4u0EWKbZR3Jt2HB2L50zAuoAMGCf/ebeQq19agi0e4KMdjRkjgcKJID
	 Eun9wkSDhyZRVKqcke5Wrr/yXtfuYLmsoNcjCJwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0414/1005] ASoC: amd: ps: guard adata->sdw dereferences with NULL check in IRQ handler
Date: Wed, 25 Nov 2026 15:29:12 +0100
Message-ID: <20261125143831.451725067@linuxfoundation.org>
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

[ Upstream commit 41e06aaef9c000c1bb52d8a6f73ae66c9bd36d83 ]

The ACP external IRQ handler is registered before sdw_amd_probe() assigns
adata->sdw, so a stray interrupt in the probe window could reach the
adata->sdw->pdev[i] dereference with adata->sdw still NULL.

The same window exists on the teardown side: after sdw_amd_exit() frees
the context but before adata->sdw is cleared by the caller.

Add NULL checks for adata->sdw in acp63_irq_handler() before dereferencing
->pdev[0] and ->pdev[1], and in handle_acp70_sdw_wake_event() for the same
reason.  The interrupt-status register write that acknowledges the IRQ is
kept outside the guard so the hardware bit is always cleared regardless of
whether the SoundWire context is live.

Fixes: e1cb350610ce ("ASoC: amd: ps: handle SoundWire interrupts in acp pci driver")
Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://patch.msgid.link/20261107175339.3547918-2-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/ps/pci-ps.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/sound/soc/amd/ps/pci-ps.c b/sound/soc/amd/ps/pci-ps.c
index b604db4942dd6..d0b66df101579 100644
--- a/sound/soc/amd/ps/pci-ps.c
+++ b/sound/soc/amd/ps/pci-ps.c
@@ -26,16 +26,20 @@ static void handle_acp70_sdw_wake_event(struct acp63_dev_data *adata)
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
@@ -209,18 +213,22 @@ static irqreturn_t acp63_irq_handler(int irq, void *dev_id)
 	ext_intr_stat = readl(adata->acp63_base + ACP_EXTERNAL_INTR_STAT);
 	if (ext_intr_stat & ACP_SDW0_STAT) {
 		writel(ACP_SDW0_STAT, adata->acp63_base + ACP_EXTERNAL_INTR_STAT);
-		amd_manager = dev_get_drvdata(&adata->sdw->pdev[0]->dev);
-		if (amd_manager)
-			schedule_work(&amd_manager->amd_sdw_irq_thread);
+		if (adata->sdw) {
+			amd_manager = dev_get_drvdata(&adata->sdw->pdev[0]->dev);
+			if (amd_manager)
+				schedule_work(&amd_manager->amd_sdw_irq_thread);
+		}
 		irq_flag = 1;
 	}
 
 	ext_intr_stat1 = readl(adata->acp63_base + ACP_EXTERNAL_INTR_STAT1);
 	if (ext_intr_stat1 & ACP_SDW1_STAT) {
 		writel(ACP_SDW1_STAT, adata->acp63_base + ACP_EXTERNAL_INTR_STAT1);
-		amd_manager = dev_get_drvdata(&adata->sdw->pdev[1]->dev);
-		if (amd_manager)
-			schedule_work(&amd_manager->amd_sdw_irq_thread);
+		if (adata->sdw) {
+			amd_manager = dev_get_drvdata(&adata->sdw->pdev[1]->dev);
+			if (amd_manager)
+				schedule_work(&amd_manager->amd_sdw_irq_thread);
+		}
 		irq_flag = 1;
 	}
 
-- 
2.53.0



