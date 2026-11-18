Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051369;
	b=wDbeuKx6L6MMMgxc6TY5uHC2K6hNDJ2lK/1yKOTNmS2lwTLKNj8VpSgryPgw6PkRdTzp
	 F4NRvXs925PlsXm9tQNuL47qBUSokSh0BFL4+ivgV2LmrMJOOK7xTcmKp9B1LEdc1/Zeg
	 8yJF1THBNbIg83/r0+2IcFtW/BD3ZW1ZXMCcmtwXUrriGeS3SztZn2a0LukboSjegW+d6
	 gqMfq0z0OIEI8iNIdJtY2oN9btX+ITH12sGk2X8GTc2jpdbqPR/BOp3kZ+NGViHhn/c5L
	 dsqnEkk6hNsrp5IxkdAeInHUMX/yr1Xongxg/XBw+jXyZLmSqzL45HtxpQTEr2334Xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051369;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6fvtL9CPUenuAMBccdOfJYi3W7ZKyZi/9+aFDFnD4EM=;
	b=dfPHeuSzqqMSsSQCryAGhobb2Xngap1DogN64wKx+FNgqvl+rqGOxtPDBZzRQLA4wlfo
	 y5Ym0oZNj5hvEKcMDdDFeCHw7b2iJULyXMispcMFTojckWDpeCdqTiv9aeW39bPLo8pHX
	 2AD8d8PRFaC3Q345yyRhIkL/DERQK5VYYzUHu+IanYrn6h8lNJkIDyML6JIz8otzdkdv1
	 CnkhmX0UcZ+ZeCWOS7cpX/hPW6ru4LCbQ9Dz8almzKteTn0xi2yhJT1Ghj5TRYQkvqWwZ
	 4GsyNua0VRINmkON2PiZvx35mfXG/LRUuSe6Y1PshyxS4PMLSXk+pqsrHfMe7B4QUkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fOZqYvhx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC919606A32C;
	Thu, 19 Nov 2026 01:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fOZqYvhx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E15FA1F000C5;
	Thu, 19 Nov 2026 01:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051369;
	bh=6fvtL9CPUenuAMBccdOfJYi3W7ZKyZi/9+aFDFnD4EM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fOZqYvhxGyGUA9PYVWCM/dZEapixCuzUgLrDBIhA+osdimsteFMqf/BY4f7oRNLft
	 hGVbA9NRjFem8PFWJ5co6n/a0rW7K+X/OgveXtkaV0lkPeNHaW/QzcjfxABJsIjm2L
	 N9qohaqUE21AxVuiPVIiQFn7vsfjRZPt9mrbCbxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0185/2214] Bluetooth: hci_nokia: validate firmware packet bounds
Date: Wed, 18 Nov 2026 15:31:01 +0100
Message-ID: <20261118150017.423777514@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 45640627e3ddc5f4d3a0d08618a596a8c65d48a5 ]

nokia_setup_fw() walks a length-prefixed firmware stream and
decodes HCI command packets from each record.

Check that each record fits in the remaining firmware image, that command
records contain the HCI command header, and that the payload length is
covered before submitting the command.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_nokia.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/bluetooth/hci_nokia.c b/drivers/bluetooth/hci_nokia.c
index 97da0b2bfd17e..159c93f6be6bc 100644
--- a/drivers/bluetooth/hci_nokia.c
+++ b/drivers/bluetooth/hci_nokia.c
@@ -359,9 +359,29 @@ static int nokia_setup_fw(struct hci_uart *hu)
 		u16 opcode;
 		struct sk_buff *skb;
 
+		if (pkt_size > fw_size - 2) {
+			err = -EINVAL;
+			dev_err(dev, "%s: Malformed firmware packet\n",
+				hu->hdev->name);
+			goto done;
+		}
+
 		switch (pkt_type) {
 		case HCI_COMMAND_PKT:
+			if (pkt_size < 1 + HCI_COMMAND_HDR_SIZE) {
+				err = -EINVAL;
+				dev_err(dev, "%s: Malformed firmware command\n",
+					hu->hdev->name);
+				goto done;
+			}
+
 			cmd = (struct hci_command_hdr *)(fw_ptr + 3);
+			if (cmd->plen > pkt_size - 1 - HCI_COMMAND_HDR_SIZE) {
+				err = -EINVAL;
+				dev_err(dev, "%s: Truncated firmware command\n",
+					hu->hdev->name);
+				goto done;
+			}
 			opcode = le16_to_cpu(cmd->opcode);
 
 			skb = __hci_cmd_sync(hu->hdev, opcode, cmd->plen,
-- 
2.53.0



