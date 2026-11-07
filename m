Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064054;
	b=ILwFVUHD+xNNCFMs5Dg+dAg2+fpBeOuHI+XYJyAWdF7+GtKuD8qHC5U0m1ITnSRZS7qY
	 sKh6CAL0w8GnqZY2zkRgdEU4WV4rtxOA3qa6dXaD3sOinECIKoVQy7PW0jHcn4VMUel27
	 1YGCigB1fzIdA9Cdzlg6LG1eiz5uApXdhSbCWmcxFqG+nYmTrxgNo9bV/xJ0TNTSVt52x
	 WIuOMN7SHJMjSiN32xKrPFJWEr8PtTIhgJo7g9sQ6l5jYQbVmqI6Vol2KcO9GO9CFKUFH
	 oomauA7zzXSPjMPOd4EWkJMBEtLGza849OBA5J2OGNs4VyzKL9WWfdwZUxU4nPClC+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064054;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QoFT+W/57t1GdtiVh/eguEcGDHrLjCG36ErLoRxhrVQ=;
	b=v1nwHJfNAY0IJBakBM6pAJoFqE7p8Ol4UNSE4WhZ923HmNFsBxtD6pP+Dwu2t1utfBNZ
	 Ic7y31Pkr/lwhfE2eZslx3yyzfji1EjIijAJaiVtME+1y6oWER5IH+77lB1b2k9jbxFS+
	 PEk4D5h3HeeUwk7DZnjB9HJkU3MtuKR0wsIchbqTUR1Jx1QYLpzdzEYDMsJ5Bw4tDRIko
	 rStQahGj9gKE3GV8dQKz1MMXzHNOUBeHwrwvxPQNvHSF1ROxD98D3Yf2PxrDPgFpdmnPz
	 jKkvHkCq+jzgdz6uVHR/9SeIrQUPximKx0wghiDmjB6/qAUudTASOIR5UTMAqjEbezA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MuAePHgJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A589606A9D4;
	Sat,  7 Nov 2026 15:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MuAePHgJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB4471F008A1;
	Sat,  7 Nov 2026 15:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064054;
	bh=QoFT+W/57t1GdtiVh/eguEcGDHrLjCG36ErLoRxhrVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MuAePHgJMI8W5m6bSx+/zqYRynJ/rVXEjJAatgZutxKnv4MXtXS+PIst81mBAN5Vg
	 ZMO3rjD5Vxmb1Dw7iIQpjcGN18KpmXRZN7nEm6CY7u1jUOnoXq42FEmCKpCsJCB3O3
	 kMEg+ZW8nvUntMafZOUrtkonZR73wb5NvJiNm8d4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0226/1257] media: ene_ir: Ensure teardown is done in the correct order
Date: Sat,  7 Nov 2026 08:42:02 -0500
Message-ID: <20261107134945.770847826@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

[ Upstream commit ae6cfbad7ca346b78f4cdac38438bbfaed8c18a0 ]

The timer can be re-armed from the irq, so ensure that the timers are
deleted after the irq and that we only free the rc device once we are
sure that the irq has been silenced.

Fixes: dccc0c3ddf8f ("media: rc: fix race between unregister and urb/irq callbacks")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Young <sean@mess.org>
Acked-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/ene_ir.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
index 6f7dccc965e7f..f98d76277b62a 100644
--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -1103,15 +1103,15 @@ static void ene_remove(struct pnp_dev *pnp_dev)
 	unsigned long flags;
 
 	rc_unregister_device(dev->rdev);
-	timer_delete_sync(&dev->tx_sim_timer);
 	spin_lock_irqsave(&dev->hw_lock, flags);
 	ene_rx_disable(dev);
 	ene_rx_restore_hw_buffer(dev);
 	spin_unlock_irqrestore(&dev->hw_lock, flags);
 
-	rc_free_device(dev->rdev);
 	free_irq(dev->irq, dev);
+	timer_delete_sync(&dev->tx_sim_timer);
 	release_region(dev->hw_io, ENE_IO_SIZE);
+	rc_free_device(dev->rdev);
 	kfree(dev);
 }
 
-- 
2.53.0



