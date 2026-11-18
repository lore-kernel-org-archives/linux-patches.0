Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060227;
	b=3x0Jur88Qnrk0Mj+IeYj6tai4LKU2h2iKiM6aGjFr3RlhgTCzKbTKh1eV3qqDC9ulNvX
	 8U+0j3H80s/p/lChBy0V137/7frb+zi7nVJCiOhLL08ljCv7RCwMgB4vx3eVKM3j00ZPs
	 RWWLOl3FwpK0qe8wH0ElBJ3YwcOpRAZ01z6iQYv1u+mm+1L5Bgg3v3HZIX0BewbGX1mVb
	 CPci5oap8I60geyrF3/EmD8UElpZqY2MEJ2/SjubNwcy5vjnXbRv6n4nfTKD844UrtYvu
	 Lnk3cMFnkA4GuMI9MNffvgk7gS1f2FyE7BcYjq2l/aFooAJJfkvi1ggrtiDJczbJPYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060227;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZA2K1CyO6NDSmcyyQRJP7yOdv83dSoQGDgSPshOd19c=;
	b=Vo2lTLy6pRNAJ3qVqqmj+eCIC+uwiDrMIX0Wb0Sg1+BVOm92EdKqLwZX5aqEhrvPhXRh
	 4+Gx0VKV84Fyq4XcgYAL2Kfjw+owxwswJ+atsT6Qvrb4ai7xjrADI02kq+6lRybRPYgLk
	 3UJWzppKuyNQ6Bbsds6A9RwsS3Ok+BsTQvnOyrKNJB+JdMeykGCntgTvG+FPqhGDGD7aK
	 TAmeFhkHtNNQQ3NG3VEivLDGjXAlQUKJU295VWOX3Mgg1JaTuuG0bFVe9Ht0fxew5nsxC
	 hsBa6abIugST59b9+2yi90r2F2upk0x0/3NMFPcLZddBKyajf4/T5C34JvLF8cT4Y7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nCjCJ3HM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73223606A320;
	Thu, 19 Nov 2026 03:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nCjCJ3HM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2CB51F000C4;
	Thu, 19 Nov 2026 03:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060227;
	bh=ZA2K1CyO6NDSmcyyQRJP7yOdv83dSoQGDgSPshOd19c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nCjCJ3HM7x6jhimnk7AHZLSZX7ZFMbXEgV/PMjGOMgghWUqGxRxCCrC9ADzCWEAYi
	 Tfkj0jlZfkQX9wpwkASRjj3X/Rv7mzhcB/2riaicyuYjR3DLpn7X1GYLpx1XTd5933
	 sa0vB36FJ0Cy1OrfHRm28N1WC9SctIirD7cLd2qQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1124/1848] spi: sh-msiof: propagate setup runtime-PM errors
Date: Wed, 18 Nov 2026 15:52:42 +0100
Message-ID: <20261118150006.361395319@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 715e96c05b381..2c6333f18f970 100644
--- a/drivers/spi/spi-sh-msiof.c
+++ b/drivers/spi/spi-sh-msiof.c
@@ -555,6 +555,7 @@ static int sh_msiof_spi_setup(struct spi_device *spi)
 	struct sh_msiof_spi_priv *p =
 		spi_controller_get_devdata(spi->controller);
 	u32 clr, set, tmp;
+	int ret;
 
 	if (spi->cs_gpiod || spi_controller_is_slave(p->ctlr))
 		return 0;
@@ -570,7 +571,9 @@ static int sh_msiof_spi_setup(struct spi_device *spi)
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



