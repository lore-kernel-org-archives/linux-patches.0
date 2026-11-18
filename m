Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050868;
	b=MIoF84bu3T1wUPrk3FAEsgsSqUwpuEA/1ZBJp1OYdHdz/IxeCCp53MqKv8Hle2BRzJhq
	 S9KwrGD6mCucuKYAR46fwgObMxTqGEIRLS2NZ+l+gHFy+CkFzZw3VMQLkhtO9yaj0yScg
	 ByUyOyV17tMLpNcud5yo2ycYrFm54yvA0BVwv+Bmq/Ggb8iZatR81QeJ9m2cIvwgx//pK
	 m6m4Jok+azqTXq30VRJQcWvv2ouiXG7bQQodIMqYzJ/xGWnCQ0cMMA//WG8AMne8p8Vu0
	 MTNQPjqJ45MExZfsHNKFpX0dHhow0gIGEjSJLUm46E/GZJ9dOPBCAKYggzBxfJJbvHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050868;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Dg+qq8pAu2giaI8fbiw57zLOE/a2DF6wYYbOsk+HfDY=;
	b=Q/IHrUGAysOdZIchi6p91kTxRRwBjdSDyIaj4mh8b2ga8tqZco4ju+mT86xesvD0jzQF
	 ISibMHyAqL0jN4JCYqikCmP/4iPVeROWg7BQSaAsWscYI7D8uxu2u3iBPhJJ8Wgb7f0Mn
	 Ft0DIx4RuewJbIEzyBrCbip5Ru/xT7PcmVIMjM8mtSo5Y+y91g4NnsckAT00jUBv0LQcw
	 QX83t+CeNdh/d4OCng34oZMlhgQzOqWqaoZAkU1WjVMWoNegFbs2Yh4ki6qXdhy8Zx2/k
	 EUiVABssfKNyWkf93fllY3CIjs1ohl56HE66Xv4YKGK5ZFlyTlQJX/qUOIdmAMkdGow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w0s1PCGY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D707606A320;
	Thu, 19 Nov 2026 01:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w0s1PCGY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62DFA1F000C4;
	Thu, 19 Nov 2026 01:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050867;
	bh=Dg+qq8pAu2giaI8fbiw57zLOE/a2DF6wYYbOsk+HfDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w0s1PCGYbcpEYVpA7O7oOyJo5fv8zts96MHv5tXrH6BB7u262APH7No+jHqAgXLTW
	 Wq1jFl4/+LiL/mcwvSjugsmAj1nBVnaiHUGTb2i/Xd7SpWNddd1RsomdQJW27s1AzI
	 DWa+CKHdACZLg1A33S3hQr2xkBnehGng5Km631LU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 2846/2857] dmaengine: ste_dma40: use proper format string for resource_size_t
Date: Wed, 18 Nov 2026 16:04:40 +0100
Message-ID: <20261118150344.053727551@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

commit 41be14c71bae05c8daa3de5ae7fd7c2a7bc0d057 upstream.

A fixup for a printk format string warning causes an out-of-bounds
variable access as the %pR string expects a struct resource instead of
a plain resource_size_t.

Change both to the special %pap and %pap helpers for these types.

Fixes: 5a1a3b9c19dd ("dmaengine: ste_dma40: Get LCPA SRAM from SRAM node")
Fixes: ef1e1c41a11d ("dmaengine: ste_dma40: use correct print specfier for resource_size_t")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20230519093447.4097040-1-arnd@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/ste_dma40.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3646,8 +3646,8 @@ static int __init d40_probe(struct platf
 	}
 	base->lcpa_size = resource_size(&res_lcpa);
 	base->phy_lcpa = res_lcpa.start;
-	dev_info(dev, "found LCPA SRAM at 0x%08x, size %pR\n",
-		 (u32)base->phy_lcpa, &base->lcpa_size);
+	dev_info(dev, "found LCPA SRAM at %pad, size %pa\n",
+		 &base->phy_lcpa, &base->lcpa_size);
 
 	/* We make use of ESRAM memory for this. */
 	val = readl(base->virtbase + D40_DREG_LCPA);


