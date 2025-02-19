Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BCF11E98FC;
	Wed, 19 Feb 2025 08:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954272; cv=none; b=Bw6zKvUTLbMZNoAiVPDnqueW63Ssc8gkmULkK7STvlQBWG6ulJycYyS7khClrrUSejNKXTuDx/NIE6m5bsduiLAXxWbmr2yLv509oFqB9VfogJjrZOCHLlxWOqfTrmnn/iAAqyt2ntykq34hvbC6sPUSO9pivl/wOav1pwOiDns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954272; c=relaxed/simple;
	bh=Ep1zkGihxCAMyS4R8OfrDtQXF89RljgDuDo8ohC6S5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qo/b4TYj+1ebbUPBPkS3L9mSfhedp4kjcSXL2sRnZDymmrA7JjNa2W1bJpvQAUCBQbxkR0hnawArGq/ocgRtZkAtTecfTiFi5hUZ58c/O/DvV6LPw/ANmJyrofNmkM2kE0etdjouG8Kv56glCZCdlvSPXDCtsgoixViwm/HEl2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JRtsnFlw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JRtsnFlw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5191C4CED1;
	Wed, 19 Feb 2025 08:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954272;
	bh=Ep1zkGihxCAMyS4R8OfrDtQXF89RljgDuDo8ohC6S5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JRtsnFlwInFMymDLX+dM3+7udMBPf4vpS1uJ7x+QVDF8Xp0mN5dqVxOsC13XNHzzk
	 hdf+9bEU7euuifkQ9XOTHWYkFncmxT0QsjCC6KPBHja3etk0JnwNyjEapfXxqDyEZJ
	 fTqnew1sUPvdbFyjnhEi9p8o8lqdexaIKght3Rts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin van der Gracht <robin@protonic.nl>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.13 152/274] can: rockchip: rkcanfd_handle_rx_fifo_overflow_int(): bail out if skb cannot be allocated
Date: Wed, 19 Feb 2025 09:26:46 +0100
Message-ID: <20250219082615.546289220@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin van der Gracht <robin@protonic.nl>

commit f7f0adfe64de08803990dc4cbecd2849c04e314a upstream.

Fix NULL pointer check in rkcanfd_handle_rx_fifo_overflow_int() to
bail out if skb cannot be allocated.

Fixes: ff60bfbaf67f ("can: rockchip_canfd: add driver for Rockchip CAN-FD controller")
Cc: stable@vger.kernel.org
Signed-off-by: Robin van der Gracht <robin@protonic.nl>
Link: https://patch.msgid.link/20250208-fix-rockchip-canfd-v1-1-ec533c8a9895@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/rockchip/rockchip_canfd-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/can/rockchip/rockchip_canfd-core.c
+++ b/drivers/net/can/rockchip/rockchip_canfd-core.c
@@ -622,7 +622,7 @@ rkcanfd_handle_rx_fifo_overflow_int(stru
 	netdev_dbg(priv->ndev, "RX-FIFO overflow\n");
 
 	skb = rkcanfd_alloc_can_err_skb(priv, &cf, &timestamp);
-	if (skb)
+	if (!skb)
 		return 0;
 
 	rkcanfd_get_berr_counter_corrected(priv, &bec);


