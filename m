Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023C23A3E90;
	Wed, 20 May 2026 17:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298045; cv=none; b=DDSMXP0WtP5+0itHyOvsrANUxenLUj5vCiangFsUnoJuLwkmvd+phzCg7OhnZYgxOd6nPfUI+SjCjBLpSQwgU1r3oecAwoWEIc8DsZTfvMj7ZaNnE8vB1d93y5DaHGqg7u5NCAuqm8eM+FQa7OdgRimE7aQF96XhAYW8f2FkXEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298045; c=relaxed/simple;
	bh=pFEh/HeA38xzr/2stUoGop4LMQAb27DKGwIIXw0aBwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kS1eOf/VDTzPbOtCIUMDYndponZXiN0PvD7LDVjGd02092iqLDBbokuFO/gPngNrhvc1Iiair0UvuwZ31PM2pG/5xBh4wbtYDtYk7LULVWf1XENL6gzeX3M718EAoOOoc4Ma3YhIL9OIax1pQFL+IdhALflyBy+l++bYzjvUMmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mM0O4FPG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mM0O4FPG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A081F000E9;
	Wed, 20 May 2026 17:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298043;
	bh=A9e2JgZKIQ6znWjqKajqbH8f91hTHk/LWM6cHZWTFBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mM0O4FPGbtHGuJSadPmOLEmv4M4AletBR909T00J3KvMX2+fy3pxV1QtmzHDNNxyq
	 RPNposk/EXwv2qnopucTZXGL/7i3MRRdqtgFxUsdYmG2TmsQf5Q4xvngSY3PZ05byP
	 gVnStwW4ZlwFHIFKjwTSGeadIdRD/Jy7bhr0u2WU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 259/957] ASoC: amd: acp: update dmic_num logic for acp pdm dmic
Date: Wed, 20 May 2026 18:12:22 +0200
Message-ID: <20260520162140.161129164@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit 5902e1f3c501375797dcd7ca21b58e2c9abbe317 ]

Currently there is no mechanism to read dmic_num in mach_params
structure. In this scenario mach_params->dmic_num check always
returns 0 which fails to add component string for dmic.
Update the condition check with acp pdm dmic quirk check and
pass the dmic_num as 1.

Fixes: 2981d9b0789c ("ASoC: amd: acp: add soundwire machine driver for legacy stack")

Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://patch.msgid.link/20260330072431.3512358-2-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-sdw-legacy-mach.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/amd/acp/acp-sdw-legacy-mach.c b/sound/soc/amd/acp/acp-sdw-legacy-mach.c
index 2b2910b1856d5..798c73d7e26de 100644
--- a/sound/soc/amd/acp/acp-sdw-legacy-mach.c
+++ b/sound/soc/amd/acp/acp-sdw-legacy-mach.c
@@ -520,11 +520,11 @@ static int mc_probe(struct platform_device *pdev)
 					  " cfg-amp:%d", amp_num);
 	if (!card->components)
 		return -ENOMEM;
-	if (mach->mach_params.dmic_num) {
+	if (soc_sdw_quirk & ASOC_SDW_ACP_DMIC) {
 		card->components = devm_kasprintf(card->dev, GFP_KERNEL,
 						  "%s mic:dmic cfg-mics:%d",
 						  card->components,
-						  mach->mach_params.dmic_num);
+						  1);
 		if (!card->components)
 			return -ENOMEM;
 	}
-- 
2.53.0



