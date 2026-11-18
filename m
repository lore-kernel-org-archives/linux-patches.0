Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043433;
	b=BzXnb+hGGAnaw3906tXuwAgj9Gkw1DKpVSIH4R1ykfMe7Z4rvxt1Qfr8T4msCElwAdKX
	 jAuT2e1XwyQOSv84MGZrFylKhggP1CF40XEpnPqKOK4q81Zt0z3v23Gh4v1MgohpJVkil
	 J3jmFBeASZMTIywwpLk7Kdd79pOYrBcTtsik5bpsx/Zf/kDmQ/CSTtFHtuNg9roID5NAH
	 dO6bJ2X5pwG2QGr2irQ6IDoBDnB5IZNkfpVPXfUqkyw3Y3fbAdYCLPmbpNRq2rVY7SxoN
	 BZ8fZDxfdjD9Yxn/43mrE7JQTSeaQLqHsQ0z1q8NHbTCeRdYtq9b8ZAlF+04ZC102oA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043433;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5WUA3A5gM+zqrczknB3I4yQoWwfFNmuQ+rFOJC0mTE0=;
	b=wY2ZnWfVQ2EVqsducSTpt68Hz8NDpvAHL+4nxqn2+BKBOptGDzeKkmu//d/dGrq11tSg
	 pOi8ShfiP0wguzbpakg5oju6z2Ux3Tl5gmhHAL9po2M4BWXnkW9r8eh/REAeOdP/HgRBl
	 nnDg83/n0UI3rovg0rHa6BG7K1f5Bi0GMv3Ok9vFdR8xIY4NxsJUGOdDYLOhK3rugOMv6
	 RSF8U+y+mq1lDbeWzR+ZLJ/jynetmyJYH8GPwBZHRkzLXV5jEo0pGu1D6zp2tr1jkIkiE
	 qOFfND5Lj1yPwBBGKGQoeeJa0x0VGyA2L36F+7fIL7gCNQqt+IERxcf0lpxXwPFcGfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=amRUx9Dz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD4F606A333;
	Wed, 18 Nov 2026 23:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=amRUx9Dz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE8E31F000D4;
	Wed, 18 Nov 2026 23:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043433;
	bh=5WUA3A5gM+zqrczknB3I4yQoWwfFNmuQ+rFOJC0mTE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=amRUx9DzLXEMnMKVsfmZHcLsl3zNZ9fd0rMDj73XiSjkAN4gY39WgHcbOu/q6Wh1F
	 4QgmSYrM4CDXw3QkW7EoPEmnj4IIkFeI5H0zjlhtFsakl6u+TFfUmT7tlOby/j+xgq
	 ZCPv+ShGyrBk6LaRWDxZjqeG8rCRIT6bNCqzj+pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0210/2857] Bluetooth: hci_nokia: validate firmware packet bounds
Date: Wed, 18 Nov 2026 15:20:44 +0100
Message-ID: <20261118150208.928671680@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



