Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D32AF517
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 19:59:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C4AC433C7;
	Mon, 21 Aug 2023 19:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692647984;
	bh=tObgPU9+08DwDhYESjC9TAFSp08hIkvMm9Cg9HeMOD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QqGZ3Ydenl86IsQ75cYJzIdntpwmqolBSw383AnjD8jfGWdo7FnTE2QtrM1VKFYJs
	 xVjfaS6Czw2xiGZYbk+L4f674KZhTyiBhI6689/uamou56C20LDtFP8ud428hDUvB0
	 DVCzZeHvEoQbvIEXvtG/pzLOtRxeUI0g7efDoc2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkata Prasad Potturu <venkataprasad.potturu@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 014/234] ASoC: SOF: amd: Add pci revision id check
Date: Mon, 21 Aug 2023 21:39:37 +0200
Message-ID: <20230821194129.377642928@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Venkata Prasad Potturu <venkataprasad.potturu@amd.com>

[ Upstream commit 1d4a84632b90d88316986b05bcdfe715399a33db ]

Add pci revision id check for renoir and rembrandt platforms.

Signed-off-by: Venkata Prasad Potturu <venkataprasad.potturu@amd.com>
Link: https://lore.kernel.org/r/20230523072009.2379198-1-venkataprasad.potturu@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/amd/acp.h     | 3 +++
 sound/soc/sof/amd/pci-rmb.c | 3 +++
 sound/soc/sof/amd/pci-rn.c  | 3 +++
 3 files changed, 9 insertions(+)

diff --git a/sound/soc/sof/amd/acp.h b/sound/soc/sof/amd/acp.h
index 1c535cc6c3a95..dc624f727aa37 100644
--- a/sound/soc/sof/amd/acp.h
+++ b/sound/soc/sof/amd/acp.h
@@ -55,6 +55,9 @@
 
 #define ACP_DSP_TO_HOST_IRQ			0x04
 
+#define ACP_RN_PCI_ID				0x01
+#define ACP_RMB_PCI_ID				0x6F
+
 #define HOST_BRIDGE_CZN				0x1630
 #define HOST_BRIDGE_RMB				0x14B5
 #define ACP_SHA_STAT				0x8000
diff --git a/sound/soc/sof/amd/pci-rmb.c b/sound/soc/sof/amd/pci-rmb.c
index eaf70ea6e556e..58b3092425f1a 100644
--- a/sound/soc/sof/amd/pci-rmb.c
+++ b/sound/soc/sof/amd/pci-rmb.c
@@ -65,6 +65,9 @@ static int acp_pci_rmb_probe(struct pci_dev *pci, const struct pci_device_id *pc
 {
 	unsigned int flag;
 
+	if (pci->revision != ACP_RMB_PCI_ID)
+		return -ENODEV;
+
 	flag = snd_amd_acp_find_config(pci);
 	if (flag != FLAG_AMD_SOF && flag != FLAG_AMD_SOF_ONLY_DMIC)
 		return -ENODEV;
diff --git a/sound/soc/sof/amd/pci-rn.c b/sound/soc/sof/amd/pci-rn.c
index 4809cb644152b..7409e21ce5aa7 100644
--- a/sound/soc/sof/amd/pci-rn.c
+++ b/sound/soc/sof/amd/pci-rn.c
@@ -65,6 +65,9 @@ static int acp_pci_rn_probe(struct pci_dev *pci, const struct pci_device_id *pci
 {
 	unsigned int flag;
 
+	if (pci->revision != ACP_RN_PCI_ID)
+		return -ENODEV;
+
 	flag = snd_amd_acp_find_config(pci);
 	if (flag != FLAG_AMD_SOF && flag != FLAG_AMD_SOF_ONLY_DMIC)
 		return -ENODEV;
-- 
2.40.1



