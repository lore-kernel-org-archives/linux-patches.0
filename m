Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C3433C198;
	Sat, 12 Sep 2026 12:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214939; cv=none; b=GXjeLG9qIbX+3/0xgmlXEBzWVDpVpy9eq++9gSajaYwVHqe4554OBSpdU5uloJmQe8ME101NENqQikWH9EsRs7VKSRYcYP01WNlKpgZG/B1JeD9GvLilIZMxzo7zwCI/9G/rABOqes3ugUSgv9WbsUJiyQdIpvCnIUpG1zBs9L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214939; c=relaxed/simple;
	bh=K8f5FSgrN9Yt+HR0gQxheFlgRDw536vhJL52gibIqTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dE/KEajOP1Hfi8/rpCjv/3OMussW7QUa4KQYQMCxNnnA4xCf674hsPRj+Tst+25pz9lTYU3mE3tgZ+4Xgo52uhe6dZKA61DggCFGB7jCMcg9HOgTgkkJKV+gMG0X1suZxod8rfWYLnNaOiY41T4qy5ZqF5Gq9h5gS4ZMxkSy/jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tOE43aMf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tOE43aMf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A4831F000FF;
	Sat, 12 Sep 2026 12:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214938;
	bh=1+Xsut6Ws7CqIzTjGPNAQNEt06/NaOkTWf9v2lbUSZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tOE43aMfy9Ud9JRr0MWGPDIO4m1pBGfF38t+6DQ53zot0CdwaFKtIqMtNzesiV+zS
	 hQNYI2DDdkPXW2q2361OtsjuaXqSafVJ6bsW3lnFSfk1Dudm4oT1gnsdkwL2JOj+6h
	 jkeW2otlamQuRjIlvAJRkR6ZBMTnVBd+KxEBHyxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rong Zhang <i@rong.moe>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0422/1376] staging: sm750fb: Add missing Kconfig dependency
Date: Sat, 12 Sep 2026 08:47:28 +0200
Message-ID: <20260912065616.942760722@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rong Zhang <i@rong.moe>

[ Upstream commit da8fd33e7d6af4c069668c2d42234b969f706885 ]

The sm750 frame buffer driver depends on FB_IOMEM_FOPS, but its Kconfig
somehow misses it.

Fix it by making FB_SM750 select FB_IOMEM_FOPS, as other frame buffer
drivers do.

Fixes: dc0ad215e5d8 ("staging/sm750fb: Initialize fb_ops with fbdev macros")
Signed-off-by: Rong Zhang <i@rong.moe>
Link: https://patch.msgid.link/20260603-sm750-fb-iomem-kconfig-v1-1-7f6a3046cce2@rong.moe
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/sm750fb/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/sm750fb/Kconfig b/drivers/staging/sm750fb/Kconfig
index 08bcccdd0f1c4..25fe422f55f2c 100644
--- a/drivers/staging/sm750fb/Kconfig
+++ b/drivers/staging/sm750fb/Kconfig
@@ -6,6 +6,7 @@ config FB_SM750
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
+	select FB_IOMEM_FOPS
 	help
 	  Frame buffer driver for the Silicon Motion SM750 chip
 	  with 2D acceleration and dual head support.
-- 
2.53.0



