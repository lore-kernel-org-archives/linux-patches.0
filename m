Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48110326939;
	Fri, 15 May 2026 16:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862721; cv=none; b=acpu3txfBdQOsHm2CKrDmKkEIqNcw2Y1CZUu0cckWWHbllMY7OjK+J7N8IWtq2mKM+2hkOg567K/UtNnYut1ab34/EKoyxvkQhoWS3U3D7dMNgnONucD8pq1oSsTDQlmTXwOgqrW72aUh5NBQ2Ig0llgZhWOQuqZF202cRQDK64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862721; c=relaxed/simple;
	bh=5tm2nPX2VDAGBnYk8G2zfmyYoNfI62sll1avieTiNIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P+CXh7YLt6++j2mQiTHx93El2b5Q1phNkH6+mVGazOF3hmqp1Sfl/3JtO97bTONqCdqBPyvChnuJyCPDnf8RJ8RAmaMPHVaNVlTLduTKLu/k2ny5Ni1z/pDMbA/SyLzHkj780bBq9PgWW0kilmkLU+H7JM1wLawryEC7Ew240eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xbaEtIaI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xbaEtIaI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97F4AC2BCC9;
	Fri, 15 May 2026 16:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862721;
	bh=5tm2nPX2VDAGBnYk8G2zfmyYoNfI62sll1avieTiNIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xbaEtIaIi0nu240TgXCs5Jz83ZK7ZRrP1JZsukhWTPr/FZw0KQ2xCengqNynh7Nvg
	 BNfGeBSQ6ibwzSmOENf84WUgTNf6vHJhgEfAq9IoB2ISFBBWU4eHPvkRtSWuV2cOnX
	 /bsC1IhGpOPM+XZtOX4rMwj0C5EwxrlaRt7kx8V0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	=?UTF-8?q?Rapha=C3=ABl=20Gallais-Pou?= <rgallaispou@gmail.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>
Subject: [PATCH 7.0 157/201] drm/exynos: remove bridge when component_add fails
Date: Fri, 15 May 2026 17:49:35 +0200
Message-ID: <20260515154701.976160614@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Osama Abdelkader <osama.abdelkader@gmail.com>

commit 26f6654a9a60eb4d241f42a0ec85412e8821480b upstream.

Use devm_drm_bridge_add() so the bridge is released if probe fails after
registration, and drop the manual drm_bridge_remove() in remove().

Check the return value of devm_drm_bridge_add().

Signed-off-by: Osama Abdelkader <osama.abdelkader@gmail.com>
Fixes: 576d72fbfb45 ("drm/exynos: mic: add a bridge at probe")
Cc: stable@vger.kernel.org
Reviewed-by: Raphaël Gallais-Pou <rgallaispou@gmail.com>
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Link: https://patch.msgid.link/20260423200622.325076-2-osama.abdelkader@gmail.com
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/exynos/exynos_drm_mic.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/exynos/exynos_drm_mic.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_mic.c
@@ -423,7 +423,9 @@ static int exynos_mic_probe(struct platf
 
 	mic->bridge.of_node = dev->of_node;
 
-	drm_bridge_add(&mic->bridge);
+	ret = devm_drm_bridge_add(dev, &mic->bridge);
+	if (ret)
+		goto err;
 
 	pm_runtime_enable(dev);
 
@@ -443,12 +445,8 @@ err:
 
 static void exynos_mic_remove(struct platform_device *pdev)
 {
-	struct exynos_mic *mic = platform_get_drvdata(pdev);
-
 	component_del(&pdev->dev, &exynos_mic_component_ops);
 	pm_runtime_disable(&pdev->dev);
-
-	drm_bridge_remove(&mic->bridge);
 }
 
 static const struct of_device_id exynos_mic_of_match[] = {


