Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39F115E80
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jun6Kq9o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA74C433C9;
	Mon, 23 Oct 2023 11:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060353;
	bh=UUw/t8Y80EacVn2aYf4q+J40ipIZ+sqjjtQeKh9ELvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jun6Kq9o2AscpfVB0KpkLCCZQnutTgXxZqUKJMjoOd570b4ng1iUwW5VPIHICGLkE
	 NfZoRYLeHSGiA3pGTUx7XBXcteBSKy6o1cMvSb2EUQZaJSqGjPqkQL2OCNO7QjipIp
	 l3dP9PsjlVlBBOaM+Nb9sciPt4Cgxnhgh9VnMUV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rocky Liao <quic_rjliao@quicinc.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 107/196] Bluetooth: btusb: add shutdown function for QCA6174
Date: Mon, 23 Oct 2023 12:56:12 +0200
Message-ID: <20231023104831.553850104@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
References: <20231023104828.488041585@linuxfoundation.org>
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

From: Rocky Liao <quic_rjliao@quicinc.com>

[ Upstream commit 187f8b648cc16f07c66ab1d89d961bdcff779bf7 ]

We should send hci reset command before bt turn off, which can reset bt
firmware status.

Signed-off-by: Rocky Liao <quic_rjliao@quicinc.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index f2062c2a28da8..96d4f48e36011 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -3984,6 +3984,7 @@ static int btusb_probe(struct usb_interface *intf,
 
 	if (id->driver_info & BTUSB_QCA_ROME) {
 		data->setup_on_usb = btusb_setup_qca;
+		hdev->shutdown = btusb_shutdown_qca;
 		hdev->set_bdaddr = btusb_set_bdaddr_ath3012;
 		hdev->cmd_timeout = btusb_qca_cmd_timeout;
 		set_bit(HCI_QUIRK_SIMULTANEOUS_DISCOVERY, &hdev->quirks);
-- 
2.40.1



