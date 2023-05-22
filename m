Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5ED171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:43:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09D98C433D2;
	Mon, 22 May 2023 19:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784605;
	bh=X40QQfdRaA3MHuarzlvmKZkdrjntoaNiRjpsI+0EnKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l/g6NHfEPEAdfxUBFWmlaGHlQ8nJDlX3/eJuY4cxs/zm2I5ehlzHITwWhcjcywS66
	 6SjVMIe0f7L7+WX67uoOzwPFlEU7X7VtMNEaIZDk5EaF/O4igrKOSjFsz3RuLG5FFQ
	 Rmnh2XDCZ0fZh1cK2TMW3aLF8/xNJMwDPFPzYFUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raul Cheleguini <rcheleguini@google.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 138/364] Bluetooth: Improve support for Actions Semi ATS2851 based devices
Date: Mon, 22 May 2023 20:07:23 +0100
Message-Id: <20230522190416.230573023@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Raul Cheleguini <rcheleguini@google.com>

[ Upstream commit 7c2b2d2d0cb658aa543e11e90ae95621d3cb5fe6 ]

Add two more quirks to resume the device initialization and basic
operation as the device seems not to support "Read Transmit Power"
and "Set Extended Scan Parameters".

< HCI Command: LE Read Transmit Power (0x08|0x004b) plen 0
> HCI Event: Command Status (0x0f) plen 4
      LE Read Transmit Power (0x08|0x004b) ncmd 1
        Status: Unknown HCI Command (0x01)

< HCI Command: LE Set Extended Scan Parameters (0x08|0x0041) plen 8
        Own address type: Random (0x01)
        Filter policy: Accept all advertisement (0x00)
        PHYs: 0x01
        Entry 0: LE 1M
          Type: Active (0x01)
          Interval: 11.250 msec (0x0012)
          Window: 11.250 msec (0x0012)
> HCI Event: Command Status (0x0f) plen 4
      LE Set Extended Scan Parameters (0x08|0x0041) ncmd 1
        Status: Unknown HCI Command (0x01)

Signed-off-by: Raul Cheleguini <rcheleguini@google.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 683556dcdc436..1ab5663b009d8 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -4105,6 +4105,8 @@ static int btusb_probe(struct usb_interface *intf,
 	if (id->driver_info & BTUSB_ACTIONS_SEMI) {
 		/* Support is advertised, but not implemented */
 		set_bit(HCI_QUIRK_BROKEN_ERR_DATA_REPORTING, &hdev->quirks);
+		set_bit(HCI_QUIRK_BROKEN_READ_TRANSMIT_POWER, &hdev->quirks);
+		set_bit(HCI_QUIRK_BROKEN_EXT_SCAN, &hdev->quirks);
 	}
 
 	if (!reset)
-- 
2.39.2



