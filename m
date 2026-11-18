Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057508;
	b=hrUz8lwaHbC1c1SUy5WnQ8InqsvHUt0bqGRlsHkBQA1yAdda0lCPKhuQNgW7G3ul9CkG
	 dKBs/MAeXpeh4N9kk23HS/SRZBm05K9DcIUkvoGBqImy5MKhvRxeTF87Ph+3Jk52DBWrf
	 8mv3Zn0Ji/eKmpQjq0Ui9wkWvZaFLo2xvcGh7ZRrlkIQW7/5XizaFWnqK2a6+L7JcyZgb
	 A/lydTXBNC2BARdyHRTOVg0BG9tLhjKcAyRQ4oO4E3Y9jMAhv1tPyPg3NWJ+WGQ4RxXUI
	 z6N+Kv1ACzo7b5fgZOVeEIKyMGmMidTWtoYruyiGsv3Q4V2cN6kAcwRoiz5SMoX+vrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057508;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uQR4PTYqS5BQZgwYFyFLqfhS7fEJYsIbK0jR+58vmFg=;
	b=0FguxDC45Ta/ff8ulsfh8O4fyhezumeVDKcuNrbmB2qAYOhIJ375HDXwN02ky0iZeReF
	 fPtLcPZtYjJ/gEk9c17EJsnli5GgKgvHfZgqbld3+0RgNffaNB1x9Up+04lbrTV4RjCqy
	 ZH4YhpGJb5NsoKf/tkFSmGzP/hgkt0hohFp5U+V/Fk4Mc0kwug7U62YlZe/9dJsCH0xid
	 aI3mg5j3qlZ5ImAa7gAZXTtYOdGEdwNlvLKOgtAuQWOAd5DgRfBePp4nU0Dx4vP/ctZ4Z
	 o60ixaL7pzZJ/oH7WwKOXbMI7s8bogZvYo8QXlDeJLh3Rt+HXGUnWy0SMhw+kpHQiAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c1mf6RNa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEFDA60A260E;
	Thu, 19 Nov 2026 03:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c1mf6RNa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB571F000C4;
	Thu, 19 Nov 2026 03:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057508;
	bh=uQR4PTYqS5BQZgwYFyFLqfhS7fEJYsIbK0jR+58vmFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c1mf6RNaPiaj3jWG/axIe4+ZBSABFSlwgeOXFhlctZ4RsmQoVa0p6SGYBbdpLxG3q
	 lObP3THR+dKr+scZAGFlc/SGNjPRHomvTe6Md9SCYYbec9oiM/KHAUR4QpPGjwh/6z
	 yjEHI7nZMqKcwZdyU7nACTAFy5hiJMwmH0LzbNl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0156/1848] Bluetooth: hci_nokia: validate firmware packet bounds
Date: Wed, 18 Nov 2026 15:36:34 +0100
Message-ID: <20261118145917.927830805@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



