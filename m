Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853C517BB21;
	Sun,  7 Sep 2025 20:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276826; cv=none; b=B5iandU7zTkBylirZwHnjx38eh9IfBsuquMgZJ0knsqcBaQ3ZEH6XGcyYAdAdtdQ4/62/ZPP18Jw5JdCqwy+WUUEzW0adW+URIOdyTf21zJ9ecU1P9JoSDyTgA5CaJ/u+gNrH94+AhFHKdIJBDPdnz0E9e1+bnWXot9W6vLRoU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276826; c=relaxed/simple;
	bh=erX9nhufKdKG2VloRWHCmp0er7/5bBFMQcBPORrqVYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HuG8b1S6onm0eQ23OkvNLdUg9E+lNaC39Q45BeFUsZX9OMTgEajaE97m5hjJkjYARY56Zk7YqcaWc2wgtfPrqPDcjh0fSH34S6vfXwBlN1h/WLfgMx1/cV4qApI5kEGITofN/LwAXoveADgDXdUI8zy9nAE2O+nPqpnmVFTOYnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X928jXfL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X928jXfL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 072E8C4CEF0;
	Sun,  7 Sep 2025 20:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276826;
	bh=erX9nhufKdKG2VloRWHCmp0er7/5bBFMQcBPORrqVYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X928jXfLLJH2dMCHogZXhJj5lNuwhdgwH6DvTb+ONDVTfB6w6t5Rh3CpmsoUMNNHh
	 hhOx2g8XededA2iAQbSlvUCLtZH3e7Sal+mYlWzCE9BjjBYzblShXWwG4XluhO6lbg
	 tTBO6xvtQk0+1yg3cjbSvwYEjD/HV7PfZV3osu1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 099/121] pcmcia: omap: Add missing check for platform_get_resource
Date: Sun,  7 Sep 2025 21:58:55 +0200
Message-ID: <20250907195612.392750538@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit ecef14f70ec9344a10c817248d2ac6cddee5921e ]

Add missing check for platform_get_resource() and return error if it fails
to catch the error.

Fixes: d87d44f7ab35 ("ARM: omap1: move CF chipselect setup to board file")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pcmcia/omap_cf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pcmcia/omap_cf.c b/drivers/pcmcia/omap_cf.c
index e613818dc0bc9..25382612e48ac 100644
--- a/drivers/pcmcia/omap_cf.c
+++ b/drivers/pcmcia/omap_cf.c
@@ -215,6 +215,8 @@ static int __init omap_cf_probe(struct platform_device *pdev)
 		return -EINVAL;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -EINVAL;
 
 	cf = kzalloc(sizeof *cf, GFP_KERNEL);
 	if (!cf)
-- 
2.51.0



