Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F07F254B0A;
	Wed,  5 Mar 2025 18:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198683; cv=none; b=C9nSrtnNB3+QkGmJttrl1a5uivKuOVQdGDgOSw4vLjb4EdtsmpChHcyzyFPZ9i6b7CVe48+aPcawhDjQSU81W5wblbz1VCo9b/9KgfuWXJ8vf+XG2lr8JPvzuXiDxcR0YtlrEarbhBuiMjkkFl1bUi/aCHumm1fsgEpYBCeIj1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198683; c=relaxed/simple;
	bh=fNHI2rzWNBsCfLQ1C3kvEXeGq1XxQv6jzrbtG3dAgLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NIoETy9wPQk+NSgX3lnFvqpzaC49miCd43z9ttxoNnK+RfKwl+eRNF5LdI1x3ngOtUn56zqMlY2567H0Ky0h3tg9UYL1juL8gqC4GajGuL42VU3CcTJ6cDjnAQQjxCkKMK/UvMyGzDT22i8MhtCQKFTFxpGfSegSDkZ51/u0yPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=00aoDlxx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="00aoDlxx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA72C4CED1;
	Wed,  5 Mar 2025 18:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198683;
	bh=fNHI2rzWNBsCfLQ1C3kvEXeGq1XxQv6jzrbtG3dAgLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=00aoDlxxwavmL+CObGSoX+PHB3Lc9EMa9tgOYAhSt3Q1gGTlS8q/4ZVTCIzJtWHyf
	 KbqS+MSpqyFx303GQOEDlfoCX9xF84VGm9wenHf/cSeKrhcL6m2hOC+mSHdFwYOD6B
	 GlCA2Xq7sFJl6bUUOZkm4wxdbOm4CcWblbaFkQ08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George Moussalem <george.moussalem@outlook.com>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.13 112/157] net: phy: qcom: qca807x fix condition for DAC_DSP_BIAS_CURRENT
Date: Wed,  5 Mar 2025 18:49:08 +0100
Message-ID: <20250305174509.814834174@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: George Moussalem <george.moussalem@outlook.com>

commit 992ee3ed6e9fdd0be83a7daa5ff738e3cf86047f upstream.

While setting the DAC value, the wrong boolean value is evaluated to set
the DSP bias current. So let's correct the conditional statement and use
the right boolean value read from the DTS set in the priv.

Cc: stable@vger.kernel.org
Fixes: d1cb613efbd3 ("net: phy: qcom: add support for QCA807x PHY Family")
Signed-off-by: George Moussalem <george.moussalem@outlook.com>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250219130923.7216-1-ansuelsmth@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/qcom/qca807x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/phy/qcom/qca807x.c
+++ b/drivers/net/phy/qcom/qca807x.c
@@ -774,7 +774,7 @@ static int qca807x_config_init(struct ph
 	control_dac &= ~QCA807X_CONTROL_DAC_MASK;
 	if (!priv->dac_full_amplitude)
 		control_dac |= QCA807X_CONTROL_DAC_DSP_AMPLITUDE;
-	if (!priv->dac_full_amplitude)
+	if (!priv->dac_full_bias_current)
 		control_dac |= QCA807X_CONTROL_DAC_DSP_BIAS_CURRENT;
 	if (!priv->dac_disable_bias_current_tweak)
 		control_dac |= QCA807X_CONTROL_DAC_BIAS_CURRENT_TWEAK;


