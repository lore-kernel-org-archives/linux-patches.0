Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7897BB00;
	Wed, 21 Feb 2024 13:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522594; cv=none; b=iJ7UhBo+jVDIa0L5S3P30dKeTJcrFbdHzESrAR2Cl5TPyjpa0fcpka9xhNniKGL/MWBXk8ejZm1SUdoMe+xG/LlyF3C2mDLSjArbFAxnQWb9r5KjxSNSsJ3ZyRkoUGJ9K9zpPJdyRki9T8VitLv6AJaasAh6o1u9FIhWOFJfdLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522594; c=relaxed/simple;
	bh=pDEVcUIu0VSopUVFJyxdgA3Ifz8GMQmj7KCr9eJNK5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AxHmz90o6cajH8dKN2xoVBoJ7UvI5l7dxUhe7txAoBPMLdVQp8jpliPtwxGNqGeVbUSB2bjg4RvsujIAQw3JbgYkiJMloCBn3wNfvWqjk9rwKuRacEQoN5hCf+/bLmWq5wqbg45n+qLQ6zm3vCBPTw6/bRE4Nl04EfBu0GyZAqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VjlgLk2g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VjlgLk2g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5B6C433F1;
	Wed, 21 Feb 2024 13:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522594;
	bh=pDEVcUIu0VSopUVFJyxdgA3Ifz8GMQmj7KCr9eJNK5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VjlgLk2gg9OJpkHJjld1sqHzCwULEWHTMW1MbxHZW/I4L2Jbdy6h0etAQeLWDW+EL
	 ZIvXaX3Dcd/DFT5TLEp1wHx55sL9IOART/mEgqd6PRbXy99cwQT7yJH0BQA5l3Iuh2
	 k9jSn0KT/0o2LPyynDd3Hebs8mRNURAcz1Km0TYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 203/476] Bluetooth: qca: Set both WIDEBAND_SPEECH and LE_STATES quirks for QCA2066
Date: Wed, 21 Feb 2024 14:04:14 +0100
Message-ID: <20240221130015.410752013@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit 5d192b697c7417254cdd9edc3d5e9e0364eb9045 ]

Set both WIDEBAND_SPEECH_SUPPORTED and VALID_LE_STATES quirks
for QCA2066.

Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_qca.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index 56b4b7248483..d10f1fe0f5fa 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -1860,6 +1860,7 @@ static const struct qca_device_data qca_soc_data_wcn3998 = {
 static const struct qca_device_data qca_soc_data_qca6390 = {
 	.soc_type = QCA_QCA6390,
 	.num_vregs = 0,
+	.capabilities = QCA_CAP_WIDEBAND_SPEECH | QCA_CAP_VALID_LE_STATES,
 };
 
 static const struct qca_device_data qca_soc_data_wcn6750 = {
-- 
2.43.0



