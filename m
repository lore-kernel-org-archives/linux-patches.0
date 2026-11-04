Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829377;
	b=1pcVOX9psylbFu2zWfbbZyKChUOO9DkPuxXKRVZuUJ29ffcjmvtJBuAjzJnVzFTWldxD
	 IAjQNeo1fSHsH5cyb6vApZpJx9tXrLisF6aFugVtR9Lo+B1Eu26bkB2bxMAwbM1I/b4qF
	 fDIIbVNRjqLLGlLyYx5Lf3DCiWXmOVEPqeboTZmjN1L8aZan2rqlTbBpQ7+VFxKAoUOaX
	 knKyefIoYsK05XoPJNtpe7TpKV+5Skc41hZgiSHTd3yCfEgbq50yME4zXKHCjoAVfPd2q
	 YnxqsHHMAnanF8Ojd6tFK9s3gTAli8YHtl1ESCeMH18G1hIpOYPn+lHCyJDbhpOaTsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829377;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oBcIvRO1/iidvy11eZ0Hlx5ILiU77WVCrkHkMgKhQPM=;
	b=SJ65uLaGyZra0MQBUx0+MwizOl8WuvULEfdb3pmWPv5lPwoPfHcobprb1RTG7MExVD3e
	 hxoRGwhCcqbz87xjL+UwciuCI1aVfqLmuCYF0rEj8uTHKrtGCIRs/KxMyBW/uqHP/6jmP
	 BJ+7AZSBKwhObUz3zza2Br0u9Jvxjn2K0zF13c/yAx22GnFxSVMfjxI3UyNyuu/SC5Chk
	 IT5XDj7BWgD1kEkujM6iSCxVCnFHgQi0eiDOLR2y8/hKRLAGmqezjUx2zbcdKQYHraheF
	 XDxWr0Yi8fXfE6eIvRPw/M2v1CMJJ8HKlEHbRsucuecp0JHz4mnism7WI/jO5EP6hIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TLjMzM79;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A00606A851;
	Wed,  4 Nov 2026 21:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TLjMzM79
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 109B11F00A16;
	Wed,  4 Nov 2026 21:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829377;
	bh=oBcIvRO1/iidvy11eZ0Hlx5ILiU77WVCrkHkMgKhQPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TLjMzM79XxmMiO3LyG6On2L6hPheA0lewQqAhVKDsAn3/27L2B8ICkgupPFgeZj65
	 UhiloZ0UZlg2nLADpWPgO/vHj1UZgl7CjuNl9qyiTlWW7GUhVRKr0is7J3nbnsDbDm
	 b9KyAPxQmonh3O5XGuCH9AnECrG9nfenGkMK8Tfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Dooks <ben.dooks@codethink.co.uk>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0087/1005] dmaengine: dw-axi-dmac: fix __le32 on set of CH_CTL_H_LLI_VALID
Date: Wed,  4 Nov 2026 15:57:00 -0500
Message-ID: <20261104211046.063974827@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ea4e47ee0d710..343d32eeaa29a 100644
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



