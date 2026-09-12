Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1259833E346;
	Sat, 12 Sep 2026 16:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230105; cv=none; b=WGWmxoEPJ7lofu1ii9R1wJu90zFRgPlQ+cgSIvKwaXSIKtgm9zFpz9oTDqIYNfPI2xys9/NPtLvSrMy/qTsqroswSdREbGEiPZcVDhdzifcBy/eNB99g5moNM3GJx8E4M7t5zU6xJaI0ScEYP+AtzGmWvnqiO28v1yzuYQjeDNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230105; c=relaxed/simple;
	bh=4A8LQHDwVldm8hl/jypQlAvbKDl+TkxXNy4Wxttzt6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rD5bHvBFooxo1AHrOXJ6cplXuSFA6jhl4spPwcycCpItYhguiB6M9ZCa4RizlrkGn2ks5fsszZS4zPL4yKCab1wdE5YMDubqC3+fZ8rThVgWDdbyBBc0/x6sYfUTPtGRlyFb4+t6JiWioR0nRmrsCSOK46k1j6aWbo1qsx3Y124=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=noVk5Ly7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="noVk5Ly7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3149C1F000FF;
	Sat, 12 Sep 2026 16:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230104;
	bh=cT84DMIFs0fMi7OfpRc43GKUpe4zJ6omt55ncC57Wb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=noVk5Ly76yPyiBr/XWkxdFarcGFe57EUIzIrouiafIXfh68duzH+7/I36J6wKF3DX
	 3Gpumf5BXK+TcaL09Jm81Il7Ka8pZJC05hPQ5e9Z8qBeDWJD4mqrwpozB6o0A57p56
	 Ddz4FAM/EJFlVpKgMHdvbIXouGRNmSiV8zW67MpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0725/1191] crypto: keembay - publish OF module alias for OCS AES/SM4
Date: Sat, 12 Sep 2026 08:57:33 +0200
Message-ID: <20260912065604.563861337@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/crypto/keembay/keembay-ocs-aes-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/keembay/keembay-ocs-aes-core.c b/drivers/crypto/keembay/keembay-ocs-aes-core.c
index 5549444533d47..2a96fedc8d639 100644
--- a/drivers/crypto/keembay/keembay-ocs-aes-core.c
+++ b/drivers/crypto/keembay/keembay-ocs-aes-core.c
@@ -1574,6 +1574,7 @@ static const struct of_device_id kmb_ocs_aes_of_match[] = {
 	},
 	{}
 };
+MODULE_DEVICE_TABLE(of, kmb_ocs_aes_of_match);
 
 static int kmb_ocs_aes_remove(struct platform_device *pdev)
 {
-- 
2.53.0



