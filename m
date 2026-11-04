Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829398;
	b=Y4wd9JDIT+2OJxGD6TUKzZ/4XoW3jPC32IjTvzhuVck+nUyRM2xpN32u5Fya6jzmC8jY
	 ECcm9PGHHcxidC0jVuFOnwJAMUAEhuAFzuregsAwTrtQmQJuLNIRPLwZaf1z+yyOyypJ+
	 iH5HFSyQE5ED65I55CAqma3RJAc/0Wi7NPXBYtM4TeAl+m+O+2u4RNeZMS2CQh/ARYERS
	 W/1DP2J0KmX6wA7UslvJRuYZ9ZA8VwdPydHSK7s9ul71U5m+SuEnR/7fKEd3MHSfycQpG
	 lMDoWfDujo5g8ITtab2mvxZaR5AbHBIE4m9IUUCK9DRDlX577T4Y+omGWxIiilkNauw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829398;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FzGpZiN4Pkvza+R0qTGgjMgEe6ceN3IPbOKpqz3YT5U=;
	b=deocd3EdAUz4tgonQHhrOhqWJRVDDxd+HhJjQV6cY2/JoOsFBzEGsjRMd0+xC0sbH7GH
	 o8yB/YSnjydZ7h8fT0J3+ADW4qW5t/b6Etymsr89vxT9WjHx+1AMpDxgrRT6rSyUFfn+1
	 gyGWkn4z9lphVy3hUP+rUpTlb/ZG3mNKSB/lJxteQn3mUCNxS57wCuq2rL83XqRnWkqTn
	 eXMJw3svdPNkMWKXNh+xXD1dJE6Qolab9/4bvtLkIkSndLQXvySax0l2z6rhTju7rv7uq
	 5L9u5Q3gsyrNKTYSH2eZJkJRhPqLLUWpe/TV2ozCOihicgbYsqKhngkNUYWPIjiVOBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="C/QI9rVu";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E2160C014D;
	Wed,  4 Nov 2026 21:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C/QI9rVu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7FC01F00919;
	Wed,  4 Nov 2026 21:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829398;
	bh=FzGpZiN4Pkvza+R0qTGgjMgEe6ceN3IPbOKpqz3YT5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C/QI9rVumtH8vPtxPBTNZSHAz97Nf+eV1K2Hjt9hYgLNUNGsCC6n4egTVFF8lxQPW
	 VcS59B1DEVW4YcQDeXIzJLjox0MZbPoBTfqGhKjnRlPwomxiCW9q8Yw1bfdJrfBiHT
	 +7WSz1Z3rl4EImiXD963a379Ce2JZdLWYaQlMxtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0102/1005] mmc: sdhci-of-ma35d1: add missing MODULE_DEVICE_TABLE()
Date: Wed,  4 Nov 2026 15:57:15 -0500
Message-ID: <20261104211046.500127670@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 9b3732cce41d177acac731e0b8024d72f0dfde38 ]

The driver has an OF match table wired to .of_match_table, but does
not export the table with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE(of, ...) entry so module alias
information is generated for OF based module autoloading.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-of-ma35d1.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mmc/host/sdhci-of-ma35d1.c b/drivers/mmc/host/sdhci-of-ma35d1.c
index 287026422616c..73f772db04148 100644
--- a/drivers/mmc/host/sdhci-of-ma35d1.c
+++ b/drivers/mmc/host/sdhci-of-ma35d1.c
@@ -291,6 +291,7 @@ static const struct of_device_id sdhci_ma35_dt_ids[] = {
 	{ .compatible = "nuvoton,ma35d1-sdhci" },
 	{}
 };
+MODULE_DEVICE_TABLE(of, sdhci_ma35_dt_ids);
 
 static struct platform_driver sdhci_ma35_driver = {
 	.driver	= {
-- 
2.53.0



