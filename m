Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7145B1ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:31:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C26DDC433C8;
	Tue, 25 Jul 2023 11:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284707;
	bh=dZ1WMYtoGzG/ORHegjjw/aXCzTkwgnTo3F8NyxTxSHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eruFPI2aLfw3JXdSYII7dSOrzPyeajmJMFOFIP/9UFuww9jwKdATpqvtgc11UnTsk
	 zQ5UOPoRcn00S5iMNMj0Nqy764qGTiZv41GEIlTFwdSFx7ntEIp1pRxBy2yGOdfg+1
	 vAdLCKbU8liw13G5T8riYEY+YWwN3j0zxnShrhgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matus Gajdos <matuszpd@gmail.com>,
	Shengjiu Wang <shengjiu.wang@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 453/509] ASoC: fsl_sai: Disable bit clock with transmitter
Date: Tue, 25 Jul 2023 12:46:32 +0200
Message-ID: <20230725104614.475702645@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Matus Gajdos <matuszpd@gmail.com>

commit 269f399dc19f0e5c51711c3ba3bd06e0ef6ef403 upstream.

Otherwise bit clock remains running writing invalid data to the DAC.

Signed-off-by: Matus Gajdos <matuszpd@gmail.com>
Acked-by: Shengjiu Wang <shengjiu.wang@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230712124934.32232-1-matuszpd@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/fsl/fsl_sai.c |    2 +-
 sound/soc/fsl/fsl_sai.h |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -552,7 +552,7 @@ static void fsl_sai_config_disable(struc
 	u32 xcsr, count = 100;
 
 	regmap_update_bits(sai->regmap, FSL_SAI_xCSR(tx, ofs),
-			   FSL_SAI_CSR_TERE, 0);
+			   FSL_SAI_CSR_TERE | FSL_SAI_CSR_BCE, 0);
 
 	/* TERE will remain set till the end of current frame */
 	do {
--- a/sound/soc/fsl/fsl_sai.h
+++ b/sound/soc/fsl/fsl_sai.h
@@ -87,6 +87,7 @@
 /* SAI Transmit/Receive Control Register */
 #define FSL_SAI_CSR_TERE	BIT(31)
 #define FSL_SAI_CSR_SE		BIT(30)
+#define FSL_SAI_CSR_BCE		BIT(28)
 #define FSL_SAI_CSR_FR		BIT(25)
 #define FSL_SAI_CSR_SR		BIT(24)
 #define FSL_SAI_CSR_xF_SHIFT	16


