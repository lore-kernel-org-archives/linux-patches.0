Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB7719D893;
	Thu, 25 Jul 2024 14:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918425; cv=none; b=m5hIP+TTYZtzDFbnlomCwGWV3OAbvzPVeECk2OyqXyp92TAeXXpgTwNqylzJKo/RFsXaBNcK0nbROKKeVdUHG0kzyBnTPeuX/YEdK7Fxc6zahRgLdW2wK9iK622vSNldBLjBYmgte5Vv3QvFt0j0tXSOF4+k/h+jeXLLuYNFKjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918425; c=relaxed/simple;
	bh=+dv1I5Y8VI590IVYmwL6xJGrmq/2bgr8ZNheVdRCTrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sEMvD42pWwtB6DKF1zilUeHAjfRzjACU1GW8Mi91A/M/jBCP+IKq9zi6RDjpr1huaNnIlXOC38gIpFq2IYY5fPrccRqmjU+Zn6snpxaWazOLw3hgTF8cZTnRkeWQQ95NiwkjkZJ5CvTJVoEuAgWsnxgLT/IU9NiAllo+l/K6eJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hL1rZj0B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hL1rZj0B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D9AAC116B1;
	Thu, 25 Jul 2024 14:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918425;
	bh=+dv1I5Y8VI590IVYmwL6xJGrmq/2bgr8ZNheVdRCTrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hL1rZj0BO+cvfhgu5rMEwS7ZcB4h2fkGXhPhcC9gZ6PeNRtGo+WKIVIEsPgsb1cLi
	 8mcT88LeEuNKJvGPnYpmBqqSHAO3rvqOp3EfhE09QHHDObB5WM0yJbkQwaQkZatcDo
	 xhyJybygVWBo8AdpSk+DESbTwQbfrTwEDS0sgcYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 16/33] can: kvaser_usb: fix return value for hif_usb_send_regout
Date: Thu, 25 Jul 2024 16:36:39 +0200
Message-ID: <20240725142729.133558416@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142728.511303502@linuxfoundation.org>
References: <20240725142728.511303502@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit 0d34d8163fd87978a6abd792e2d8ad849f4c3d57 ]

As the potential failure of usb_submit_urb(), it should be better to
return the err variable to catch the error.

Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Link: https://lore.kernel.org/all/20240521041020.1519416-1-nichen@iscas.ac.cn
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
index a8c7879095de7..0d23d3c5624a4 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
@@ -266,7 +266,7 @@ int kvaser_usb_send_cmd_async(struct kvaser_usb_net_priv *priv, void *cmd,
 	}
 	usb_free_urb(urb);
 
-	return 0;
+	return err;
 }
 
 int kvaser_usb_can_rx_over_error(struct net_device *netdev)
-- 
2.43.0



