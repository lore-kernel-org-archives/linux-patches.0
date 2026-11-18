Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057607;
	b=zMP64qwJmJUq4VNFn0ypuFg5jT8HTpmTbFH+P9gEc+SjA7cYRFUcBRp8L9YpLlYFBWmm
	 EdQZ+HsXUwi1erUb2XOvNAHALZvf9tryO24eYLDgP6j/k5++VveGNJVT7ZWwrFHO8V2Ij
	 G0ANJkmrXAI9z1YQzSuj3wIusgQe+bI4EGPMpvYiQwotMxmK56Wq0ffem+vifSktcolNO
	 Z9wwXqpU7wsdaCTu6WwaMvsSqBH7hT17AWRvuV7QWUaoiIuzIQKGKrg1BUGPAIEjE82QN
	 AqduBKMDnlEmLr3QEPtaC/wMLRlpYqthjf6alXv20eN3SHkuC3OyddTI/pOBX+27IOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057607;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tvn8cCr5py8CktjQHoqAWN1jBhEdByhski++Xmnxq+k=;
	b=Zzw4Bp//IHEiCXZrur7NFL/hLJR+5MFkFqMhGXFkHt5koTtiGKEcYKTIy48oxlbQ02DQ
	 EVLJwHZ8xaJUlogtd9tMVslH8YnyGkgR3RXs6lG7XJDOx8G9gBeJDGW59U7hxqFN+uzgM
	 0xmjkdaFtA76WSlrtkEq53GbK0wtrZJAFVYeZ9Rdc80IjPOyXPdQ/YtmszJtJkHwrERB0
	 Mco/FgXlCQJAued94ipojMmmxuX4tfjB6YU5CoY05RVUA4FXWo5GF4IHnNPhvYtJyJ+yJ
	 FWNx1Llw7mkimM2l+lZse6KWbMH62DKz9xnBqjIcu+knVLL4XaBv49bkpRb95iyNsXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V6wPgZgj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8158C60A2600;
	Thu, 19 Nov 2026 03:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V6wPgZgj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D89A41F000C4;
	Thu, 19 Nov 2026 03:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057607;
	bh=tvn8cCr5py8CktjQHoqAWN1jBhEdByhski++Xmnxq+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V6wPgZgjtRrVuvCMJWAIv5PQkPQfRlkjqRo/Hvu+OtGFsIDf6Z3glndfv+AuJCX7o
	 Ve0WaKTqMSKirl1BLCWXYNHVn0t7ApcuHsZZTSBIde4yM29pTRCUmeu7siRJJv4L3c
	 Qd7+EZOazF5+3J2JFDZkVk25O4BurNUr0K9LmoFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Jun <lijun01@kylinos.cn>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0191/1848] tpm: tpm_tis_spi: fix nodef CR50 tpm_tis_spi_resume is null
Date: Wed, 18 Nov 2026 15:37:09 +0100
Message-ID: <20261118145919.724813182@linuxfoundation.org>
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

From: Li Jun <lijun01@kylinos.cn>

[ Upstream commit b4d1adc70471d0752bba674552d19971ed9fa869 ]

if no define CONFIG_TCG_TIS_SPI_CR50 in config,
the add of tpm_tis_spi_resume is null, this cause the tpm chip to
fail to resume.

Signed-off-by: Li Jun <lijun01@kylinos.cn>
Link: https://lore.kernel.org/r/20260812100914.3540149-1-lijun01@kylinos.cn
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm_tis_spi.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis_spi.h b/drivers/char/tpm/tpm_tis_spi.h
index bba73979c3687..87927f48beaf9 100644
--- a/drivers/char/tpm/tpm_tis_spi.h
+++ b/drivers/char/tpm/tpm_tis_spi.h
@@ -44,8 +44,12 @@ static inline int cr50_spi_probe(struct spi_device *spi)
 }
 #endif
 
-#if defined(CONFIG_PM_SLEEP) && defined(CONFIG_TCG_TIS_SPI_CR50)
-extern int tpm_tis_spi_resume(struct device *dev);
+#if defined(CONFIG_PM_SLEEP)
+	#if defined(CONFIG_TCG_TIS_SPI_CR50)
+		extern int tpm_tis_spi_resume(struct device *dev);
+	#else
+		#define  tpm_tis_spi_resume tpm_tis_resume
+	#endif
 #else
 #define tpm_tis_spi_resume	NULL
 #endif
-- 
2.53.0



