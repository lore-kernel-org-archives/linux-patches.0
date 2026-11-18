Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047817;
	b=snx2/QD/wF3Y+bPE8bdD6+lSqtKXTRWhdaXhsMVdwXUHtG6qY4GegJy9fN8JB397EWN7
	 kYD05jLSlxI3RfVilzvtTnuEqcocWunAn73JHZlKFeUjGcsy0ccfXMRhpdvQjo9kOD5f0
	 wUZIqvIol6EcKrEOD0pZGP+sS40s53UeIxiCED0FztRARUfWhgInDfC/xxPiG6mKIm2Lt
	 rJmAqfqQIwXUlZOpAu4poq0WhoAR3YNucR/J+9euH5crffQFN3ZpRUNdtt4p7ALU2/n/y
	 C3LrAlSItifGOyO5J+xNyfn7tfLeSYvSO/0p0dM7sLcTHEYieuMd2cX85S2CTheo0JQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047817;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1wWPSLwetmgwl1DbYQIViAWuYGEFrYiR6wGWT25cCXk=;
	b=vwMpAr0n/54mn6NISpI0P8gwzPFipJOCbtKQETQjZtDCxFgRWOi3qXYvMsXF4wsZYK25
	 DxoWt4rD6s9+gTgd62v5zk/hxp2Q4gl3hcpJUx1bFa1oz6gahPf+KbdB/tpCa1QYgmpIM
	 2jNfoIRpvf65Xhqi5pD9pj7pj9zLDXqxn8KnBqjGXuN8A/qp65WRaRbMnh/vxePuzvSEJ
	 lLK6D+eheDQoUZ+WtyTwadNCqddCJ9viPQQ6Z1YmquxFwmfbg/yA9Xfu+mS/J46fcdKJt
	 CVwvE/yQPIRYrGdu6P38CQKNk1rOPg3hrQMUj10gguB4m9zKMHyfL0Ug321zpIY3HIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zGXmwlwK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9CE606A325;
	Thu, 19 Nov 2026 00:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zGXmwlwK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9CF31F000C4;
	Thu, 19 Nov 2026 00:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047817;
	bh=1wWPSLwetmgwl1DbYQIViAWuYGEFrYiR6wGWT25cCXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zGXmwlwKazmMrGL74fT6hvmd9y5SOcExGDorrokDlWOoQD6dMpOKe89OG/bd4rIF2
	 hL4BkozEX70WiWR//XObTw7ODdx+290WuOpnAB8rCtwu0QJWnlqtBWCFFHrOJDVWmm
	 eIhck/PoTz7A28s0NneaVj+dPBK9k1iHPLvHIAKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1733/2857] spi: sh-msiof: propagate setup runtime-PM errors
Date: Wed, 18 Nov 2026 15:46:07 +0100
Message-ID: <20261118150303.713626598@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index aaeafa4cdaec9..7722bba03e3db 100644
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



