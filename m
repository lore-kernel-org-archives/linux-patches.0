Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C425F1BBBC7;
	Tue,  2 Jul 2024 17:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940533; cv=none; b=f/9BL36tZ5Dr26DY29AbWBuooom8YIG1bhXJPSIyPOtUOBX1N/95vjk6qdIDFrRIrNNzC/fLm6CrgJi3DfR1PbN8m3Q8kAqo8cPLqA/rPLEhV7yJ1pyRD3fLGHtLQNyAs7iJp4aT9wCEUUTGwe0SpNWheCL8D/mlEdaN0zmVcD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940533; c=relaxed/simple;
	bh=tiCP8hxSPbMm2kNzWud47NYhkmuLdJRh/kRM4zI2G1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aHb9WsK3oBTC/FrhTPzWU941s2xiMOF37L01cazEEYzQSXAKo0znjJv7Lc5ngNvPIec8tItZz+QhawdNb48WhMQeuHS2/YM/AAXa3bV+i72YHNGet+2pLvOzXNKM+Fi52fNpo6x7IdTyA1UCMxHrQurqYPWfZpFntWqzr62q+yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s+UmNuX9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s+UmNuX9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 343EBC116B1;
	Tue,  2 Jul 2024 17:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940533;
	bh=tiCP8hxSPbMm2kNzWud47NYhkmuLdJRh/kRM4zI2G1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s+UmNuX9BYvQRipTLh8o0LGzNnbqRI2RBKwflLwI23jmit/9bt1NXdZVIfjeoSLFo
	 Enlj2BV0MjvmKztu2M7ps4SpZ/gZIU3ckgn9r7HazlcBSORBO70F3KxqRtgDJf+FUY
	 rYV+v4qY2j6wkMRkAjDEQrevs6AkToyO5EW3dIEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ferry Toth <fntoth@gmail.com>
Subject: [PATCH 6.9 151/222] Revert "usb: gadget: u_ether: Re-attach netif device to mirror detachment"
Date: Tue,  2 Jul 2024 19:03:09 +0200
Message-ID: <20240702170249.748885067@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

From: Ferry Toth <ftoth@exalondelft.nl>

commit 24bf27b92b1c6a322faa88977de2207aa8c26509 upstream.

This reverts commit 76c945730cdffb572c7767073cc6515fd3f646b4.

Prerequisite revert for the reverting of the original commit f49449fbc21e.

Fixes: 76c945730cdf ("usb: gadget: u_ether: Re-attach netif device to mirror detachment")
Fixes: f49449fbc21e ("usb: gadget: u_ether: Replace netif_stop_queue with netif_device_detach")
Reported-by: Ferry Toth <fntoth@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ferry Toth <fntoth@gmail.com>
Link: https://lore.kernel.org/r/20240620204832.24518-2-ftoth@exalondelft.nl
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/u_ether.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/usb/gadget/function/u_ether.c
+++ b/drivers/usb/gadget/function/u_ether.c
@@ -1163,8 +1163,6 @@ struct net_device *gether_connect(struct
 		if (netif_running(dev->net))
 			eth_start(dev, GFP_ATOMIC);
 
-		netif_device_attach(dev->net);
-
 	/* on error, disable any endpoints  */
 	} else {
 		(void) usb_ep_disable(link->out_ep);


