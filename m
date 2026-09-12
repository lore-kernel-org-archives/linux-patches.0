Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6382576E;
	Sat, 12 Sep 2026 07:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199879; cv=none; b=ujtWBME8tWTZ0YeGct+nSJbd8k6eFsgqkUlp7EYqlIztQjZILywmzmTw8gWL+qMdVInEjDXeN2BV4ft3xYKmdp8K7zxkaSPAglFV4ZjYAjBB8G0evTyRJ9t+ziw94fa/2nEbYgiJUrEdI2psgU+nOnaEpurj4cv2yrhDYVEA/LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199879; c=relaxed/simple;
	bh=iakJ3HFq428OFE+/bGkaCTib/V2p2EmfAy0PI4yrqhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oFuMX6TsNqeF1yIW/EyLIpBS8rAlfnSH2BpXojvk8B4S7UmMPxAa7g3ZjPpijYSASMZDyiOc91Q2xaQEEm7WUJNrQHPC2rTiU7IrAs7aL5RgtSnvlSFrVpw27pcSuGrd+MJIj/VU6nHAKMrtTkmmcbKaHCk+IAcLH/jFn+GeX3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ke/S3HCL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ke/S3HCL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C621F000FF;
	Sat, 12 Sep 2026 07:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199877;
	bh=H+9WDQALgWGco5045OgIL6Bh8EqPbEh2+/yBWYU5klE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ke/S3HCLc+J/rZqZ18tnkOUnYSs6IpxfnkMBuKwrDI1fW5PJP6eyRDzzjJiYFf2oT
	 PHRVlm7r0UVhY1OkjR67/tuCFYE7G1y0zlPlh5YnPTcaWAZ1uP92HFQk4H7nlbPAzk
	 ekWIzpPFS7C13wOVh+lx1QyRl8J7tDCpGw3YeVG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0674/1815] crypto: keembay - publish OF module alias for OCS AES/SM4
Date: Sat, 12 Sep 2026 08:40:24 +0200
Message-ID: <20260912065704.710587444@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Can Peng <pengcan@kylinos.cn>

[ Upstream commit 0a94091e29f914e4f233a208599ca4055882c01b ]

The Keem Bay OCS AES/SM4 driver has an OF match table wired to
.of_match_table, but does not export the table with MODULE_DEVICE_TABLE().

Although the match table lives in keembay-ocs-aes-core.o, that object is
part of the composite keembay-ocs-aes module.  Add the missing
MODULE_DEVICE_TABLE(of, ...) entry so modpost can generate OF module alias
information for OF based module autoloading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by the
platform driver, and the missing module alias publication.

Fixes: 885743324513 ("crypto: keembay - Add support for Keem Bay OCS AES/SM4")
Signed-off-by: Can Peng <pengcan@kylinos.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/keembay/keembay-ocs-aes-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c b/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c
index 460a943cca227..419f88af1031b 100644
--- a/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c
+++ b/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c
@@ -1561,6 +1561,7 @@ static const struct of_device_id kmb_ocs_aes_of_match[] = {
 	},
 	{}
 };
+MODULE_DEVICE_TABLE(of, kmb_ocs_aes_of_match);
 
 static void kmb_ocs_aes_remove(struct platform_device *pdev)
 {
-- 
2.53.0



