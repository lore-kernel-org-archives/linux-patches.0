Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D012E7646;
	Tue, 15 Jul 2025 13:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587527; cv=none; b=NxTDXyQ7TPoM4tNAkw/jnCLS/rBzLZM5lZXi0DWBGtzKAgzWIkQoxZa7UwWozmA2WovstP/EmxVlsRpkIc4qo5YmmyRh8lYxMy8ygsE5SggROTlfG/k+yq7f9F6lg0mAvCepAP3uC5e900G0uIFga/fJpYXpaP92t4+m7Uqn9sY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587527; c=relaxed/simple;
	bh=1qvy5hDV9KPTFFhm/eA0TYZgSnkHEz9vQNctN7PJSyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wo3cFEl1ndFLlta624HsK1Fokcc9suOGJYa6UqMgr8WzGF6y96OmQb/q4ZmipLuud+x/pPP72Lb7mfeCS41OP931iKBWq8Zd7WDuABkjE186nDsMKAOWZyciTmbKkYAkNx8xFgf3ThHyEp2yodT6+l6Zkto48zv4D6kiTGh664E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QB/+Sa1O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QB/+Sa1O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6568C4CEE3;
	Tue, 15 Jul 2025 13:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587527;
	bh=1qvy5hDV9KPTFFhm/eA0TYZgSnkHEz9vQNctN7PJSyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QB/+Sa1O98hhzK8vgUeQk2wMDS6v9XfMbVp4c9oPJlpMsXibh3USs6zABN5SLpiLG
	 yAVZdDl9iNo+ozAq4Va0o1v8nAMvte88L0Ks5BmfNSv1qpf+mGwtir87g/bVUHTim7
	 A9RQm4hA+wsac9Czxx1ISHVORigFMouTLyhv1bHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Junlin Yang <yangjunlin@yulong.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 028/208] usb: typec: tcpci_maxim: add terminating newlines to logging
Date: Tue, 15 Jul 2025 15:12:17 +0200
Message-ID: <20250715130811.961269302@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junlin Yang <yangjunlin@yulong.com>

[ Upstream commit 7cbcd008e104d16849e5054e69f0a3d55eaeb664 ]

Add terminating '\n' to the formats where missed.

Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Junlin Yang <yangjunlin@yulong.com>
Link: https://lore.kernel.org/r/20210124143947.1688-1-angkery@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 0736299d090f ("usb: typec: tcpm/tcpci_maxim: Fix bounds check in process_rx()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/tcpm/tcpci_maxim.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/typec/tcpm/tcpci_maxim.c b/drivers/usb/typec/tcpm/tcpci_maxim.c
index 57c5c073139a9..df5887db46946 100644
--- a/drivers/usb/typec/tcpm/tcpci_maxim.c
+++ b/drivers/usb/typec/tcpm/tcpci_maxim.c
@@ -151,7 +151,7 @@ static void process_rx(struct max_tcpci_chip *chip, u16 status)
 	 */
 	ret = regmap_raw_read(chip->data.regmap, TCPC_RX_BYTE_CNT, rx_buf, 2);
 	if (ret < 0) {
-		dev_err(chip->dev, "TCPC_RX_BYTE_CNT read failed ret:%d", ret);
+		dev_err(chip->dev, "TCPC_RX_BYTE_CNT read failed ret:%d\n", ret);
 		return;
 	}
 
@@ -160,13 +160,13 @@ static void process_rx(struct max_tcpci_chip *chip, u16 status)
 
 	if (count == 0 || frame_type != TCPC_RX_BUF_FRAME_TYPE_SOP) {
 		max_tcpci_write16(chip, TCPC_ALERT, TCPC_ALERT_RX_STATUS);
-		dev_err(chip->dev, "%s", count ==  0 ? "error: count is 0" :
+		dev_err(chip->dev, "%s\n", count ==  0 ? "error: count is 0" :
 			"error frame_type is not SOP");
 		return;
 	}
 
 	if (count > sizeof(struct pd_message) || count + 1 > TCPC_RECEIVE_BUFFER_LEN) {
-		dev_err(chip->dev, "Invalid TCPC_RX_BYTE_CNT %d", count);
+		dev_err(chip->dev, "Invalid TCPC_RX_BYTE_CNT %d\n", count);
 		return;
 	}
 
@@ -177,7 +177,7 @@ static void process_rx(struct max_tcpci_chip *chip, u16 status)
 	count += 1;
 	ret = regmap_raw_read(chip->data.regmap, TCPC_RX_BYTE_CNT, rx_buf, count);
 	if (ret < 0) {
-		dev_err(chip->dev, "Error: TCPC_RX_BYTE_CNT read failed: %d", ret);
+		dev_err(chip->dev, "Error: TCPC_RX_BYTE_CNT read failed: %d\n", ret);
 		return;
 	}
 
@@ -311,7 +311,7 @@ static irqreturn_t _max_tcpci_irq(struct max_tcpci_chip *chip, u16 status)
 			return ret;
 
 		if (reg_status & TCPC_SINK_FAST_ROLE_SWAP) {
-			dev_info(chip->dev, "FRS Signal");
+			dev_info(chip->dev, "FRS Signal\n");
 			tcpm_sink_frs(chip->port);
 		}
 	}
@@ -445,7 +445,7 @@ static int max_tcpci_probe(struct i2c_client *client, const struct i2c_device_id
 	max_tcpci_init_regs(chip);
 	chip->tcpci = tcpci_register_port(chip->dev, &chip->data);
 	if (IS_ERR(chip->tcpci)) {
-		dev_err(&client->dev, "TCPCI port registration failed");
+		dev_err(&client->dev, "TCPCI port registration failed\n");
 		return PTR_ERR(chip->tcpci);
 	}
 	chip->port = tcpci_get_tcpm_port(chip->tcpci);
-- 
2.39.5



