Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844212571B4;
	Thu, 17 Apr 2025 18:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914155; cv=none; b=QK1A9yEsuSve0+7LxUdgQET+Nf8D+5U0PblHz2z4ooGNIiiuo4CQ1+u+JL3rxmSpcMBp3zwKJmbRky2wdIRM0X5tvAWI+0Ddkfix4hAfMw80n7uRyg4ZaRbbFdbUz0jEPtLNFbDyqpKxQqRnHear9ssyPKi3vqTx2Qj5f3G61UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914155; c=relaxed/simple;
	bh=ydNd/ph/h9Mzo0jX3gVLmP8/9oyv4g/W+8DI73D2SdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SyF1fWd+jmL3RTlXgojuQmS4+3ORP8H2vvlP4UjW0n4BS+adxvwqM73hRlpv/Gs9eFLmjLySWrOyDFQHckChdyF4feQJW1WxxIYK6JrnDcvjC51qK0r+QO+5cbs7XSTBdyQ5N4astp0+CiXBJmuiwiTDGhb+7MYvZgG7Q1NNve0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U8/qN4Zd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U8/qN4Zd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1093FC4CEE4;
	Thu, 17 Apr 2025 18:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914155;
	bh=ydNd/ph/h9Mzo0jX3gVLmP8/9oyv4g/W+8DI73D2SdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U8/qN4Zd6Ra1Cr+Rx/jlDpJ5QzpE85sqhgpE5wjoUQdWPwc/PVPkyKTrte/0g/TeE
	 L3Wc54hyH9xVPGqLZxPeSuep4ncM/ZGgTHqXnjV/PTRHSS2JBnDwlY8yJeqD+a5QxE
	 Va74HEXhoHoccELDoyV6mla8VoKIqzXfCcr8FTZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janaki Ramaiah Thota <quic_janathot@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 125/414] Bluetooth: hci_qca: use the power sequencer for wcn6750
Date: Thu, 17 Apr 2025 19:48:03 +0200
Message-ID: <20250417175116.462313484@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Janaki Ramaiah Thota <quic_janathot@quicinc.com>

[ Upstream commit 852cfdc7a5a5af54358325c1e0f490cc178d9664 ]

Older boards are having entry "enable-gpios" in dts, we can safely assume
latest boards which are supporting PMU node enrty will support power
sequencer.

Signed-off-by: Janaki Ramaiah Thota <quic_janathot@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_qca.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index 37129e6cb0eb1..fbf8840fa534e 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -2346,6 +2346,7 @@ static int qca_serdev_probe(struct serdev_device *serdev)
 	switch (qcadev->btsoc_type) {
 	case QCA_WCN6855:
 	case QCA_WCN7850:
+	case QCA_WCN6750:
 		if (!device_property_present(&serdev->dev, "enable-gpios")) {
 			/*
 			 * Backward compatibility with old DT sources. If the
@@ -2365,7 +2366,6 @@ static int qca_serdev_probe(struct serdev_device *serdev)
 	case QCA_WCN3990:
 	case QCA_WCN3991:
 	case QCA_WCN3998:
-	case QCA_WCN6750:
 		qcadev->bt_power->dev = &serdev->dev;
 		err = qca_init_regulators(qcadev->bt_power, data->vregs,
 					  data->num_vregs);
-- 
2.39.5



