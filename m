Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D384DE720;
	Wed, 30 Sep 2026 17:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788984; cv=none; b=hKAzugoFYAeodRdySXgh8cYtwPXf74/yZnYBUouO+BsHtzdSh/ZZ9T+Zg7nB0j7xO6/ZiPcVlCxnZpNYshYBJcgmlNb+3bDt6KlMTenSXop4C4N7IZMqte4/I/qpoHg2iyxn2aYuTUAFFxERuT68/c6aMh/vbn3zP1Q7fSI83ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788984; c=relaxed/simple;
	bh=Yk1ANwyxsddeIuIZ/cG0MAnV/Kng2FUwt+EZ0u6JwsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HUqycloLiU+S0IKZ9zj4WPG3kCYp93Wit9bgGlbCrgm/scbzrFOnxGaLtgkXVGz83A4554JPSCrVB5nkytjRO0+qrkNsIRrBpGJON3ug9ofAM+ONUC/Xyl7Odi5Vn8bjg+1vtghDEn6sAMFj9uMD/60fS2PjqUSUWlFLHJ9Kc78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pHLljDtf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pHLljDtf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BF541F000FF;
	Wed, 30 Sep 2026 17:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788982;
	bh=xyr7ljRz+v6VofDp4O/8rs8yzGxKj3P2C0J6jtcBdq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pHLljDtfbBFSXsTzNqDkqzi2b3P4Ro73NrDEsUU+n7tpiNyrkW6aA4pIguJxfPl3S
	 9MkK7AK++uMFJ5xWPXnuiiH4pd0b4PmQw9jit2w+DzAqKFa2MoQ07WN3L+GJuI5T2I
	 AAQUjKZqw8yEuYAAsWLgP5avzg8l9VImOaG0eCaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sanderson@brivo.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 318/877] pinctrl: meson: Fix typo in s4 group name
Date: Wed, 30 Sep 2026 17:20:29 +0200
Message-ID: <20260930152421.550767856@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Sean Anderson <sanderson@brivo.com>

[ Upstream commit 692f32609a30f75ca3401e25b504bfd06bd5662a ]

One of the i2c pin groups has some junk at the end. The name should be
i2c2_scl_h1, and indeed that's the name used by i2c2_pins3 in
meson-s4.dtsi.

Fixes: 775214d389c25 ("pinctrl: meson: add pinctrl driver support for Meson-S4 Soc")
Signed-off-by: Sean Anderson <sanderson@brivo.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/meson/pinctrl-meson-s4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/meson/pinctrl-meson-s4.c b/drivers/pinctrl/meson/pinctrl-meson-s4.c
index 872948699e9fe..365dafe457a9f 100644
--- a/drivers/pinctrl/meson/pinctrl-meson-s4.c
+++ b/drivers/pinctrl/meson/pinctrl-meson-s4.c
@@ -854,7 +854,7 @@ static const char * const i2c1_groups[] = {
 static const char * const i2c2_groups[] = {
 	"i2c2_sda_d", "i2c2_scl_d",
 	"i2c2_sda_h8", "i2c2_scl_h9",
-	"i2c2_sda_h0", "i2c2_scl_h1l,"
+	"i2c2_sda_h0", "i2c2_scl_h1",
 };
 
 static const char * const i2c3_groups[] = {
-- 
2.53.0



