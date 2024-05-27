Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDBD617E90E;
	Mon, 27 May 2024 19:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837247; cv=none; b=eL8fbco2uGdetaAY80SB8m1aQF5GMHDXm+b30q2JZEqeWq5PxmH0JCZNsLyDyLp5I/P+wXWFskhgLcoosFUhxysH2ptYvfiD5853CiztOwVsOVtBLGkhdkr4d7OtXpEfeKONuZU8ivMvq9c74fsblIciY0TfDd9hfB3UF0sWC2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837247; c=relaxed/simple;
	bh=jV6U9BSbuqhLwh/Gw4oraXNInLcKuwARLwEJmlE9XlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B58HK8/Wd9XlWgS5jw2R2GwXr1mpevGFdL1tY7jNZP9Ybzf0aZ11bvzOqhbvwFg1VcFGlimzf3EexbIBYUdwmghlNKtXahZblkazS4Ak4Y2Z+liYkrNSGpchbL1ODtFgUt1xGVPXPj1HiLPc8u2j4UGVYdWX+pIkpizy/26VWxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mXYBwXcZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mXYBwXcZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C68C2BBFC;
	Mon, 27 May 2024 19:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837247;
	bh=jV6U9BSbuqhLwh/Gw4oraXNInLcKuwARLwEJmlE9XlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mXYBwXcZEZEKVRzPV+Z7uMchKFrRqBLr8eTodLIHYjTcDWlr4CKkYUR+qJTMJgns6
	 MSAjmBI0XhslwMgX2AhXQgNY4v6KjBTg9HNrrXVLKagjuhORjr95yrfTy3cT17fh13
	 DpA1hWRm8BN59cocdoaMmhpx9LsYYjbxqQ4ujzko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 315/427] media: radio-shark2: Avoid led_names truncations
Date: Mon, 27 May 2024 20:56:02 +0200
Message-ID: <20240527185631.207620188@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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



