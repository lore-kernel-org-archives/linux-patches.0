Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4341019750D;
	Thu,  6 Jun 2024 14:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682953; cv=none; b=dRKSV/p2DycbcRwH6HTn3tl4PcRgemFQ/iiHNXueShL5SPkbzfA/eHbIG/HEktWVG/1OeEQx0ULLL3BlMTqQ9KZ+poYvVzRCD+ActytqrHOGJPm1327CLKhFi6SnbhA5YeWQxlP17mFpKue02LBaXVpzUrWdeVJwZbunOX7q6U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682953; c=relaxed/simple;
	bh=jaSLzcnKWXMWfogY6WKoE2+30ihdCfNcMPgTwKA/8RI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fSfXfdfw9Idf2a3jR3R+UK394CUwcROEHNRd9WgUg4w9FYErOff/uKkNRY1sUfRa0SO2G+o6BmX7Hpom0kyR0kJFkCgpudQLI1oEeTk+JZpcA5eXs7Q+5Qge/TouwnCKwIgE4ywHjNHYtCwzecLAmhC09BhjJWU2PHf/4BweRgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Npo05qT1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Npo05qT1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 197EDC2BD10;
	Thu,  6 Jun 2024 14:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682953;
	bh=jaSLzcnKWXMWfogY6WKoE2+30ihdCfNcMPgTwKA/8RI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Npo05qT1hM8i92Q6wEw81rRHPLLGJMl22oU4EcBIVuAnlqtQyBV6uVFsFrE7nPDrr
	 8grq80UyxG4+Dc/zfb3LdRsW0Xj5JEvuwieuZulN8poCruqQxYpi2yE0H56w37yaUR
	 rxqeK32RiVUJtZiK9d0DOpURKtmE5mZrdKc0lIQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Daniel Thompson <daniel.thompson@linaro.org>,
	Flavio Suligoi <f.suligoi@asem.it>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 117/374] backlight: mp3309c: Fix signedness bug in mp3309c_parse_fwnode()
Date: Thu,  6 Jun 2024 16:01:36 +0200
Message-ID: <20240606131655.849180887@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit e962f13b1e86272a5dcdaede2dfb649152e981e9 ]

The "num_levels" variable is used to store error codes from
device_property_count_u32() so it needs to be signed.  This doesn't
cause an issue at runtime because devm_kcalloc() won't allocate negative
sizes.  However, it's still worth fixing.

Fixes: b54c828bdba9 ("backlight: mp3309c: Make use of device properties")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>
Tested-by: Flavio Suligoi <f.suligoi@asem.it>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/74347f67-360d-4513-8939-595e3c4764fa@moroto.mountain
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/backlight/mp3309c.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/video/backlight/mp3309c.c b/drivers/video/backlight/mp3309c.c
index c80a1481e742b..4e98e60417d23 100644
--- a/drivers/video/backlight/mp3309c.c
+++ b/drivers/video/backlight/mp3309c.c
@@ -205,8 +205,9 @@ static int mp3309c_parse_fwnode(struct mp3309c_chip *chip,
 				struct mp3309c_platform_data *pdata)
 {
 	int ret, i;
-	unsigned int num_levels, tmp_value;
+	unsigned int tmp_value;
 	struct device *dev = chip->dev;
+	int num_levels;
 
 	if (!dev_fwnode(dev))
 		return dev_err_probe(dev, -ENODEV, "failed to get firmware node\n");
-- 
2.43.0



