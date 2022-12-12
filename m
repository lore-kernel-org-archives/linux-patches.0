Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 835CC28ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:15:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECDEEC433EF;
	Mon, 12 Dec 2022 13:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670850916;
	bh=lFjGZy635NdoFxSVWGMg/9MYUDXIrmraQx3ZM3OmtL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A3KI+Q93omhyMBgJs5j3Qwhr9g2rEU5SnKe/NBqDYR8pgXzZaUS/YgOBFIgH2K0xD
	 o5G8uLsxH6mNUZBm6SQFJqxk48yFlVBMATHM6SzjJfcVNaBwEyNLrvOAb/GKcvevj+
	 NMK8XQD/BHyLI7LHobnp21x8NRa9FXAxZ3Z79l68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@oracle.com>,
	=?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 063/106] rtc: mc146818-lib: fix signedness bug in mc146818_get_time()
Date: Mon, 12 Dec 2022 14:10:06 +0100
Message-Id: <20221212130927.634259574@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 7372971c1be5b7d4fdd8ad237798bdc1d1d54162 ]

The mc146818_get_time() function returns zero on success or negative
a error code on failure.  It needs to be type int.

Fixes: d35786b3a28d ("rtc: mc146818-lib: change return values of mc146818_get_time()")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20220111071922.GE11243@kili
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-mc146818-lib.c | 2 +-
 include/linux/mc146818rtc.h    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-mc146818-lib.c b/drivers/rtc/rtc-mc146818-lib.c
index 3783aaf9dd5a..347655d24b5d 100644
--- a/drivers/rtc/rtc-mc146818-lib.c
+++ b/drivers/rtc/rtc-mc146818-lib.c
@@ -103,7 +103,7 @@ bool mc146818_does_rtc_work(void)
 }
 EXPORT_SYMBOL_GPL(mc146818_does_rtc_work);
 
-unsigned int mc146818_get_time(struct rtc_time *time)
+int mc146818_get_time(struct rtc_time *time)
 {
 	unsigned char ctrl;
 	unsigned long flags;
diff --git a/include/linux/mc146818rtc.h b/include/linux/mc146818rtc.h
index fb042e0e7d76..b0da04fe087b 100644
--- a/include/linux/mc146818rtc.h
+++ b/include/linux/mc146818rtc.h
@@ -126,7 +126,7 @@ struct cmos_rtc_board_info {
 #endif /* ARCH_RTC_LOCATION */
 
 bool mc146818_does_rtc_work(void);
-unsigned int mc146818_get_time(struct rtc_time *time);
+int mc146818_get_time(struct rtc_time *time);
 int mc146818_set_time(struct rtc_time *time);
 
 bool mc146818_avoid_UIP(void (*callback)(unsigned char seconds, void *param),
-- 
2.35.1



