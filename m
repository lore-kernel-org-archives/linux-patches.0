Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A30B33F5BA;
	Wed, 20 May 2026 16:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295228; cv=none; b=heG0iWpj2kHXn6lqMSN5MkQORq6XXHSWCnwHnCV6Nd4tIsfUTej8wNfFIu/AwhlpBdgx4RJ73azBnHW5rX0ngtw0q0rcTPiA3BO+kcdXgBAKxgyd5abNJ2mzNfolpOaKnCh2Ct/oF1rDqBYYjabQYy0byM+oSAmN0HyJtRZ0Vng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295228; c=relaxed/simple;
	bh=vh6sSxOCadek0UFcca7yAHm+rUAF2KmcFRv3cBiQ7ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YkS0kZJHB1kE2iqe0DuNvY1IPAaujP2x0jG5l1cUQDiBOMD4Xe02OHGk1zdiVm66OfIYAIh61cFxwigYKJrjiszZyPnQuIDo/MjEX15OxHFmNbXjFXfeOkz44usJlwrnLaeAak9E/fureYi2gbHb9+38kLVZSbC0GE4WLZ9/neQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mNQrmWYh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mNQrmWYh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E35D1F000E9;
	Wed, 20 May 2026 16:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295227;
	bh=Pwb4dWj5+GVA94kbo/qAmv/ghdTb/+Um+SY4JMbdyiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mNQrmWYhDfgz2LGAq/m3k/d3G7a9a1sopVliq1f8b3unDieAik5sHT540N+pHe8uc
	 jSR+Ozvqg4+CuTIST0GHIS0x+gTIsDpIcdxZerKzS17m8+b8Cm8hXoAp3VOxjju18b
	 NGxFX5RgR/LxCqpYcMXQAFmbd9Kv72mzCVRZohl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0337/1146] ASoC: amd: acp: update dmic_num logic for acp pdm dmic
Date: Wed, 20 May 2026 18:09:47 +0200
Message-ID: <20260520162155.827502632@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index cd7b1acc7216d..a9c8d9545281e 100644
--- a/sound/soc/amd/acp/acp-sdw-legacy-mach.c
+++ b/sound/soc/amd/acp/acp-sdw-legacy-mach.c
@@ -551,11 +551,11 @@ static int mc_probe(struct platform_device *pdev)
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



