Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E5E168CF
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:10:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C39E5C433D2;
	Mon,  8 May 2023 11:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544240;
	bh=IRK2DORPnbkO9g0F+zpv4H4P8iekk+Ilkw9JhVxYXg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ea7EbJWQI/8vTarTehobmKgeSr/12Dr5SJioVUMtAB6HLOXfTn3nGBoTRAUTvuBGd
	 Q96qcEXjVAGDqPbJt04LuW+6GKR4T7it4YDJotQyrFcsiMRVeq825OCdvj+2eaau0n
	 ib9Dr/H+MocsgPoKImbnRhvYuFVUIfR7jC1yM2ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Simon Horman <simon.horman@corigine.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 345/694] wifi: ath12k: Add missing unwind goto in ath12k_pci_probe()
Date: Mon,  8 May 2023 11:43:00 +0200
Message-Id: <20230508094443.744505601@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

[ Upstream commit 488d9a484f96eee4f0e8e108aed42a057a1c7295 ]

Smatch Warns:
	drivers/net/wireless/ath/ath12k/pci.c:1198 ath12k_pci_probe()
	warn: missing unwind goto?

Store the error value in ret and use correct label with a goto.

Only Compile tested, found with Smatch.

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Reported-by: Dan Carpenter <error27@gmail.com>
Link: https://lore.kernel.org/all/Y+426q6cfkEdb5Bv@kili/
Suggested-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20230307104706.240119-1-harshit.m.mogalapalli@oracle.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/pci.c b/drivers/net/wireless/ath/ath12k/pci.c
index ae7f6083c9fc2..f523aa15885f6 100644
--- a/drivers/net/wireless/ath/ath12k/pci.c
+++ b/drivers/net/wireless/ath/ath12k/pci.c
@@ -1195,7 +1195,8 @@ static int ath12k_pci_probe(struct pci_dev *pdev,
 			dev_err(&pdev->dev,
 				"Unknown hardware version found for QCN9274: 0x%x\n",
 				soc_hw_version_major);
-			return -EOPNOTSUPP;
+			ret = -EOPNOTSUPP;
+			goto err_pci_free_region;
 		}
 		break;
 	case WCN7850_DEVICE_ID:
-- 
2.39.2



