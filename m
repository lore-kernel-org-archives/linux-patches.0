Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0707C400E07;
	Wed, 20 May 2026 18:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302400; cv=none; b=dvcB0jNfSYt87teUMeHm8jmS4s0iBNZsL5tEwlaBt6/juqjvo1ky68e3hw9h/LGLV77kZxGxajM6Xj7Bgw1ALigCwzRy3RiuwHdMrZp+z1/OhLpTeNGnuftznqGZ4eGKBrby4qwyOeEguX0no9NaHqGCPrl+tiA5P40WBZZ/SCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302400; c=relaxed/simple;
	bh=8QGNDv99avdARFlB4goBWufW636Hrff9XEYbW2r1NZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z9DnOMaeEaHF7E7DkB7f8KbLt+imh9r/OPiW4MKM82+i/p1nK/UCjWSyA0Tx13ZRI6WmEPzlgYSAkps8MwLrYJJIvHqTqh4QKfTtnkSwEMHRRQYDACokq4SE1dHOyGt7ob48srrFDfrilDmK7llBR4zX3JrsVzjCI57735B9fM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KNhpwIiv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KNhpwIiv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5258C1F00897;
	Wed, 20 May 2026 18:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302398;
	bh=K41ttXtU2Qg19BtuTIeVpWTxOmdf7lC7lpiGWGC5pqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KNhpwIivDHVHdCqjJUh0A/ESUGjg4vyWHvPJ+9rfBFCORuwSzimud3zQ9tsF19Eup
	 +32QDMXZVF8nRoOjND7Wa4zv+YsHkcMYMqO48XrHkCHQNhJMjyioJ4yd/ST5NoEn3/
	 jazjA+3+gvIcA6r2II7IHVbk9k9Wg/hfkayES3QQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu-Chun Lin <eleanor15x@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 250/508] pinctrl: abx500: Fix type of argument variable
Date: Wed, 20 May 2026 18:21:13 +0200
Message-ID: <20260520162104.066645469@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu-Chun Lin <eleanor15x@gmail.com>

[ Upstream commit 34006f77890d050e6d80cbee365b5d703c1140b4 ]

The argument variable is assigned the return value of
pinconf_to_config_argument(), which returns a u32. Change its type from
enum pin_config_param to unsigned int to correctly store the configuration
argument.

Fixes: 03b054e9696c ("pinctrl: Pass all configs to driver on pin_config_set()")
Signed-off-by: Yu-Chun Lin <eleanor15x@gmail.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/nomadik/pinctrl-abx500.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/nomadik/pinctrl-abx500.c b/drivers/pinctrl/nomadik/pinctrl-abx500.c
index 0cfa74365733c..a4940199f2ad0 100644
--- a/drivers/pinctrl/nomadik/pinctrl-abx500.c
+++ b/drivers/pinctrl/nomadik/pinctrl-abx500.c
@@ -853,7 +853,7 @@ static int abx500_pin_config_set(struct pinctrl_dev *pctldev,
 	int ret = -EINVAL;
 	int i;
 	enum pin_config_param param;
-	enum pin_config_param argument;
+	unsigned int argument;
 
 	for (i = 0; i < num_configs; i++) {
 		param = pinconf_to_config_param(configs[i]);
-- 
2.53.0



