Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638EF2585
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:13:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E59BC433D2;
	Mon, 12 Dec 2022 13:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670850810;
	bh=rC4C5KlF/wH7iXW8BDp5Nlem5dbuIJAtxKq0LpLwA5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hKIjWl+g+AVrWFnlZoAKnuo2NzPiWf82QewSl8uCWOcsZ7npKa1M+b0OXoM0rzc6B
	 +gf0eHOqPBXT5A6WIgHxGH3/ve4vm9ajmEdqi5HTyPmAlOT6sS9I1oGgmX4u6DasFk
	 2gOYv9Tz16aH0e9lYzQISLmvC272q8YOCaRwU7CU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
	Alessandro Zummo <a.zummo@towertech.it>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 034/106] rtc: mc146818-lib: change return values of mc146818_get_time()
Date: Mon, 12 Dec 2022 14:09:37 +0100
Message-Id: <20221212130926.349551396@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
References: <20221212130924.863767275@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mateusz Jończyk <mat.jonczyk@o2.pl>

[ Upstream commit d35786b3a28dee20b12962ae2dd365892a99ed1a ]

No function is checking mc146818_get_time() return values yet, so
correct them to make them more customary.

Signed-off-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20211210200131.153887-3-mat.jonczyk@o2.pl
Stable-dep-of: cd17420ebea5 ("rtc: cmos: avoid UIP when writing alarm time")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-mc146818-lib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-mc146818-lib.c b/drivers/rtc/rtc-mc146818-lib.c
index 6ed2cd5d2bba..6262f0680f13 100644
--- a/drivers/rtc/rtc-mc146818-lib.c
+++ b/drivers/rtc/rtc-mc146818-lib.c
@@ -25,7 +25,7 @@ unsigned int mc146818_get_time(struct rtc_time *time)
 	if (WARN_ON_ONCE((CMOS_READ(RTC_VALID) & 0x40) != 0)) {
 		spin_unlock_irqrestore(&rtc_lock, flags);
 		memset(time, 0xff, sizeof(*time));
-		return 0;
+		return -EIO;
 	}
 
 	/*
@@ -116,7 +116,7 @@ unsigned int mc146818_get_time(struct rtc_time *time)
 
 	time->tm_mon--;
 
-	return RTC_24H;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(mc146818_get_time);
 
-- 
2.35.1



