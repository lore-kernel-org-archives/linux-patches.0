Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08B75208BA;
	Wed, 30 Sep 2026 17:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790334; cv=none; b=kgEkiql0GOF9+pyp93kzOxQVIthoGbSlHk3H41HWc/N1ODn2qmKKKRwY5jMllDtOASvNftwKgLywq52WhonGR/A73Pcsmj+6Zf+c0HF77oowoqNWc2vQK9x2kLmAd3FTvNbec3zOFGhuCJpGJ3HfSbGAd2Oa4aJm2jwK3ACwbjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790334; c=relaxed/simple;
	bh=gWc7Z/GSJ5whe6X5cwDmPUGq7H6dFtGC/BZmyCoUoSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JnwxglwXUxYD9PyicsfwlZvWdMh4KU6sGAtA/7AgkwoUCZFkHmCA7uSA3WXZcSpAgZdkNOWJV7X5y0SRuf0MfV3ftoSP0CVUzE8+3Q+/erTL67m9TAEHYhACgSsPsRMuk72nqtTJSpRvKB8IlAtZEVNEr3RzWh9zNs+4T/N1u6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qn2JpaTm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qn2JpaTm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3710F1F000FF;
	Wed, 30 Sep 2026 17:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790332;
	bh=doBQTwafDdsw9U6X+n2A1x2DFphrCG1hCUnoroyNDn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qn2JpaTm2Nr9Zd4aNUD3nvw4UVGWyDsfWJhw3V2VXTqIoBtBQylENAD77YF0p/t3V
	 WCxW9b/tvE9bW1G4L1nPGu0kaYmY9BTvCzl/mQygd0mmoD7Q60LtgkFIWSPGpb/qii
	 3jiEVTyplvhORo6l4jJ67MpQ2pP2Iv5B1abDI9jM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Richard Acayan <mailingradian@gmail.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 793/877] i2c: qcom-cci: Stop complaining about DT set clock rate
Date: Wed, 30 Sep 2026 17:28:24 +0200
Message-ID: <20260930152431.829629821@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

[ Upstream commit 8284750a182937bf805f703311501730f02eb40e ]

It is common practice in the downstream and upstream CCI dt to set CCI
clock rates to 19.2 MHz. It appears to be fairly common for initial code to
set the CCI clock rate to 37.5 MHz.

Applying the widely used CCI clock rates from downstream ought not to cause
warning messages in the upstream kernel where our general policy is to
usually copy downstream hardware clock rates across the range of Qualcomm
drivers.

Drop the warning it is pervasive across CAMSS users but doesn't add any
information or warrant any changes to the DT to align the DT clock rate to
the bootloader clock rate.

Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Link: https://lore.kernel.org/linux-arm-msm/20240824115900.40702-1-bryan.odonoghue@linaro.org
Signed-off-by: Richard Acayan <mailingradian@gmail.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Stable-dep-of: 7362a1553eb0 ("i2c: qcom-cci: fix device_node refcount leak in cci_probe()/cci_remove()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-qcom-cci.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/drivers/i2c/busses/i2c-qcom-cci.c
+++ b/drivers/i2c/busses/i2c-qcom-cci.c
@@ -602,14 +602,6 @@ static int cci_probe(struct platform_dev
 		}
 	}
 
-	if (cci_clk_rate != cci->data->cci_clk_rate) {
-		/* cci clock set by the bootloader or via assigned clock rate
-		 * in DT.
-		 */
-		dev_warn(dev, "Found %lu cci clk rate while %lu was expected\n",
-			 cci_clk_rate, cci->data->cci_clk_rate);
-	}
-
 	ret = cci_enable_clocks(cci);
 	if (ret < 0)
 		return ret;


