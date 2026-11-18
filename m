Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034087;
	b=mJv5/PHSzvRDkBXwN1KMrT5lY8djoW4SDOmETugExdo/N34LeDHmQY/SA8SBgRQ4fiZe
	 eZ4hmWEI2g9hYQ6RCFBcRO8pBMpePGbvm2MmVnS+kzOpxhoqY8obKkp9igKGTRfwXJP32
	 0wZHiAqbYCLqhoDipYAZSVXBqC3AXyc08Hg+Bmk2p3Seyv2kaGSP78MmpOLjVbagn23P5
	 KWhKGXxWSRmN92HMZJlbUriCQS+jzBtUpruofReXM4pH/wchX8VNB3LhkiKSNB3ogB23r
	 2g5qoPELbaHbvKxeSqMGffJ+4uzgbni1mi74lhAbAlKhHX8jf3826jqOXZjzpR6UD/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034087;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TgpiK+3yjCzF0aA/vlHNFRnu5n+wxdhbufLrvE/U61E=;
	b=Q1K70xfKyPhmOPTPXcQkm4i55DgqioSe+vxDdhSZNHVIwmRzePPfurdSgPL8lCOW42fi
	 3z/FtaeR3Xs+rqNLoXF0nFlSaj43Y7CJTU+ZHK7lBsaVuqOBal0YXnCmXP9NKlYWBP2XE
	 hxeUlhp775yoo1xEWE7eIPtv3CLMtrLWcLEm1gEDLYVw3kn8/p4QcKqeBfkVtWPS/hQ4D
	 7CXTpuxXEY+anXQoxzq5mQjJdBL6NinmRrmX5vteEfJUg4lq5TNV7RkDyvtv/jFwYpClC
	 ee195QrfXlVX9xWRLK3zDSf2o6aLCs/ltY5aM6PNGGj/FdDJ/Dvwi6Qm3vtP6k+LmCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YzOoBNwr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC61606A32A;
	Wed, 18 Nov 2026 20:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YzOoBNwr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E69B1F000C4;
	Wed, 18 Nov 2026 20:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034087;
	bh=TgpiK+3yjCzF0aA/vlHNFRnu5n+wxdhbufLrvE/U61E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YzOoBNwrchrMNIdsMflGH346hKI/EMutgaaNdoPJvhyAgoX62oCHh/FFUUA1zxdyE
	 5CGRmi3YHPuEJoOkScFjAexvCps9vRDIN4GHyDE2cqA4DK4XrOaszttrehoUCnHXOF
	 blAuK4xD0jz/owf/3ehOLuT/7tY1dVydV7V3Qvfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0243/3318] Bluetooth: hci_nokia: validate firmware packet bounds
Date: Wed, 18 Nov 2026 15:14:25 +0100
Message-ID: <20261118150322.435018884@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



