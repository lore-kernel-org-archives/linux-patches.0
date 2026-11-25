Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619166;
	b=1vYc5+3ddwrAfQ6G8tUvhRUc4L2JLUJpUX7aZ7vYeIL5X12MjlsOEDJX3xJItTyZJ3ll
	 /sDqr4/tOP5smgm3e+s0kiLQcShODP2m0XYJlOpzlKCFTa3O1v2+9gOV5+YcnYtS2h0v/
	 292I99qSUTLhzZLqG7fRWUKDjdQUWOO3wYFUGVVdvYVy5CIwNsUrWLn3g3Okyt3uX3w//
	 Sm+Wkw8FV8ASvBs9NRMWPtwW468bcvmhxqTWs3AwOybpbRhh+CVrzmG8eHHYK/5QFhs+o
	 AhXLUNORB+Q4G0t4z2tFVpoPDnYimmMpcRHj/L9yPUNiVEsS6/cJIoPKoDKLiW+CPBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619166;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2MitvDivMq5OAY/MdswFI6K4eZW+DAnas2ZLoiOqYjk=;
	b=ZtSo2qF3W5JW1XYQJQHZ+G4a4MWn/4tDSJZae8+7GAM3NEGoqBf8tSpx9OMUVdXwkvu0
	 4dy5zZDRmPVaTmfBfN8cmHnBmkN9Xzlm59cA2SZe7tP5tBnS77r+zwhEMwAkGojAMa3qf
	 jPCgzcKZdHO4wwzlTPgUpJezFxTiMJO0srAX+UwlXVQx5Mui4HNU3cNkEuxk/nFLEAz6K
	 eSqzo8w4sBU+ZeaSVawDSaXEK0WXUeVa1HZs1mBhQL8K5NIe2I8kuFbyq3sAKH+6xnQaD
	 KZanuTi/iZ7BpA8Agm+6e7ZGqkmmO22TiAe+ptvgBXnnOvIxAIdjIn2lqURvU2KEwPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xTiXxTdJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E48606A32E;
	Wed, 25 Nov 2026 15:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xTiXxTdJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93CCA1F000C6;
	Wed, 25 Nov 2026 15:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619166;
	bh=2MitvDivMq5OAY/MdswFI6K4eZW+DAnas2ZLoiOqYjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xTiXxTdJsOPXX5HrRHm/skTN7ZbmN8KVIv0+xhcnDecjTQd2AIZiON+QmmT9EjYI8
	 LpMaRA3hC2d5UEJgkxdZMvxqMn1NmWicfv5Ni3qSAD1nZcKuv0yWMlvtOS9p/KijgX
	 toJyzEWafnk7Ogp0IcNz4fR+sEhxWZPllOJPhU98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janne Grunau <j@jannau.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0512/1005] ASoC: apple: mca: Fix clock selection for clock consumer FEs
Date: Wed, 25 Nov 2026 15:30:50 +0100
Message-ID: <20261125143833.738338899@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Janne Grunau <j@jannau.net>

[ Upstream commit d9bcb20e403908415809c37b96db4c9d651298cc ]

In commit 00309bfb1f54 ("ASoC: apple: mca: Support FEs being clock
consumers") the syncgen clock selection was misunderstood resulting in
selecting a random clock. In the capture on multiple BEs for IV sense
data use case the configuration worked partially by sheer luck. On
Macbook Pro's with 6 speakers it could result in desync IV sense data
triggered likely by sample rate changes.
When the FE is a clock consumer select the clock of first used BE as
SYNCGEN_MCLK.
Add function like macros to determine the clock index based on the FE or
BE number.
This is functionally equivalent to the state sent in v2 of "ASoC: apple:
mca: support simultaneous I2S capture on the frontend" in [1].

Link: https://lore.kernel.org/all/20260628-apple-audio-redux-v2-4-6328269c9652@gmail.com/ [1]
Fixes: 00309bfb1f54 ("ASoC: apple: mca: Support FEs being clock consumers")
Fixes: 108a14b20f95 ("ASoC: apple: mca: Support capture on multiples BEs")
Signed-off-by: Janne Grunau <j@jannau.net>
Link: https://patch.msgid.link/20261110-snd-soc-apple-mca-capture-multiple-be-v1-1-d9569a8374c5@jannau.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/apple/mca.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/sound/soc/apple/mca.c b/sound/soc/apple/mca.c
index be702b2942a53..ec3636f9dc86e 100644
--- a/sound/soc/apple/mca.c
+++ b/sound/soc/apple/mca.c
@@ -53,6 +53,8 @@
 #define SYNCGEN_STATUS_EN	BIT(0)
 #define REG_SYNCGEN_MCLK_SEL	0x104
 #define SYNCGEN_MCLK_SEL	GENMASK(3, 0)
+#define SYNCGEN_MCLK_FE_CLK(n)	((n) + 1)
+#define SYNCGEN_MCLK_BE_CLK(n)	((n) + 7)
 #define REG_SYNCGEN_HI_PERIOD	0x108
 #define REG_SYNCGEN_LO_PERIOD	0x10c
 
@@ -313,7 +315,8 @@ static int mca_fe_enable_clocks(struct mca_cluster *cl)
 		return -EINVAL;
 	}
 
-	writel_relaxed(cl->no + 1, cl->base + REG_SYNCGEN_MCLK_SEL);
+	writel_relaxed(SYNCGEN_MCLK_FE_CLK(cl->no),
+		       cl->base + REG_SYNCGEN_MCLK_SEL);
 	mca_modify(cl, REG_SYNCGEN_STATUS, SYNCGEN_STATUS_EN,
 		   SYNCGEN_STATUS_EN);
 	mca_modify(cl, REG_STATUS, STATUS_MCLK_EN, STATUS_MCLK_EN);
@@ -390,7 +393,7 @@ static int mca_fe_prepare(struct snd_pcm_substream *substream,
 
 	/* Turn on the cluster power domain if not already in use */
 	if (!cl->syncgen_in_use) {
-		int port = ffs(mca_fe_get_portmask(substream));
+		int port = ffs(mca_fe_get_portmask(substream)) - 1;
 
 		cl->pd_link = device_link_add(mca->dev, cl->pd_dev,
 					      DL_FLAG_STATELESS | DL_FLAG_PM_RUNTIME |
@@ -401,7 +404,8 @@ static int mca_fe_prepare(struct snd_pcm_substream *substream,
 			return -EINVAL;
 		}
 
-		mca_modify(cl, REG_SYNCGEN_MCLK_SEL, SYNCGEN_MCLK_SEL, BIT(port));
+		mca_modify(cl, REG_SYNCGEN_MCLK_SEL, SYNCGEN_MCLK_SEL,
+			   SYNCGEN_MCLK_BE_CLK(port));
 		mca_modify(cl, REG_SYNCGEN_STATUS, SYNCGEN_STATUS_EN,
 			   SYNCGEN_STATUS_EN);
 	}
-- 
2.53.0



