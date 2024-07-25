Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4461DF519;
	Thu, 25 Jul 2024 14:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919023; cv=none; b=sTh8YSbXqGo1bcx3mGjqleL4IRStUDxxS7yjPCKg0Hvw2Pq8HvouLxxCaK0IVp4/58k/3evjWc++xv1K7aGJ7TpO8xXkhPQ1NpaIg7JhgaeruOXeMeeUZvvYL4lcaGMzRxLdlSAhXJF9td1dMVV8081XRFhvvi0YRPGzCS0mK+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919023; c=relaxed/simple;
	bh=j8/DCpBowdzcb9SMRKze/NCe98LdUNmd3pKBirqBDSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cmYYxz31L8XLb6+9XpfqPDwaZk1sRSh9zWC9nhbg12ICSeP3AxxWstjHQCuq6IKJWOs1qUy95efDgKdG4KNp9J2mucGngyLX4AXaCP5TZv5gBI9kq5J2pJ0haDXXBkLP1rgs8LnP5HH/dGqYjWTIZkyxhw4KryWLBX9KP8rxolU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WVid4rJ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WVid4rJ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C21C116B1;
	Thu, 25 Jul 2024 14:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721919023;
	bh=j8/DCpBowdzcb9SMRKze/NCe98LdUNmd3pKBirqBDSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WVid4rJ7kRnOlgiE6ECFCRNhZzJvpSiJc7774eB+j4J78WNeDIqvuL805x7+wOULI
	 WVfz6ZPUwj9ukiResSgO+aeVQCkmST2fO46lj6fTlv1JOQJ/VAeEnwOXEwR7r86R5b
	 HwQxeAHlxyAhgCYk+3BQgpII8cVyrlsvcYSNMUB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 28/59] can: kvaser_usb: fix return value for hif_usb_send_regout
Date: Thu, 25 Jul 2024 16:37:18 +0200
Message-ID: <20240725142734.325117348@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142733.262322603@linuxfoundation.org>
References: <20240725142733.262322603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 411b3adb1d9ea..a96b223984070 100644
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



