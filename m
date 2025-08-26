Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BBF721D3F2;
	Tue, 26 Aug 2025 14:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218705; cv=none; b=cJvUmXyvbWieEUQkfKPjg2NuNAoY5StVBPTw21jLIHIqYfTiTWdTZbWWsueUkZWZWMvZuSTFi/ioH/tegDionq5Oaa9syhBlCJdSDPaWj6Qo3K/Xth88cd27NetvVsWpnoBnj/f0c8S/M1t1tl8salr+Ebnv1Ac0e0l5PV0Z3tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218705; c=relaxed/simple;
	bh=UVfJM669TvIwfGUcpAW13oP1F1js6BISR2v9yD2aIts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jn6Vh3YMsn6Re3BDlX98UPGulGcvHeAGghyTd/i4oN4mLD6qaIv6PnkXUtnpAeC0BmAaIyyOx7Rc+yum2a7uk0kbZNbismmFAnxJ0My5D3nJ8iMefhQI1jJ8K7jHlVwcxMPRdRw5xeUDVmEz7PAGLHM5O9tfX1fKgROWNYaGZR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RKZ813n0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RKZ813n0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A64C4CEF1;
	Tue, 26 Aug 2025 14:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218705;
	bh=UVfJM669TvIwfGUcpAW13oP1F1js6BISR2v9yD2aIts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RKZ813n0COMTm4G6ZDHp0Z8s7d9rs2vLDpSkc4Ph0S93dg7C6VmBIPxvJd/Or1kCk
	 /RE1/vXofOUTRy7ziPyHkmXO8AykJww/1PTctIfjPvSQvQ+BZlZlyzOLA0SS/41JlM
	 tjalIQPNheFWQFF/cPomFmR06j0fB1IrZ1/V1ybI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Jimmy Assarsson <extja@kvaser.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 101/403] can: kvaser_usb: Assign netdev.dev_port based on device channel index
Date: Tue, 26 Aug 2025 13:07:07 +0200
Message-ID: <20250826110909.466310002@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jimmy Assarsson <extja@kvaser.com>

[ Upstream commit c151b06a087a61c7a1790b75ee2f1d6edb6a8a45 ]

Assign netdev.dev_port based on the device channel index, to indicate the
port number of the network device.
While this driver already uses netdev.dev_id for that purpose, dev_port is
more appropriate. However, retain dev_id to avoid potential regressions.

Fixes: 3e66d0138c05 ("can: populate netdev::dev_id for udev discrimination")
Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Link: https://patch.msgid.link/20250725123452.41-4-extja@kvaser.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
index a96b22398407..602f0b3bbcdf 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
@@ -813,6 +813,7 @@ static int kvaser_usb_init_one(struct kvaser_usb *dev, int channel)
 
 	SET_NETDEV_DEV(netdev, &dev->intf->dev);
 	netdev->dev_id = channel;
+	netdev->dev_port = channel;
 
 	dev->nets[channel] = priv;
 
-- 
2.39.5



