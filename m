Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015958;
	b=FG0P2ELG8PJzMaOI9MVXKh16AHNqBKmZpIBzX7a9aO8Q2c3BLtIbnxAsOyLU4KiyDFWz
	 ma57hUF/tnitM9U9ZjgLGIV+76BqA8PB5ic2M3lmwsh/zo9uiwAQztMd2LPKfZfwWbvng
	 x13JiaAAmAtD1rKXgDTpMa80ebjr9UOkT4JarJcnq/tic20fefqp9tTM/W0XipcK9Ky7W
	 k3ao1jw8zJxAPmXIvMkKaDZe09X1d4siUc4Zw2PmVsSHVgJMCrxMmURb+dbInJtnf/FzM
	 mMSPhvfQkV6p8G18qbz3lWJLieoC+yezLu3OsJHCfdQuoUSWeKsiopiaButqxXZy0GQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015958;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yJPNt0zx3ehF1umZepHtOGbDqpJuEtZurvn7+kFdoVU=;
	b=VUkMtpFkofuXSGCmlxse1pQe1Hp5E645bPaXojSYS7UEJDDutGTMCGYCXW0VW23o5ZJk
	 3CkL8iQcG/KdfhWiX15MB/lbeKbyiBN9Z71KOa3ODPkdXh/NiOzUyC0oeLNHQrDOYOmCt
	 5YOwwcIWw3/+aSk3ZQjxLBt7xE98WEogTjvFWR4e4VruX+9UgP4SymcbBeNGSEAx8UBng
	 tYTt/KqCvC/8YsMGcRL+tq6Cdn82mhI/u0lsNoa0qj01iWANkJ32t4yFRWxmYt4NmTHd3
	 Xts51NQxFNvmwpN636O+9kAR+jGOmK9SLBSout/mX/JbqiEhKkIQm0jMVtbxGxKUUWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qXDxGRrh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56957606A330;
	Wed, 18 Nov 2026 15:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qXDxGRrh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF6D1F000C5;
	Wed, 18 Nov 2026 15:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015958;
	bh=yJPNt0zx3ehF1umZepHtOGbDqpJuEtZurvn7+kFdoVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qXDxGRrhjWRmyikkNGkc5GeGM1xjnmbAfmQ3u3UzLy12gTTzFBmTFuCNeoOCRaW80
	 gpsVAztZr/xMhBp8Uq3xRNF2MyXvHBGRKXO+f5ENCWT0QMr0hUH1LjQg6sz3eWFfjH
	 HydjWriAPvqOEdkXZC8rIGNR/VoEFgbaePx01RRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julia Lawall <julia.lawall@inria.fr>,
	kernel test robot <lkp@intel.com>,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Frank Li <Frank.Li@nxp.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0358/2651] dmaengine: loongson: loongson2-apb-cmc: Fix signedness bug in irq handling
Date: Wed, 18 Nov 2026 15:26:38 +0100
Message-ID: <20261118150300.724656684@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Binbin Zhou <zhoubinbin@loongson.cn>

[ Upstream commit bf27ec04a888d4f1301a8da040719f2c332da681 ]

Storing that negative value into an unsigned variable makes the check
`if (lchan->irq < 0)` always false, so probe errors are not correctly
detected and propagated.

Fix this by changing the type of `irq` to `int`, which allows proper
signed comparison and error handling.

Fixes: 1c0028e725f1 ("dmaengine: loongson: New driver for the Loongson Multi-Channel DMA controller")
Reported-by: Julia Lawall <julia.lawall@inria.fr>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/r/202608152230.p20WPlS0-lkp@intel.com/
Signed-off-by: Binbin Zhou <zhoubinbin@loongson.cn>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>
Link: https://patch.msgid.link/20260818093448.3597016-1-zhoubinbin@loongson.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/loongson/loongson2-apb-cmc-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/loongson/loongson2-apb-cmc-dma.c b/drivers/dma/loongson/loongson2-apb-cmc-dma.c
index 60eb4d9616103..c6ee34aa656eb 100644
--- a/drivers/dma/loongson/loongson2-apb-cmc-dma.c
+++ b/drivers/dma/loongson/loongson2-apb-cmc-dma.c
@@ -90,7 +90,7 @@ struct loongson2_cmc_dma_chan {
 	struct dma_slave_config	dma_sconfig;
 	struct loongson2_cmc_dma_desc *desc;
 	u32 id;
-	u32 irq;
+	int irq;
 	u32 next_sg;
 	struct loongson2_cmc_dma_chan_reg chan_reg;
 };
-- 
2.53.0



