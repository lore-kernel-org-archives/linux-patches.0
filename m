Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057042;
	b=vtKuy6LqMPBa+Q2UYh7HDZMOi3jW/D1/a6hCXtk7lO8o0o3Ou6NglqnS9a99PU9AAyzh
	 G7s6fJW+HMtD5ytitgGo3rmw5ZKDpHEQ/rxRIKJX05ah+zRz0zayLVpwdVfSOp41Pmqoh
	 Rnx/Sy7syFyrYltYv2wr59Ey602pk8+BvRWVKFVY/+X4WkmGDaja4vRtCpOjLsVkc9cEc
	 4hga5y6htEmmA+aThZ/Rgvrn7GnJY9VmbYeR/1co8Z+GKnHwZNimICZeQS7p6F5jgJysE
	 SdqX1HWUud0hNumXKIMG2wiDKjhc5crWjE2qQcjDMRu3WbqkolrTNz/3QhkeHBJATfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057042;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CqPAokj8lC7i03rsHhxXMvTh+dbboy3hHg7b/5NSYyA=;
	b=aftbScIvC9t2kniv1VD+iAXEv8S+CXEc9aNTI45f4mmfbElwSM856FuCikufDh47HY+x
	 S89QA7vvz7r51uxa7bRa/Tvp1VkYbjTZjE1vOYZOwMwexXfj4DZd1ydoFpXpBVOqVboY4
	 c0fXum23XMZZhnEq1UNMcm8zZz+2s4DlcmXBwQT5Fyw9w+tiKuGbLf3jauDg04qYSwGUb
	 GmwzYLiatiYkEG9c/X/msP2OGbzlEJGVtEuy7iE770Ba7CV9AKbM0pdRRy/8ApEenCVnP
	 dqxc3hmIPt8MCvEhYgH2qJG8nB6eF0uea6FzSQMecqNhxPKBpTL8FmhOXaa0lPvhrZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pl5+aIXK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A425606A320;
	Thu, 19 Nov 2026 02:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pl5+aIXK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E4271F000C4;
	Thu, 19 Nov 2026 02:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057042;
	bh=CqPAokj8lC7i03rsHhxXMvTh+dbboy3hHg7b/5NSYyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pl5+aIXKbFR7k2BbvSUNraAgB3pwDzcgVX2R8+utaHBJkHNhz6ovRtXIrqgAI1yzs
	 FFmhmKWa+BdG77KtRGsIsFvxeIfMmd3usdPXUmSEAW1QUNGqWY0aZ2r/jOD9UtAyhW
	 dTify8rdOlCrxcZioBQJ1OJhOGBMNBr/4ax7LD3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 2202/2214] dmaengine: ste_dma40: use proper format string for resource_size_t
Date: Wed, 18 Nov 2026 16:04:38 +0100
Message-ID: <20261118150138.374658319@linuxfoundation.org>
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
@@ -3644,8 +3644,8 @@ static int __init d40_probe(struct platf
 	}
 	base->lcpa_size = resource_size(&res_lcpa);
 	base->phy_lcpa = res_lcpa.start;
-	dev_info(dev, "found LCPA SRAM at 0x%08x, size %pR\n",
-		 (u32)base->phy_lcpa, &base->lcpa_size);
+	dev_info(dev, "found LCPA SRAM at %pad, size %pa\n",
+		 &base->phy_lcpa, &base->lcpa_size);
 
 	/* We make use of ESRAM memory for this. */
 	val = readl(base->virtbase + D40_DREG_LCPA);


