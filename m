Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591394;
	b=pclk/t5P6Umwp6U90EkSpFqky8ri2J/wRgdK07yu5L+HYLR6L4HIRqG0f3KXauZujxuS
	 pQ2D35qdLzFwQqzxc8elbTSn7NKWxvvS5OI14fkaC8DEXvlPBMLDAjTu2mg3cnnMeHwGu
	 18jWZ25ecIaJ5sJr9weT1frxFv5gq+AlFOgMpp3E6RpPEBx3tlPXTFzg8QuhyBukRjl71
	 8T6hS0OAoYiDvDum+/KZu1nJuQcFpkFQuDUQxxdfEqEOzfH3nt2AMHzwZRs+yd61uVMfA
	 WtCfXFZC6gEv64XZoMOMM6KPoI9bwJXg8Tz5C7RUdJRjjIaShbw4ARMileua9V9uAgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591394;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eracaZhux9beHw57KuLp2vup7o8GQIiuT8sHaqKqvys=;
	b=D4/amdO2GfKKzxqJSlxb7vANGKU6Ux2qIjaJaIj+CIVGH6BqgU4tFx7Q379DRWipUCU2
	 2xM+C9LGpyBV7dnSvJbA21DuSYaOMu/MWaJFMdw4ss7IpuypSp9PyY8sYZfgMUk2w+4Fz
	 lk4vLn1dFymbbz6nemOa5axzoUxt02IlF5ty/j5yZKilzh9pwelSqNQsDGtrS6Xy3cOaO
	 LxCop8SHT1szvEq43HxnR7NP0y+8H0J5HyfM/odfWUUTkQPvRTI5aCxa+hllWk42z7O3D
	 HprVqV+dHt2+I0bGIvEQFw0Pv4tZikl0ZoMu5cICVmeV0pdgO6x/co0F+zh6pTcVqIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uMLiev9c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC7B6079D40;
	Fri, 13 Nov 2026 17:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uMLiev9c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08AD81F000C4;
	Fri, 13 Nov 2026 17:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591394;
	bh=eracaZhux9beHw57KuLp2vup7o8GQIiuT8sHaqKqvys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uMLiev9c7eqlLYoIdjJzLmF9YTQeaGkzRe2yvXVgENb0c7POVW1oa7y/XtFkoeKCT
	 kGN5yOLvmg/o0QXKzZcwvW7TXH69LCo38Oer8sGJe3PJkfje1X/GnFghZFJBNksu/b
	 CMx/lDOs6v311/MYJYqPklJmMwAXVVBuR0hozFas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Zhang <18255117159@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 493/670] spi: cadence-xspi: Use FIELD_MODIFY()
Date: Fri, 13 Nov 2026 10:50:57 -0500
Message-ID: <20261113153828.640332651@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Hans Zhang <18255117159@163.com>

[ Upstream commit 6fa473f4c5dcc20db9799f90da48b977730e05f1 ]

Use FIELD_MODIFY() to remove open-coded bit manipulation.
No functional change intended.

Signed-off-by: Hans Zhang <18255117159@163.com>
Link: https://patch.msgid.link/20260430155456.36998-4-18255117159@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: ea9854a169e9 ("spi: cadence-xspi: reject SDMA transfers larger than the requested length")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence-xspi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/spi/spi-cadence-xspi.c b/drivers/spi/spi-cadence-xspi.c
index b6b42daae1bce..90c6d9fa4dbb9 100644
--- a/drivers/spi/spi-cadence-xspi.c
+++ b/drivers/spi/spi-cadence-xspi.c
@@ -453,8 +453,7 @@ static bool cdns_mrvl_xspi_setup_clock(struct cdns_xspi_dev *cdns_xspi,
 		writel(clk_reg,
 		       cdns_xspi->auxbase + MRVL_XSPI_CLK_CTRL_AUX_REG);
 		clk_reg = FIELD_PREP(MRVL_XSPI_CLK_DIV, i);
-		clk_reg &= ~MRVL_XSPI_CLK_DIV;
-		clk_reg |= FIELD_PREP(MRVL_XSPI_CLK_DIV, i);
+		FIELD_MODIFY(MRVL_XSPI_CLK_DIV, &clk_reg, i);
 		clk_reg |= MRVL_XSPI_CLK_ENABLE;
 		clk_reg |= MRVL_XSPI_IRQ_ENABLE;
 		update_clk = true;
-- 
2.53.0



