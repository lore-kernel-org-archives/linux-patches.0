Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45CC579DAE;
	Wed, 21 Feb 2024 14:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524191; cv=none; b=q3dai1oVPbfWpDmWJiGw21IYBaD8+rkjLQp9PyL8NGMP4EA4O19c3uuIvQT2PZRX4SqCjs5xyYJLxTpY50DcU+LKRtR9XBCxzrijh6/ZgXu0eBcpOScoT74Y/0603XITk5ZCWSn8snxfPSr8WfoJa2xwIn6KRN9xg4pofX0veHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524191; c=relaxed/simple;
	bh=jaytldXrqRyHZ4GARDwUHctdl8Tf8xbYseCWFnCYlqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fvQA3MQbr8UjeZ5bsx8z+RtIRoSrQll3l8s3Brwx16KbXGlZxtqlJ73eRe6AE9rPe7IMhcIBpZnmU248jzVaKjg3H2SJB6X+9yowu1sAH9JIYQbUODGKiEdeTEXbX9R9a34ERWIk61fcKtdNdWs9iWEiu78yQCxN6oEQ7JvDW3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tVp2zPqz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tVp2zPqz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70597C433C7;
	Wed, 21 Feb 2024 14:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524190;
	bh=jaytldXrqRyHZ4GARDwUHctdl8Tf8xbYseCWFnCYlqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tVp2zPqzxDy5+xZv5IPekrKNkLO8W+5MC4r9YiAeLT8lfiBWgYn+pspKFzxb/5rZB
	 lJa9WKtArINwzT9P67IenffWKSnIVErBW387EVnrgcERNQGHP0gA4j0PA2YXn3hO57
	 pnThm/bCTFHbmADzmPXEuFgXr4rA8f9R3lbovX7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 172/379] Bluetooth: qca: Set both WIDEBAND_SPEECH and LE_STATES quirks for QCA2066
Date: Wed, 21 Feb 2024 14:05:51 +0100
Message-ID: <20240221130000.004129826@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index bc0850d3f7d2..6e0c0762fbab 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -1814,6 +1814,7 @@ static const struct qca_device_data qca_soc_data_wcn3998 = {
 static const struct qca_device_data qca_soc_data_qca6390 = {
 	.soc_type = QCA_QCA6390,
 	.num_vregs = 0,
+	.capabilities = QCA_CAP_WIDEBAND_SPEECH | QCA_CAP_VALID_LE_STATES,
 };
 
 static void qca_power_shutdown(struct hci_uart *hu)
-- 
2.43.0



