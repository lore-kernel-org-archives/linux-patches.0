Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93CC9222560;
	Mon,  2 Jun 2025 14:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874357; cv=none; b=NOGqxZfHkA+haM2kEqoVfZASp5SiF+wLQY587vAqSU5QJShMCigENuByTkurBUmMcj+yY/MuSTVrf/L+apVJhOfT5jLP91byrZMTJTGNGk7c4pwYA3F4kQYtWievm+WMBzuoLCzY655qORN+RNNIaI0gXbnKm60esQE7qs2sLKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874357; c=relaxed/simple;
	bh=+t1JVm3AOBTRaOHgnhYUhKH2qPZ9IbPLWkDwI+CP5/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GEYXzmc8Vt4Jt8JKdBsFwn7G7vuPlvOAd6g55tnbBXg5trfazlM/EcxTj+eC36u9tyHtKVM1VLOjxqqdiPEOaGbQetelp/u8NDg6wYcB/ZUAFhJbK39PdYMt8/nCOV20V3KDyyT6fTt4HL38jmuJTKXouwZJsA2qCWAMFzGuF0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sK6b6dbQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sK6b6dbQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1838EC4CEEE;
	Mon,  2 Jun 2025 14:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874357;
	bh=+t1JVm3AOBTRaOHgnhYUhKH2qPZ9IbPLWkDwI+CP5/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sK6b6dbQ+XcEr9sGHTtIooQz71IkYZr18LM9p8Eft3QnNyuqNnTPCCM3afFgihRxS
	 FI9G5hG+uhoSoCOyKw+7mYkgm6jyFXwOUx/NpD+ukrwU51SdAQz9uV0869+sME5JpX
	 CzHdQMqpaLNXpKgcPiG11qW1IgUuDJsFjNyvZGBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nishanth Menon <nm@ti.com>,
	Simon Horman <horms@kernel.org>,
	Roger Quadros <rogerq@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 443/444] net: ethernet: ti: am65-cpsw: Lower random mac address error print to info
Date: Mon,  2 Jun 2025 15:48:27 +0200
Message-ID: <20250602134358.921448392@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nishanth Menon <nm@ti.com>

[ Upstream commit 50980d8da71a0c2e045e85bba93c0099ab73a209 ]

Using random mac address is not an error since the driver continues to
function, it should be informative that the system has not assigned
a MAC address. This is inline with other drivers such as ax88796c,
dm9051 etc. Drop the error level to info level.

Signed-off-by: Nishanth Menon <nm@ti.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Roger Quadros <rogerq@kernel.org>
Link: https://patch.msgid.link/20250516122655.442808-1-nm@ti.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 9c8376b271891..c379a958380ce 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2095,7 +2095,7 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 							port->slave.mac_addr);
 			if (!is_valid_ether_addr(port->slave.mac_addr)) {
 				eth_random_addr(port->slave.mac_addr);
-				dev_err(dev, "Use random MAC address\n");
+				dev_info(dev, "Use random MAC address\n");
 			}
 		}
 	}
-- 
2.39.5



