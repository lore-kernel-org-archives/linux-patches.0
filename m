Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB17288B9;
	Sat, 12 Sep 2026 16:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230881; cv=none; b=ULdeZ8s09uFiFL88Dv5qC69ZdzeAdiFV7l3dHb/njxK2gc6GBNNex/OUJmUI7/b0yFmbblnC2/9aANPjUOlMahXTMwW4dXnAQK9Q5n9fAIBCkqX47miKLdRc9GmCMPOkbbkgR7OijU4UWoQyTTCialNhbGmFfjoS3m9RygHm5L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230881; c=relaxed/simple;
	bh=aFLzJFrgG/3EmtaTol2MOa2FyPx2epwIcV1IdXCxEzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EaKw1FYY87LAts/PEw9TKh5w5I9ctytUh0DHw049MPJ+JUAYeMPi25MJfPGV8uNEzPwfm1+GoSdJcn+QlvqSa62RSF7Kllv9h3sRoBRFckwr3ey4c1ZOPBsd97IqVprFWzFiV3aTPkCy0RcaYowmsv5ga2xNgEOXAB1vO8JgoRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ziVnThRT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ziVnThRT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78CC61F000FF;
	Sat, 12 Sep 2026 16:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230880;
	bh=CTTeyy9H8ytzGImP5fTq2wCvzXf150a+ghclIpIjZw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ziVnThRTzIfAADOHy0ITojrEerbR0/QOXKZ9nZ1D5iyi9dvRFsyjAbl7GyWEOkmU2
	 pPqPO3A6laiH4gA3YL6IOoEKcnSkvtaxqaGWJnPZPRUtuKIJqXbM0L3Kh6eLYXd1PJ
	 pUto2ZEvR589fYaEFCbn2Jt8z0UX7fMRxw5YXLkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0886/1191] drm/sun4i: tcon: Drop TCON TOP device reference
Date: Sat, 12 Sep 2026 09:00:14 +0200
Message-ID: <20260912065608.138748806@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jernej Skrabec <jernej.skrabec@gmail.com>

[ Upstream commit 8208832a38ff3d2560eb8a77a9d7a2f17d8ebcdc ]

of_find_device_by_node() takes a device reference. Drop it after mux
configuration succeeds.

Fixes: 0305189afb32 ("drm/sun4i: tcon: Add support for R40 TCON")
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Acked-by: Chen-Yu Tsai <wens@kernel.org>
Link: https://patch.msgid.link/871a3108086c15a483eef23301984c8d2254dfa7.1785772659.git.jernej.skrabec@gmail.com
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun4i_tcon.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/sun4i/sun4i_tcon.c b/drivers/gpu/drm/sun4i/sun4i_tcon.c
index 933d45bb9122d..4df011b126a84 100644
--- a/drivers/gpu/drm/sun4i/sun4i_tcon.c
+++ b/drivers/gpu/drm/sun4i/sun4i_tcon.c
@@ -1405,7 +1405,7 @@ static int sun8i_r40_tcon_tv_set_mux(struct sun4i_tcon *tcon,
 {
 	struct device_node *port, *remote;
 	struct platform_device *pdev;
-	int id, ret;
+	int id, ret = 0;
 
 	/* find TCON TOP platform device and TCON id */
 
@@ -1428,21 +1428,20 @@ static int sun8i_r40_tcon_tv_set_mux(struct sun4i_tcon *tcon,
 	if (IS_ENABLED(CONFIG_DRM_SUN8I_TCON_TOP) &&
 	    encoder->encoder_type == DRM_MODE_ENCODER_TMDS) {
 		ret = sun8i_tcon_top_set_hdmi_src(&pdev->dev, id);
-		if (ret) {
-			put_device(&pdev->dev);
-			return ret;
-		}
+		if (ret)
+			goto out_put_device;
 	}
 
 	if (IS_ENABLED(CONFIG_DRM_SUN8I_TCON_TOP)) {
 		ret = sun8i_tcon_top_de_config(&pdev->dev, tcon->id, id);
-		if (ret) {
-			put_device(&pdev->dev);
-			return ret;
-		}
+		if (ret)
+			goto out_put_device;
 	}
 
-	return 0;
+out_put_device:
+	put_device(&pdev->dev);
+
+	return ret;
 }
 
 static const struct sun4i_tcon_quirks sun4i_a10_quirks = {
-- 
2.53.0



