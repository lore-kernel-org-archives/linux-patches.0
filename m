Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015205;
	b=F71/F3Zdpy41lgvEZY2VsxaHOMk46LVBxju0RAVP7xRlFU+nEZnjWI39YfW5rXHBDvmP
	 O6Dp9/nysY1TDWO0wljHAEfb+RCEWLLuFp8dUOneji9yiTT48n86QmyHhtVd+qQFcPIaJ
	 DyyIb4B9pq4qDyf703+l47BvF4JJRKK52OgAbaw1gJBsRzZ6PihCj75ifLYgwBqLwLcMa
	 5nOusgOsvTen9FlcZvA3aQ8ovVVe2ojNdoKA4lhcQ1MPifkrmCs+mg0WIt6n+sm7I127J
	 bPRpetXTzCw/gL5GEUBHW1R482ATkK+TeBhnN6nLP5Tgymit2St+SdgW4syGyFlpm0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015205;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cz0SLKoH3HMoTWEx1FkmejFDRrahKnGpRrt4/GKqZ1U=;
	b=Lqw3e4EU5a7GiUgvsjwD2nhzduhL0ltrX6lDeF1UG0v/0/Bl8SoRSt7dA2i6zznBrryX
	 e6+9TAmummpS14RdRz/ubqwolbsIcNF/Yhk0Z/Hrgp4ni2WTvWB3E4Zx9qajAnAzUJq1O
	 2h9gIiMIjOIoxjt3/ZDUHj3XuD8couLJAwT975s3jw7y72yBfjdK4AZz+86nUg9P7baiW
	 Yfkh86YmiPxgcibopKCsmj6S0j2bhz0+xpj+7Zp4jkCRe94NGM7wo7Pazk9dkv1jv7CyV
	 bRYwD1DtntkGx6OkOOr+RERN95olT8O39gBLi5+JXDq+/niOAnkDigJtKL5uN4usfow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=STXhCVzo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7F6606A337;
	Wed, 18 Nov 2026 15:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=STXhCVzo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB16E1F000C8;
	Wed, 18 Nov 2026 15:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015204;
	bh=cz0SLKoH3HMoTWEx1FkmejFDRrahKnGpRrt4/GKqZ1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=STXhCVzoVv7Yxq/rvFpfY8QqR8RS5Co3oscK0ES6e7A4of/hMBjzoYZRIawZFpeCT
	 82yD/i9mfBgsV/qqtpunBApozTA0NHvgGkn7NAbjOBB5Y1cuM+wS/8CV3EeVJUvk6V
	 npvVX6unMSLoL9UbC0wHoP1Bq9lx2y2Ax5xA6K+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0090/2651] spi: sh-msiof: propagate setup runtime-PM errors
Date: Wed, 18 Nov 2026 15:22:10 +0100
Message-ID: <20261118150251.149375551@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 1aeab7ec0bc8d..4c425ec627767 100644
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



