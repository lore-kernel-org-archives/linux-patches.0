Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060920;
	b=s41tJ4xZ9zTJi/xGEfKgmxnJiN/FX1c8Sa9NqkOQGIskvt0ufrDJJAFjr4A65bn9pNgl
	 fOLRmVTmmjuCdpV6544WyoZswAKwiqCrxla+NpEBYfvSrImmw8fViSLTU/+YetwnTSoyV
	 jhjQlv0/LBnOQt1pADSPiRUA/Q7/tvw9J7zSd3nP5sz9JGriZxXcubriVfvIP87guXWZP
	 7yBMqF53q+88ojKtwsirJbGK4hb5JC3E7y2mWzfG2JbEic7QnZcb1hjZahlOeAENujqnm
	 gK3RYHyBTLTuxUv6wjuUTZbV3jrSIhNk2qYAI8xA4yYNyjEZNoQEzbiY0bi6KJfQqXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060920;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A+oUUsDFjnkjk6ZAye/kHh2ovWpwR4sIYiO4joYuuKM=;
	b=QK+xWKIRrx5Wy+VFYAj7CFlcpr2oPFyvgIBZ1dGdpD/ijHlE0I8VEpjhJn4ztYPu3Vmj
	 TWNROAUZ4yNIK/ZrBxLzPePWxNKp7gvEd+kQ8snbVNu2vYKmf0/rHa+dsbMHT/qPodxJK
	 xuS21SqPon/mkdGJG8P9WKBJNxks2Nwe4JXyfZ2RN8Zn2JCV972rbCFKMT+SHD4Rn0C0X
	 g4V9dY2yKyCY67h3P/Gq7V08ReHlDjsNsa92Hd4NzhksaEdcvMN6BE2e1llKKq2kkDfzQ
	 3uc848I13NL2mWAFnFlB3JrTinmhjiSgaHh9iYESoVGHOp3pzZEQvU0n1FWUnP2mpaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xDyoqBrD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB43606A33A;
	Sat,  7 Nov 2026 14:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xDyoqBrD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EE481F0089F;
	Sat,  7 Nov 2026 14:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060919;
	bh=A+oUUsDFjnkjk6ZAye/kHh2ovWpwR4sIYiO4joYuuKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xDyoqBrDqEqpWSQDDbL94J0NOv1NkIH13wG2jublrlpAwU9jnn92FghDk8fLtHQdo
	 j33UX1C8RMmA7wSOgpsK7q8JI86v1/j9zkn7Gtzo9VbK93fRUPFcIWI/5EPw98L2dY
	 4VCk83Gw+wMZr8DfRCMLCvt8Vn64bSbi+Oe2heGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0287/1536] Bluetooth: hci_nokia: validate firmware packet bounds
Date: Sat,  7 Nov 2026 08:38:23 -0500
Message-ID: <20261107135005.721527194@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 49bbe4975be4b..e5aa606b8d35b 100644
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



