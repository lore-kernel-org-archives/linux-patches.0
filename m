Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556928462;
	Thu, 17 Apr 2025 18:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915476; cv=none; b=g026vJ0UMcBDHB3ZXdkMyK7/5LuCSH7rifQIk48pqGGL55o5A6KuzfUt8+9U6QdR2qBgYFqyULidacBTDRuwMA/y+V93BSl3GT+afc6/2y8LwNTmmUcLkuCxP5bgereL4b/WBxKd0oTPnTWB64xu/+WlnaRFXTzNIGN5AGnhPKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915476; c=relaxed/simple;
	bh=KV1h+235WZ+AKCm26czZoB/V/zr48XH3HKtvMd4JbjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o6NEXpyag/iIuehb2B+pB4TPd82B561LLhDSnNuYndDgp+qKgzE65/7AJdA3U4Vu3zIgrpLCsb3Gx9W5KTWMwC7WbQQKjOMn+Pqb/OmuJH65XxI8C+G03G9QrIWQ3yzzgQUJB0VOhZqgDJpf70zPfqQ2Gff1ZUkJu1d6tf+Zq0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PjWrMws5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PjWrMws5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8EAFC4CEE4;
	Thu, 17 Apr 2025 18:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915476;
	bh=KV1h+235WZ+AKCm26czZoB/V/zr48XH3HKtvMd4JbjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PjWrMws5lmIGh9Yzvv4Y0umRGoZ8iMUfVNkbPFFoXc9hSmVR7sQxHl3pOWh1M2Jn4
	 cqRuzNSgZPPk+QCHLn6m8wgccy+Y7wRLlv7eK7PKgkGzkTub8VgZ9UHWTz6IdjNELN
	 papOyi2quLpL/xNB5NOW87D4rBntxHV7xO2GjJXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janaki Ramaiah Thota <quic_janathot@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 122/393] Bluetooth: hci_qca: use the power sequencer for wcn6750
Date: Thu, 17 Apr 2025 19:48:51 +0200
Message-ID: <20250417175112.505152337@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 37fddf6055beb..1837622ea625a 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -2353,6 +2353,7 @@ static int qca_serdev_probe(struct serdev_device *serdev)
 	switch (qcadev->btsoc_type) {
 	case QCA_WCN6855:
 	case QCA_WCN7850:
+	case QCA_WCN6750:
 		if (!device_property_present(&serdev->dev, "enable-gpios")) {
 			/*
 			 * Backward compatibility with old DT sources. If the
@@ -2372,7 +2373,6 @@ static int qca_serdev_probe(struct serdev_device *serdev)
 	case QCA_WCN3990:
 	case QCA_WCN3991:
 	case QCA_WCN3998:
-	case QCA_WCN6750:
 		qcadev->bt_power->dev = &serdev->dev;
 		err = qca_init_regulators(qcadev->bt_power, data->vregs,
 					  data->num_vregs);
-- 
2.39.5



