Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210817;
	b=PzofFw/S5o8GRU7sz6V8jRrWP9AbTj2zL2zps+8M5VyFf6aMPdxRxOOpD1UYrqudr81N
	 AdnHTx+i04QRLqHKflS1wqS5FOClrtFLBhPYjjoXqRf36pxPtySBJpk11TEduYc53qiOV
	 FRR8bd/oTV11MQQDNXEYm9iqaC32op2bfp8Dm0UsxQDRrOaKbVpqAtydekODqvEzUsAWv
	 QSvAGSj4v/6CSPW+QH7ljFPw4pFEPXb4vQrP5UjXlAVneR1XW1aZUkpu9H+yLbhodzuVo
	 z5OdsPft/D4PANZoOBTgoT7vqU/OExM9U2+2IVw4a7fKJOesr+zov6Ll8L5bWM3U3dA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210817;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tlYwtDPXEaAfbnmPmxiUSHM771olpcpKFFeYIZWYHqo=;
	b=fqtn0dta8ZXSj4N8JVIlag0CfNhpc7QXeuecw1zi8OoUxcZkNMDLdYLcbxxTqmFF0LZM
	 m0aa7oK+RLXsxzVLHMGFd6+KNYh9D9TXOm1FKApNSFrvEgqKfQ6lHL3I97rShucENCEtZ
	 YUl2IxnZLj5zLogdzyJr4dJJpdK9FsCmK1w4ILpf9LA9HIe4PypaOmqmL9ejjyDXn3YG3
	 2BpPwQb/y1HS3/piwRodWoGtvs7yDwcp+Bj6813CCdRzXM77Y/AALzM6DyzA6TwLwQ9Tj
	 ip1n/DICP074tXZ/k+TeweMY0kCT+s9IXGUEvrlfxqRsKpc4g4fjEkz3UwLi9N3etiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="bp6/A40D";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5227D606A322;
	Wed, 28 Oct 2026 18:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bp6/A40D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EA7E1F01828;
	Wed, 28 Oct 2026 18:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210817;
	bh=tlYwtDPXEaAfbnmPmxiUSHM771olpcpKFFeYIZWYHqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bp6/A40D0ryFMsKpnF4MmtzPcR7Wz06U9w3+eKtKOat021NCKBaN8RtAbtF+999gZ
	 a1hE9iioIXsoIebYL4OPLu01WX5lnX2+QyYpyEG3H3rCClvE0zHqrkYRqFEY6WC6Lp
	 lz/79za/YJucjYw54UteG6IsLTRKWEfPuP9jXEUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zev Weiss <zev@bewilderbeest.net>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 158/571] mtd: core: clear out unregistered devices a bit more
Date: Wed, 28 Oct 2026 17:55:05 +0100
Message-ID: <20261028170011.765573663@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Zev Weiss <zev@bewilderbeest.net>

[ Upstream commit 00596576a05145a1b5672897a82ef87af00becf4 ]

This allows an MTD device that has been unregistered to be easily
re-registered later without triggering spurious "already registered"
warnings in mtd_device_parse_register() and add_mtd_device().

Signed-off-by: Zev Weiss <zev@bewilderbeest.net>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20211015185049.3318-1-zev@bewilderbeest.net
Stable-dep-of: 12b31d1acd20 ("mtd: core: call _get_device() with the master MTD")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtdcore.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 16077e5a2df1c..cd49719ca3410 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -750,6 +750,9 @@ int del_mtd_device(struct mtd_info *mtd)
 
 		device_unregister(&mtd->dev);
 
+		/* Clear dev so mtd can be safely re-registered later if desired */
+		memset(&mtd->dev, 0, sizeof(mtd->dev));
+
 		idr_remove(&mtd_idr, mtd->index);
 		of_node_put(mtd_get_of_node(mtd));
 
@@ -1031,8 +1034,10 @@ int mtd_device_unregister(struct mtd_info *master)
 {
 	int err;
 
-	if (master->_reboot)
+	if (master->_reboot) {
 		unregister_reboot_notifier(&master->reboot_notifier);
+		memset(&master->reboot_notifier, 0, sizeof(master->reboot_notifier));
+	}
 
 	if (master->otp_user_nvmem)
 		nvmem_unregister(master->otp_user_nvmem);
-- 
2.53.0



