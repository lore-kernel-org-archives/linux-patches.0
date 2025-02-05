Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA03175D5D;
	Wed,  5 Feb 2025 14:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766638; cv=none; b=SUw++h2li5fBlzCrZWWZL2UbtDOWsLALE9L8NR9ecnq4q8LPsRtWdTz3q63DZkLWHSjjc4hBl3Wx9/lw5/SEu1l6CmAL9a9tABcECv31ZHhogrjrxNCijuqr0ysJuWDpgmlvvhO41wHvElObinjRm4KZCJ3Q4h1t3c+UCjHhL4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766638; c=relaxed/simple;
	bh=oJgV2tXRkNpw4BJURoICWTPF1U7xMa5h50NHcEKtKI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lmcFm9IaR7xQvDJWqEkbMDY5rEsrSJQ2AKH7sevguztymuvrhlSx2cQ6l6aWj3qQVcmnhcwZXN6obV1YHGBp2/1CdJa19yu72+ZwfCN82l1UFVTCjcRc6TiMfhAjVzZmCI43eQXn0T9QB9ejHdODDmFrWM9vfXQId4z22DwnQEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sfi6VdWg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sfi6VdWg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4530EC4CED1;
	Wed,  5 Feb 2025 14:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766638;
	bh=oJgV2tXRkNpw4BJURoICWTPF1U7xMa5h50NHcEKtKI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sfi6VdWgoDVAGav8WUUovt5AMsir7anx9PnbcNJnyoaXRzjlFtoeKsU5iKTXwg1nR
	 MFP4DTGt56Et5RE5KNUliSJyPlnRd5cxuFyTzP5Ozo5vIAIdu0mgkfy1vpOW5sSTCL
	 3CMfTpNF336zLLQVLT7EjINSKXtKK0dISm0r4ENk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 294/623] ASoC: Intel: avs: Fix the minimum firmware version numbers
Date: Wed,  5 Feb 2025 14:40:36 +0100
Message-ID: <20250205134507.478041954@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit dbda5c35b88794f6e5efe1b5b20044b0b3a340d4 ]

For few TGL-based platforms the minor version number for AudioDSP
firmware is incorrect forcing users to utilize ignore_fw_version module
parameter.

Fixes: 5acb19ecd198 ("ASoC: Intel: avs: TGL-based platforms support")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20250109122216.3667847-3-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/core.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/sound/soc/intel/avs/core.c b/sound/soc/intel/avs/core.c
index 73d4bde9b2f78..82839d0994ee3 100644
--- a/sound/soc/intel/avs/core.c
+++ b/sound/soc/intel/avs/core.c
@@ -829,10 +829,10 @@ static const struct avs_spec jsl_desc = {
 	.hipc = &cnl_hipc_spec,
 };
 
-#define AVS_TGL_BASED_SPEC(sname)		\
+#define AVS_TGL_BASED_SPEC(sname, min)		\
 static const struct avs_spec sname##_desc = {	\
 	.name = #sname,				\
-	.min_fw_version = { 10,	29, 0, 5646 },	\
+	.min_fw_version = { 10,	min, 0, 5646 },	\
 	.dsp_ops = &avs_tgl_dsp_ops,		\
 	.core_init_mask = 1,			\
 	.attributes = AVS_PLATATTR_IMR,		\
@@ -840,11 +840,11 @@ static const struct avs_spec sname##_desc = {	\
 	.hipc = &cnl_hipc_spec,			\
 }
 
-AVS_TGL_BASED_SPEC(lkf);
-AVS_TGL_BASED_SPEC(tgl);
-AVS_TGL_BASED_SPEC(ehl);
-AVS_TGL_BASED_SPEC(adl);
-AVS_TGL_BASED_SPEC(adl_n);
+AVS_TGL_BASED_SPEC(lkf, 28);
+AVS_TGL_BASED_SPEC(tgl, 29);
+AVS_TGL_BASED_SPEC(ehl, 30);
+AVS_TGL_BASED_SPEC(adl, 35);
+AVS_TGL_BASED_SPEC(adl_n, 35);
 
 static const struct pci_device_id avs_ids[] = {
 	{ PCI_DEVICE_DATA(INTEL, HDA_SKL_LP, &skl_desc) },
-- 
2.39.5



