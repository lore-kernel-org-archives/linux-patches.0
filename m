Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 923EE81AA7;
	Thu, 13 Jun 2024 12:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282018; cv=none; b=ZNoLrMzK0CIfVtCC8lP5Tigv5QUDK0/5EqFSSPfNaRoIi6L2Nw9tcqxb9e+Qj6jQ4lr2L4tKaI2xdkNYnHwTCKf1f4KE+eGSP/e8lY8MZis2k9cz6jHo1He/7FiNBca2IOb7Y7kf/J8cPQ78NCFKbTTY4Y6svIEBlXVUnqo2Xl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282018; c=relaxed/simple;
	bh=bhpMkoi6ItGZvOfW2/GEZp635wckwGAaQmyh9Fkx/T0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a+kquXtoketsxgwzmnvWkcBgRJILcFZsy/PDwPEk1ycIzq1JY24k63i+eFdPoRT02bDlrssUV/6U3NJyf7ruCQu47SsAxmJHeGQl9ppFWtlumt5P2AG6un9eALypjUSk+w16X/ATimiHNPruSRvFDVXuiZrz+FafVMc6/zifGs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sWi5W0C7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sWi5W0C7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7059C2BBFC;
	Thu, 13 Jun 2024 12:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282018;
	bh=bhpMkoi6ItGZvOfW2/GEZp635wckwGAaQmyh9Fkx/T0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sWi5W0C7TElh0aBbg5XWqX8b/CTWsmbc0Q4wxEFOs5e2MLKcfhGfpNCFv3mLCr5BD
	 JvWtmarCxvDFpgr2iXKZbrslRNFSJsFYMHLrMe4TxJn8BPUzoKcQ1OwRyhZx2ExZZh
	 o0Ug2jdpb/rPUNOpH6jaea7qRfJP5e2dEulXfhUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 134/402] media: radio-shark2: Avoid led_names truncations
Date: Thu, 13 Jun 2024 13:31:31 +0200
Message-ID: <20240613113307.363924104@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



