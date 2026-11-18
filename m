Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050865;
	b=UDt8Sx5JQNZy7lZfFVZgtn+HijdsZtzDFXuBJzCFRC6pWCmqE9Hj8Oq2vpbhnbA49NGm
	 X8WuF8StV12LtaAs0tBW5sfOLyADctvwJSIMjlyAetRL8TVBKc6P2HoRAYLnBjZlKehyx
	 MkgHG+ZkqvTl/Wyf7srE7GN5OZs7yNarETbnZuEAyZq/dQqfCvh0C9oksy4z6kmTazVo1
	 0HV7uWEbpHfPeiPSoU9z9AscoGeuUv3uQOjzN0A4jZdZDe7YX2jLaZtyyG/BRL4tcGlMe
	 zY1aMon9kswzrYdd917GMW/TqC4y74rzHX8n8Kj0li2tfDJ7MZCdbkb6ZYTV7Q9MsDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050865;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xzJj5lezFGafAHWQTHGwxQx4xIhPshQmHQqx8ALpC0E=;
	b=E7uXSAWtcMjjKL7ea2zeVnFXZ5hur/VJN7g5KRqtRjjJ701+5Wjtg6oDmeqR+MMzMgqy
	 mwrDyWNSpWx6PXe9xseFbSRezABDMkPPlhGt5d5XXJVk9qcb7Iu34lqE4uJwpBuwb5ufG
	 OqZkd9LnKoMFbqJpH9vp3b5BcaQ2XTPngl1YZB5fJlD+ft6sEHhiYdP9IylJ/wKucq+9d
	 x4SJG1p713bLPctAWiDh3F9x8RRzsegaYU9P8PxM0mLC7iQxUPXjIcpeOCMPXp7WMlE+j
	 TsP8e0OPQSMX3FQjcc2VCRxRGJx6hnFBHdpbe+pS1QJSxB/d9UCzEpyYmi1i16/fdIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oArfNo+o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5E7606A330;
	Thu, 19 Nov 2026 01:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oArfNo+o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5ECA1F000C4;
	Thu, 19 Nov 2026 01:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050865;
	bh=xzJj5lezFGafAHWQTHGwxQx4xIhPshQmHQqx8ALpC0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oArfNo+oCMT2YcDAI5KNToiloaIq7/GJUou2OFePGsl8+czdX8B3+FlatnK1Qx/TZ
	 zQonDPxN/J0StGFVMYc19oiZkc4WDGXhtjN37cT1hZ9ZlbeTzcbrKmXLbkdzwdZY9F
	 IMaSG6GWVEz808eKFOWTcS7fKfo+hvs3Kt6ZyiWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 2845/2857] dmaengine: ste_dma40: use correct print specfier for resource_size_t
Date: Wed, 18 Nov 2026 16:04:39 +0100
Message-ID: <20261118150344.011181168@linuxfoundation.org>
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
@@ -3646,8 +3646,8 @@ static int __init d40_probe(struct platf
 	}
 	base->lcpa_size = resource_size(&res_lcpa);
 	base->phy_lcpa = res_lcpa.start;
-	dev_info(dev, "found LCPA SRAM at 0x%08x, size 0x%08x\n",
-		 (u32)base->phy_lcpa, base->lcpa_size);
+	dev_info(dev, "found LCPA SRAM at 0x%08x, size %pR\n",
+		 (u32)base->phy_lcpa, &base->lcpa_size);
 
 	/* We make use of ESRAM memory for this. */
 	val = readl(base->virtbase + D40_DREG_LCPA);


