Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A3838758D;
	Tue, 10 Mar 2026 11:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141644; cv=none; b=M2JPZR+KpYNFOeNuP3dEEyf6Wi/0gb16uq/sbQE8FpbseKZ2Y5U8KPQj5BSPetRjvjaKhnzHFfI55O7LoikpDsR60g4ukIWE/c9VPFzEZcLQi5qZiBbig/9XAiwj60RrN2TCgFm/I+V7VSZeI2qU+2eeIEpkWSUyAM9ZroaUJG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141644; c=relaxed/simple;
	bh=5QurvBrlKao6PNW3VYI23cPsVbqWtnCOZOWq4i9pH7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kSGJtNFEWqcpPlzf0SJ5MP/7VYj8Le0o9R+6rC/ljpYMm7A0MrwYLve0thNRKgITQvH1KPU9lPfGhx4l1VsclnWH1L4m/5POHp3W07lHLqCoOxb2IydANBkSVMAjrtsEmnRXhjmgHTe/N8Scz4nxS2IprRL2JHG0MT5gsol5lL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B/hjRFLy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B/hjRFLy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42978C2BC9E;
	Tue, 10 Mar 2026 11:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141643;
	bh=5QurvBrlKao6PNW3VYI23cPsVbqWtnCOZOWq4i9pH7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B/hjRFLyUL7BxTBPE2SSycYPKeqx/SkLSwSNhYbvWd2rynfctcxUQQGCplGLM7vTY
	 CmqYLQtT6Xuq992pEfJvWsQ4YTjn/xuBoyQI4x/wAW9SLe99W3NUOr8Kb1C36CUEXZ
	 aFyQCBEG4mANI9FyiHKLQomvV0sl4q28rUjlPN7sx8jVmB87RrnJPLVGWTh0q+6Lo3
	 UiznWVTgVl9eknOmRJUUGC2Cgq5KBRHI5l/9C2V0PexHcajd7RsBnqMVmKzchMEjzf
	 U5jVAVNaMm4gY3FIGtN//FcOGKb1tyZeyQpU4U8HPjSp+/kwLAsxEDs1FNKprRmSQV
	 8RtXU5jUGcF+w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ethan Tidmore <ethantidmore06@gmail.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 009/314] drm/tiny: sharp-memory: fix pointer error dereference
Date: Tue, 10 Mar 2026 07:14:28 -0400
Message-ID: <7d149f4b38b654130f7bf88d54118b390e84da28.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
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

