Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C8363939B3;
	Sat, 12 Sep 2026 18:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239130; cv=none; b=pH37Ren/u/m8F082f5cuaUAQY1IqiupLrLjREMuWSlxOZA8FIBSo1RYq8a79IECJcU4q4mRbATJ6Sm+/wTvYOUeMIrh+ucTuiTYa6j1/FBoWb3Bfev9nhqPvOYhTNYK+yjDViCHs84KT0Qz2MoqJs5FB0702Ll9LfMXtIS3KaPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239130; c=relaxed/simple;
	bh=sWEvcdGBNpwBfGkW103AEUhj+j5C6F13+StH7R2cwTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nxPqwUeIWNkIW5XBauHShDDsIWVXr99YvLJNEdgbpzTjmvVT8R0dlreUizIBQzN/TpATjxFtHlA2tMWebKYnPi56uiC7aG+VBxA56NSOpWZ/f4C+sziUMoTB08u5bH9P6NIlQzwyOUHDvx7mgXtd05a2pL8URt/uF6/re5F6RmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rYL93OsE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rYL93OsE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2CA51F000FF;
	Sat, 12 Sep 2026 18:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239129;
	bh=M9+zoO60m/XiquSZIMRU0dISr/Ku4aUS+FZu+HZ4jWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rYL93OsELbNsE+kloqYaQ6iPFMBzoXgYTN5GXlWLOdJtSm1d0nY/xBnyYepzqOj0k
	 uCsg0eJjwUcZj93XkFuxIs6LnWc/N71GDHYm93yQTaUY2MOkOmVRtzNi3syv/5+UPi
	 0kQjaTt/v+Qy5obX4PEhb12COSvzxhThpHwPUnf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 602/935] crypto: keembay - publish OF module alias for OCS AES/SM4
Date: Sat, 12 Sep 2026 09:00:32 +0200
Message-ID: <20260912065540.648169275@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5206be54eb202..b44b8ff6eed3a 100644
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



