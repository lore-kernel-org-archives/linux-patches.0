Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214830;
	b=wqEr5qUYL8PI4b0jbCrKceqPGvoftsKjqdG8AeI5PrgRf+34Tbrgyy3YalMvgtBqwjPk
	 i3zTG8zssqaeBFAyqh7SaUO9HsusvbzSUU00+r0JtW92I8TRz9rtnxaLcpZQwM5SIO8bV
	 atjK7cQz3k25E9i89fWUgAEAf6/lnSdYlqZ1tDIyrdCNEnI7w5fUeKAT/wJ5PZ3t+Hi41
	 jWa8er6HbMoan0u8P9gg3RmszdHTV5FW/LFGAPVh8B3Up3T0pu2CxGFSfp4JKO1nbIdmt
	 99Vo3ZMr2Puo5YUc8IImp170fpvhXQ1x1QEb/MXcF3WHF5WI60/ZdkplBKJcOJmZrpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214830;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g07m+En5tyKXHvZlkuF3LFhm16YInqQVA9qLCJ93waM=;
	b=14tQRps1kG4SYNfvHHU57fCzrhJWPBOg2ILYEVvFulck9c8EbZBO3Cv/rfh2lYEthHzo
	 B276aJXqusiiev6/lruop25IsjhWUzDvRw/r79xjgpQ5vc0zOfZxOPC+LI+hGU3kZPmN3
	 H7BuNWufOOLJKP732lLkyhKJ7e1tp4ZO2TXz/ri+bCu+Ag+4ZOskwYMueEkODiu8pLBHu
	 SBvvQhFiRsvFzrdtKpuBX0dncrf+yH0338XiosBfXUYY3ZpH4NtXcfnTkaoFTvAd/1dCT
	 n0zU0faxhHoVxKQdroc2GRfkYwv4v5Jii+E1rq4URkFCehPneEZCpwlqCe6fveyEIhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wsmYnezh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 530A7606A320;
	Wed, 28 Oct 2026 19:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wsmYnezh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A48BD1F01825;
	Wed, 28 Oct 2026 19:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214830;
	bh=g07m+En5tyKXHvZlkuF3LFhm16YInqQVA9qLCJ93waM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wsmYnezh0/hVdGp/8mKmys53Fs3PGL6WcCDPuMmCHaZC8Lq38cqRoXhW2WcuZiAxm
	 ea4oWPuIViy0amXPbJzaP9ZiSTybu9xmCw5+NKeMlP6VfxCc+0KtD1KE0ipHuADUXG
	 eaw22zu5K+prChl2J+wBxN42z3cs24gtxpF8CU5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Yakovlev <vovchkir@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0953/1887] spi: spi-dw-dma: fix print error log when wait finish transaction
Date: Wed, 28 Oct 2026 17:50:49 +0100
Message-ID: <20261028170521.091868416@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Yakovlev <vovchkir@gmail.com>

[ Upstream commit 3b46d61890632c8f8b117147b6923bff4b42ccb7 ]

If an error occurs, the device may not have a current message. In this
case, the system will crash.

In this case, it's better to use dev from the struct ctlr (struct spi_controller*).

Signed-off-by: Vladimir Yakovlev <vovchkir@gmail.com>
Link: https://patch.msgid.link/20260302222017.992228-2-vovchkir@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-dw-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-dw-dma.c b/drivers/spi/spi-dw-dma.c
index a795df52c5fe7..6ace5ff7675b1 100644
--- a/drivers/spi/spi-dw-dma.c
+++ b/drivers/spi/spi-dw-dma.c
@@ -231,7 +231,7 @@ static int dw_spi_dma_wait(struct dw_spi *dws, unsigned int len, u32 speed)
 					 msecs_to_jiffies(ms));
 
 	if (ms == 0) {
-		dev_err(&dws->master->cur_msg->spi->dev,
+		dev_err(&dws->master->dev,
 			"DMA transaction timed out\n");
 		return -ETIMEDOUT;
 	}
-- 
2.53.0



