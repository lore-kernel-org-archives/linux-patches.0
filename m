Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C268F183CA9;
	Sun,  1 Sep 2024 16:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208067; cv=none; b=gPKw7FEKdMxJkEN3JGivTPzXZPiEsH/AF7dGR2pXVF1N2ZPGfLi9luEQ9RtHAnnH/q2SsQP/+lwfgkAmbokfF+BsyXvJGtEmfpK75PV5ntk/rf60ERKd/XQ6+hANzlicNogm3HwtsDanq9YP63eMgXmK/MaTcngFISoNnAlz1NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208067; c=relaxed/simple;
	bh=wCnS1X5gRXx34Zt7iGLVCEboP469l4EhSuBFs8Rd1fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ea8enqI7vp/Way5XIaTwZe0O0ezBzwwZqx/wugoaEa2hLOBhl7Ne3xC4SAjndB6K1H9UXU/ePM0VmOcsdV8dV7dvMFcq636HkKEnH2gbfj+Srp12CShIXyAUfQBKXzHqBARoEZ19vyi115+pNvln1jojEC5/KmfVjXZzGo8ZgmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pc7l/slC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pc7l/slC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C60BC4CEC3;
	Sun,  1 Sep 2024 16:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208067;
	bh=wCnS1X5gRXx34Zt7iGLVCEboP469l4EhSuBFs8Rd1fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pc7l/slC9rQ2J3N5cvTuqVjx/7tY0HcS/t1HvR1KyJMCLc8/VC8hbFPW2g6NlgyRd
	 9MQHZcY38TIP4R7E9DKbrIdarXs4kyhsx9Pqk/xSeeDFGyhYkbpYGW0bzienLoEyQY
	 2ry+P2Ofr+TvIinUvW1W4FGazYRhVJKnvWAeGmt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuntao Liu <liuyuntao12@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 32/93] ASoC: amd: acp: fix module autoloading
Date: Sun,  1 Sep 2024 18:16:19 +0200
Message-ID: <20240901160808.569485193@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuntao Liu <liuyuntao12@huawei.com>

[ Upstream commit 164199615ae230ace4519141285f06766d6d8036 ]

Add MODULE_DEVICE_TABLE(), so modules could be properly autoloaded
based on the alias from platform_device_id table.

Fixes: 9d8a7be88b336 ("ASoC: amd: acp: Add legacy sound card support for Chrome audio")
Signed-off-by: Yuntao Liu <liuyuntao12@huawei.com>
Link: https://patch.msgid.link/20240815084923.756476-1-liuyuntao12@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-legacy-mach.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/amd/acp/acp-legacy-mach.c b/sound/soc/amd/acp/acp-legacy-mach.c
index 6d57d17ddfd77..6e820c2edd1d8 100644
--- a/sound/soc/amd/acp/acp-legacy-mach.c
+++ b/sound/soc/amd/acp/acp-legacy-mach.c
@@ -137,6 +137,8 @@ static const struct platform_device_id board_ids[] = {
 	},
 	{ }
 };
+MODULE_DEVICE_TABLE(platform, board_ids);
+
 static struct platform_driver acp_asoc_audio = {
 	.driver = {
 		.pm = &snd_soc_pm_ops,
-- 
2.43.0



