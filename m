Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92AF41F75B4;
	Tue,  3 Dec 2024 15:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241585; cv=none; b=c4q56BMSw/WaCLg/t6R/ybcs9MQpiy+Eur1KX1m4ACG57ZmkVPJPOwRq7pNkKA12XDRVunjlju9I/4OiAfIdQ5sPITU1knPplFXXaULPKvGxBSHO5xqhLRcz9aeq1uTa74b+B7qhAQls+ukOVWD633d+ysHwVqIJWbmtBwmqUHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241585; c=relaxed/simple;
	bh=GUtQlEST33PzsFC1jwBaUD+Ixcd9DUtuEirMd3d8PKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tvHOytkFeGB6byZKhPEILkrJMS4aqttKpp2uf1hM2K+dCtzk1c1zSxheVWcUd2zsYfZJsTtR8ulntnxMVRvbe3ixkBdjLLW/5VvtapyNsmeH5CLGpyJ5+/dELPWFpapIJOjiovJ1EHIlHniu471pkU0SznPPurjczcGfFKUQbqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=poAINTmP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="poAINTmP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 064A0C4CECF;
	Tue,  3 Dec 2024 15:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241585;
	bh=GUtQlEST33PzsFC1jwBaUD+Ixcd9DUtuEirMd3d8PKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=poAINTmPws9/ccxnQNSmoukqy4FB0ykxjUY9h6AahY3ZbgaAKv3Tatn+tLVF3Oik0
	 mFM9agHRLbAGPUrxJUoe4kERsZJWqRx9sD42LilC2EfiAzPxSUzmLlxxA+d6enKHXf
	 jMMWihYSi2VxKeUS8FZVy7mBHmdUmQgz/XOw9wnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhang jiao <zhangjiao2@cmss.chinamobile.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 460/826] pinctrl: k210: Undef K210_PC_DEFAULT
Date: Tue,  3 Dec 2024 15:43:07 +0100
Message-ID: <20241203144801.700387122@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0f6b55fec31de..a71805997b028 100644
--- a/drivers/pinctrl/pinctrl-k210.c
+++ b/drivers/pinctrl/pinctrl-k210.c
@@ -183,7 +183,7 @@ static const u32 k210_pinconf_mode_id_to_mode[] = {
 	[K210_PC_DEFAULT_INT13] = K210_PC_MODE_IN | K210_PC_PU,
 };
 
-#undef DEFAULT
+#undef K210_PC_DEFAULT
 
 /*
  * Pin functions configuration information.
-- 
2.43.0



