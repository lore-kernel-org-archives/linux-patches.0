Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4AB61D301
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:08:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28367C433C8;
	Tue, 25 Jul 2023 11:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283283;
	bh=DeTAqd2Ti1ukAPlpzY/eu7tdF0BTBQiXjwHOPtrNmCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jH2n2PO5J1ItEFGiM+GqXNgsBI2HWgohGXG3Y9pkBK/xZHR85Xpu27xpYJV4p7emK
	 ZW7bmMTQVWP3XI2FfNszfYAPWobVLvBfZp3ziPuM1Vmcl14MGtdiNJwhTsTIsFEUV6
	 pJbjMUR/3b8tz7bDeQaKE8mo+ArgGKL9U6b4DeJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matus Gajdos <matuszpd@gmail.com>,
	Shengjiu Wang <shengjiu.wang@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 20/78] ASoC: fsl_sai: Disable bit clock with transmitter
Date: Tue, 25 Jul 2023 12:46:11 +0200
Message-ID: <20230725104452.110722064@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104451.275227789@linuxfoundation.org>
References: <20230725104451.275227789@linuxfoundation.org>
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
@@ -560,7 +560,7 @@ static void fsl_sai_config_disable(struc
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


