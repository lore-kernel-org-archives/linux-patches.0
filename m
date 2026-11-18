Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054647;
	b=ZRO7wNs/g6wSVOifI+aU5kOFda3xIkI0Lo9kESxGHWRAJsk6aFOO9IboFWRsD7JfRQ2H
	 pALWr4CytIBwO6RQHSR9eU+JhVvK3VZziexSDJBMmw9+osBQnhCpMfUBDnTp6Kq3Jug37
	 /tZ27I03ZN/x1KCQpoPIOGR8NxliBAdkYJeMjfemrixMgpKWRrKIfF3rwUAGESrCMetqL
	 AzdmpM8JoM2OY4Dd4wiXDLAM28u4KhuWBoLmydGgkfzmAIgOUGvb0uf0H84MMWBADIbo0
	 4wYfheQo7vgET5bnRZKe93NRZfUeSDm8g6Zk9R4jIUU1aY3GCMNQF76RdrcV8+BmZcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054647;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ECtP30jGjjuybN72XUkAE4DOPj3jJXqTXZSJKTnCAwI=;
	b=4dxOwcZA+GvI0s5xSaE6FssTBP8xHEoMqHQlHT0twwl5q33kvycev3l9I/pUi0ktcj/A
	 nZQrR01pV4SsVSudVyFNuS/YB3qYSOhsEYyG54muess0AbpetErMkEtxcK6uqfy/4LHhA
	 529IF1uRnc9TnOjzNSzhyEcEd5Y3a1QI3AE1u+9K8VVOb1nVzFRjiG0WunjQ2MUzNs4EP
	 KEqFnwxgQ7BS2AWyPbOrXSurq4872oj7dx5fsu2xuppd2NeUh74jDDxvzGOymFGLKIhZ7
	 HukIXf1r0io9CgBGtwIH50beWVfTOvnYSXrrf1wNpH7GcNEnROZYrDYl36YuEhHA1vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UuVLQ+zI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 009FF606A320;
	Thu, 19 Nov 2026 02:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UuVLQ+zI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 508021F000C4;
	Thu, 19 Nov 2026 02:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054646;
	bh=ECtP30jGjjuybN72XUkAE4DOPj3jJXqTXZSJKTnCAwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UuVLQ+zIZGTlH9Wq1c2Snm5mR4yUEhniOR/zjpd5adNXIs/ho7miZP0gkuukQq5Ce
	 BBaWlWgu3WqkhHwbVTutCNEP8bcg8p6BJT5Hd9QalLn2pt+/XUq5y1EjB/4R4bOVDd
	 kIwPEF4j0e+lkc6c5brfUGNsrR3SrtmNkr0CSEmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1332/2214] spi: sh-msiof: propagate setup runtime-PM errors
Date: Wed, 18 Nov 2026 15:50:08 +0100
Message-ID: <20261118150104.683744136@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
index 2dca03b9221a3..8c9bc58689863 100644
--- a/drivers/spi/spi-sh-msiof.c
+++ b/drivers/spi/spi-sh-msiof.c
@@ -559,6 +559,7 @@ static int sh_msiof_spi_setup(struct spi_device *spi)
 	struct sh_msiof_spi_priv *p =
 		spi_controller_get_devdata(spi->controller);
 	u32 clr, set, tmp;
+	int ret;
 
 	if (spi->cs_gpiod || spi_controller_is_slave(p->ctlr))
 		return 0;
@@ -574,7 +575,9 @@ static int sh_msiof_spi_setup(struct spi_device *spi)
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



