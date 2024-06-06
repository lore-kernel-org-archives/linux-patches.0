Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C8819AA7F;
	Thu,  6 Jun 2024 14:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683329; cv=none; b=VTjLuczDRfjMoakQVcBBv4gvZSG3muHGK80sRRGbcauWK4H9wO4Wuk24W19KKcZGkoeoxs1QuV/4bEA5Kw1AkxEt2kOXS1gXwqSrlpR6ygMmbtQ57KMas/VY28NkIWf+9Mad8iOO9Srq0laTsJDMBoZSLxwV6fpFs/flnsv2xFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683329; c=relaxed/simple;
	bh=omVtpLQIeygE6+Beodz26vUiVloQ9Kr2qD3iTXDa0sA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kfLh09+3DSmghCbpP0F+kKLE0C2EFvjkVrMPUXQjDFUt4Pq7qDjdSdsozNk8gsoURegHARvJLqakeH/ZREGenV+5V41x8WDPiEp8Vq1k0J7+iST/+ds3ugdz0jl71rOetucPq+nLEBDlsxqh3asH5p5EugDA/yxhR6F1YGG8Kzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ozPeuPkB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ozPeuPkB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F508C2BD10;
	Thu,  6 Jun 2024 14:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683329;
	bh=omVtpLQIeygE6+Beodz26vUiVloQ9Kr2qD3iTXDa0sA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ozPeuPkBr909MgVXi0VeqFiZZ+tdjQdf7lT250Cjze1gf2JFUQvh/HMLZbHpLCZXc
	 Cu7uwtA5qCRs5jKlU8oZlcDFXclHt4kJ6jfpGkeeZZRDGjgcprJc75y/7NHyx/zhO1
	 JsqehlOkLLteZRFCDRovf85cbs2mvtLQfBulDp+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 207/473] ASoC: Intel: avs: Fix ASRC module initialization
Date: Thu,  6 Jun 2024 16:02:16 +0200
Message-ID: <20240606131706.772115416@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 9d2e26f31c7cc3fa495c423af9b4902ec0dc7be3 ]

The ASRC module configuration consists of several reserved fields. Zero
them out when initializing the module to avoid sending invalid data.

Fixes: 274d79e51875 ("ASoC: Intel: avs: Configure modules according to their type")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://msgid.link/r/20240405090929.1184068-6-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/path.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/intel/avs/path.c b/sound/soc/intel/avs/path.c
index ce157a8d65520..989a7a4127cdd 100644
--- a/sound/soc/intel/avs/path.c
+++ b/sound/soc/intel/avs/path.c
@@ -308,6 +308,7 @@ static int avs_asrc_create(struct avs_dev *adev, struct avs_path_module *mod)
 	struct avs_tplg_module *t = mod->template;
 	struct avs_asrc_cfg cfg;
 
+	memset(&cfg, 0, sizeof(cfg));
 	cfg.base.cpc = t->cfg_base->cpc;
 	cfg.base.ibs = t->cfg_base->ibs;
 	cfg.base.obs = t->cfg_base->obs;
-- 
2.43.0



