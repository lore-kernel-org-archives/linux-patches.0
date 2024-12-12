Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49322210E1;
	Thu, 12 Dec 2024 16:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019740; cv=none; b=d43WocXLEnbrU7LKZb54R3wCdzmJ9y55BboxhmF+QhOntN+K5Qm2W/LQIuPIVGyrpDxPT+QDPbXuuncOESgaG8m9ija3DdXQSvFA18lqRd5IUcR9gh1Em6HcEGEQbrhNRs337P3LTm7JySuqlcOOi78TIp+5ld1jX8BHLHv2JiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019740; c=relaxed/simple;
	bh=G0bD15sS6rA666Ely72FNLAzPXdxyBzyYJddhtRd+5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ObD55TM0/STFLGOhx/eRGXA3vwhkRx8iu47cZeho6FBWCvfLn2HFLHFBHh7lHeGMCJy0p/FzWlNwd6r5fPgwElkNeDtTsQjhZzhHnibQnaWAMk5cGvv4vjG712gCmmeEgrLnQfxpXinzRpTZsEeukqL4d48vlMYWYCiwQ5iGKAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YhnY4063; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YhnY4063"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29CF0C4CECE;
	Thu, 12 Dec 2024 16:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019740;
	bh=G0bD15sS6rA666Ely72FNLAzPXdxyBzyYJddhtRd+5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YhnY4063L+aM/d+xw8iUrd86JTGE3ko+dBQiXmcyPC4mJr17wFqN3VIZn2A79yOJz
	 e85XAS1v18dngPXPbqEWevO7Vilg+8smebGv8bKyeUjfs891Zy0LqqIclDmygvgB1b
	 r+y+We7+fr+79JR7f3Iqg6WbiAS2CxHSWOf0ZgFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhang jiao <zhangjiao2@cmss.chinamobile.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 258/772] pinctrl: k210: Undef K210_PC_DEFAULT
Date: Thu, 12 Dec 2024 15:53:23 +0100
Message-ID: <20241212144400.577404668@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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



