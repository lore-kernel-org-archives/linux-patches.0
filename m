Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4858C2F5481;
	Tue, 12 Aug 2025 18:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023549; cv=none; b=O1dCrhsUwpVFqy/osKNoXF5FluH4dPeCDp9hcVGt1C6wN76v3zv0AxQiDcOqAwpt4gezTpRRfN2CA6RcnONxn44pBJTakMvLRcQGmJYEDv+ymkG2Ixa8qdcKmLQRVUaYaCj5kdW9v68SDYK5nVT0YBMIK0RwDXDo29MUU5X060g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023549; c=relaxed/simple;
	bh=7K68s1sqLlLMc32J+ZlMwHepU3s8Iw+jVVT9uKnU6Ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vwy/5+C9O8/66AcXbRSlH4bJDbmjmD0SPW9ycog8s+0j2Q7CHI12fPfpLhyThzxJAoaOucxfFSzPL2KYmaOGe63WhHDOGHjmEuDOqVaeUkCORJvVAMqEtPbXwzyoNIIvqbxmJGDuo5ivzayhYXXFHtjPczeWrE9B4pXPBGAEIEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2JhJnZ3a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2JhJnZ3a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB655C4CEF0;
	Tue, 12 Aug 2025 18:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023549;
	bh=7K68s1sqLlLMc32J+ZlMwHepU3s8Iw+jVVT9uKnU6Ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2JhJnZ3a7+jfOVDNGhqDW7b+j13tEHWqsfQqD1e0113WNj85YUWLJe7KgjLQkwyE/
	 Fv3fa74K3Q2kYep7uI1t1ri72fMmudIS/YsZ15R6coLKM6i71vCLFmrmRfdOyjFrdo
	 77yidVxc+d8BvHM/P7eXyd05lSHacltWpsWWSBUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuming Fan <shumingf@realtek.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 113/627] ASoC: SDCA: Update memory allocations to zero initialise
Date: Tue, 12 Aug 2025 19:26:48 +0200
Message-ID: <20250812173423.609175228@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 15247b5a63f506125360fa45d7aa1fbe8b903b95 ]

All the memory allocations in the SDCA ASoC helpers rely on fields being
zero initialised, the code should use kzalloc not kmalloc.

Reported-by: Shuming Fan <shumingf@realtek.com>
Fixes: 2c8b3a8e6aa8 ("ASoC: SDCA: Create DAPM widgets and routes from DisCo")
Fixes: c3ca24e3fcb6 ("ASoC: SDCA: Create ALSA controls from DisCo")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20250715151723.2964336-4-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sdca/sdca_asoc.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/soc/sdca/sdca_asoc.c b/sound/soc/sdca/sdca_asoc.c
index e96e696cb107..febc57b2a0b5 100644
--- a/sound/soc/sdca/sdca_asoc.c
+++ b/sound/soc/sdca/sdca_asoc.c
@@ -229,11 +229,11 @@ static int entity_early_parse_ge(struct device *dev,
 	if (!control_name)
 		return -ENOMEM;
 
-	kctl = devm_kmalloc(dev, sizeof(*kctl), GFP_KERNEL);
+	kctl = devm_kzalloc(dev, sizeof(*kctl), GFP_KERNEL);
 	if (!kctl)
 		return -ENOMEM;
 
-	soc_enum = devm_kmalloc(dev, sizeof(*soc_enum), GFP_KERNEL);
+	soc_enum = devm_kzalloc(dev, sizeof(*soc_enum), GFP_KERNEL);
 	if (!soc_enum)
 		return -ENOMEM;
 
@@ -560,11 +560,11 @@ static int entity_parse_su_class(struct device *dev,
 	const char **texts;
 	int i;
 
-	kctl = devm_kmalloc(dev, sizeof(*kctl), GFP_KERNEL);
+	kctl = devm_kzalloc(dev, sizeof(*kctl), GFP_KERNEL);
 	if (!kctl)
 		return -ENOMEM;
 
-	soc_enum = devm_kmalloc(dev, sizeof(*soc_enum), GFP_KERNEL);
+	soc_enum = devm_kzalloc(dev, sizeof(*soc_enum), GFP_KERNEL);
 	if (!soc_enum)
 		return -ENOMEM;
 
@@ -671,7 +671,7 @@ static int entity_parse_mu(struct device *dev,
 		if (!control_name)
 			return -ENOMEM;
 
-		mc = devm_kmalloc(dev, sizeof(*mc), GFP_KERNEL);
+		mc = devm_kzalloc(dev, sizeof(*mc), GFP_KERNEL);
 		if (!mc)
 			return -ENOMEM;
 
@@ -925,7 +925,7 @@ static int populate_control(struct device *dev,
 	if (!control_name)
 		return -ENOMEM;
 
-	mc = devm_kmalloc(dev, sizeof(*mc), GFP_KERNEL);
+	mc = devm_kzalloc(dev, sizeof(*mc), GFP_KERNEL);
 	if (!mc)
 		return -ENOMEM;
 
-- 
2.39.5



