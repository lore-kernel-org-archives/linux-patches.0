Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624726;
	b=bU0FwLIBNr94ULsGBvjHoItb9a/BIhHdm4gFL26HrO3eW0qazMX9xiTiuR4I4k6PXp/l
	 iCRk+nqT5Tt2duLQYW4mfS3dlzNxdJsH1mTtPl+FSDCpPcENcrp3nWOnCdo3Kj1agmmDT
	 ycAqJJM2pXoo3MVCbWFXuUHWYAhtY7a9DNbqlNpZd6ZOZ6hDHC97vhhoMCGFw0grguJDa
	 7Jts3mlBeosHyk8XowA+o/7BPHMA3kMvbvH+0oViJzkCsiqubYAqmMvcMHjhXocSCLaws
	 MBIoNXnUf5nY8ZFsI8KzwTDTb8JidyIM6/5mME5XNYpt84NgYnlarahuQP7WCE63fZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624726;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sgonxPbBvwNi+EI4H9M3CVRDN1k0sskW7hmQrudRO3E=;
	b=jMjIH3X+uL+SdoQ5HPsYci/o6V65nXlttnJ8Xt/acb/RRubfdkW9dhb15lipvuo3PtqJ
	 Tb8fYjLmXcXbxW36CkSG+WtzoXrv/yJWvVkgCClcXE0w4KQd7Guk7LB9axs4Qlxj455Tc
	 J1915Uhu+URXt9SzFxP2HA7fgeNrs2WuWzmKGXgeDWU81ez5wB6hDgQ8RANi0pF0eZBFd
	 32kG4mi4j495aDO6FUjWQ807pek3/BUuoaV5X0TKpX0GtDuD5wbmvgYfkIhOzD39gjizq
	 JhimtHPVIpBZTZouFbvaV1EkXRSCr4/+HOEoqzaV8gPJNqqvGLqWwY6NFtW9e2IQsHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EuAZNTSW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C9E606A33C;
	Wed, 25 Nov 2026 16:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EuAZNTSW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D19D31F000CF;
	Wed, 25 Nov 2026 16:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624725;
	bh=sgonxPbBvwNi+EI4H9M3CVRDN1k0sskW7hmQrudRO3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EuAZNTSWph1VB+yt098Uxs7FR31/1qY5u7WSPn2ccS6ybGlkIDrXHQ5cBkCE3jiY0
	 ByE7Fpe+UnHqnzSXE85C5+8dGb0uNrIyQUqXR+Kh9/hEgPxqhRttfNKeW7NUAPTyNR
	 EdcCzxQzvRqcfxQYJluxqtmmPQ1jEtjjJeUseoWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 288/816] ASoC: SOF: amd: enable soundwire host wake irq mask
Date: Wed, 25 Nov 2026 15:30:36 +0100
Message-ID: <20261125143855.872639936@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit a536f3c51edb63900b3340978d38da3aabc1fb2f ]

Enable SoundWire host wake interrupt mask during acp init
sequence based on wake enable checks for each SoundWire manager
instance for ACP7.0 & ACP7.1 platforms.

Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20250502154445.3008598-8-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 34ea81a7f284 ("ASoC: SOF: amd: guard adata->sdw dereferences with NULL check in IRQ handler")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/amd/acp-dsp-offset.h | 5 +++++
 sound/soc/sof/amd/acp.c            | 7 +++++++
 2 files changed, 12 insertions(+)

diff --git a/sound/soc/sof/amd/acp-dsp-offset.h b/sound/soc/sof/amd/acp-dsp-offset.h
index 414151187b449..e77554f74c20d 100644
--- a/sound/soc/sof/amd/acp-dsp-offset.h
+++ b/sound/soc/sof/amd/acp-dsp-offset.h
@@ -131,4 +131,9 @@
 #define ACP_SW0_EN				0x3000
 #define ACP_SW1_EN				0x3C00
 #define ACP70_PME_EN				0x1400
+#define ACP70_EXTERNAL_INTR_CNTL1		0x1A08
+#define ACP70_SW0_WAKE_EN			0x1458
+#define ACP70_SW1_WAKE_EN			0x1460
+#define ACP70_SDW_HOST_WAKE_MASK		0x0C00000
+
 #endif
diff --git a/sound/soc/sof/amd/acp.c b/sound/soc/sof/amd/acp.c
index e5a36dc6583cb..244a9e0a8665e 100644
--- a/sound/soc/sof/amd/acp.c
+++ b/sound/soc/sof/amd/acp.c
@@ -583,6 +583,7 @@ static int acp_dsp_reset(struct snd_sof_dev *sdev)
 static int acp_init(struct snd_sof_dev *sdev)
 {
 	struct acp_dev_data *acp_data;
+	unsigned int sdw0_wake_en, sdw1_wake_en;
 	int ret;
 
 	/* power on */
@@ -601,6 +602,12 @@ static int acp_init(struct snd_sof_dev *sdev)
 	switch (acp_data->pci_rev) {
 	case ACP70_PCI_ID:
 	case ACP71_PCI_ID:
+		sdw0_wake_en = snd_sof_dsp_read(sdev, ACP_DSP_BAR, ACP70_SW0_WAKE_EN);
+		sdw1_wake_en = snd_sof_dsp_read(sdev, ACP_DSP_BAR, ACP70_SW1_WAKE_EN);
+		if (sdw0_wake_en || sdw1_wake_en)
+			snd_sof_dsp_update_bits(sdev, ACP_DSP_BAR, ACP70_EXTERNAL_INTR_CNTL1,
+						ACP70_SDW_HOST_WAKE_MASK, ACP70_SDW_HOST_WAKE_MASK);
+
 		snd_sof_dsp_write(sdev, ACP_DSP_BAR, ACP70_PME_EN, 1);
 		break;
 	}
-- 
2.53.0



