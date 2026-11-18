Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024141;
	b=xpa+IHiWg+xS0C+56XAb4AuegjfNI2X13HlaXOVR/X9bay+voauWi42txZGvi5jNJm+a
	 XjiKEBqmfs4eb+8dCFwzU5cRSNIS7Edzz9fNeW7JatG5Hl3v8RP2u4I6E0LmA/ciQmFSL
	 oANRo+JEtE5h4iFuKzwNK18kGjLhPq70p8r00sFR078fyuQ2G4S2f5ltS9SafueZwVnhr
	 NPduLbn1lg4cx0o/KnA8PVUSwAgYBxe5Tb8DnKmCzd1/18duzUcoayVf0LiQsMhLc5sgm
	 QW559u0iHSHcE9lq/AciLaIzXqyXjVFPRzx6FxFTTOxqzIz6HeizH2jeONOQWgQlnZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024141;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q6SiFXR9K1E4YKF4zFZnY7lGQakMXC0rYZr32rbHwyQ=;
	b=jIc5IQy+1aP9ZUG6WVwLqMALqT3CJ81FhXWeLChWuAYR03Uo1Q5aZl2hs9PiTaKoj1vS
	 QXj1VONw4XhajD6pp0HxvAb7uwDXPd0dBX9PwHlMms8zcSQ6GeQ7KGxacHPON/in0kjuD
	 VBhNszvXlX68w+LV1LZCZFX0qbSgA/UA0B2/EhrtWhNTSRNRVSSjB/L674jW7xEYLfF/C
	 T6j4c1F/dY58ZP0s51Qk2wbq+0idDhzyS/LWxPMl1jOw2H7vhycPoU4s7QBO0xrrrgdfM
	 GUfePwH9NQdc5akJQEv/Nxif8+4H4GLPIlUlDWSwquqmMcVmVVxEAVhS9ZMceXRYocg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W3UzkxEM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912F8606A33A;
	Wed, 18 Nov 2026 17:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W3UzkxEM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7FBF1F000C7;
	Wed, 18 Nov 2026 17:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024141;
	bh=Q6SiFXR9K1E4YKF4zFZnY7lGQakMXC0rYZr32rbHwyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W3UzkxEMX+iHRvkxrL7SFTWnGemSRRa3f1aHI6V/iZ7+wEI31aILsG1j4HvCDal56
	 lqd4daip7sTaudEcN0fW3fq9E7PqdZcxc9HXkNGPQ04BFxcVEXXgijz5pEteEbAYZi
	 ZwU4UZJomvj1SFOS4xVuT8/Iq6Pv3zDUWwdcvM8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Liu <1298662399@qq.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0621/2151] crypto: starfive - handle clock enable failures
Date: Wed, 18 Nov 2026 15:39:16 +0100
Message-ID: <20261118150144.533668105@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Jiawen Liu <1298662399@qq.com>

[ Upstream commit 5358248961ae23f7253d010ddfde1cfd2556ce22 ]

Return error from failed clock enable.

starfive_cryp_probe ignores clk_prepare_enable return for hclk/ahb, then
remove/error paths unconditionally clk_disable_unprepare both clocks.

Check consecutive clk_prepare_enable(cryp->hclk)/cryp->ahb returns in
starfive_cryp_probe.

Signed-off-by: Jiawen Liu <1298662399@qq.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: c8acdd77a623 ("crypto: starfive - propagate clock and reset errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/starfive/jh7110-cryp.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/starfive/jh7110-cryp.c b/drivers/crypto/starfive/jh7110-cryp.c
index 42114e9364f0d..a976de668abe2 100644
--- a/drivers/crypto/starfive/jh7110-cryp.c
+++ b/drivers/crypto/starfive/jh7110-cryp.c
@@ -126,8 +126,15 @@ static int starfive_cryp_probe(struct platform_device *pdev)
 		return dev_err_probe(&pdev->dev, PTR_ERR(cryp->rst),
 				     "Error getting hardware reset line\n");
 
-	clk_prepare_enable(cryp->hclk);
-	clk_prepare_enable(cryp->ahb);
+	ret = clk_prepare_enable(cryp->hclk);
+	if (ret)
+		return ret;
+
+	ret = clk_prepare_enable(cryp->ahb);
+	if (ret) {
+		clk_disable_unprepare(cryp->hclk);
+		return ret;
+	}
 	reset_control_deassert(cryp->rst);
 
 	spin_lock(&dev_list.lock);
-- 
2.53.0



