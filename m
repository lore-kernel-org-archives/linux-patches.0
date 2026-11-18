Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061302;
	b=s5tVMB99CNsHsQIrwMQLBAe0/0EFoTwMkBbglrU7OdcIbS9E18Qe0UWtag5tO6P7JNpa
	 vNQZSmVk0ObOMZAAn51TdZl+rh4NNODUpizeFlBkyYXDIs+sco5/TZLzcT5KSdOjCq9xs
	 E8f1ic+ObFABzqyh1JojZqTUpi0sCQBBgLIV70JxMjCQjQpJZCWE3Uq0Q8yJC0C2xaNUG
	 2MzS9b90OGRR5F8swLxUsVT65wHWLqH5r1oqrxoPmcbDvjls55aGqD7WY9av6IAbOkb0l
	 RfFcRA44dDjOKC4YVkqG3kxlvqsIPFrdBeO3DaHtzcRKlGYQ9IhNuZMoooecK4KOg0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061302;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TJykYcX3VzNvqKdhtmuPYxzBYCnLyPAeElY4lJ66rGw=;
	b=LD7xqX3cdZ+8zQ5gFC8fySMKFgIAsQht+bd05+2Uv9uaxJGyMw91GiIUO1efoddqS/rW
	 UGcV2KPXdrGOKTZ/Gyx6Ar6nmH07m04JDT4FcoEONnRUWgaUxS53yY8TEWtUuceS6OSgJ
	 BtCbMlG3ipLqboDI0tMbm81Cjd3qlBUy36t0jzeQXbcTcaUfnWC21r2N2w/vMFFb+EtF2
	 W2ie4cXhX6P9VcGrBixKHSqAXEi9XdrL17othufqXCEREGmu7rBCP5tVsyTPUAIYMh3dg
	 FoArFvSWzr13Nv0LngY/q7Ql7Ij5TycbYG0LiQesBED+RN27OL1n14lBDbELtX6Lh8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=udeLlGJt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEFC4606A32A;
	Thu, 19 Nov 2026 04:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=udeLlGJt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1293E1F000C4;
	Thu, 19 Nov 2026 04:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061302;
	bh=TJykYcX3VzNvqKdhtmuPYxzBYCnLyPAeElY4lJ66rGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=udeLlGJtdM6nGfXXM+mLLCYgPgDqlY9evT7dJS8PrKynthpFSnSDJF6ZrLt9ogOGE
	 /M3HTNQytlTTsPd3ozZgmPtGuiVTHvsPS+yNeJH0HQl2ptRC0MFcmVq1GsTKBoQ3mg
	 ZL+YwlCpd9YCFJnOKTUzivZMvDWsu0u1J8XoeDQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Linus Walleij <linusw@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1502/1848] dmaengine: ste_dma40: Fix logical channel bounds check
Date: Wed, 18 Nov 2026 15:59:00 +0100
Message-ID: <20261118150022.229864771@linuxfoundation.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 57938e0c2a24f9f792fe9f611391ef6b58d1aa21 ]

d40_validate_conf() checks the raw dev_type against num_log_chans,
but d40_allocate_channel() derives the lookup_log_chans index as either
2 * dev_type or 2 * dev_type + 1.

Validate the dev_type against the derived logical channel index limit so
channel allocation cannot write past lookup_log_chans.

Fixes: 26955c07dcf3 ("dmaengine: ste_dma40: Amalgamate DMA source and destination channel numbers")
Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/dmaengine/20260618051539.15E201F000E9@smtp.kernel.org/
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260927-dma40-fixes-v7-19-89f595e8851d@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 800a957820b9b..002138f12d136 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1753,15 +1753,26 @@ static int d40_validate_conf(struct d40_chan *d40c,
 {
 	int res = 0;
 	bool is_log = conf->mode == STEDMA40_MODE_LOGICAL;
+	bool invalid_dev_type = conf->dev_type < 0;
 
 	if (!conf->dir) {
 		chan_err(d40c, "Invalid direction.\n");
 		res = -EINVAL;
 	}
 
-	if ((is_log && conf->dev_type > d40c->base->num_log_chans)  ||
-	    (!is_log && conf->dev_type > d40c->base->num_phy_chans) ||
-	    (conf->dev_type < 0)) {
+	if (!invalid_dev_type && is_log) {
+		int max_dev_type;
+
+		if (conf->dir == DMA_DEV_TO_MEM)
+			max_dev_type = DIV_ROUND_UP(d40c->base->num_log_chans, 2);
+		else
+			max_dev_type = d40c->base->num_log_chans / 2;
+
+		invalid_dev_type = conf->dev_type >= max_dev_type;
+	}
+
+	if (invalid_dev_type ||
+	    (!is_log && conf->dev_type > d40c->base->num_phy_chans)) {
 		chan_err(d40c, "Invalid device type (%d)\n", conf->dev_type);
 		res = -EINVAL;
 	}
-- 
2.53.0



