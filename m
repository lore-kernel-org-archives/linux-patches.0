Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057039;
	b=pfvPcSnfZT40eHZBVz9nf6udrk+AZk/x+RTY1OqhkLjhd49q9oLHA/b+7VnZHw8pjpK/
	 3Q7eqVnBbiHVgTJ/MBW+8jsTgWtI4I122D0qShP5DeKu+K8N27suzJRdWs1eG26w6zR3A
	 /oZsRWx5+kVoQbslgIY733Wv1fF9noIbTsLL5ascr1f9jH5QNRipXEBu0Ld66kUr41c7k
	 6pbfFY3XeUvx1LOHAdqFgKXKdt7ahWiICLcYpYvovAI2aqHYqR5reJvOVwJIacuxaTh5j
	 zxX5DTcAYae0sD9uX4Fd3sJv0yfdfqZg/W+3fSAyWcHD4eaGacJCWTxpMV/TylZf1Mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057039;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BGGLAHG17FNf57n3iLiKHIjIJEtIvme3TKSyJLZKqrk=;
	b=ApPRU35kf62tD3vr8t90t6UIV1ww9cCQ5zLztE/3xSv2WBMbdckQsFk/WYNhnhpQDY1q
	 S5AZwdrTOWP3CEXXRMHwH8EAf+AlgJZ0LxBMaBOVlsmXvsjuZMgOUW/BIO5F8LkcAQQxo
	 lvKYi16wvE1WPg9NxlDAAd50jCaRpzOEpTwF47vr/6lvbDW6A3V8F4zgzq3oCd22FtJUA
	 87iQYSdM03zdk+Xars8M2Vyk3VRmRtk/h3J3MjiMK8lUzmoZre95Xw0IVZDADvdjVLyJG
	 4V7ldNtRJ2MKXOfEw1sgJwAhY8kza5TIkXhxIYJL86ZtvaM5yGz7zJmAAPmP94oV1Pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lu3NWbnj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6FB606A325;
	Thu, 19 Nov 2026 02:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lu3NWbnj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F2A01F000C4;
	Thu, 19 Nov 2026 02:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057039;
	bh=BGGLAHG17FNf57n3iLiKHIjIJEtIvme3TKSyJLZKqrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lu3NWbnjfSUCAi3SEA4s1VYePQjoM/6Wkpyt9jNMBnE/6BC0sn5obVsKdQ6I5XmPO
	 tXkCLiGV2IsNcmxY+bNZV+jlK91SOgpLt4i2bcXShApQaOGpT31bC2S6lHBMMzjKAw
	 vN21LjUaGRdpsRhzkfe19BDgGXv7ZOFgrMjBKrZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 2201/2214] dmaengine: ste_dma40: use correct print specfier for resource_size_t
Date: Wed, 18 Nov 2026 16:04:37 +0100
Message-ID: <20261118150138.337617459@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3644,8 +3644,8 @@ static int __init d40_probe(struct platf
 	}
 	base->lcpa_size = resource_size(&res_lcpa);
 	base->phy_lcpa = res_lcpa.start;
-	dev_info(dev, "found LCPA SRAM at 0x%08x, size 0x%08x\n",
-		 (u32)base->phy_lcpa, base->lcpa_size);
+	dev_info(dev, "found LCPA SRAM at 0x%08x, size %pR\n",
+		 (u32)base->phy_lcpa, &base->lcpa_size);
 
 	/* We make use of ESRAM memory for this. */
 	val = readl(base->virtbase + D40_DREG_LCPA);


