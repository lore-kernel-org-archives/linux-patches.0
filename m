Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063858;
	b=5cNdxVJWiS7UOFnnvuL4WfgIujQvI5AtX2zMz/6HvyasWO+tWNDO1ivrbskpkTn3pRqB
	 1KnVTXPd5thhp7pNz9xilbecFpfMMRy7+raUb25LyeiSldWylAb1423lPofYnG1je2PVQ
	 s45BxW5cktZf1HHm0xBGlqzs/AQnABVocPimXIA5ebLjIz2PYWD5eO+28gzLx4ddLJdDK
	 XrFLL5kOKaTLz5gckFbEB+YV2Zd4DIUWW+Nzwrj8QAZaanPS17RUwHXkAs00RyfxCYhLq
	 FZ/x6BF+c5pu/uHLy3q/5IfxPe5n3ADiemOsHleM3DgATDIZaIeVCOyqDa0GVGiSIyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063858;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0FXdWbDES3ZyPYY/184tAV9Ukx+8kQ+wmHvQ3eQq/YE=;
	b=0sZ8auVguUG64YiVymTSFSQDenuDgx0wgcOdeA45auGysYHA4zdpnGSMybASccMgFtlh
	 Lk77iFGMAVtLb2A8OaTYSIlw412dK+P5QJ5a5HNaQE/IsFxr8EkW6s5dx1gceewmo8pI9
	 KavWDId4evIEYP5dh+LkQJA5HgjiJw49vQ4TIZJHaAem4UolwU/ADeRmEbY0MmXI319HR
	 258gYZ3JYH0c3eqLV297beSI9fmi7sXOt8cfQ7yMJGbGh0Y2OOYf4IDv9c8MeO7nzbkbO
	 ZP35jPsyIJYQjL/1p7sbpPXBtFoGKX6dtHMX+j3nqZD+iQOUsaiJBCqnvh3T6cn29nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VVpSftZU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC65B606A9FF;
	Sat,  7 Nov 2026 15:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VVpSftZU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23FDE1F0089F;
	Sat,  7 Nov 2026 15:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063857;
	bh=0FXdWbDES3ZyPYY/184tAV9Ukx+8kQ+wmHvQ3eQq/YE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VVpSftZUX/7R8Sxrjygu6JKIQx8YR6nmg29aXqayFByFX7ow/ka5swIFENbEgljZR
	 hRCBTlq/7UR4mVEDY0L0v+ZSptLEwh1XKWmDW+kl8Uaiq7a6QKUnUyZHiX64vDksNg
	 XH6pnP+k4yXhb+cCX4nVahqDSljOsg/xUKaapsuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Dipen Patel <dipenp@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0065/1257] hte: tegra194: Initialize slice locks before registering chip
Date: Sat,  7 Nov 2026 08:39:21 -0500
Message-ID: <20261107134941.193544346@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit 1329abe1bae416ab2cff89c3312d33f745d341c7 ]

Registering the HTE chip publishes its request callbacks to consumers.
Initialize every slice lock before registration so a concurrent HTE
request cannot use an uninitialized lock.

Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Fixes: 09574cca6ad6 ("hte: Add Tegra194 HTE kernel provider")
Cc: stable@vger.kernel.org
Acked-by: Dipen Patel <dipenp@nvidia.com>
Signed-off-by: Dipen Patel <dipenp@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hte/hte-tegra194.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/hte/hte-tegra194.c b/drivers/hte/hte-tegra194.c
index 4a7702b32b24f..1612812abe8f6 100644
--- a/drivers/hte/hte-tegra194.c
+++ b/drivers/hte/hte-tegra194.c
@@ -910,17 +910,17 @@ static int tegra_hte_probe(struct platform_device *pdev)
 
 	hte_dev->chip = gc;
 
+	for (i = 0; i < slices; i++) {
+		hte_dev->sl[i].flags = 0;
+		spin_lock_init(&hte_dev->sl[i].s_lock);
+	}
+
 	ret = devm_hte_register_chip(hte_dev->chip);
 	if (ret) {
 		dev_err(gc->dev, "hte chip register failed");
 		return ret;
 	}
 
-	for (i = 0; i < slices; i++) {
-		hte_dev->sl[i].flags = 0;
-		spin_lock_init(&hte_dev->sl[i].s_lock);
-	}
-
 	val = HTE_TECTRL_ENABLE_ENABLE |
 	      (HTE_TECTRL_INTR_ENABLE << HTE_TECTRL_INTR_SHIFT) |
 	      (hte_dev->itr_thrshld << HTE_TECTRL_OCCU_SHIFT);
-- 
2.53.0



