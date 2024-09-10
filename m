Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D69218C335;
	Tue, 10 Sep 2024 09:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961799; cv=none; b=LQ1censhMQ6JuqGnsmXITw8/Htq3Jk712QV6gMPIpHU8XhilzKK2PPZk3KK9yETvnFKmH1vs/3kEVHfFvzucaJkrEQgm6KaBZGrmAwPZalyKXZmPyD7F6EvVwwGqQy4vikufgkVcHPyh6uBUHILHj1NJHUfxFWtBWx8YFj3Pyj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961799; c=relaxed/simple;
	bh=2VGioMgyU4aiP/DTiEOI+sp9FSNGoJ0Fh5N8IeXF9CY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nv+5V61ZDTm3YG7l/7EZ4vLabPbG2H81skPIGRkpCYowS1Gb3dZJP+H2fIyprbj+RrKweghtr4gtHTZxFtsYkltFVr1+vKvWB2qfuVKmN6cBEsOR1YcRaXSlHF3DCK+wtw0DS4okAwxiOBWdq4MVlNI8VVZ/ZCwy7eZ3mMH1bRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rAii+NOY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rAii+NOY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15336C4CEC3;
	Tue, 10 Sep 2024 09:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961799;
	bh=2VGioMgyU4aiP/DTiEOI+sp9FSNGoJ0Fh5N8IeXF9CY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rAii+NOYWoGLXCbd9g5Osa0uEFRBPPEFRBkQZLrgd0qkBiPV/+F2Btipl29ejXK4L
	 QkrBAtVVw8npKn57UhRFGcZDikCusI0lUdUbA5CfX0+ecW9IXjSmJWue8+fmx5/HLR
	 fgf8oD1v8yewBH86bKP5sdSrWg8ceSQ88sh74J0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Jocic <martin.jocic@kvaser.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 166/375] can: kvaser_pciefd: Remove unnecessary comment
Date: Tue, 10 Sep 2024 11:29:23 +0200
Message-ID: <20240910092628.061376042@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Jocic <martin.jocic@kvaser.com>

[ Upstream commit 11d186697ceb10b68c6a1fd505635346b1ccd055 ]

The code speaks for itself.

Signed-off-by: Martin Jocic <martin.jocic@kvaser.com>
Link: https://lore.kernel.org/all/20240614151524.2718287-4-martin.jocic@kvaser.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Stable-dep-of: dd885d90c047 ("can: kvaser_pciefd: Use a single write when releasing RX buffers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/kvaser_pciefd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/can/kvaser_pciefd.c b/drivers/net/can/kvaser_pciefd.c
index aebc221b82c2..3ac18dd0a022 100644
--- a/drivers/net/can/kvaser_pciefd.c
+++ b/drivers/net/can/kvaser_pciefd.c
@@ -1701,7 +1701,6 @@ static irqreturn_t kvaser_pciefd_irq_handler(int irq, void *dev)
 		kvaser_pciefd_receive_irq(pcie);
 
 	for (i = 0; i < pcie->nr_channels; i++) {
-		/* Check that mask matches channel (i) IRQ mask */
 		if (board_irq & irq_mask->kcan_tx[i])
 			kvaser_pciefd_transmit_irq(pcie->can[i]);
 	}
-- 
2.43.0



