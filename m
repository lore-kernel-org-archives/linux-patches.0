Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C8F3BED47;
	Fri, 15 May 2026 16:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862736; cv=none; b=GLHWvPdm4A2q58tO/qnCfuCk7kBxU7UA2vwpO9k6V09lkj6dPNy1E0YTah0wfsV6Nt34dD64kHneb3o9a+31TVIy4RwOHKHyzPiKS/YYTziCVFA54uxC2HUyuPevVIUB8RFQPAgrHGGsOvn+WdnemGPMwehuMSawFDfYjlJxFvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862736; c=relaxed/simple;
	bh=/bcST7MvFXcs8xuYsStOUj0oxrn8EpLArY6it0dl+uI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AF3SuLy1YHKn7x/2glH9XI8MNHy+rW0JQFN4idxa0cGWS4pXXIrV6l2GVYGaxMlPVSFeIKfTJH3042TcFbsB6km6F5fMzzesGTg2jIvFCPKkZRFz81GGazgCdwm1pj8P35u4hbkX8ETtYGe7p17OQE8zUSua7Qu5QY0l/4gTvI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z6WQlXpz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z6WQlXpz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BDB9C2BCB0;
	Fri, 15 May 2026 16:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862736;
	bh=/bcST7MvFXcs8xuYsStOUj0oxrn8EpLArY6it0dl+uI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z6WQlXpzSmizoht/D9XizXBbsH+FNf+tHeMOKIFIxar0SxcOkw5RxRgWUjA6EYaUG
	 hUMfHnnmlllLTyl0JQ8vHglLCf3GG1N3rhv0EnGcVvrl24MxVzzmmbP0WXqixO/DI4
	 cbVI2iKkkVwUr5yfCfIOqBT2H16U08EueoLOLGh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	=?UTF-8?q?Rapha=C3=ABl=20Gallais-Pou?= <rgallaispou@gmail.com>,
	Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>
Subject: [PATCH 7.0 162/201] drm/sti: remove bridge when sti_hda component_add fails
Date: Fri, 15 May 2026 17:49:40 +0200
Message-ID: <20260515154702.085130211@linuxfoundation.org>
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

commit 84ae1840260fece9b6b70d3872b79384bbe5a90b upstream.

Use devm_drm_bridge_add() so the bridge is released if probe fails after
registration, and drop the manual drm_bridge_remove() in remove().

Check the return value of devm_drm_bridge_add().

Signed-off-by: Osama Abdelkader <osama.abdelkader@gmail.com>
Fixes: d28726efc637 ("drm/sti: hda: add bridge before attaching")
Cc: stable@vger.kernel.org
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Acked-by: Raphaël Gallais-Pou <rgallaispou@gmail.com>
Link: https://patch.msgid.link/20260423200622.325076-1-osama.abdelkader@gmail.com
Signed-off-by: Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/sti/sti_hda.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/sti/sti_hda.c b/drivers/gpu/drm/sti/sti_hda.c
index b7397827889c..360a88ca8f0c 100644
--- a/drivers/gpu/drm/sti/sti_hda.c
+++ b/drivers/gpu/drm/sti/sti_hda.c
@@ -741,6 +741,7 @@ static int sti_hda_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct sti_hda *hda;
 	struct resource *res;
+	int ret;
 
 	DRM_INFO("%s\n", __func__);
 
@@ -779,7 +780,9 @@ static int sti_hda_probe(struct platform_device *pdev)
 		return PTR_ERR(hda->clk_hddac);
 	}
 
-	drm_bridge_add(&hda->bridge);
+	ret = devm_drm_bridge_add(dev, &hda->bridge);
+	if (ret)
+		return ret;
 
 	platform_set_drvdata(pdev, hda);
 
@@ -788,10 +791,7 @@ static int sti_hda_probe(struct platform_device *pdev)
 
 static void sti_hda_remove(struct platform_device *pdev)
 {
-	struct sti_hda *hda = platform_get_drvdata(pdev);
-
 	component_del(&pdev->dev, &sti_hda_ops);
-	drm_bridge_remove(&hda->bridge);
 }
 
 static const struct of_device_id hda_of_match[] = {
-- 
2.54.0



