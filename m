Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355D719B5BE;
	Thu, 25 Jul 2024 14:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918559; cv=none; b=kWtHI3KE4ivfTNNath0USP8QrTRl75q8o+KXl7EmzwOmXTpwZ93mHwUx0IxzANfwiLVeAbDKePke/NqIVe2mtDUE31/uLJrt7fDQ902NgoCuvWIg23sj6FvfQxe66OHdYxWoQmWGmmU0tw8+ZnznrkUyl9dFPR3KhjaRnmP90PE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918559; c=relaxed/simple;
	bh=Qiev8cGpMCudh6YAJBuz/LESEzMKk8ordXeTzNixkb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cLROqjyFS+JyOlmSOAS/cIn0J4zPYfj6QFgyB0f/RWVCJkDgwAL1roU2lGsvhJOJxZ/NnkwEQyAd0qUNdOE/PMzS5qKKLB4Mhy2p6nyFoI9E8MsD8wDyG5LeEBQ/Kxzwou7EQItb2cv+KZQX2xaGGCqGy6wJIgTx2AKpO2sWv8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CfHOtrS4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CfHOtrS4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A269C116B1;
	Thu, 25 Jul 2024 14:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918558;
	bh=Qiev8cGpMCudh6YAJBuz/LESEzMKk8ordXeTzNixkb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CfHOtrS4p2bmILjYyysszLYoaWbKa+Dqlr1tjyl3lpJL54xDpdxlNeqkvikjjNEp8
	 gTBTWr+GLhjVImbkoGHoBEfw8ZfXDyAd5MzLLTaaAG3+bOAi55QMvGkbblaMCR8N9C
	 EE6vzi+zot42VUVWYvHR1DBd5Ye48xpLGwMDH3aA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 22/43] can: kvaser_usb: fix return value for hif_usb_send_regout
Date: Thu, 25 Jul 2024 16:36:45 +0200
Message-ID: <20240725142731.312469599@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142730.471190017@linuxfoundation.org>
References: <20240725142730.471190017@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



