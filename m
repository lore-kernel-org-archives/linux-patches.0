Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676F415E87
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j/NqHXag"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5EBEC433C7;
	Mon, 23 Oct 2023 11:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060852;
	bh=59qRKOtBMITZbmRnInavRNLpDAt6ZKXrtrh8Gh8SjGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j/NqHXagmS+XHicUm4IR8B94DHTPd9PG/9IbCa3VkGBHayPQgs6P54Gr+16CBbfvv
	 WZtV8iEAkhnV4DeGpMG33LaauVIfLHXzwqDQ4mTfvFJ9LfeSYdYvtCCQ8Fq7cZAPOQ
	 tN1DFtOP1Vc6zU2KwzLER76qAutIq7JDFcBN5vU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 115/123] ASoC: pxa: fix a memory leak in probe()
Date: Mon, 23 Oct 2023 12:57:53 +0200
Message-ID: <20231023104821.616582822@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104817.691299567@linuxfoundation.org>
References: <20231023104817.691299567@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit aa6464edbd51af4a2f8db43df866a7642b244b5f ]

Free the "priv" pointer before returning the error code.

Fixes: 90eb6b59d311 ("ASoC: pxa-ssp: add support for an external clock in devicetree")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/84ac2313-1420-471a-b2cb-3269a2e12a7c@moroto.mountain
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/pxa/pxa-ssp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/pxa/pxa-ssp.c b/sound/soc/pxa/pxa-ssp.c
index 5fdd1a24c232d..ff3db623c476d 100644
--- a/sound/soc/pxa/pxa-ssp.c
+++ b/sound/soc/pxa/pxa-ssp.c
@@ -797,7 +797,7 @@ static int pxa_ssp_probe(struct snd_soc_dai *dai)
 		if (IS_ERR(priv->extclk)) {
 			ret = PTR_ERR(priv->extclk);
 			if (ret == -EPROBE_DEFER)
-				return ret;
+				goto err_priv;
 
 			priv->extclk = NULL;
 		}
-- 
2.42.0



