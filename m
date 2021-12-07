Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA602C9E
	for <patches@lists.linux.dev>; Thu,  6 Jan 2022 16:48:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC2CC36AEB
	for <patches@lists.linux.dev>; Thu,  6 Jan 2022 16:48:02 +0000 (UTC)
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Thu, 6 Jan 2022 16:47:59 +0000
Resent-Message-ID: <YdcdPzzKKj0/TolH@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Tue, 07 Dec 2021 09:06:13 +0000
Received: from sin.source.kernel.org ([2604:1380:40e1:4800::1])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=k/Ws=QY=systec-electronic.com=andre.werner@kernel.org>)
	id 1muWQM-00Ask1-2X
	for broonie@sirena.co.uk; Tue, 07 Dec 2021 09:06:13 +0000
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.source.kernel.org (Postfix) with ESMTPS id F07A3CE19EC
	for <broonie@sirena.co.uk>; Tue,  7 Dec 2021 09:06:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 42F6DC341C6; Tue,  7 Dec 2021 09:06:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5C774C341C3
	for <broonie@kernel.org>; Tue,  7 Dec 2021 09:06:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 5C774C341C3
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=systec-electronic.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=systec-electronic.com
X-Virus-Scanned: amavisd-new at ox4u.de
Received: from [192.168.10.117] (unknown [212.185.67.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by mx11.pro-ite.de (Postfix) with ESMTPSA id C9B3DEB4088C;
	Tue,  7 Dec 2021 10:06:04 +0100 (CET)
References: <59372065.103064.1638543313537@ox4u.de>
To: lgirdwood@gmail.com, broonie@kernel.org, anson.huang@nxp.com,
 yibin.gong@nxp.com
Cc: linux-kernel@vger.kernel.org
From: =?UTF-8?Q?Andr=c3=a9_Werner?= <andre.werner@systec-electronic.com>
X-Forwarded-Message-Id: <59372065.103064.1638543313537@ox4u.de>
Message-ID: <c8a8b54f-3784-e473-a59b-3fa202f79f96@systec-electronic.com>
Date: Tue, 7 Dec 2021 10:05:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <59372065.103064.1638543313537@ox4u.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-SA-Exim-Connect-IP: 2604:1380:40e1:4800::1
X-SA-Exim-Mail-From: SRS0=k/Ws=QY=systec-electronic.com=andre.werner@kernel.org
Subject: [PATCH] linux: regulator: pca9450.h: Correct register masks for LDOs
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: ID7qnRxTCVKh

 From 6dda12150785665ddd1059d53aa22bf902bfe4aa Mon Sep 17 00:00:00 2001
From: Andre Werner <andre.werner@systec-electronic.com>
Date: Mon, 22 Nov 2021 15:40:17 +0100
Subject: [PATCH] linux: regulator: pca9450.h: Correct register masks for 
LDOs

Within the defines of the register masks for LDO3 and LDO4,
the most significant bit was missing. The datasheet said
the range is 4:0 bits. Thus, the output voltage cannot be
set above 1.7V for each.

Signed-off-by: Andre Werner <andre.werner@systec-electronic.com>
---
include/linux/regulator/pca9450.h | 4 ++--
1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/regulator/pca9450.h 
b/include/linux/regulator/pca9450.h
index 71902f41c919..0c3edff6bdff 100644
--- a/include/linux/regulator/pca9450.h
+++ b/include/linux/regulator/pca9450.h
@@ -196,11 +196,11 @@ enum {
/* PCA9450_REG_LDO3_VOLT bits */
#define LDO3_EN_MASK 0xC0
-#define LDO3OUT_MASK 0x0F
+#define LDO3OUT_MASK 0x1F
/* PCA9450_REG_LDO4_VOLT bits */
#define LDO4_EN_MASK 0xC0
-#define LDO4OUT_MASK 0x0F
+#define LDO4OUT_MASK 0x1F
/* PCA9450_REG_LDO5_VOLT bits */
#define LDO5L_EN_MASK 0xC0

-- 
2.31.1

