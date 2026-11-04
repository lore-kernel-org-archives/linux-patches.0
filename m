Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829464;
	b=hUn0htZYrEQnVKDnvyOl06zcU+6HPj8D06jjm6s8kGpTaPKDcuBAbBWUEawSPCv7KK6v
	 HS6OSNGPrfg8JQs3oqy0CGDlkwkwac8rL4ZxEQc03cm3M6XPGnN+D7Wv9m/u7IKubz0Uf
	 yorV8eHhrHiHX8gGsAxi43x3D4qOBf41q7otwU7AfVf5NLU3SgNMyKQmVUozwWBdsFbyG
	 bRDWkIfAEHJiXlPs+nkb8vaiZhNpjGlEG3mOWesjShZ33n99M0YQiKZv+wPJhBoqnDGQL
	 soeAxdgvYm2R4jmCg84aG1roT6hrWEYyERxc1gmjUWKG6ZCYZwim34FtlSE1OvXBKgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829464;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+EKAOEme+brDgk9+mhkt6QTrnsu6o+MSddkpONa+5BU=;
	b=vt2Tt4IbQMKQVhCwAtZVe2IAMT87qyo6ptkYK+llODCTx/xwm8IWnrARxypxbRTDepX6
	 e9nmu5EKKDCHUziw9d5OzfUE0P6ygoQa7de0hvqtdKTpcaYqkxpmtmjuXIyQ2ABx2w79B
	 nwEujcLIQBVWjgJEMunPynl2qNQ4/yFwGGwW3OeG2CO2r7pplWjQCKMCYC1k5T2JLjaoR
	 oCp83W5gT3LschLKTnNW0kkQdGt46BmkEwurIm1Updscy8Gvm6KrHClxOZmhjF7XNbnvk
	 ASTkFT/RJLXC9G8yAGicFkFDMhuEXfCzZKkNRSGNUIw+PXCQbNw2JdN/CHiESwTXU1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iDwI6CED;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6BAB606AB0B;
	Wed,  4 Nov 2026 21:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iDwI6CED
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F9EB1F00A17;
	Wed,  4 Nov 2026 21:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829463;
	bh=+EKAOEme+brDgk9+mhkt6QTrnsu6o+MSddkpONa+5BU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iDwI6CEDZb3iJS3iFJ8Bnz9RADNa/BAaVivwmoYdR6x2sn0ujVh9FDGr6P4LTLx0d
	 Fn3cF3VB0YOkOAmKtzzB5o4Z7iJnB4pgvUao83D71nck8y0RyCyrGF0rKCTXBLaRXO
	 5Ib1+CrVgdjB2BTiW7K3w6c2QHdsI9OthFxXWks0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0134/1005] crypto: keembay - add missing MODULE_DEVICE_TABLE()
Date: Wed,  4 Nov 2026 15:57:47 -0500
Message-ID: <20261104211047.451805664@linuxfoundation.org>
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

[ Upstream commit b73b71df4cb4ca241165ad31218c82dfe489147c ]

The driver has an OF match table wired to .of_match_table, but does
not export the table with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE(of, ...) entry so module alias
information is generated for OF based module autoloading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the platform driver, and the missing module alias publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/keembay/keembay-ocs-ecc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/intel/keembay/keembay-ocs-ecc.c b/drivers/crypto/intel/keembay/keembay-ocs-ecc.c
index 59308926399d0..f31b5ae73f664 100644
--- a/drivers/crypto/intel/keembay/keembay-ocs-ecc.c
+++ b/drivers/crypto/intel/keembay/keembay-ocs-ecc.c
@@ -987,6 +987,7 @@ static const struct of_device_id kmb_ocs_ecc_of_match[] = {
 	},
 	{}
 };
+MODULE_DEVICE_TABLE(of, kmb_ocs_ecc_of_match);
 
 /* The OCS driver is a platform device. */
 static struct platform_driver kmb_ocs_ecc_driver = {
-- 
2.53.0



