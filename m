Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458803D7D7B;
	Wed, 20 May 2026 16:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296156; cv=none; b=lKSRt5Qe5umuv+EByVE81y9xEFgQ55k2AXf2z9z97QEfQ7d3D/KdYeFFcH10mSs+qkuj+kf8kf5cteTh20LxTs2WPt7AeWDQWKMU9Lb1iM/vSPotMyvXpGWNiXm5ckSo3IhrKwhvDamg3cSAnUuIdntHP7qgDlQWNZkG4pz68N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296156; c=relaxed/simple;
	bh=iNEQpT+XjaBnsYhAvKLZd9wHC4KiwTRCbnEh7JHimFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NqOsN9XfeYKE9aTtK80e8z8wyI2QCp/C9DB7OkpAj1GN8I7kVmP0yftcJ59vkHxMygB4Yl3V7TPiP2yVg58LyhcOQ6tktVSt+dEVNSPxRB0p7aDcQubtz7kKsHXYF6Pi9Q7KrEWKzIZ5Ebs+oHmmZ66XThBVz0mR001vJh1jiGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w/Z0aRDB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w/Z0aRDB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAEEA1F000E9;
	Wed, 20 May 2026 16:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296155;
	bh=PtyM9RCE45XQZDgKuo6oZaddY0lyNwG6/5Itm1whGXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w/Z0aRDB6vN4LS1/ki1352+rj/lgy1T0n4j5ludZ1665vGTAWPYFQhXA5Si1bnbHL
	 HxZ/DbIpG4q9mJiadEdCPjOA+3ylIVYE723HLrqJ4nTM5uuRc8h3IhCPDv+JjIbOBO
	 msKVaUZRny2KSmr4vzMRT5oazzgBwo3xzk//Ssro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Inochi Amaoto <inochiama@gmail.com>,
	Chen Wang <unicorn_wang@outlook.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0652/1146] pinctrl: sophgo: pinctrl-sg2044: Fix wrong module description
Date: Wed, 20 May 2026 18:15:02 +0200
Message-ID: <20260520162202.940542580@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Inochi Amaoto <inochiama@gmail.com>

[ Upstream commit 7648112358a4207916d3e38bfee49f85552fe95f ]

Fix the SoC model in module description string, it should be
sg2044 instead of sg2002.

Fixes: 614a54cb5ac3 ("pinctrl: sophgo: add support for SG2044 SoC")
Signed-off-by: Inochi Amaoto <inochiama@gmail.com>
Reviewed-by: Chen Wang <unicorn_wang@outlook.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sophgo/pinctrl-sg2044.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/sophgo/pinctrl-sg2044.c b/drivers/pinctrl/sophgo/pinctrl-sg2044.c
index b0c46d8954ca1..cf0b674c038f0 100644
--- a/drivers/pinctrl/sophgo/pinctrl-sg2044.c
+++ b/drivers/pinctrl/sophgo/pinctrl-sg2044.c
@@ -714,5 +714,5 @@ static struct platform_driver sg2044_pinctrl_driver = {
 };
 module_platform_driver(sg2044_pinctrl_driver);
 
-MODULE_DESCRIPTION("Pinctrl driver for the SG2002 series SoC");
+MODULE_DESCRIPTION("Pinctrl driver for the SG2044 series SoC");
 MODULE_LICENSE("GPL");
-- 
2.53.0



