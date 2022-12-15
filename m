Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED855692
	for <patches@lists.linux.dev>; Thu, 15 Dec 2022 18:11:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3AC6C433D2;
	Thu, 15 Dec 2022 18:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1671127886;
	bh=NvZsQhBEVa9BvcAEIzlPEstT1Xf5Bin7iI2soNcdTvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bcm9Cdcq2bLU5tCViGDQqC+puIfUT3gboozfWEKXh1CJJchLcVdHt1zCBFIhPLqR/
	 r9x777jiEsHRRprq8U+cMchaJdBhl1UQGc0ARwkvMzyp6ZdQvDsRZC9VMtvTF4208d
	 CVF+iLnCqhV9vZ4vbYOwSTzk2ntXdr1xt7YWY8ZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Schocher <hs@denx.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 12/15] can: sja1000: fix size of OCR_MODE_MASK define
Date: Thu, 15 Dec 2022 19:10:39 +0100
Message-Id: <20221215172907.525621700@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221215172906.638553794@linuxfoundation.org>
References: <20221215172906.638553794@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Heiko Schocher <hs@denx.de>

[ Upstream commit 26e8f6a75248247982458e8237b98c9fb2ffcf9d ]

bitfield mode in ocr register has only 2 bits not 3, so correct
the OCR_MODE_MASK define.

Signed-off-by: Heiko Schocher <hs@denx.de>
Link: https://lore.kernel.org/all/20221123071636.2407823-1-hs@denx.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/can/platform/sja1000.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/can/platform/sja1000.h b/include/linux/can/platform/sja1000.h
index 5755ae5a4712..6a869682c120 100644
--- a/include/linux/can/platform/sja1000.h
+++ b/include/linux/can/platform/sja1000.h
@@ -14,7 +14,7 @@
 #define OCR_MODE_TEST     0x01
 #define OCR_MODE_NORMAL   0x02
 #define OCR_MODE_CLOCK    0x03
-#define OCR_MODE_MASK     0x07
+#define OCR_MODE_MASK     0x03
 #define OCR_TX0_INVERT    0x04
 #define OCR_TX0_PULLDOWN  0x08
 #define OCR_TX0_PULLUP    0x10
-- 
2.35.1



