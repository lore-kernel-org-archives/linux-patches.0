Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060699;
	b=owMGLUMd7iF8uKFUgwXIQkhewOCof6hIOWstDw7Yn6ngDxBStuxhSYVycGmCyv6GuJI8
	 YE7ZnhfLp/oSbQ28DcRMAeSKMwf9/hknAFeP6Scgyn/FFiTPWZ0tWK+2FMKxxoRykXojW
	 XEvegfDb4mecOB3WG/6NjXvDjbsAcLwpRQC6BDSqv5banqKg/cMY50H+ZIasBRkmfkBBL
	 8M04BcMrNj+Q35rSXpS0++nTpHs5/0B/XQcJBpKi1bA4Q5Hd01w1nCChyC650opmQtPuW
	 m1Qb466Pv22zDSORTbjT8i2twgRZTEhLmIisJtzbowcH2RdWYbDw7YjrNUKUNCrReqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060699;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U0cQ+XPJwKxScwMOAlxIwRXoLO82k1Ex3h+9Q2smAP4=;
	b=2HYZzb/PkBETkmJKkW/5LlORpH8eLZS/oAO4Gicg6qaUX3GsuCtHMDhf7NZ2ht5XNvIp
	 07mKGU+CWKufBOvskqQN6CovJUOAv+KXCjDpdHXLjiYy67OKssClLpT3xK0dorqkdGUE9
	 FA4Wqwp3tmcrjIuuAHbYd9rHp9/0vKqVfcmMgmMf1a0yMkoJLHwM0vfVnGBr0OYsnpLGy
	 5bvKIRaKIhkU/LQ3LkmQ7ZNUiv6icDrJJxS7UKDCr/g/fhK+KZz1wQxVlstMBhhvJpbSh
	 9HbsUtjWfJQtOfFYWYXB/W9WnRU5wunJBCUiP2Gl49wSKPZPwtNQj6WeGh5dHA372vQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gzxf0ptV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA92606A326;
	Sat,  7 Nov 2026 14:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gzxf0ptV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14E901F008A1;
	Sat,  7 Nov 2026 14:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060698;
	bh=U0cQ+XPJwKxScwMOAlxIwRXoLO82k1Ex3h+9Q2smAP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gzxf0ptVNW8uJLcEJIiMI9kpWnxdCn2dhqbh5xrmRD3/1xG8G2sCdqJmRHbIFG4jV
	 idgFcwPEvsxQOb7w69yxbNLnbjcfBq/+TjpNqvNugFJ+7FG7eeqWKxrA+xRfAkm3ZN
	 fpe7J33oJsUbAKziJacCl+rBUE5kbceoY0l8A8Bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0087/1536] mmc: sdhci-of-ma35d1: add missing MODULE_DEVICE_TABLE()
Date: Sat,  7 Nov 2026 08:35:03 -0500
Message-ID: <20261107135000.115593048@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

[ Upstream commit 9b3732cce41d177acac731e0b8024d72f0dfde38 ]

The driver has an OF match table wired to .of_match_table, but does
not export the table with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE(of, ...) entry so module alias
information is generated for OF based module autoloading.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-of-ma35d1.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mmc/host/sdhci-of-ma35d1.c b/drivers/mmc/host/sdhci-of-ma35d1.c
index b84c2927bd4ad..c21a49a987c2b 100644
--- a/drivers/mmc/host/sdhci-of-ma35d1.c
+++ b/drivers/mmc/host/sdhci-of-ma35d1.c
@@ -298,6 +298,7 @@ static const struct of_device_id sdhci_ma35_dt_ids[] = {
 	{ .compatible = "nuvoton,ma35d1-sdhci" },
 	{}
 };
+MODULE_DEVICE_TABLE(of, sdhci_ma35_dt_ids);
 
 static struct platform_driver sdhci_ma35_driver = {
 	.driver	= {
-- 
2.53.0



