Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F1271B0122;
	Thu,  6 Jun 2024 14:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683359; cv=none; b=U54CYr4GhLclh236Ctg0g4LjL7FKx6XepI+/EokKA4kGRQVsOQFPTYbC/zkn4F56p/kSpu3VJhG+6RRQ+fY19Rw30wCHH3kX0SsiQA7m782+OQpQZYhOwj0vFKuOzJiYD2swR8ENwzJ7yrEoDTleNGdCZtUjDUrVybPP0TrQIPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683359; c=relaxed/simple;
	bh=iGKedrnBnH18PoRaSy8YbrT6UeH6X4wNih4CgIFXBtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XQWSU6fGbTrYWo4szSMzuLXUJi4msDaPlq4JROfBkQkl+ih0mVPwFsfOXFc/KWBNVLpaYonPqMO/iR2MG5FNKVu2om47a7L5rDP0nq2hXc90Tffr58eGjOdn5IooLjArP49NAhoz9QZfXaOHe0DHxEWgxtTZNsYrxeBydFnQIT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fo9gG+w3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fo9gG+w3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70A15C2BD10;
	Thu,  6 Jun 2024 14:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683359;
	bh=iGKedrnBnH18PoRaSy8YbrT6UeH6X4wNih4CgIFXBtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fo9gG+w335laZUciZSzHw+haGd9Etoe0OCqaLFXZaI9jSBFJIUYb035jVLcy9c5kn
	 wmlfo7EhAtuwLBoQU2y/Jo4tb+bk5v3KYIARk3msyTjt5htxy11+08m2Rx++4CRZ9J
	 1e04fEwo1TLG3uOzWOzrgSx4SAhxOGKjPC7GqaMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 211/473] media: radio-shark2: Avoid led_names truncations
Date: Thu,  6 Jun 2024 16:02:20 +0200
Message-ID: <20240606131706.897537576@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



