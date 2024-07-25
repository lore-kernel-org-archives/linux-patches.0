Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947B78468;
	Thu, 25 Jul 2024 14:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919157; cv=none; b=Tb+E8iY60yy+hEjCBkPxI9Y5YCPlEeCenWSadLOM4lvHDGzs0NhhLSmz2b62FfkvGw794dqXYsH2meG2JErpL8X2gSoW4KHR+YSVVE/KIppO+wFE/QGAY33BqnBaiW8tMpFJCllRT8OJgeh1Dbfpomt49KV/bL4v/inipI9uxc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919157; c=relaxed/simple;
	bh=x8hHa7y1coi+1Mdfp+poDv7CSIIzmVtSlij4wthgdyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VJDvYZiFyPCMhkuW2IUlK3sm2kbHi6l+kACXSHpLJxhIUD8aa+d6zLfVTi2kLyFhj0Outy9nj4hEZue9Y6uCauYmA6oFghr663q0iEYc3zuNg9ADrUPXO4y4aPUgHNy2DRbf5C6CY4DBLlnUVne1/IqJ5/EobCSLZ3JCq7AgoKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EHTOEIsb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EHTOEIsb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AAC8C116B1;
	Thu, 25 Jul 2024 14:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721919157;
	bh=x8hHa7y1coi+1Mdfp+poDv7CSIIzmVtSlij4wthgdyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EHTOEIsblBFQOfaJvfKjQGg2ZLzwXHyGY6azH2boW8Kkobc61mNgmywRn0VD2oenD
	 OH0UNsRPPLj/ahZAYpISEfZ7HOZdxXfeHRGeAlDwzPlW0Ajz8UB/INdn9SzR98F+9+
	 iDTr1CuHBHEx+zTqRSfzfXFFNSH9iv4xD/JhR0G8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 42/87] can: kvaser_usb: fix return value for hif_usb_send_regout
Date: Thu, 25 Jul 2024 16:37:15 +0200
Message-ID: <20240725142740.021476133@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142738.422724252@linuxfoundation.org>
References: <20240725142738.422724252@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 573d3a66711ab..95ed200553929 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
@@ -293,7 +293,7 @@ int kvaser_usb_send_cmd_async(struct kvaser_usb_net_priv *priv, void *cmd,
 	}
 	usb_free_urb(urb);
 
-	return 0;
+	return err;
 }
 
 int kvaser_usb_can_rx_over_error(struct net_device *netdev)
-- 
2.43.0



