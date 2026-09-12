Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C587824DCF9;
	Sat, 12 Sep 2026 14:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223930; cv=none; b=kV+2iAzLJaulMtcLMec+Ct0QZHvwDVzpH9lAi6fBOHxxzC/5ujTEhk6XjiMrzN7Yi6HwSsAJtHQg0xEEwMqZk6R2voN/m14afxaD4Wrhbss3PUUVzLF0jMkodovW+eADUW2GnE05nLqVA/xvmrajEngARaBHHnLx8waSkA6N07E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223930; c=relaxed/simple;
	bh=W2tEB9EncvrDn7nvBlBsmYiwXKnGh9xO4hhtJbo5NGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Igr+eXzpnUQZ7wu0IADkTGI7jquhyKqbNmF9rLde0sAstRYyoSZ7aZmghEGCsnMRRAH8dbiCL2sNZnhoic0zbyCuuanAbRKiog4OE/lJ8WAS2AG1qJJoTVgqxv141XP/lzUiGUOIyIpPkTso5zXbB7Qf80vO1/TcpODKwTLyHo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QLCLdaDJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QLCLdaDJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E7D71F000FF;
	Sat, 12 Sep 2026 14:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223928;
	bh=Ch5rBveeVLwny9A2LhXnduXskCbHl9yFlcCBUMC0nZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QLCLdaDJGrdOH6Zxi4UqjelBr5BGIzeQY413lEMC44CkoDLJEkvHsFqjDdb0Xm9xL
	 VChTMXe+rHlRQOWbsodTeok6uUkshXTNlzqViCNidChAvwbQ79c6rO6Ac/Q0fBu6W6
	 A4R1sbd3ZYxSPF0S+oXMzUdqWgV9sR/X3cNAnTag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0888/1424] crypto: keembay - publish OF module alias for OCS AES/SM4
Date: Sat, 12 Sep 2026 08:55:20 +0200
Message-ID: <20260912065627.215398567@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 394613df96e7e..2003805f08daa 100644
--- a/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c
+++ b/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c
@@ -1561,6 +1561,7 @@ static const struct of_device_id kmb_ocs_aes_of_match[] = {
 	},
 	{}
 };
+MODULE_DEVICE_TABLE(of, kmb_ocs_aes_of_match);
 
 static int kmb_ocs_aes_remove(struct platform_device *pdev)
 {
-- 
2.53.0



