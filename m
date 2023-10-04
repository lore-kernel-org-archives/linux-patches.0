Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE1E1D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a95R34fU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D58CC433C8;
	Wed,  4 Oct 2023 18:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443325;
	bh=ooJaIlpRT/Mi7Iv9nJzRr7wU/ESq1DqQvocqnJ1SVew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a95R34fUYVpVvGwKyZzuQma3Np7mUIf7mUVEc6a7as+z4PLl+yhXK0pwMg/mmmXo6
	 CkfurgAmOOkokAbF92UIWkCkcWnzSvxm8TlojuerZN75rrbP5mAY0a/P7BoU/FL50W
	 cqPfujmxv8RpCCzt2UXsQvW/rfttajtusZ3Ez+y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	ChiaEn Wu <chiaen_wu@richtek.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 116/259] power: supply: mt6370: Fix missing error code in mt6370_chg_toggle_cfo()
Date: Wed,  4 Oct 2023 19:54:49 +0200
Message-ID: <20231004175222.647410681@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

[ Upstream commit 779873ec81306d2c40c459fa7c91a5d40655510d ]

When mt6370_chg_field_get() suceeds, ret is set to zero and returning
zero when flash led is still in strobe mode looks incorrect.

Fixes: 233cb8a47d65 ("power: supply: mt6370: Add MediaTek MT6370 charger driver")
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: ChiaEn Wu <chiaen_wu@richtek.com>
Link: https://lore.kernel.org/r/20230906084815.2827930-1-harshit.m.mogalapalli@oracle.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/mt6370-charger.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/mt6370-charger.c b/drivers/power/supply/mt6370-charger.c
index f27dae5043f5b..a9641bd3d8cf8 100644
--- a/drivers/power/supply/mt6370-charger.c
+++ b/drivers/power/supply/mt6370-charger.c
@@ -324,7 +324,7 @@ static int mt6370_chg_toggle_cfo(struct mt6370_priv *priv)
 
 	if (fl_strobe) {
 		dev_err(priv->dev, "Flash led is still in strobe mode\n");
-		return ret;
+		return -EINVAL;
 	}
 
 	/* cfo off */
-- 
2.40.1



