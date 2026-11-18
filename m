Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062205;
	b=oqPKKFzPNHunBJJzivcwhz+UXDdp7/OV8H9iuqXRZaDdaM39g0RayCx6J5rL6vG6QKo/
	 HAcjCL0EoEgzAMa7jOUreE6O1griwS06S9EY0ziuXjdXZhK78dBG2oXFREXwZ6CbwW168
	 9kvuXPvVHrYY9z4Jr0o6A63z2hzWhSEkLdUylVBo42WEpWF20Pch7FW7o7K9Vd+8WdwdJ
	 iKDIwliUiy5xwKCYy+9oJQpc9HrND4NL5bYDOlsmD4HBGv7SUDkD8hFjGNCAFUB0ijXlV
	 GREUjwtd0fJjVaRAz1mfDzpGlwc1GHC1YjeMHFGttwvKOg2hEB/0d64BTus+qfTNLrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062205;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tz/BJuXj7iDd/HUtrGkVk3on1j+GJ+IaSwR+mQJL1rM=;
	b=wWOwnXelY5EpUiYtH0pLXER4gmCDQyW+yXQzmivKaSShgdSu9l0DEObctXPR8nK2h+Nk
	 ZZJj9vmzfVr4fXu0lsQ7p/pQVFU0j82/e4p2zReKjre1Rf+qwDz5zJkyXhyvmveeCX333
	 SHn5FOutfYCXvsgM71HlCSWOYTHe3aT0AIjTPXksUDYyWJkXvBYMD0ge+DkFKMP5+hPx7
	 Uz4K8vXp2Tyo0Jewh3PmYgGorsfs9GjsWAsV25kWzjtYocA08MMW0GN9Pziw493wt6yRs
	 s5hqPEw7cJpmyyLavnPqXdP020njgL1G+MD0ekOX3y6O7SEiGDJ9ZOUg6R2brInf/2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zNeWNsK0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 222F9606A320;
	Thu, 19 Nov 2026 04:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zNeWNsK0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B5841F000C6;
	Thu, 19 Nov 2026 04:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062205;
	bh=tz/BJuXj7iDd/HUtrGkVk3on1j+GJ+IaSwR+mQJL1rM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zNeWNsK0BFE8qWc7PvCbJQeLqDNE4oDzxIOAz4SfVkwXM5qk9l6kYVZ7e9Uuch0ZQ
	 8hrBGIJ0Sa6Lp0IluRIU5aQNWCPM8Cktf0ohHK30JzIQMPeZTlx1SLdDy2OEWTuZWW
	 P9z3HGzqDa8+X2wYTBkykK6Yxhec1j6g3e84qId0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.10 1828/1848] dmaengine: ste_dma40: use proper format string for resource_size_t
Date: Wed, 18 Nov 2026 16:04:26 +0100
Message-ID: <20261118150036.182267701@linuxfoundation.org>
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
@@ -3647,8 +3647,8 @@ static int __init d40_probe(struct platf
 	}
 	base->lcpa_size = resource_size(&res_lcpa);
 	base->phy_lcpa = res_lcpa.start;
-	dev_info(dev, "found LCPA SRAM at 0x%08x, size %pR\n",
-		 (u32)base->phy_lcpa, &base->lcpa_size);
+	dev_info(dev, "found LCPA SRAM at %pad, size %pa\n",
+		 &base->phy_lcpa, &base->lcpa_size);
 
 	/* We make use of ESRAM memory for this. */
 	val = readl(base->virtbase + D40_DREG_LCPA);


