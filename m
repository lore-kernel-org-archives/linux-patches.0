Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59DFC2E5434;
	Tue,  8 Jul 2025 16:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751991848; cv=none; b=uJTaJ2SaXAea9UIm/2iz0HCt69nHs9wtpp5x3KvBYJYB2z6bRAsptGemGS21G58S8+SQ6fsBxwq+7mP3kvPMu7kQjXsUV3dl6DUYlt0po9tQaZSf4Bp6wt7wSc6pTmcm21UeF3XT9rci4QJA2JzX4CUlq1rMxMXTysfNCIvj5+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751991848; c=relaxed/simple;
	bh=Md+IK+CFgnWDzP1CmWaP+2RQSv6EnpOY5JcDfaFrVUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kd5Uf8+xAnUHJdbN3WWekZQLKGFSNzn7lqJNTXXEWpkiBrWtSi8QxMOHZMkfGv4+w2sQ4Oda2hSguI6WZwKwUlG5zGx72jlnbNBSQIskh99garQwQJcppJAt6bbXj3kOn277hd4YrMhCoJ4EosyRRF/QEuUpCw/5Lxofal/amnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u6oXVesJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u6oXVesJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CC63C4CEED;
	Tue,  8 Jul 2025 16:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751991847;
	bh=Md+IK+CFgnWDzP1CmWaP+2RQSv6EnpOY5JcDfaFrVUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u6oXVesJjjqSrqpncs282A4wplDkhGUb2HpxspuxMo7C31JkAa4L+tOoU+qOOqMeG
	 /n0NDy/THDyz8VEr8DVhNJzbVBfp79SF3bRp+WQuX3W5tJ9DYDWFUb5S+8+MW6RadQ
	 OwmsOZl3R9LghTVHsC9PAE+cSuYjHZGW+DJVxl6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Elena Popa <elena.popa@nxp.com>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.6 001/132] rtc: pcf2127: add missing semicolon after statement
Date: Tue,  8 Jul 2025 18:21:52 +0200
Message-ID: <20250708162230.809601191@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

commit 08d82d0cad51c2b1d454fe41ea1ff96ade676961 upstream.

Replace comma with semicolon at the end of the statement when setting
config.max_register.

Fixes: fd28ceb4603f ("rtc: pcf2127: add variant-specific configuration structure")
Cc: stable@vger.kernel.org
Cc: Elena Popa <elena.popa@nxp.com>
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20250529202923.1552560-1-hugo@hugovil.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-pcf2127.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/rtc/rtc-pcf2127.c
+++ b/drivers/rtc/rtc-pcf2127.c
@@ -1456,7 +1456,7 @@ static int pcf2127_spi_probe(struct spi_
 		variant = &pcf21xx_cfg[type];
 	}
 
-	config.max_register = variant->max_register,
+	config.max_register = variant->max_register;
 
 	regmap = devm_regmap_init_spi(spi, &config);
 	if (IS_ERR(regmap)) {


