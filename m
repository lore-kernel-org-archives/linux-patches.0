Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF4A1D8DF6;
	Thu, 17 Apr 2025 18:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912836; cv=none; b=quRwMbQKm2CtCbWB87XwSegKLz0fowAGS/jrCMiHBAG/OOhXqqYsGPeFwCtvpLoXS01J+V1NMnJlnXhEMoyL14EKvMeZ5lnHMLOVVdQbL2QH/ZLBHfT0zq5IYVFuzMZiTdPMqpRW20P239hBjsKGHqtkaEU7S2mpnthZL2AyDmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912836; c=relaxed/simple;
	bh=ZzIEkGn9kHyFsqgCu7IOsmtl9oQx7CCWLMwLbjqMp5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cs6XZ2oljONVF+jPungpzXs69cgXHk12PpVhRBvQ5Mm0l9qZw7W3s4pXTDH4vf8fxKRyWdBIzUtGkIcoTIxErgxSl1oFU3iN12hOyg9USlWbzoDWSoJOLInPDyOyAImSLzKE/zubja5aAQMx9gQ7zHPBnWeyD6bMPgJpC+DHaw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jwWayZSN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jwWayZSN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4FDCC4CEE4;
	Thu, 17 Apr 2025 18:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912836;
	bh=ZzIEkGn9kHyFsqgCu7IOsmtl9oQx7CCWLMwLbjqMp5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jwWayZSNIUV2XeLK7X0KKJLh+IFQc3QYboTclsFPUuELm2tG7pJwgrUQxBiGhNudj
	 rQ5ViewhUI3jWj5WXQG89HFvKZj4OMW7NiQtLn9uA975uGzybMufFzd3CxYELY0duF
	 JeUKZdMbB8kISwmIn8K4G1dkTtaHsR/2YtSu83Bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janaki Ramaiah Thota <quic_janathot@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 141/449] Bluetooth: hci_qca: use the power sequencer for wcn6750
Date: Thu, 17 Apr 2025 19:47:09 +0200
Message-ID: <20250417175123.641656733@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 0ac2168f1dc4f..d2fd08aceb179 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -2359,6 +2359,7 @@ static int qca_serdev_probe(struct serdev_device *serdev)
 	switch (qcadev->btsoc_type) {
 	case QCA_WCN6855:
 	case QCA_WCN7850:
+	case QCA_WCN6750:
 		if (!device_property_present(&serdev->dev, "enable-gpios")) {
 			/*
 			 * Backward compatibility with old DT sources. If the
@@ -2378,7 +2379,6 @@ static int qca_serdev_probe(struct serdev_device *serdev)
 	case QCA_WCN3990:
 	case QCA_WCN3991:
 	case QCA_WCN3998:
-	case QCA_WCN6750:
 		qcadev->bt_power->dev = &serdev->dev;
 		err = qca_init_regulators(qcadev->bt_power, data->vregs,
 					  data->num_vregs);
-- 
2.39.5



