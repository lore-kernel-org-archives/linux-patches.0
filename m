Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E083917727;
	Mon, 27 May 2024 19:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838419; cv=none; b=iysGqSg7obwtMrlOPC8UCsTHpg/7TiLN0ykgsnAuFSmd/xr3CEK9lu/0TTfPzkdkpMA8Lu90QS8E9cp1ynF2h04dIz7wLoTk5X60TGePLDm+z4vwhFp9HS+fuFX12kUTIOmQ0Fs6NaMQ34iBoG/mLo8aN8okyVTYntgyS6dVM6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838419; c=relaxed/simple;
	bh=fXEhE3WmfkqESkAj8soyoT0Uq4RC39sI3RZukWQIejI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VbTRIdk4QeDDAJ2hfFObFlEOJMawic8WHePszAmtaO4SHOwiPYYDF75RKJ+kfPC4sAnQkTB9Cq7W4AAdMjNNQqjFowGIjx/vuAYTMl4N0w/neJv8r+lDvUFaaciy7p7CLyZMnTIO0c74633baHXgpHCZfDFLaABzlOupwqVy2JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LQfKMd32; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LQfKMd32"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77543C2BBFC;
	Mon, 27 May 2024 19:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838418;
	bh=fXEhE3WmfkqESkAj8soyoT0Uq4RC39sI3RZukWQIejI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LQfKMd32B3dwZhkpCpMpoqfRaFOEJ1JMrYWJrea4cscy/w4cJw7xy2B5sdZq4Q8Ls
	 1qoIbXv3oqWsnCWbkROpC61XBaILBhAp++/pwfs32XENYPv6UVFv6Foha17soqKeKY
	 GEB+hgmhnwpcNfSUxplyckPQlf7XSJ+nF6mG30gg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 384/493] ASoC: Intel: avs: Fix ASRC module initialization
Date: Mon, 27 May 2024 20:56:26 +0200
Message-ID: <20240527185642.843495606@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 3aa16ee8d34c1..2fae84727a3bd 100644
--- a/sound/soc/intel/avs/path.c
+++ b/sound/soc/intel/avs/path.c
@@ -367,6 +367,7 @@ static int avs_asrc_create(struct avs_dev *adev, struct avs_path_module *mod)
 	struct avs_tplg_module *t = mod->template;
 	struct avs_asrc_cfg cfg;
 
+	memset(&cfg, 0, sizeof(cfg));
 	cfg.base.cpc = t->cfg_base->cpc;
 	cfg.base.ibs = t->cfg_base->ibs;
 	cfg.base.obs = t->cfg_base->obs;
-- 
2.43.0



