Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5777939FC0
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zhdhsnou"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09481C4E779;
	Wed, 15 Nov 2023 20:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081584;
	bh=iZOrbLkD6Xl2pgUOfLQOSl7aXnDhjEjVK5E54A3cf0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zhdhsnou24bgBVGf9Zr2xdv8ySw+Tw6z6oB+cWtpV0HmDFbVHzVroQrJJsZmZklRz
	 LudnSTGA4nutM7T0Q/3eNlyRSPoNtvOSxb/Py6OSUMtFTWDGDFwxGeRi2jGNn+t4w8
	 3Mm4f8okbleg8FSxtwsXeQF7W80Dyk2ZMqeAu8r4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dominique Martinet <dominique.martinet@atmark-techno.com>,
	Alex Fetters <Alex.Fetters@garmin.com>,
	Avri Altman <avri.altman@wdc.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 243/244] Revert "mmc: core: Capture correct oemid-bits for eMMC cards"
Date: Wed, 15 Nov 2023 15:37:15 -0500
Message-ID: <20231115203602.898891357@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115203548.387164783@linuxfoundation.org>
References: <20231115203548.387164783@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dominique Martinet <dominique.martinet@atmark-techno.com>

commit 421b605edb1ce611dee06cf6fd9a1c1f2fd85ad0 upstream.

This reverts commit 84ee19bffc9306128cd0f1c650e89767079efeff.

The commit above made quirks with an OEMID fail to be applied, as they
were checking card->cid.oemid for the full 16 bits defined in MMC_FIXUP
macros but the field would only contain the bottom 8 bits.

eMMC v5.1A might have bogus values in OEMID's higher bits so another fix
will be made, but it has been decided to revert this until that is ready.

Fixes: 84ee19bffc93 ("mmc: core: Capture correct oemid-bits for eMMC cards")
Link: https://lkml.kernel.org/r/ZToJsSLHr8RnuTHz@codewreck.org
Link: https://lkml.kernel.org/r/CAPDyKFqkKibcXnwjnhc3+W1iJBHLeqQ9BpcZrSwhW2u9K2oUtg@mail.gmail.com
Signed-off-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
Cc: stable@vger.kernel.org
Cc: Alex Fetters <Alex.Fetters@garmin.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Link: https://lore.kernel.org/r/20231103004220.1666641-1-asmadeus@codewreck.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/mmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -96,7 +96,7 @@ static int mmc_decode_cid(struct mmc_car
 	case 3: /* MMC v3.1 - v3.3 */
 	case 4: /* MMC v4 */
 		card->cid.manfid	= UNSTUFF_BITS(resp, 120, 8);
-		card->cid.oemid		= UNSTUFF_BITS(resp, 104, 8);
+		card->cid.oemid		= UNSTUFF_BITS(resp, 104, 16);
 		card->cid.prod_name[0]	= UNSTUFF_BITS(resp, 96, 8);
 		card->cid.prod_name[1]	= UNSTUFF_BITS(resp, 88, 8);
 		card->cid.prod_name[2]	= UNSTUFF_BITS(resp, 80, 8);


