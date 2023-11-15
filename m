Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD413A8F7
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ImTl1en2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E50BC433C7;
	Wed, 15 Nov 2023 19:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078034;
	bh=gB+CjLdLolDcdL0GLgqmH80HRuzu2FgTj0varcPQjrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ImTl1en2ztmliLH7oiOpEaWspFAkW+udV0n2ARw3fnIVoIsfr3Rkvw2iGY+dl3uSx
	 UDuKC7b8gEFVZnD39yEby4C7ZEpEkwADpq1R1zNgQvKRhc1WjqnAJ5NjznllOD41WE
	 E6iWkSnzZqwfdMAqtQQx64zcZihQyodrnYKvcQZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcel Ziswiler <marcel.ziswiler@toradex.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 070/379] Bluetooth: hci_sync: Fix Opcode prints in bt_dev_dbg/err
Date: Wed, 15 Nov 2023 14:22:25 -0500
Message-ID: <20231115192649.293089897@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcel Ziswiler <marcel.ziswiler@toradex.com>

[ Upstream commit 530886897c789cf77c9a0d4a7cc5549f0768b5f8 ]

Printed Opcodes may be missing leading zeros:

	Bluetooth: hci0: Opcode 0x c03 failed: -110

Fix this by always printing leading zeros:

	Bluetooth: hci0: Opcode 0x0c03 failed: -110

Fixes: d0b137062b2d ("Bluetooth: hci_sync: Rework init stages")
Fixes: 6a98e3836fa2 ("Bluetooth: Add helper for serialized HCI command execution")
Signed-off-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 5218c4dfe0a89..d74fe13f3dceb 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -151,7 +151,7 @@ struct sk_buff *__hci_cmd_sync_sk(struct hci_dev *hdev, u16 opcode, u32 plen,
 	struct sk_buff *skb;
 	int err = 0;
 
-	bt_dev_dbg(hdev, "Opcode 0x%4x", opcode);
+	bt_dev_dbg(hdev, "Opcode 0x%4.4x", opcode);
 
 	hci_req_init(&req, hdev);
 
@@ -247,7 +247,7 @@ int __hci_cmd_sync_status_sk(struct hci_dev *hdev, u16 opcode, u32 plen,
 	skb = __hci_cmd_sync_sk(hdev, opcode, plen, param, event, timeout, sk);
 	if (IS_ERR(skb)) {
 		if (!event)
-			bt_dev_err(hdev, "Opcode 0x%4x failed: %ld", opcode,
+			bt_dev_err(hdev, "Opcode 0x%4.4x failed: %ld", opcode,
 				   PTR_ERR(skb));
 		return PTR_ERR(skb);
 	}
-- 
2.42.0



