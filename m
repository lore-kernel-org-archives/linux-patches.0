Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621565;
	b=fydSsm9u2Wn0iNkDjBfcl6juTIXvkEEBHpIZC++Li7XavY0scBSGUecyvEgIvTeEhUN3
	 V5RgnRaj8eFqjksO16y/RaQkllM3Sseuierd+QZ2ekfrZJeVxW7TBRMVYINkYNPFgYEcl
	 pcj8wtNqIZKOoiKZ6hh3juTyjZiq0Y0CiX1RSjK3LDrm2fPDnf6JWazEv9RyAXfKVbspH
	 A/WoGiE0fQ9XQExeb715tIOju9Z6ouGpBE76HXCQRiNVNKSopUcpCIfnlhSbZXSTbBvOQ
	 m4qjL/r8dQfrKBE34ORy1AA9kZ53MSYCoLlH2Or+ZbL2Zej7JYNLe4bFDY3PgNGQPSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621565;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k6SBt053dmMnvEwCNGyH/P0/6WJA+9ZgyqykMuMBFrw=;
	b=j6zy6B94Ab3aiHOy6mhy1QF1ycr5dxXiLay3EjrZDPcteirj6ZcO74y84jDHtT+W5xAa
	 vJXZhUhJ5bG5K7w33KpP6lJhaluzrKP7KNJxHyJiwDn1n621npIbp61hwpIo91PBx7XLn
	 IbrgFQZxFY2qDO1uAQUUWM+ypqo1F90uxSKXTgFVH3J0AIUwjMWSwi8Dl/NvUrO/I4ML4
	 gxlTxeNlGSrGVgkYB+y2mc+hZqhiivIYnZgsZyNWm8jxfuBmzuL4CBxLqZvsDGsbbBpnF
	 nk8AQ2jjmPLOw1/chK3runUMEKhXGJizmPr7PZVxpIRxQuogZGDKj+cwOldXP60ppyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E41M+vNi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F05606A31E;
	Wed, 25 Nov 2026 15:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E41M+vNi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B3951F000C0;
	Wed, 25 Nov 2026 15:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621565;
	bh=k6SBt053dmMnvEwCNGyH/P0/6WJA+9ZgyqykMuMBFrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E41M+vNiH0tALpiWr+XG176KzEwgQs7GAKl3v6/ykfvz/Cg6o6D+50C1MHv1s7EH9
	 8f2x84szKrONR2UAZXyfQHAUOA7sbfhiBAh7GBRTNpLogKUgIlEI5QDkW9fUUMJXhR
	 xkALRJt9gMpObQSXvixWfA/boflC87E78eisj+gU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislavs Nilovs <valorcool@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 267/990] Bluetooth: qca: Disable SoC debug logging for WCN3950
Date: Wed, 25 Nov 2026 15:27:14 +0100
Message-ID: <20261125143828.349283604@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Stanislavs Nilovs <valorcool@gmail.com>

[ Upstream commit d97b618b6675516d63d55b8f31ee6cb3b164bd6b ]

Added WCN3950 module to the switch-case to disable SoC debug packets.

Fixes: 590deccf4c06 ("Bluetooth: hci_qca: Disable SoC debug logging for WCN3991")
Signed-off-by: Stanislavs Nilovs <valorcool@gmail.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btqca.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bluetooth/btqca.c b/drivers/bluetooth/btqca.c
index 4215522e62a2c..ba0b8869b3f6e 100644
--- a/drivers/bluetooth/btqca.c
+++ b/drivers/bluetooth/btqca.c
@@ -948,6 +948,7 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
 	switch (soc_type) {
 	case QCA_QCA2066:
 	case QCA_QCA6390:
+	case QCA_WCN3950:
 	case QCA_WCN3991:
 	case QCA_WCN6750:
 	case QCA_WCN6855:
-- 
2.53.0



