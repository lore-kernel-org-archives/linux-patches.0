Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAFFE4315A;
	Sun,  7 Sep 2025 20:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277870; cv=none; b=mwCne4XSNoKrzIywAJpYSuDpuv91qscM3S1tAwVnWJAxK25UuDkt3/cNmWJEXZuviQHyqlkspgIa7I57W85wSxphJri1/bd9vOrCOzWuVFVP+985EisUK4XFxQg0fwfGvIvI5zk/K/b+rg3vxLFahdNWxwOJK3bLKflXCz8D4Ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277870; c=relaxed/simple;
	bh=f858sCHZnMVN3rOhb+TmRESR29M36DmAqgFZpSX8cSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KbVQaY6eheClD6ZcvRz/R0r+Aefth0aZNNalWDwlZQrX3KNC+DPGXyu4/BE8OFGW/rlaNNEkE8BTaObhSJSgSCu9vSxMTAabDfm4V2ovahd1p11VSzVsRKGADuflYecGM89lVpJfAj2f9f+AfeN7ttgyf4yF+svQoH6vg65U5GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zTNe30g3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zTNe30g3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E346C4CEF0;
	Sun,  7 Sep 2025 20:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277870;
	bh=f858sCHZnMVN3rOhb+TmRESR29M36DmAqgFZpSX8cSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zTNe30g3BagDeufoI1/XNKa26UwQZ7dRcoH2AU2ZxWEJqQuUf2nVa4F6bN0GiFlKv
	 hhXPZ5MvYnbOJ0vs+ihf87M+SxEv7+YDy2d8UFMSygtJJpLCpvJZsAdCjikkBCwORK
	 LUIWVLBe+mYL8+5CuyKUf8iKnAala/r8YawXFosU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 148/183] pcmcia: omap: Add missing check for platform_get_resource
Date: Sun,  7 Sep 2025 21:59:35 +0200
Message-ID: <20250907195619.330346373@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 1b1dff56ec7b1..441cdf83f5a44 100644
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



