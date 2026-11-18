Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028872;
	b=aTeUjkGPDiMar9tE+E/UA2hCOqv0tjHCHF3j/7uIw37fCLemkuDYrSgm8Rlz8tx8pnmH
	 erX0s7Kag5HkujWQKhOp7kveL+HRu9L4ZGf583uyDSAtwH+fhPhdxM4m/tiBohv7CKy5l
	 n/9gOq+py2FunOdU91uyvhvcG8FXhlrG9nL0nKKyz2UNcVXymnxjdhrRBcASlujMihIYo
	 BcEYq9JhYPBOuwqyDs0rw92hTk0UHjEymotDRB8iKZQPd3drnpU6Iq4ziGEJ8rfpRnPif
	 +AZWOdxNBeRdGNvXlzxTw5ocoinBMV8IkJrAPqq07vkAF8koCffkVxyFF1HUbQoEQVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028872;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IYpyZkSmh9oSfJGQ6FGk24BdFlftF4B5mFdLCQFuCLU=;
	b=5mVSxPnrhLhQ5KegX2X8twoaAkqRrQeC04+g6LQ3mvv9FxRI902L4ra3vvLKrGdJJwIT
	 ewY3g1w/1zhuHlwZGvP80t7T+q+UomlCjWHE5aZek3a8wtmu5uqECo/UMgdOVrUuxO0Rc
	 LBQGWXGcRvknth245KZV2wn0T3ecXqckRSKMh2t9+WjIhGwJd6RVazC2wyiHCZw7BaZNg
	 gmn5f/RWOVq5CE9yaXhdqXMNhjNCO/uTL0osLYvYRGsaLfQjWabcHZg8Bpg6sSBW+1PD3
	 JRX6+ue8qED0fj0IfiEWwH2l7hC48iOudju8mGawmLFfBYwPcCu9UNUSTOIFLsc5e6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ALXb2KL3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BFBB606A338;
	Wed, 18 Nov 2026 19:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ALXb2KL3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41871F000C7;
	Wed, 18 Nov 2026 19:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028872;
	bh=IYpyZkSmh9oSfJGQ6FGk24BdFlftF4B5mFdLCQFuCLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ALXb2KL3j2SHQhpYAVBeLASnzYGKfE7o58VCwxWiN40PynQjTTrWlZJo4UUbEkcIp
	 4Xz3lAfWEfbUVajV0arJThqSB/E5YljPptCDw/hDA38D1QumQ/SZ9sRYchijXy4C/0
	 b90ZqiTeK5dJcE38/Z+COWnk4V87JWS+CZsAmyYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0148/1756] spi: sh-msiof: propagate setup runtime-PM errors
Date: Wed, 18 Nov 2026 15:37:55 +0100
Message-ID: <20261118150014.032430776@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 152867998da9f331d6235d76aae1c7e1650708a9 ]

sh_msiof_spi_setup() ignores pm_runtime_get_sync() before programming
native chip-select registers and marking the configuration initialized.

Use the checked runtime-PM helper and return failure before register
access.

Fixes: 7ff0b53c4051 ("spi: sh-msiof: Avoid writing to registers from spi_master.setup()")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260830140133.24156-1-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-sh-msiof.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-sh-msiof.c b/drivers/spi/spi-sh-msiof.c
index a83416a1d8959..3f82dd88c1b9d 100644
--- a/drivers/spi/spi-sh-msiof.c
+++ b/drivers/spi/spi-sh-msiof.c
@@ -558,6 +558,7 @@ static int sh_msiof_spi_setup(struct spi_device *spi)
 	struct sh_msiof_spi_priv *p =
 		spi_controller_get_devdata(spi->controller);
 	u32 clr, set, tmp;
+	int ret;
 
 	if (spi_get_csgpiod(spi, 0) || spi_controller_is_target(p->ctlr))
 		return 0;
@@ -573,7 +574,9 @@ static int sh_msiof_spi_setup(struct spi_device *spi)
 		clr |= SIMDR1_SYNCAC;
 	else
 		set |= SIMDR1_SYNCAC;
-	pm_runtime_get_sync(&p->pdev->dev);
+	ret = pm_runtime_resume_and_get(&p->pdev->dev);
+	if (ret < 0)
+		return ret;
 	tmp = sh_msiof_read(p, SITMDR1) & ~clr;
 	sh_msiof_write(p, SITMDR1, tmp | set | SIMDR1_TRMD | SITMDR1_PCON);
 	tmp = sh_msiof_read(p, SIRMDR1) & ~clr;
-- 
2.53.0



