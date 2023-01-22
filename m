Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85977E
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:10:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E740C433D2;
	Sun, 22 Jan 2023 15:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400245;
	bh=AGgRiUxW2WyNCtHhWR74Vkmi6U0/r3HGGNQR/DzksRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jLWNBg4WHX7m4vqtfv4i2BDYWm8mRNmsPxq79aMmXMe0uO5AznAV6P/pYn+oMRRin
	 cxQY8G4/3M/UKceQKS8nx6Udhbej7OzzyoJdXiqge4GrlZIea3jj5GbstNYDp2d3WW
	 v4r9IXey4DBOWgpz5RvJ228OBvSFOrtRPGWOapF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohan Kumar <mkumard@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.4 44/55] dmaengine: tegra210-adma: fix global intr clear
Date: Sun, 22 Jan 2023 16:04:31 +0100
Message-Id: <20230122150223.986755888@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150222.210885219@linuxfoundation.org>
References: <20230122150222.210885219@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mohan Kumar <mkumard@nvidia.com>

commit 9c7e355ccbb33d239360c876dbe49ad5ade65b47 upstream.

The current global interrupt clear programming register offset
was not correct. Fix the programming with right offset

Fixes: ded1f3db4cd6 ("dmaengine: tegra210-adma: prepare for supporting newer Tegra chips")
Cc: stable@vger.kernel.org
Signed-off-by: Mohan Kumar <mkumard@nvidia.com>
Link: https://lore.kernel.org/r/20230102064844.31306-1-mkumard@nvidia.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/tegra210-adma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dma/tegra210-adma.c
+++ b/drivers/dma/tegra210-adma.c
@@ -224,7 +224,7 @@ static int tegra_adma_init(struct tegra_
 	int ret;
 
 	/* Clear any interrupts */
-	tdma_write(tdma, tdma->cdata->global_int_clear, 0x1);
+	tdma_write(tdma, tdma->cdata->ch_base_offset + tdma->cdata->global_int_clear, 0x1);
 
 	/* Assert soft reset */
 	tdma_write(tdma, ADMA_GLOBAL_SOFT_RESET, 0x1);


