Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E221D222D57;
	Thu, 12 Dec 2024 16:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022434; cv=none; b=WjnQiWKeTgN1n4sqOSPjInexcJpC1LnuJuOdYrGHS9LJrHFbEeeCWWCdu0mZ2JHm7F00uHznDRx/GudakzdS1TXcjw/KxZHWPFCJH0ytwFNCiA8WI315L0wV4VPkG929HvAVKpjzsjvaYa01ufYRFIJ4P5ATeLrao7DrLfhkKCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022434; c=relaxed/simple;
	bh=XqyRH3f3GfOiWryebxJwE/5opZw0Gz43WxfC9drRVG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iOUQZM7lznz9NebtNuzFEpW36TL/IkWdPAL231qcY+AGUU05SQ5WdWqSO5Dhw3Fh9wfeIK1NFsU7VDu+pIGPdm957JzCIK+9hYpNCsomkorM7nyNC0ECtwDebZd7eYNMZG7AERymVsYTo10M9C7xZAxyoiSadarcof0xy2NwQCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P1JzWtNd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P1JzWtNd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51E49C4CECE;
	Thu, 12 Dec 2024 16:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022433;
	bh=XqyRH3f3GfOiWryebxJwE/5opZw0Gz43WxfC9drRVG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P1JzWtNdq2hkApcpIw2OhxrIt/K1OKe4391QulixNvNdk4uU6h0MiYdg/HXatFBEO
	 2bEeQyNbkKdfo+aepAnq9VAv39/zNgOag8TyxkdIWUxFrj6QyR54IknmMfCkN2vebi
	 wt+BJsh3A9vt/UftbIK8mvBlUI46+GOe49tcvviU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhang jiao <zhangjiao2@cmss.chinamobile.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 239/565] pinctrl: k210: Undef K210_PC_DEFAULT
Date: Thu, 12 Dec 2024 15:57:14 +0100
Message-ID: <20241212144320.928614606@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

From: zhang jiao <zhangjiao2@cmss.chinamobile.com>

[ Upstream commit 7e86490c5dee5c41a55f32d0dc34269e200e6909 ]

When the temporary macro K210_PC_DEFAULT is not needed anymore,
use its name in the #undef statement instead of
the incorrect "DEFAULT" name.

Fixes: d4c34d09ab03 ("pinctrl: Add RISC-V Canaan Kendryte K210 FPIOA driver")
Signed-off-by: zhang jiao <zhangjiao2@cmss.chinamobile.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/20241113071201.5440-1-zhangjiao2@cmss.chinamobile.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-k210.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-k210.c b/drivers/pinctrl/pinctrl-k210.c
index ad4db99094a79..e75c96c6b3daf 100644
--- a/drivers/pinctrl/pinctrl-k210.c
+++ b/drivers/pinctrl/pinctrl-k210.c
@@ -181,7 +181,7 @@ static const u32 k210_pinconf_mode_id_to_mode[] = {
 	[K210_PC_DEFAULT_INT13] = K210_PC_MODE_IN | K210_PC_PU,
 };
 
-#undef DEFAULT
+#undef K210_PC_DEFAULT
 
 /*
  * Pin functions configuration information.
-- 
2.43.0



