Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC7E26B2A3;
	Tue,  8 Apr 2025 12:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114370; cv=none; b=bAbyJgpon4gNfqAl/kwoBx33CVjeAaYwgLyIx7flwcwaugbgs0Cuk2JJLoxskSvs0oBhr6E1RIv9iUZ4laH//f3+x0XED82mCiguOqJIhFirQvTjnLNmL7iQ30AclmoZcjDnY22P6siIteSC4ZBB1qz5YFM1DN5JsfuWsfLhYVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114370; c=relaxed/simple;
	bh=WySOHKNQOaq1FLAqdIIm5yaeIdtOzoDNU8vjvd2C/CI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ruCK6W7cTXk25jv9ooV5W4p0ouzP/MFhUgUXJa21ThokOVDpXPuIGaSOwpzWfIJGOvHdAGJ00JcfIUS7etj+gdg7GyqBJgNllEwiX1/3ZkBXJUXaWk+a+S5G6GjeXXg1zU1c++PE7blELMftDubNNOWgRbtYttr6o6S8F2f8Uhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fthdbeAl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fthdbeAl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB64FC4CEE5;
	Tue,  8 Apr 2025 12:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114370;
	bh=WySOHKNQOaq1FLAqdIIm5yaeIdtOzoDNU8vjvd2C/CI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fthdbeAl0s2Qj45jLbfTH12FJUZDumZYheRjchoo8eJ5GKLm7CdFvu5GrrYvIZrN2
	 WGG19O10/EsVGa3rnTM/9FIviNxCB+WA4vGv44sOlhabYkGOHAFjY1QhQ1ivx8P4hw
	 t0TF87GDZcVzohSQr5l5xyrtvAJ+j4hnRWr3co4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Keeping <jkeeping@inmusicbrands.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 079/499] drm/panel: ilitek-ili9882t: fix GPIO name in error message
Date: Tue,  8 Apr 2025 12:44:51 +0200
Message-ID: <20250408104853.196775116@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Keeping <jkeeping@inmusicbrands.com>

[ Upstream commit 4ce2c7e201c265df1c62a9190a98a98803208b8f ]

This driver uses the enable-gpios property and it is confusing that the
error message refers to reset-gpios.  Use the correct name when the
enable GPIO is not found.

Fixes: e2450d32e5fb5 ("drm/panel: ili9882t: Break out as separate driver")
Signed-off-by: John Keeping <jkeeping@inmusicbrands.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20250217120428.3779197-1-jkeeping@inmusicbrands.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-ilitek-ili9882t.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-ilitek-ili9882t.c b/drivers/gpu/drm/panel/panel-ilitek-ili9882t.c
index 266a087fe14c1..3c24a63b6be8c 100644
--- a/drivers/gpu/drm/panel/panel-ilitek-ili9882t.c
+++ b/drivers/gpu/drm/panel/panel-ilitek-ili9882t.c
@@ -607,7 +607,7 @@ static int ili9882t_add(struct ili9882t *ili)
 
 	ili->enable_gpio = devm_gpiod_get(dev, "enable", GPIOD_OUT_LOW);
 	if (IS_ERR(ili->enable_gpio)) {
-		dev_err(dev, "cannot get reset-gpios %ld\n",
+		dev_err(dev, "cannot get enable-gpios %ld\n",
 			PTR_ERR(ili->enable_gpio));
 		return PTR_ERR(ili->enable_gpio);
 	}
-- 
2.39.5



