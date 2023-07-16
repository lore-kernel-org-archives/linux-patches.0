Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5E98F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:00:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71C71C433C8;
	Sun, 16 Jul 2023 20:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537644;
	bh=mGSaPe0b0JgF6oBM+lFhaiwEm5jhd/lwQLVL4VJP9Y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OcCwXgy+Wyi2jjuh1Q9Ni0gxZIgRhf6kxAlmDXB3EGEECp8BO1kAbme6DspJsiBWm
	 EpMige9MGpUNtb6IYl9O6lqUjkwxicegT8n/pRlFf+kM7elv2b+PySU/AEtRGJGcfx
	 4Wagph3PQxd51O3Pz5uJ5g58de2oIaP4QwgeR7to=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziyang Huang <hzyitc@outlook.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 169/800] wifi: ath11k: Add missing ops config for IPQ5018 in ath11k_ahb_probe()
Date: Sun, 16 Jul 2023 21:40:22 +0200
Message-ID: <20230716194953.034286691@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ziyang Huang <hzyitc@outlook.com>

[ Upstream commit 469ddb20cae61cad9c4f208a4c8682305905a511 ]

Without this patch, the IPQ5018 WiFi will fail and print the following
logs:

	[   11.033179] ath11k c000000.wifi: unsupported device type 7
	[   11.033223] ath11k: probe of c000000.wifi failed with error -95

Fixes: 25edca7bb18a ("wifi: ath11k: add ipq5018 device support")
Signed-off-by: Ziyang Huang <hzyitc@outlook.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/TYZPR01MB5556D7AA10ABEDDDD2D8F39EC953A@TYZPR01MB5556.apcprd01.prod.exchangelabs.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/ahb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath11k/ahb.c b/drivers/net/wireless/ath/ath11k/ahb.c
index 5cbba9a8b6ba9..396548e57022f 100644
--- a/drivers/net/wireless/ath/ath11k/ahb.c
+++ b/drivers/net/wireless/ath/ath11k/ahb.c
@@ -1127,6 +1127,7 @@ static int ath11k_ahb_probe(struct platform_device *pdev)
 	switch (hw_rev) {
 	case ATH11K_HW_IPQ8074:
 	case ATH11K_HW_IPQ6018_HW10:
+	case ATH11K_HW_IPQ5018_HW10:
 		hif_ops = &ath11k_ahb_hif_ops_ipq8074;
 		pci_ops = NULL;
 		break;
-- 
2.39.2



