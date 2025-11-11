Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9DB30C34A;
	Tue, 11 Nov 2025 01:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823904; cv=none; b=hmFgL5SmVpUMBx3z6RIt12fqWH6pdbrZhCH47CgM4/IkTGfR57wVQWzItb/yt+St74FK5yaaWrIffir3XdNe5VaUuCHwmsM2ZitSWFdp2D3bWEbcXIIrK7CbbRzwUTkjYX6TJGwJAAlWzCfe0T5Ml/CA83RoRpV87L6vbJgwLRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823904; c=relaxed/simple;
	bh=ZWbBAZkQokJs8EXx/+8nUW8WFUM2sjDFZ5RExSNMS8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tS1aA3ZHPLXInY5gdhC1zd2d1i3TO1KP5wHz3dEUJUPdayPfwqNzss87e8mpkQYEvaeGKVm8P+kRlKPDoDQmfAWqQ96Sd8sksGyD6c+a85QNdHcl9KdqidtbtBCo28tf4eoakFVTxd4uCJ5qSCpONbMlNYk0ZG17RH22iGmEC0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q+rdOaQR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q+rdOaQR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9069EC116D0;
	Tue, 11 Nov 2025 01:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823903;
	bh=ZWbBAZkQokJs8EXx/+8nUW8WFUM2sjDFZ5RExSNMS8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q+rdOaQRpN99PVUcJS6XJMPzS1VNUpd5JHOptwtOUrgTUIkjJpoo27ywcLvDVDvfR
	 U1jCIejlx1iwnT3q8b0SSY8pr4CvFByNMFTta4PSiK8Rv6KxmwaloYAKmtoSCxsG94
	 pp+XE5uHSCPOg6lYMZMdxNU12egg7DJGGgcfBWfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 347/565] udp_tunnel: use netdev_warn() instead of netdev_WARN()
Date: Tue, 11 Nov 2025 09:43:23 +0900
Message-ID: <20251111004534.681095517@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit dc2f650f7e6857bf384069c1a56b2937a1ee370d ]

netdev_WARN() uses WARN/WARN_ON to print a backtrace along with
file and line information. In this case, udp_tunnel_nic_register()
returning an error is just a failed operation, not a kernel bug.

udp_tunnel_nic_register() can fail due to a memory allocation
failure (kzalloc() or udp_tunnel_nic_alloc()).
This is a normal runtime error and not a kernel bug.

Replace netdev_WARN() with netdev_warn() accordingly.

Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250910195031.3784748-1-alok.a.tiwari@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp_tunnel_nic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/udp_tunnel_nic.c b/net/ipv4/udp_tunnel_nic.c
index b6d2d16189c0c..6d13d2f829243 100644
--- a/net/ipv4/udp_tunnel_nic.c
+++ b/net/ipv4/udp_tunnel_nic.c
@@ -892,7 +892,7 @@ udp_tunnel_nic_netdevice_event(struct notifier_block *unused,
 
 		err = udp_tunnel_nic_register(dev);
 		if (err)
-			netdev_WARN(dev, "failed to register for UDP tunnel offloads: %d", err);
+			netdev_warn(dev, "failed to register for UDP tunnel offloads: %d", err);
 		return notifier_from_errno(err);
 	}
 	/* All other events will need the udp_tunnel_nic state */
-- 
2.51.0



