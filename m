Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9801852;
	Tue, 23 Jan 2024 00:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969500; cv=none; b=WZHgdlQcOAd5cLJXqd+OtHYMTRCeNVjHZRWyE7ZJHAPY3zuzQ744SPGjD2KfsLNeJeUmPkjpHwyaaV/AfQhcG2UUbP1LV7VlBfyM4SwkRkmCijcBA7T/mYOdlNuPj+pz+As6Ue2D3tbRNr+EcTW38kvWbAFVk9iiQgsdPNTu0iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969500; c=relaxed/simple;
	bh=km8+TW9qOfc6d2mr5LelbTQAvcpTwCNmkCsd9oeahGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ePEeTtNrd5TC2ODC0SpwCa3MyIlvIEq7OjjqZq4YyAQTi3KsI2vHTM4ULhm5ADEkU6mP4k2QLNZV0PRWsVMtv5mgBN8jvGpmx4CeIdwTnbd5aDmhlJ5sK47Cff1bXOOMc40812myovK8XAYJsmK2+4u9T4ruluXRb/w8NNnJgac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P/wWABSt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P/wWABSt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F28EC43143;
	Tue, 23 Jan 2024 00:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969500;
	bh=km8+TW9qOfc6d2mr5LelbTQAvcpTwCNmkCsd9oeahGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P/wWABStVE84BMwJYs63m01+37+y6nWAyHSArxgZN/kCtc6yJ7tbR8CBJ/w3NBz03
	 a9CfSkhP/g7KfCu/9kfAWt/Xl+880lEtPacRZh5g6OB/ZtxaHdqSaNyTB2OZuvqJm+
	 Zj/o3nBMToWWfDoXxE18KrW+5o1LykBXIh0P78xA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 286/641] ASoC: SOF: topology: Use partial match for disconnecting DAI link and DAI widget
Date: Mon, 22 Jan 2024 15:53:10 -0800
Message-ID: <20240122235826.843538397@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit 2f03970198d6438d95b96f69041254bd39aafed0 ]

We use partial match for connecting DAI link and DAI widget. We need to
use partial match for disconnecting, too.

Fixes: fe88788779fc ("ASoC: SOF: topology: Use partial match for connecting DAI link and DAI widget")
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20231204214713.208951-2-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/topology.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sof/topology.c b/sound/soc/sof/topology.c
index 37ec671a2d76..7133ec13322b 100644
--- a/sound/soc/sof/topology.c
+++ b/sound/soc/sof/topology.c
@@ -1134,7 +1134,7 @@ static void sof_disconnect_dai_widget(struct snd_soc_component *scomp,
 	list_for_each_entry(rtd, &card->rtd_list, list) {
 		/* does stream match DAI link ? */
 		if (!rtd->dai_link->stream_name ||
-		    strcmp(sname, rtd->dai_link->stream_name))
+		    !strstr(rtd->dai_link->stream_name, sname))
 			continue;
 
 		for_each_rtd_cpu_dais(rtd, i, cpu_dai)
-- 
2.43.0



