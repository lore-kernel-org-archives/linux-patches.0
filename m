Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022805;
	b=QKwvqCf1QB8ereJVp+vcW8HYSdq2Mqp3pBghNSQi7XlXbuhT3S0u5ikTF6XeNbn8V2Xk
	 HGnp6hZwKT3dNj6ZZ973yrgInwt7iAuNZrY/9LW2qevv65WTexm0itMr4/ebg1nKoWXVA
	 /Szyh67ENi6h33hkEVK/qBT8e5RdiX7381tM2wjbK6IywfUXxarQcdAoMcb7zPcxPmtqS
	 WNaUbixcY8UkBpIUjHV4Tmzpb0Nv7jPkIiBsEqNYuTstyf/mQHl7Hue11c5E4ZcivGgec
	 L2PeiofRLeDH/9MAnhPrbw6ztgvbGUGfsXczgqUox/ON1PZlHU7JW616YF0mRrT0Aiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022805;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uMHAoThB9GNfXTS4GK/IniLX0tanrsShQtrdnL/4ok8=;
	b=uV9oGJZbu8i+vQjsbaId/LEoiuwFlZbn+CLWRvpuhEjwL4w+WFzZ58EKUvIU7kN8tYvv
	 ca+66mRSzv8rs7QuQApzGpgcq9F15P2O3vWXpAYv6rTNUZJQ8b2Pu/8G4mN5ZkGC97EG/
	 +fJ0RnzMRcAwcewvzcMXfTxxFtdb3/bNFyLPmFTyp8flNcLo7F1gIXGnV0ss9ETduNTFu
	 bTwxT61mnIDu+1qMOK7kBXwNMEFnlrkRW2GpX5UD4k7sxxra5/hFHdCmQwJrNZxi4b7iK
	 0EGO3r3RU9TAfNKW/ia9SlZXzgxkeI0eQVnqi+25Y1q1DIg4pQxsarKzVT+Xgllnisw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ecyUNpAg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E3C606A32F;
	Wed, 18 Nov 2026 17:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ecyUNpAg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86DD81F000C6;
	Wed, 18 Nov 2026 17:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022805;
	bh=uMHAoThB9GNfXTS4GK/IniLX0tanrsShQtrdnL/4ok8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ecyUNpAgICh7qshC3ABaJCCOakaSfLIvEuzSyYQm9GLIQM8MW+j3uyEjsFm78XcON
	 YaZ1gQE7irIgVL0dvry04f0hNra9p4qUm34HCdjf6QM9sZ8blgNW3moKTD7Y1BWyHs
	 h5fuu4bAmCUr+BmsJ0920ua4tfZFh1FIQ/tVYX4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0145/2151] spi: sh-msiof: propagate setup runtime-PM errors
Date: Wed, 18 Nov 2026 15:31:20 +0100
Message-ID: <20261118150127.053435424@linuxfoundation.org>
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
index a4ae96290aa24..8880f4da9b0fd 100644
--- a/drivers/spi/spi-sh-msiof.c
+++ b/drivers/spi/spi-sh-msiof.c
@@ -453,6 +453,7 @@ static int sh_msiof_spi_setup(struct spi_device *spi)
 	struct sh_msiof_spi_priv *p =
 		spi_controller_get_devdata(spi->controller);
 	u32 clr, set, tmp;
+	int ret;
 
 	if (spi_get_csgpiod(spi, 0) || spi_controller_is_target(p->ctlr))
 		return 0;
@@ -468,7 +469,9 @@ static int sh_msiof_spi_setup(struct spi_device *spi)
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



