Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A3056458;
	Thu, 13 Jun 2024 12:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281063; cv=none; b=F5mfsl1b1/2lh/j1aZuJaL4DnYAx0E858Ng+VOhshild9Km3DnQ8il+bJDB8GQbiKsfmHZ1xwqypjZmCMzt8jFJugbwYH8IwQLvzXCihsN1ZgXnNSAlGrhTn94JDOsiwGo9lwrAFUQdSRzGVe8Z9QpVnWTaofBn0ILpfdFdkUNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281063; c=relaxed/simple;
	bh=lCiDnOHvhuGJqkrFSAvLM+Zas2y8di/Ukys+UFV6IxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Iz3j4cG8CpyX/bkJ8K+504pCToy/Wtl1W6OyrSslMw6G/KkHdRzvDIGnbt+HfKSX9sCxFz0+vH5eHZV26Fan3cJNqq7HsZHTJZv5iHlxKLFOoxlWyW2xdmCkzZwaSdmcwS+ygc0fPl0IxjlNBhwUWKEtQPH/ea8iRWBD0+4+Y5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tgCbwIoP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tgCbwIoP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C621C2BBFC;
	Thu, 13 Jun 2024 12:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281062;
	bh=lCiDnOHvhuGJqkrFSAvLM+Zas2y8di/Ukys+UFV6IxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tgCbwIoPEthul/eQ3qE4hvHFAR5XL3dRmweNmXx7gP8vAUYoR5GLJ0BI1i+tdot+M
	 a4ZsJO7aYXp8qUujtEiDpGrN4dCcvE9+yPpggFJ3As9Vqb69Hyp5LaM+Rj4+Oomm8u
	 lmv2lPKQ/yl/zatBc9eDbvE3sTftvz4FfL/Im+lc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 100/317] media: radio-shark2: Avoid led_names truncations
Date: Thu, 13 Jun 2024 13:31:58 +0200
Message-ID: <20240613113251.419865082@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



