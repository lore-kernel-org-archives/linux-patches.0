Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F3420B7E0
	for <patches@lists.linux.dev>; Thu, 23 Jan 2025 08:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737621361; cv=none; b=TAK/+NBa3tCwOjn8+RQZoXJMPRtVGEhfpHIBgspadnkAe8icQBUgOYU2n5EZjPOCdHK/yYBP0m7dTRR++80ziIcahcrg56YxlWzh0AXzWqL0rR58ijDd3qiiKu/Hr6jMGM0QzA7Ky95Xq7fUsTnqThKyhTlZXpvj8qHmP+50Vk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737621361; c=relaxed/simple;
	bh=9d0NMu8Vr9pmkDsrgxwczUM/xGPN56RXc7d3r26kf7o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HSUvAR6aK4zpxQaKlRfvtYxSeeL9Q6UHZdM0+VnkA2Jm+A8mywhnfRatJvAAv6PZczXxT9vkE7MaPGFJ2eUWmwZNxRZHM+sau9jb9DU+4zaBk/dL6+Vj3C8Ei61PEsKv2JnD4PfPkVPdJqEf0zRaBttXVR5nbRwouD2IC8SDkNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=agSkFcRj; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="agSkFcRj"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-21675fd60feso12741555ad.2
        for <patches@lists.linux.dev>; Thu, 23 Jan 2025 00:35:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737621359; x=1738226159; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nRuUrZ+X/fNLuM+96mPvasp0f1sEW4x60a4HaBMx6cw=;
        b=agSkFcRj9hvit2CvrnNT+9w4preFKFZ3RHMmOS/ePnLpvlsQCttW3C3SqJpxF0Frdu
         DI4/YWe3kXS/Kh9a8nlaEuf7LI7Sh0zCUqOBud84E1KyqKY3Nnp/uhRQ+ypR9IMLAz9R
         L3ESLHZWIBVCYi55+yElr7DpPh+wDO0IyCYkx8LG6ba/imodCuW3r6ZLdJEKcZOV/j+7
         lZUp0PR9cvgtupJr02flsIubq4uGmAVrD+FSxwY0vHCtgFCStSL88YKVsg73rPTQMLXJ
         ITlA8YWn63c/xkYkpXgNiI3xW8WhBM6ulQBJLxxZu2jGX7V13FROKawleHnftnDvFrn0
         kiPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737621359; x=1738226159;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nRuUrZ+X/fNLuM+96mPvasp0f1sEW4x60a4HaBMx6cw=;
        b=nKSjDvodC935yN6OoCph2RM4Hj2j6tTqBo+vtkQWgZZZ+qwJnXH55+z31+mZXNEfeb
         blT5gxfqBtAJUWX2fiHzQFGyJPyjjTJlsAWXzGKY8LzmLfnUSxQXjbXG4h89LZdyf5Al
         5a4Ejnd1YryoujFtcHTs/1Qpy8Z97TT+0D1pBINXHRR6B+1jxbWDavDHufDjWWCIgTI7
         phzCIvWCAvE7KQVQyuuGunEGbvsZImZ7zZXukXStq/ZbYqwfzi2c7TBlJhu/ifSjM+V5
         6rChDGq7Ai3GGZRtU7To3oyerdlPmO6hTDSBnFI7Z4uggBHUKj7gpOtWV8WIj7iHhQ07
         305A==
X-Gm-Message-State: AOJu0YxCdhtmP+Hkzxfg8dlVVzn2HfJPod67pxYfyV3oZeeh5Ttox8hD
	jO5QL3h1Jn1gH4iwIvyARX8K4zSYu28x/r7SxYbN5uyxy+DKoHq+
X-Gm-Gg: ASbGnctEXabw8uC5kGqvLbcbIsA32Bjk0ARiLytw4zDBEfOCVX3F8x2ZePZovFjsYuH
	1OdD0nhqsz30ovO0uAg83e/RdSs7vQM2awLs1mtVigbQfCiXBqvuWedqk7Z+49i93mFcDpnHwRd
	g7HPAcDpvwIqWM3RIHWKHUTsEk3Tcn+TaPRMObAlpXflN7pkxHFL3ltQlX1hURYhR/dEu52Yqfn
	ntS5HDdJJwy7xBke0TMF0uorSwUm8EYJVBG45GSFn07VgK50ce3YIGxecoPzNundAa3liXZHTmh
	X7oumbKFUnqA25ZG3tlEfPJWkLT4jPHLDI21HiIF
X-Google-Smtp-Source: AGHT+IHzBtes2/AcX/XzEEZhXMZD72Znl2Pf8eP22awI9v2aL/irqO6yWyjhrrziyaCoEGxFd235oA==
X-Received: by 2002:a05:6a00:369a:b0:726:f7c9:7b28 with SMTP id d2e1a72fcca58-72daf9bec24mr41966633b3a.8.1737621358930;
        Thu, 23 Jan 2025 00:35:58 -0800 (PST)
Received: from jren-d3.localdomain ([221.222.62.240])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72dab817385sm12982587b3a.68.2025.01.23.00.35.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2025 00:35:58 -0800 (PST)
From: Imkanmod Khan <imkanmodkhan@gmail.com>
To: stable@vger.kernel.org
Cc: patches@lists.linux.dev,
	kvalo@kernel.org,
	rand.sec96@gmail.com,
	m@bues.ch,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Imkanmod Khan <imkanmodkhan@gmail.com>
Subject: [PATCH 6.1.y] ssb: Fix potential NULL pointer dereference in ssb_device_uevent()
Date: Thu, 23 Jan 2025 16:35:51 +0800
Message-ID: <20250123083551.3400-1-imkanmodkhan@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Rand Deeb <rand.sec96@gmail.com>

[ Upstream commit 789c17185fb0f39560496c2beab9b57ce1d0cbe7 ]

The ssb_device_uevent() function first attempts to convert the 'dev' pointer
to 'struct ssb_device *'. However, it mistakenly dereferences 'dev' before
performing the NULL check, potentially leading to a NULL pointer
dereference if 'dev' is NULL.

To fix this issue, move the NULL check before dereferencing the 'dev' pointer,
ensuring that the pointer is valid before attempting to use it.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Rand Deeb <rand.sec96@gmail.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://msgid.link/20240306123028.164155-1-rand.sec96@gmail.com
Signed-off-by: Imkanmod Khan <imkanmodkhan@gmail.com>
---
 drivers/ssb/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
index d52e91258e98..aae50a5dfb57 100644
--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -341,11 +341,13 @@ static int ssb_bus_match(struct device *dev, struct device_driver *drv)
 
 static int ssb_device_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
-	struct ssb_device *ssb_dev = dev_to_ssb_dev(dev);
+	struct ssb_device *ssb_dev;
 
 	if (!dev)
 		return -ENODEV;
 
+	ssb_dev = dev_to_ssb_dev(dev);
+
 	return add_uevent_var(env,
 			     "MODALIAS=ssb:v%04Xid%04Xrev%02X",
 			     ssb_dev->id.vendor, ssb_dev->id.coreid,
-- 
2.25.1

