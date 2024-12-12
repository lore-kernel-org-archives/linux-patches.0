Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9631513CA81;
	Thu, 12 Dec 2024 17:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024487; cv=none; b=cAB60OLyBNM3Ac5a7Z3QszRAKusdqNTs8r0pg7Lkfwkoa6XJ4B39dqNkahT2AYl0aO36eB6hxa1q29fcAR1Dds3ah2mnIOdI1TSiiaLFG3UJ+8UjMKq6wxV8gfncWoKQgpmt1a4zyLVR8uChNubFHogB7sNklUC9cryD3B9qeTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024487; c=relaxed/simple;
	bh=SuiL67DWljFw828X0+bRxXT2u2pQK/u3qW+7KgE14ck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wq8oG8QV/Ofxdh7Npl7+Lv92DrLC0FI2L5J6qT4Dh7xYJKsXpQ08Q3slARVmCNGrtd/IlIFR/Su9uoN+lCxq5BL529acclsdivxM385KOioK2f9bHJMvjaiNzsL8i7j8mO8gsEM77mq5kextQSFZJKBUXyMbkcbBL6E3l+Se4sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eUn37oV1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eUn37oV1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 112C0C4CED3;
	Thu, 12 Dec 2024 17:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024487;
	bh=SuiL67DWljFw828X0+bRxXT2u2pQK/u3qW+7KgE14ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eUn37oV1oho8yvD2Ig9dnvRDK9RPEdlx69+BhUAXPfu50JARaxyjD0as7UzsWyuX/
	 acn8IdTi3SM/xOTrb+TgBFrGUmW3ly74f/WCMxPVdFqvZEbFgpiJA7f5dtPh7CRLTr
	 Ruxnab0Oj7niMeYW16VuUXEunM0vPat1XnBm54CU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 311/459] ASoC: fsl_micfil: fix the naming style for mask definition
Date: Thu, 12 Dec 2024 16:00:49 +0100
Message-ID: <20241212144305.930142487@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

commit 101b096bc2549618f18bc08ae3a0e364b3c8fff1 upstream.

Remove the _SHIFT for the mask definition.

Fixes: 17f2142bae4b ("ASoC: fsl_micfil: use GENMASK to define register bit fields")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
Link: https://lore.kernel.org/r/1651736047-28809-1-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/fsl/fsl_micfil.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/sound/soc/fsl/fsl_micfil.h
+++ b/sound/soc/fsl/fsl_micfil.h
@@ -75,9 +75,9 @@
 #define MICFIL_FIFO_STAT_FIFOX_UNDER(ch)	BIT((ch) + 8)
 
 /* MICFIL HWVAD0 Control 1 Register -- REG_MICFIL_VAD0_CTRL1*/
-#define MICFIL_VAD0_CTRL1_CHSEL_SHIFT	GENMASK(26, 24)
-#define MICFIL_VAD0_CTRL1_CICOSR_SHIFT	GENMASK(19, 16)
-#define MICFIL_VAD0_CTRL1_INITT_SHIFT	GENMASK(12, 8)
+#define MICFIL_VAD0_CTRL1_CHSEL		GENMASK(26, 24)
+#define MICFIL_VAD0_CTRL1_CICOSR	GENMASK(19, 16)
+#define MICFIL_VAD0_CTRL1_INITT		GENMASK(12, 8)
 #define MICFIL_VAD0_CTRL1_ST10		BIT(4)
 #define MICFIL_VAD0_CTRL1_ERIE		BIT(3)
 #define MICFIL_VAD0_CTRL1_IE		BIT(2)
@@ -107,7 +107,7 @@
 
 /* MICFIL HWVAD0 Zero-Crossing Detector - REG_MICFIL_VAD0_ZCD */
 #define MICFIL_VAD0_ZCD_ZCDTH		GENMASK(25, 16)
-#define MICFIL_VAD0_ZCD_ZCDADJ_SHIFT	GENMASK(11, 8)
+#define MICFIL_VAD0_ZCD_ZCDADJ		GENMASK(11, 8)
 #define MICFIL_VAD0_ZCD_ZCDAND		BIT(4)
 #define MICFIL_VAD0_ZCD_ZCDAUT		BIT(2)
 #define MICFIL_VAD0_ZCD_ZCDEN		BIT(0)


