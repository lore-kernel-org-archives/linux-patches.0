Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EFE117727;
	Mon, 27 May 2024 19:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838437; cv=none; b=K0vGd8eWnSP8bMrqqOPi49PhaVnTFDLiLOhm7ltQRstK2HFm2Xe5p6y1KwwuEld9NJ9m6d132VUq+YiqbUMRTR2Hk1budEA/n0K4bKw5iXADHcD0YNii158tT9Ae8VvD6//wbv24fn1Vy5To5XS7MvF1cpiJ0/Qeuw3s5AORXfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838437; c=relaxed/simple;
	bh=U33fKBkTm+X3qhoJN4x3kqLfGLZzVaxcXEnIuUl8wLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eZqhOwcrQv0nhepWfedhNXdvCra6GH7ZJzDjAufFzYPhqVjy6YDWwdfIEvV9nzvaUE88Zqv4saj2jpyfw/5bZxHkIFPicznFg2M0izmuTzpi1t/DOAqkpeTPwQYaRQZHieZTa6L5MKhFkEY0V6Wi0GQPvOurAmjinBeeLsBg3jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pRmQY9up; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pRmQY9up"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E20CC2BBFC;
	Mon, 27 May 2024 19:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838437;
	bh=U33fKBkTm+X3qhoJN4x3kqLfGLZzVaxcXEnIuUl8wLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pRmQY9upQXTVFuvIcCkmnqbdM2Xfd6RmFW5cmcZd0U8r4KU1ordZYLXiv5M3IZSk7
	 cMF6S7XndtKXb7Y0OnXKndZnczQZ9o2hnojFbuAWm5oZFHOsrDMt8Fn9raCKKgzQlX
	 csNQ4mEQqRjbRLttK0gjyP1sBF7qfPsNqouIsKMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 390/493] media: radio-shark2: Avoid led_names truncations
Date: Mon, 27 May 2024 20:56:32 +0200
Message-ID: <20240527185643.022152358@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 1820e16a3019b6258e6009d34432946a6ddd0a90 ]

Increase the size of led_names so it can fit any valid v4l2 device name.

Fixes:
drivers/media/radio/radio-shark2.c:197:17: warning: ‘%s’ directive output may be truncated writing up to 35 bytes into a region of size 32 [-Wformat-truncation=]

Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/radio/radio-shark2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/radio/radio-shark2.c b/drivers/media/radio/radio-shark2.c
index f1c5c0a6a335c..e3e6aa87fe081 100644
--- a/drivers/media/radio/radio-shark2.c
+++ b/drivers/media/radio/radio-shark2.c
@@ -62,7 +62,7 @@ struct shark_device {
 #ifdef SHARK_USE_LEDS
 	struct work_struct led_work;
 	struct led_classdev leds[NO_LEDS];
-	char led_names[NO_LEDS][32];
+	char led_names[NO_LEDS][64];
 	atomic_t brightness[NO_LEDS];
 	unsigned long brightness_new;
 #endif
-- 
2.43.0



