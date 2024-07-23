Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E4413D896;
	Tue, 23 Jul 2024 18:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760196; cv=none; b=WS3hat77uvZNqgmnjGbZU4bzZJBYUW/Sr7Q/Usyzwz3GJO+ob734eKsKDsrVt9iV6iNFM76IkibPS4xEh6sGu5YrqcJ4SEYGMQHk19xQLSM3L8y3zmyA0DHyZmJ4g5JYEcf838ldL3eFpytLLJIbApPSWKce6XyOYqczq8IulZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760196; c=relaxed/simple;
	bh=sfgfsRoZQdlg8PfNf4kWI+hFnu+70kgZtzqJd5uyL0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R1e1H3LKmoJxpiDdgEFaibudrDi6WgX707Ee8f6VqE0s8H9i4zH+ARU2we++v1LVseDDln4FppW0b6p+lBVCIRwR+5o5zuIPITZ0LoXgLzwc7/1rv7rWB5BnMOI514OoqpRZIt0lgPl8Fi3C4uLYUiK1iJ0drLCyc+Qlu/F6x5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1I6OBXls; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1I6OBXls"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A50C4AF09;
	Tue, 23 Jul 2024 18:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760196;
	bh=sfgfsRoZQdlg8PfNf4kWI+hFnu+70kgZtzqJd5uyL0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1I6OBXlsyXQUbzxWD6LUJNFGAzZwhnQv01t4CU+NcyqEh3S5eopmqKIq57p1nhsuh
	 /2oyzmOnSBzdCwieLsKpNafPbbRnwc/OrQLRQCj+n0/NZjve3RjTUCN4mgFHmuhltM
	 qK1Z+gLggrVRDDxucMCi2qitcV04SuuQde+sPx9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 104/163] can: kvaser_usb: fix return value for hif_usb_send_regout
Date: Tue, 23 Jul 2024 20:23:53 +0200
Message-ID: <20240723180147.493796171@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index ffc3e93292501..024169461cad0 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
@@ -295,7 +295,7 @@ int kvaser_usb_send_cmd_async(struct kvaser_usb_net_priv *priv, void *cmd,
 	}
 	usb_free_urb(urb);
 
-	return 0;
+	return err;
 }
 
 int kvaser_usb_can_rx_over_error(struct net_device *netdev)
-- 
2.43.0



