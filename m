Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045105;
	b=BnTuF77mNcAutHkj1ea3CguKO5r65ZmCo9pdlA7alfo+AR8tqRT97dEtTh4S+eoIfocj
	 1lYd5rrp0w5GR6xfWMXGkXnRKDeD1GIXKLhRv0xEGSLg/wPB65UC6+fw7gbSZaujqw7eE
	 Un9eiquIjKDHaYQnGY6Ksiv18oELpWFxznoX9haGazsQMrNIreC2CtIQldwyKNzgdqoJP
	 yEzxocleuTjPK4D21Fno0kEAGvCsV4cGJjIR7FHEYdPaqSidyeQwKHHUB1OXxJ+JDQIAH
	 Rp78vKHAFHg/jTBBOFnnxvJQa6r7dH119fEsz6OiXYA+Ar5NYxWmjvg2l2xzJ107Kcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045105;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eKciubuQVsZ9CD7paH13LyJIBZ3IRdDlHaTjRCNR1I4=;
	b=aajfHx5PbISZRnnLPGIzkE180dtoMEc+VZJ14+jWnC4yp1dlSci0USj4Y2ldK1lrhHJ7
	 TA75bZyQPJStqMN051x6x5OJJqsrcDj4FnE8KZTowWEXvlrOMhf6hQP8mPdhk65miLMHR
	 nEwXyZkAo+MUE6qqIv+crFf0iPH4zlpw9+4OP+ZNalI0LMdV5H6jSEGvTXa3MUh0hXPxn
	 qt0M77N6vpEKXSf9hL33JSqdPxFMQQk01DQvsVihoVpXEiIC2kbMmg2R9wEsVhn2X+VKZ
	 XQ7XOa+JvljhaHZSXtCZQpvPmMbMjtg6/WRKE3vaNlXl0MUyc/wb0x3XRF9wXGmtMgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xZScHeB+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60BC7606A31C;
	Wed, 18 Nov 2026 23:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xZScHeB+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2391F000C4;
	Wed, 18 Nov 2026 23:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045105;
	bh=eKciubuQVsZ9CD7paH13LyJIBZ3IRdDlHaTjRCNR1I4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xZScHeB+KTiKspeo/G588osnbgz+G3WZguhMhjahs39ojjcTdzaFTzgzwi2Kklhno
	 UKGyd9nOoR84pp+fyFjMK7z/x55/RGjjmVJAJsEwBP4ODHJF+sBoL/M84QWqnd9JLP
	 QE+5YY0ZiltOn/SQ43XGSyOYhEcs4S1rlmbY7IPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0805/2857] media: marvell: manage the MMP camera clock provider
Date: Wed, 18 Nov 2026 15:30:39 +0100
Message-ID: <20261118150230.556899884@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 9887716132d6c3c58cc67841dfb441c5a4a0d209 ]

mmpcam_probe() registers an OF clock provider before requesting the IRQ.
Neither a later probe failure nor driver removal unregisters that provider,
although the underlying clock is registered with devm_clk_register().
This leaves the provider referring to a clock whose lifetime has ended.

Use devm_of_clk_add_hw_provider() with the existing mclk_hw so the provider
is unregistered before the managed clock and camera storage are released.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: 81a409bfd551 ("media: marvell-ccic: provide a clock for the sensor")
Cc: stable@vger.kernel.org
Assisted-by: OpenAI:GPT-5.6
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/marvell/mmp-driver.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/marvell/mmp-driver.c b/drivers/media/platform/marvell/mmp-driver.c
index df16899ab1cbe..308e7b25783a4 100644
--- a/drivers/media/platform/marvell/mmp-driver.c
+++ b/drivers/media/platform/marvell/mmp-driver.c
@@ -25,6 +25,7 @@
 #include <linux/list.h>
 #include <linux/pm.h>
 #include <linux/clk.h>
+#include <linux/clk-provider.h>
 
 #include "mcam-core.h"
 
@@ -259,8 +260,8 @@ static int mmpcam_probe(struct platform_device *pdev)
 	/*
 	 * Add OF clock provider.
 	 */
-	ret = of_clk_add_provider(pdev->dev.of_node, of_clk_src_simple_get,
-								mcam->mclk);
+	ret = devm_of_clk_add_hw_provider(&pdev->dev, of_clk_hw_simple_get,
+					  &mcam->mclk_hw);
 	if (ret) {
 		dev_err(&pdev->dev, "can't add DT clock provider\n");
 		goto out;
-- 
2.53.0



