Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2492D4F8B0;
	Tue, 23 Jan 2024 01:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974646; cv=none; b=KAn5xznfQZRoAfR3Bms5Irx22JsmLHEk3SD7JVY5Un4JAKJ9G9BBFrXKL0uIPLWFXFpD9wPaQDZXgTQspqNyOfGxKe8Jx9ueem1ELJrM5JRnCG/ahtLK4dZBOA3ZCL2yBhGPVDdhqdBJfYFOO9U+A/1FYSgLwjaVhsGfy2R+z40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974646; c=relaxed/simple;
	bh=NOkA7fBsd+JxJxR1Bc4/8RKdXvBkbtIlIt9qqWP8ey0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WXwGQwO9DGNY0j0/R28Yp1hvlHgzu3rCZdm7/mMYh5WjoQZXwrfmFH32YQqzSYi0u0DpUZECEvsBbhFFq4hepR2sFur9wmnS3oo0TTqFFw1duOoHQPoYw/pbgmrFfUr2Hvv9XAwfuDYuE6EFzUv4x1sOMZg1fNvqztaG2N/ruGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Je/ytrso; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Je/ytrso"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0B3BC433F1;
	Tue, 23 Jan 2024 01:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974646;
	bh=NOkA7fBsd+JxJxR1Bc4/8RKdXvBkbtIlIt9qqWP8ey0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Je/ytrso36xfG0l0NVVeIIqCEdUO8Fl+a0ZpOLvwsyYRH1HgS5vYHNfU6zOz8H0kD
	 OIl85M45OP9sveimfalfFG4IAkXvIi688/aTAXwLToBg4nu7ZIgXCKb7jaXd3vDW95
	 Cfg9HS8eDlP+NzCDbFR18n5nOUsmeFV8fOfG5cmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Dafna Hirschfeld <dafna@fastmail.com>,
	Paul Elder <paul.elder@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 202/374] media: rkisp1: Disable runtime PM in probe error path
Date: Mon, 22 Jan 2024 15:57:38 -0800
Message-ID: <20240122235751.635683985@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit 13c9810281f8b24af9b7712cd84a1fce61843e93 ]

If the v4l2_device_register() call fails, runtime PM is left enabled.
Fix it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Dafna Hirschfeld <dafna@fastmail.com>
Reviewed-by: Paul Elder <paul.elder@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Stable-dep-of: 452f604a4683 ("media: rkisp1: Fix media device memory leak")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rockchip/rkisp1/rkisp1-dev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/rockchip/rkisp1/rkisp1-dev.c b/drivers/media/platform/rockchip/rkisp1/rkisp1-dev.c
index 560f928c3752..79cfa99f2a64 100644
--- a/drivers/media/platform/rockchip/rkisp1/rkisp1-dev.c
+++ b/drivers/media/platform/rockchip/rkisp1/rkisp1-dev.c
@@ -514,7 +514,7 @@ static int rkisp1_probe(struct platform_device *pdev)
 
 	ret = v4l2_device_register(rkisp1->dev, &rkisp1->v4l2_dev);
 	if (ret)
-		return ret;
+		goto err_pm_runtime_disable;
 
 	ret = media_device_register(&rkisp1->media_dev);
 	if (ret) {
@@ -534,6 +534,7 @@ static int rkisp1_probe(struct platform_device *pdev)
 	media_device_unregister(&rkisp1->media_dev);
 err_unreg_v4l2_dev:
 	v4l2_device_unregister(&rkisp1->v4l2_dev);
+err_pm_runtime_disable:
 	pm_runtime_disable(&pdev->dev);
 	return ret;
 }
-- 
2.43.0



