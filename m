Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830884;
	b=Xyg1BfdLmYT5pxmIhscXzrzKUtV3fFInO/PEAnHcV7ce/scS5x3kNUtNmiyLtUGyjNF7
	 G/wB577ZgOt7TMfLs9s5M5m3uuBosNq6OsXZEgVlJdR0GyIRdU7Evu7n9yezUP+0Kthch
	 Lvfu+AytPRfC0lUx3sJz2IUeCWypvQ/c4LnuBV9vkly7Son9qCo/0EYvo3hYlivP9FsS8
	 sXDYw8ROIbPF9ekCV/i2t7wGirzBiebVo0Z5I9Mus/wucw+1VCDXR4ev5vIcpVLDJv2/+
	 mHyY+/A0y69yVSRmf7eKltv/kCFDRm46xMujVL/AnGxb3QklX5Bz5y7sj6VpyNUGddA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830884;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sm5CL/KDGGQtkIRq3jiso/SQm/vE0C8uB5LmbrSkB0U=;
	b=VlQcfwaCRdspIxKlYKcUZ3OtxWwiTuWR0c3CVJsPITO//xF0Zd2Bna+vZPlOD6ShUCoX
	 ZAdqJRi8HDKKHhLIN1/gMCFWlotgd8otKOkD4vO2wd9xlOGBdRaU1F80Z7X9iTCXul2/J
	 EzhleJfW6F1/Rx/FSj4m3CyyI5PrTPBHZtTb1WEYZXS6mrSfNdZvdS93c7pqrdVUpP0DM
	 /ja7ojxVKOxQ+Agy5cOmf8KyhLlnU50UlESe2hIO6U/SlKLPi7pQ6hA5jzss4k4myuJby
	 hhk4X6aBUDxzJppxGLgAlIX/SfJjSydMR72x78PTzNHfo2U0tfHP8DKshEwC7LkM8lQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oDmZwZDY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE36606E837;
	Wed,  4 Nov 2026 22:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oDmZwZDY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C531F00A15;
	Wed,  4 Nov 2026 22:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830884;
	bh=sm5CL/KDGGQtkIRq3jiso/SQm/vE0C8uB5LmbrSkB0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oDmZwZDYglnw9jCJDIMDHhduRcx8jDz/VyOSURuab5zQ5uuTD7hxp+hXW/MllhEbd
	 rsP6yIwWWvYIwJf7mLjI5t41GZA7cXfX1eND8VjDR0uh7UvMqfjkPxFFCFnHqE5oLU
	 ovBRDz92yg8WwNdpEEpcnX9EiBPFoPyi++rX9bx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0347/1005] Bluetooth: hci_nokia: validate firmware packet bounds
Date: Wed,  4 Nov 2026 16:01:20 -0500
Message-ID: <20261104211053.695560522@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 1e65b541f8ade..be2923231e712 100644
--- a/drivers/bluetooth/hci_nokia.c
+++ b/drivers/bluetooth/hci_nokia.c
@@ -354,9 +354,29 @@ static int nokia_setup_fw(struct hci_uart *hu)
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



