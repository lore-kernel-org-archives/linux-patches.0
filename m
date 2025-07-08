Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EBD82E5B11;
	Tue,  8 Jul 2025 16:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751991845; cv=none; b=fZ3ab0hKWPNjqzA5tKMz6PzN5QrnL2/nZVksf4sP/so2GrAIHC9vu3B+6XHXpyP+jvLdB2F9Awd0raTXL8251Tmtgo0e6CmpHqJozJZIoSUuuCs62rRUhKmQAD670xmgsxlHJUG2ySFlllteVc0nmD4ZIR9OuKrMGZ1oTalDzSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751991845; c=relaxed/simple;
	bh=+R+fFYFMmpVQk5FynUlbURJL9ALAG/XtaM+2L2FeD+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FbH/UI/1kMwPG7eC9v8COrD4m+nPTiHg+NYJx/UznugcUHUHXJuADNHRTCAROCbrxowlbB8SAnq4/YBzqq5HBUdoBORIJireDy6OkpY7uG9y8LbLVMVgLtj1edTSvdliNnO7Q6g8U2F3/X/KugFgqZyVsEeuQwc49ax7lfzWxEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xXEM58bd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xXEM58bd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 538B0C4CEED;
	Tue,  8 Jul 2025 16:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751991844;
	bh=+R+fFYFMmpVQk5FynUlbURJL9ALAG/XtaM+2L2FeD+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xXEM58bdy2bVUQovCARZ+//jXaJvMKhxfKdFp0LotUbZ2H9D0oIE9QHGI5tzonmDT
	 q/gipJRZZKqjcvjnOD/32R6MX8F9UBF5jlV+buX2werIS3s85b2EJes7IQfvDLZ4vC
	 VLqAl68UalQ7v9V4HWCBFF5OtohK2uPmVaMu4YHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Elena Popa <elena.popa@nxp.com>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.12 001/232] rtc: pcf2127: add missing semicolon after statement
Date: Tue,  8 Jul 2025 18:19:57 +0200
Message-ID: <20250708162241.468540551@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


