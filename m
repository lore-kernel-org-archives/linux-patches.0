Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019185;
	b=Ay0ui3o49pWz6B73Hs2yOEB+MaNkaUolB5FuY5oVihECI4SakzG7t9SAKuuvQWOsnfxC
	 H7tbSHhwJKcb5/TE8uR/jkJzLPxFuT9jjLx+SujR7HqYYCK6cD3vn0Ab70ke/FBD8hZG4
	 rpbtaArXGZ7/SJzAH7zkmaelSugrTJy4Fbi6DMNQ2ADRhSOMXBYAgz1vsTispnLy6PIC3
	 0UQOQ8io50JPp7gvtFUFG5pC6YzsxqAOvaIFvltun4/zocQJ1vqO8//PXX180bnqRrJ/R
	 yZxytMa0FcZgs6Fdxty2vkXJNaLVb00gX6zlSJwlHt3sDEQJKBU9PiaGjRMkPIcLlNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019185;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q4BSbljuXN8wM5Aq/+upHo/qQbSZ6vH/cYx3y8w2IPc=;
	b=pdL0V4xweoJxUyACd0ah3nllRufBD41Poo4VPeHy0/Se2MBh1bejyPLF+zT2rUSauWPQ
	 KcxD+U8IlmYnAuVsEhuN5peE+qMzryiy2b3xetfUY3MffA3wXLZnOqKlVtRNQlvfIaXdj
	 hrhGWIFYWlVMuGIDcPKdRjOPNpLFP0QJrabJ81uIeeC8O5FRfu7Un1dQEryX4nxxdjLgD
	 0+web4zeCbeIZLzwoNg407yGMmEuAUdSiw3kWGI9RLhd2jUqwD/uSCVJKvwVpEYT2FL6C
	 6v2vfGghUa3jncMKHK+4pDVRvOl8xDDh6NNqCgje83vmkKgB7PlxaPftGfLHn+3cWrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zxsp8Ap5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47B9606A31C;
	Wed, 18 Nov 2026 16:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zxsp8Ap5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3217A1F000C4;
	Wed, 18 Nov 2026 16:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019185;
	bh=Q4BSbljuXN8wM5Aq/+upHo/qQbSZ6vH/cYx3y8w2IPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zxsp8Ap5wRipFvquDptT25F4QiLwzeGZfamY1lyRpSvD1mPyFJP0A6EllKC2Pi9Ti
	 yKKw7a+cZB+01EtOgfOB7JooZRkXM3w4zcRYfxYUVaYegcjMxYufcaV/7iXnqS3GqE
	 26rFGVxooC+8csolYXQLwCS8vNFB1MMAvYPRmBfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1506/2651] ASoC: mediatek: mt8188: Handle constraint return value in FE startup
Date: Wed, 18 Nov 2026 15:45:46 +0100
Message-ID: <20261118150342.227194703@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 71253751586b8ce37570b8e15cfbc74f0dd06c3d ]

snd_pcm_hw_constraint_minmax() may return 1, which is then returned
from mt8188_afe_fe_startup(). ASoC only treats 0 as success when marking
the DAI as started, so .shutdown() can be skipped on rollback.

Return 0 explicitly on success.

Fixes: bf106bf09376 ("ASoC: mediatek: mt8188: add platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20261007110858.509341-3-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8188/mt8188-afe-pcm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/mediatek/mt8188/mt8188-afe-pcm.c b/sound/soc/mediatek/mt8188/mt8188-afe-pcm.c
index f8cbe7bac36de..4174ddbb94078 100644
--- a/sound/soc/mediatek/mt8188/mt8188-afe-pcm.c
+++ b/sound/soc/mediatek/mt8188/mt8188-afe-pcm.c
@@ -320,6 +320,9 @@ static int mt8188_afe_fe_startup(struct snd_pcm_substream *substream,
 					   MT8188_MEMIF_DL7_MAX_PERIOD_SIZE);
 	if (ret < 0)
 		dev_dbg(afe->dev, "hw_constraint_minmax failed\n");
+	else
+		ret = 0;
+
 out:
 	return ret;
 }
-- 
2.53.0



