Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D624932ED5D;
	Tue, 11 Nov 2025 01:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823945; cv=none; b=g4vqDH9uXX5T8gkeNymub9wx99N5BnJlvwwBGTx96AP4dj5hJnhRpieIFHyDD/vpb+WFjg1SF1LzIAElhEaTrJxvUcND8AviQlXNw78uTJ745gCfUvBu8Rlkw/Uji89mV57ImC/idDaY5u82jMi6e497tOBsWwExng/x0Dnm+MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823945; c=relaxed/simple;
	bh=jl4NsO7TWnaUxMI+x6Qigy+tHfwQ4/uaMLCeqmwEfSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jblfnNiNlZxx4SuRAn5/wbv/pN9uhg4wOndC1Y02sX2kpTnVzMc6JFzw50PnTZQEp1c7hj2NTpDEAchwM3beGFsr+m1uOXNoZa4dGjybr7UfWs/1XTSRtIf/5/vlIl1yaLBml25iyZOz3GUkljOCw2ca6OGOGLCHecu38C/lDzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BP/mSNPh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BP/mSNPh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 546EAC113D0;
	Tue, 11 Nov 2025 01:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823944;
	bh=jl4NsO7TWnaUxMI+x6Qigy+tHfwQ4/uaMLCeqmwEfSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BP/mSNPhr2UvMJYvyAWZ26RqdO8FBC71ll9LOtutFY0bvun94ppT5JDNL59Ov6C0k
	 HHAF1hqjJ4yVdUFcXxLTtpE9lb5mTHvQFSZe70YEAdGokeRFk9dBNyiEQQkxcHAz3V
	 8HwQ/7jagaybZ7Fj1uN+HJONQb1pFqfzrhb7Dsgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parthiban Veerasooran <parthiban.veerasooran@microchip.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 402/849] microchip: lan865x: add ndo_eth_ioctl handler to enable PHY ioctl support
Date: Tue, 11 Nov 2025 09:39:32 +0900
Message-ID: <20251111004546.158677418@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Parthiban Veerasooran <parthiban.veerasooran@microchip.com>

[ Upstream commit 34c21e91192aa1ff66f9d6cef8132717840d04e6 ]

Introduce support for standard MII ioctl operations in the LAN865x
Ethernet driver by implementing the .ndo_eth_ioctl callback. This allows
PHY-related ioctl commands to be handled via phy_do_ioctl_running() and
enables support for ethtool and other user-space tools that rely on ioctl
interface to perform PHY register access using commands like SIOCGMIIREG
and SIOCSMIIREG.

This feature enables improved diagnostics and PHY configuration
capabilities from userspace.

Signed-off-by: Parthiban Veerasooran <parthiban.veerasooran@microchip.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250828114549.46116-1-parthiban.veerasooran@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan865x/lan865x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/microchip/lan865x/lan865x.c b/drivers/net/ethernet/microchip/lan865x/lan865x.c
index 79b800d2b72c2..b428ad6516c5e 100644
--- a/drivers/net/ethernet/microchip/lan865x/lan865x.c
+++ b/drivers/net/ethernet/microchip/lan865x/lan865x.c
@@ -326,6 +326,7 @@ static const struct net_device_ops lan865x_netdev_ops = {
 	.ndo_start_xmit		= lan865x_send_packet,
 	.ndo_set_rx_mode	= lan865x_set_multicast_list,
 	.ndo_set_mac_address	= lan865x_set_mac_address,
+	.ndo_eth_ioctl          = phy_do_ioctl_running,
 };
 
 static int lan865x_probe(struct spi_device *spi)
-- 
2.51.0



