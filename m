Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0DE3806C1;
	Tue, 10 Mar 2026 11:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773140776; cv=none; b=JA9wLSpATaoZhiA7RbtEKDTluMwu0ME0s02boQumnWHHbx96nFY+o9k6bErJtfyvr2IbBMubkAf4NSJUr8WDv5iAMdOy/f4sx/JQR2Rf4MnX5aK4R6ZPs5m6PhicvC2rPDIJfWSUJxTM5VlPmzL/Hnd06+CK0tZ/s/qyWZNY26I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773140776; c=relaxed/simple;
	bh=5QurvBrlKao6PNW3VYI23cPsVbqWtnCOZOWq4i9pH7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hHRiKAvKSn2uM90qGZ5/d61+peBEZYZPW4CxrPVMUxJV26+6iLm2jTTQX8jozRciL735YV23pcv4kH1Vx0I7SdXEgv9wHSLLbSuI8thsOXXHxtYecek8W1KfYlOWNQh9kgWLnqONdMuORSIp8tvQAAdf9znN8jEIcapIOtJ9MyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=efoCPGna; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="efoCPGna"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30689C2BC9E;
	Tue, 10 Mar 2026 11:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773140775;
	bh=5QurvBrlKao6PNW3VYI23cPsVbqWtnCOZOWq4i9pH7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=efoCPGna4NS4vre8BH7tdLhwuQpBEZnc9tUSPfIGxbhyjD+3WIeJ7ldsBm5tOQAWA
	 74b6vItosmZHnRhVt3kNxFC5Hhx1XyUfqC/rwAneNjFl0Hh0e/P05mf8/iTYU5Lf9d
	 1/GXCct2QUbvEXvh9g7YCfmDMunZ1Ve/3aLDfrI3Vn0Jrpu0ubknrwxIdVBh07aazk
	 X58imr0zbW8Re9BPbZYIOqmHIVHUnLbjcydja43gi6V9tUfrzQbbUNbMA/eXDOaBjv
	 4X9bva0EsM5HCkRV8YKM37KuKbvaYASoV/uBeWBFWG0nWbk/L/lHpvZ72TsA0eLvvN
	 lA0XJIiAUzLMg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ethan Tidmore <ethantidmore06@gmail.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 009/311] drm/tiny: sharp-memory: fix pointer error dereference
Date: Tue, 10 Mar 2026 07:00:56 -0400
Message-ID: <e90413efd93d95e9f7d301bad12ad093b18fe8e2.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ethan Tidmore <ethantidmore06@gmail.com>

[ Upstream commit 46120745bb4e7e1f09959624716b4c5d6e2c2e9e ]

The function devm_drm_dev_alloc() returns a pointer error upon failure
not NULL. Change null check to pointer error check.

Detected by Smatch:
drivers/gpu/drm/tiny/sharp-memory.c:549 sharp_memory_probe() error:
'smd' dereferencing possible ERR_PTR()

Fixes: b8f9f21716fec ("drm/tiny: Add driver for Sharp Memory LCD")
Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patch.msgid.link/20260216040438.43702-1-ethantidmore06@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tiny/sharp-memory.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/tiny/sharp-memory.c b/drivers/gpu/drm/tiny/sharp-memory.c
index 64272cd0f6e22..cbf69460ebf32 100644
--- a/drivers/gpu/drm/tiny/sharp-memory.c
+++ b/drivers/gpu/drm/tiny/sharp-memory.c
@@ -541,8 +541,8 @@ static int sharp_memory_probe(struct spi_device *spi)
 
 	smd = devm_drm_dev_alloc(dev, &sharp_memory_drm_driver,
 				 struct sharp_memory_device, drm);
-	if (!smd)
-		return -ENOMEM;
+	if (IS_ERR(smd))
+		return PTR_ERR(smd);
 
 	spi_set_drvdata(spi, smd);
 
-- 
2.51.0

