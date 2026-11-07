Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060630;
	b=lsyZO0/+zNmt9LpauJeudFstueKRP4GC846ik04jufgwtX2i/IyMDmnNhlvg5grW7W/m
	 H6OC85Tl7mRHwywGcX3UKD+C9JWD7uCABixHgea35JynUDXFmJcMIxnVqJszJaDvO4W58
	 KNwvUqMyKkxToL/fScyv+Aeo+VDlODrRFaEjZIkULTmxB2qYvcMc9oRQdf7GtVRkzQlcT
	 2HMZYW0vPbLw5E7DjTjcxu/RXf19KYiFcfVZufC4LM/m8gag6f+74aPnHN/H0a60alvBb
	 RH6rtGo56wWoqIkLVhjbPlBlqT19yy/8E2hi7YtyeiqNfxh7NwqtfVuHy1LxjSgFw/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060630;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tE77bzU4Uv12kdkZXVA5cExDjPhrjcWFDD7SRdNPlls=;
	b=uIVeyc3xZRC1E6V3wxPZuzBRPsqN4W4sfFisFZQFzYNySkoWDC2xLBKrFkjHc39SpQsv
	 w8oZcB6pIl5CO31E9hMdm2mkcXiQ9Z/U/DYiB5WpK3iSE0UMFUbeFaBD2sMTRpayYerwZ
	 xW2roARHZkMy9/MQsIDch1Pgj+zJe0znXaAu/5SB3vpSU9xDKlxQt1t1ZnwVcbTBduRQ7
	 /xd9DfAq+nnnxNOQ9OrAdC+TuZb776G7Kb+9vHAcY52qCU8G2LKrkBrfh3Ayr5FiPUT7m
	 TgzQoXj2MCk4iNSwheTXgCILjEMjgC3XSWBol2FSlfOCX2Iv7jw6JoSt7OZR1yUV2EQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IiSCbhom;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74826606A32C;
	Sat,  7 Nov 2026 14:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IiSCbhom
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F161F0089F;
	Sat,  7 Nov 2026 14:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060630;
	bh=tE77bzU4Uv12kdkZXVA5cExDjPhrjcWFDD7SRdNPlls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IiSCbhom+H+2qc10wlfWyw4PPBlsRmOLgbwIdDfye13PNNDWpA5rU8gwE5SDUaerP
	 evq9IG2z04b0l+gEcs3GV3G6oh5AK5Ur2xHU+v7ffNTc7yEWqANmhR+Q6yWqnEtOiR
	 zw2VFw5AqkcIxvKi0g/JNDpo7ngcLCmVHa7//6+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Dooks <ben.dooks@codethink.co.uk>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0074/1536] dmaengine: dw-axi-dmac: fix __le32 on set of CH_CTL_H_LLI_VALID
Date: Sat,  7 Nov 2026 08:34:50 -0500
Message-ID: <20261107134959.754465558@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Dooks <ben.dooks@codethink.co.uk>

[ Upstream commit 89aba9c39bdda8a973a6ffed7c9e93321edcfc16 ]

When writing the lli->ctl_hi, this is an __le32 type so the
value being orred should be convered to __le32 by cpu_to_le32.

Fixes 1deb96c0fa58a ("dmaegine: dw-axi-dmac: Support device_prep_dma_cyclic()")
--
Note, the call to axi_chan_irq_clear() is passing lli->status_lo
through which is also an __le32 but it does not seem to be set
anywhere. Is this also a bug?

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
Link: https://patch.msgid.link/20260617084944.705266-1-ben.dooks@codethink.co.uk
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
index eee37f3de0da3..8cfe9309819a3 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
@@ -1128,7 +1128,7 @@ static void axi_chan_block_xfer_complete(struct axi_dma_chan *chan)
 				hw_desc = &desc->hw_desc[i];
 				if (hw_desc->llp == llp) {
 					axi_chan_irq_clear(chan, hw_desc->lli->status_lo);
-					hw_desc->lli->ctl_hi |= CH_CTL_H_LLI_VALID;
+					hw_desc->lli->ctl_hi |= cpu_to_le32(CH_CTL_H_LLI_VALID);
 					desc->completed_blocks = i;
 
 					if (((hw_desc->len * (i + 1)) % desc->period_len) == 0)
-- 
2.53.0



