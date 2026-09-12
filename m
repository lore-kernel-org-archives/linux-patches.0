Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CDA0418A43;
	Sat, 12 Sep 2026 08:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202625; cv=none; b=gQqcD7hEI+bCZAW8snr1fvenZ3B478cj+M+k105U/0mkDK6Czm2HhPGgsK6mZ+mIlXTS9EBiHAgylET2tiSqqwZPooWP2JMjxQ9LEPp552CgnnfW3A1yrAtRnhJz3d+OTo8fmxFqjCTi5tXZI15osRRHdvZtRDTIgWTRiFC265M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202625; c=relaxed/simple;
	bh=qaro2K0Tm1Qj3xdpfHt/Js+J6iT7OX6lmoSFAKGiKsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PcNqVz1HKsK6LanalRH1sNwINevfPaY4Ecyz5w35fnWK5rBfXUYKjKce//eDDFK6RPpY+j8m2RAm46xHvM+WQCQ8d0wwWnKU8aJ1zGXAbNRKKc/0xww/6bA39iGIyhlAui9slU8EKc6E6UB2KdaIybrpike5LNy6kdQ8CYDoBT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gemziURB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gemziURB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA3901F000FF;
	Sat, 12 Sep 2026 08:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202623;
	bh=APwuiNBTemlraNHkR0/4nnd5zxJDl6Tznw5kQL1gyLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gemziURBhQyrOzfKV+8SL4R28Nxj+PRzjll3bokjNXNmHYYVtsGod7SXnm0ZB9BIr
	 YtWtGNn4JTB/gVMRoCaAjCiOOttxTPdoaYoAT2j4UV1r2p1Q2M88VdyODvnnD7D4KM
	 0q29JUjnDtjp6qhDual9POvsuV/W4DdWUH21bc1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1242/1815] pinctrl: airoha: an7583: fix spi group pins
Date: Sat, 12 Sep 2026 08:49:52 +0200
Message-ID: <20260912065718.170848882@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>

[ Upstream commit ccc41d25590645096bdbf420b43e7c22627b3f59 ]

pcm pins were used insted of spi pins. This patch fixes an issue.

Thanks to Daniel Schwierzeck for noticing it.

Fixes: 3ffeb17a9a27 ("pinctrl: airoha: add support for Airoha AN7583 PINs")
Signed-off-by: Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/airoha/pinctrl-airoha.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/airoha/pinctrl-airoha.c b/drivers/pinctrl/airoha/pinctrl-airoha.c
index ee2bd0ee8c40f..4900df81a5e75 100644
--- a/drivers/pinctrl/airoha/pinctrl-airoha.c
+++ b/drivers/pinctrl/airoha/pinctrl-airoha.c
@@ -738,7 +738,7 @@ static const int an7583_jtag_udi_pins[] = { 23, 24, 22, 25, 26 };
 static const int an7583_jtag_dfd_pins[] = { 23, 24, 22, 25, 26 };
 static const int an7583_pcm1_pins[] = { 10, 11, 12, 13, 14 };
 static const int an7583_pcm2_pins[] = { 28, 29, 30, 31, 24 };
-static const int an7583_spi_pins[] = { 28, 29, 30, 31 };
+static const int an7583_spi_pins[] = { 45, 46, 47, 48 };
 static const int an7583_spi_quad_pins[] = { 25, 26 };
 static const int an7583_spi_cs1_pins[] = { 27 };
 static const int an7583_pcm_spi_pins[] = { 28, 29, 30, 31, 10, 11, 12, 13 };
-- 
2.53.0



