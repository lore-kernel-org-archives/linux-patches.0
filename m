Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8241A423149;
	Tue, 31 Mar 2026 16:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975516; cv=none; b=UKaXPmtkdMRU1oyhRoVeReWTnPyhdyw5njgd8OrFHc/1AnM78Ih65LqYVoTm/C4R0Vn2H4XYYmildC42agTLEUXERn1uJvQrbEUBXTKCA3IzSfTFUQXQoHbMfRw8b0vk20iVK2Y9yE0mFI4ubrFmylPs7qSNbIakBWsL+z3Hn/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975516; c=relaxed/simple;
	bh=4Mexmz7EY5q5ZvxZTRy34BnoMqOxlV8htLzNHFDXXc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dfh2YVyEuZ/UusgrvsOLszlaU2FrkUJV96eIwIpQuBkY6sswfLlKNLjRhlDNXCzyti/q9EyI8oIYxfSyIMse7ND1JPYxoEL7M845jIr/JQW73Qf/vUeBKCr4yemVrEMgYP6XMjtlVR5tg9p7sQp3pJRn+o/Yng0VGmIASpywMFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cv5UPzE/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cv5UPzE/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15EFDC19423;
	Tue, 31 Mar 2026 16:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975516;
	bh=4Mexmz7EY5q5ZvxZTRy34BnoMqOxlV8htLzNHFDXXc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cv5UPzE/SEbb6nLAHyfnPQ47nmAukrC/grI9p0kYOogzqlO29nbAnK7p4tJq+csOH
	 edM2XutsbERdfEZrAEWhx04OFSkwfSQxgh/hy7Klz/2yJS0mxEt6lFS69kOO193c1Q
	 QZxu7R3N6fFQ6o0DPnorcyjwMw4sH7b8dGAsGqcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@nabladev.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 325/342] dmaengine: xilinx: xilinx_dma: Fix dma_device directions
Date: Tue, 31 Mar 2026 18:22:38 +0200
Message-ID: <20260331161810.870772894@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@nabladev.com>

[ Upstream commit e9cc95397bb7da13fe8a5b53a2f23cfaf9018ade ]

Unlike chan->direction , struct dma_device .directions field is a
bitfield. Turn chan->direction into a bitfield to make it compatible
with struct dma_device .directions .

Fixes: 7e01511443c3 ("dmaengine: xilinx_dma: Set dma_device directions")
Signed-off-by: Marek Vasut <marex@nabladev.com>
Link: https://patch.msgid.link/20260316221728.160139-1-marex@nabladev.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/xilinx_dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index 89a8254d9cdc6..e6d10079ec670 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -3003,7 +3003,7 @@ static int xilinx_dma_chan_probe(struct xilinx_dma_device *xdev,
 		return -EINVAL;
 	}
 
-	xdev->common.directions |= chan->direction;
+	xdev->common.directions |= BIT(chan->direction);
 
 	/* Request the interrupt */
 	chan->irq = of_irq_get(node, chan->tdest);
-- 
2.53.0



