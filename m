Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B9F280CF6;
	Wed, 23 Apr 2025 14:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419776; cv=none; b=OljqYBWiwOFQR2CKw4VbXXC7HzRQ3NuD+roo9Ttlb+OwoXdN0tEQV8Xf/tzQQ4h5S66+eAzZoLy8szZK3zHE2gIeIsIpOHDfGRRn3V7eCruTg5s98GD94PmOMiDY0/plkTSU1V+bq/7I0YHzcgi5sZ23/MryORLUtTDtZdELV90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419776; c=relaxed/simple;
	bh=eRyOv8W6lHlNvKezpGFqA03EeIZUGSbEvVmAhgb30Os=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H2eRx2dHVlr3fFJ1K21kzp76hL2VZbknjekrQjaL2snxumJlZNJgkX7TIa1AacZMZl3oDAyjChrU07Q38Uz0oU5OpV0ETCd//mvJFdRxLhFnxsloS/DiY+Gz9iRSXlkhQA38uMpLJdGrY9i1JXXpZM20+qjIvyd3bIM546O1SEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XrDMtIPN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XrDMtIPN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C33C4CEE2;
	Wed, 23 Apr 2025 14:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419776;
	bh=eRyOv8W6lHlNvKezpGFqA03EeIZUGSbEvVmAhgb30Os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XrDMtIPNkpYLL8XP+NUwMnlixXPygL5rQSCBuSppTzZmdtRDLZUmLzWC/gHS2I8Zq
	 QtihwS/xzPg4v8hHD2He8gGBfUdCzWYgiCysTQn4x1C17SIOqeKcaFJyx2CfLmEpfP
	 HMENmXg/PWNei/2Pf9A97yh7NkqBwljmL1CbWtOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wojciech Slenska <wsl@trackunit.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 025/241] Bluetooth: qca: fix NV variant for one of WCN3950 SoCs
Date: Wed, 23 Apr 2025 16:41:29 +0200
Message-ID: <20250423142621.547134861@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit e92900c9803fb35ad6cf599cb268b8ddd9f91940 ]

The QCA_WCN3950_SOC_ID_S should be using qca/cmnv13s.bin, rather than
qca/cmnv13u.bin file. Correct the variant suffix to be used for this SoC
ID.

Fixes: d5712c511cb3 ("Bluetooth: qca: add WCN3950 support")
Reported-by: Wojciech Slenska <wsl@trackunit.com>
Closes: https://github.com/qualcomm-linux/meta-qcom/pull/817#discussion_r2022866431
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btqca.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btqca.c b/drivers/bluetooth/btqca.c
index 3d6778b95e005..edefb9dc76aa1 100644
--- a/drivers/bluetooth/btqca.c
+++ b/drivers/bluetooth/btqca.c
@@ -889,7 +889,7 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
 			if (le32_to_cpu(ver.soc_id) == QCA_WCN3950_SOC_ID_T)
 				variant = "t";
 			else if (le32_to_cpu(ver.soc_id) == QCA_WCN3950_SOC_ID_S)
-				variant = "u";
+				variant = "s";
 
 			snprintf(config.fwname, sizeof(config.fwname),
 				 "qca/cmnv%02x%s.bin", rom_ver, variant);
-- 
2.39.5



