Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062202;
	b=gFr87wvVM9P9TYZ22sCQ40nYXKxkAP5q4kWcN5ceHslrph86Vjul90jba6+RnIDZJbYU
	 ZSjQZQm4IeVQlG75p5qkRWSZS7GZYK6HGh++gbXsWfyGapQmckkZ3iOfmgSUGDZZQ2pl8
	 Z+bY+ccLPrNClHXyoNvmjMwCVFy+iGTtV2VXKMAxShXKGBgQ6FjZgowkFiUKhCxPRQsUb
	 pkvHneIbpp86btRP3DLgU1d+iS1COdwEGL8D5Jk6W2Tdb9DgZKDdZgKQJk/uDTxVQF8II
	 5TFFS9LXsoY8MJ3QGttV84aEg9VJgeMZJxkcdGnxLzkEqNiieCh8z3a5n28gqvAHXow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062202;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tMF7FCGlL1OX668XlZGadA+eaeyRyS4Nu+IvVj0qg5Q=;
	b=eU33vpF0CcdVWRxJEjLVxD5noDoG2PlkeX3pcGBuin94784OT69SAdmWCRpa9MryrXwZ
	 VOMcnuYh/HZKViDX9hN/qeGu6yzOhbdaUIPjKEdGGfokLGDm/cfxQaEmDHwy/iUy95R+s
	 XmygLYfdxbBDWA5CTh/ESciFnnwz60wKFu7jVb2KkkBsy6S/nK00KLSezHsTFKAY1WPqJ
	 nTDzh0l1aWkKZ6MhYEYzDkXdVtY06T46tL0qEslSS2tKfMrHgja0D58YXf6zYhQiCAE5H
	 eQhaGRN2bPnrUwgG1QWheWvo0O2omEa6xWny3Sf+VDH1lmIqO2Vg31XXYiYb9wezBTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="h+/+arj3";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF4C606A326;
	Thu, 19 Nov 2026 04:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h+/+arj3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCD8C1F000C5;
	Thu, 19 Nov 2026 04:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062202;
	bh=tMF7FCGlL1OX668XlZGadA+eaeyRyS4Nu+IvVj0qg5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h+/+arj3J27JFSHImgRMPf+zI4uPZQwB/RnSrrLX7VdRlMYwQotCzM+jMB4nk160s
	 7m0OXHkW37recI+8Zz9eLU4jQDEoZwgPDcxa1tCvtXzqF9BgCqhWtD68sby++Ml43A
	 jR0vlr5PkDGzx5PzgPBoOfji1TcjJG971ms8NVB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.10 1827/1848] dmaengine: ste_dma40: use correct print specfier for resource_size_t
Date: Wed, 18 Nov 2026 16:04:25 +0100
Message-ID: <20261118150036.150722335@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vinod Koul <vkoul@kernel.org>

commit ef1e1c41a11d37069029bc0563c2fa6915d9880b upstream.

We should use %pR for printing resource_size_t, so update that fixing
the warning:

drivers/dma/ste_dma40.c:3556:25: warning: format specifies type 'unsigned int'
but the argument has type 'resource_size_t' (aka 'unsigned long long') [-Wformat]

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 5a1a3b9c19dd ("dmaengine: ste_dma40: Get LCPA SRAM from SRAM node")
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Link: https://lore.kernel.org/r/20230517064434.141091-1-vkoul@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/ste_dma40.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3647,8 +3647,8 @@ static int __init d40_probe(struct platf
 	}
 	base->lcpa_size = resource_size(&res_lcpa);
 	base->phy_lcpa = res_lcpa.start;
-	dev_info(dev, "found LCPA SRAM at 0x%08x, size 0x%08x\n",
-		 (u32)base->phy_lcpa, base->lcpa_size);
+	dev_info(dev, "found LCPA SRAM at 0x%08x, size %pR\n",
+		 (u32)base->phy_lcpa, &base->lcpa_size);
 
 	/* We make use of ESRAM memory for this. */
 	val = readl(base->virtbase + D40_DREG_LCPA);


