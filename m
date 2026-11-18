Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048830;
	b=M59CJeS7rG2DtBvcQXV8+7o7phqEkzA2Rka8iikS0cWkrgNnZddO1ytQz4+VvILQErGJ
	 voUA4M7e1gnuDI1yNERM87xK7iPutmMCAST47EioErYmEFASQy7JjGiTV2i6eUWOskub7
	 3NgEHwWMnXiv6NC6SgP5Q+JWiW96517K/JuDdKraCrE00MWmrdG/F5rzTJ0JfRxVsrfit
	 8p9VBcOaTL7hTKKg5rAe+DKf54dlTWM/1Xhu4Eca2umG+axbyxHfZgPjl1plEKmiW9X/3
	 WRXYNQxXn+CCb7K/aaMKxhyvIG6F5gETvT91Rq7iGXj8DLvg/JpXe3wPR0aewSXq1qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048830;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=8+8Nk2A1kH9/pd1cXGuQrSHePnMV1Nded3x3evLnxJ4=;
	b=mLx9AIhaj6o3irDShdPa1uiEnfQNLUoeDBi1a5eTc6BrV37N6dMxefs6XK0YBzQPD8rl
	 0nwRFOYRYbOijyt08vYrkUbxzj9JSewpCjuC5krEWJqaRIzR40gil8+0c9X2l13Un03jQ
	 rtcr/XSKVLudsfAk9UrWxE82OgaAsMZi9fg2IXGyxpU9VEUJZgVVljVf4ertOPjj63pFS
	 Ej20BVOx7TbksYTH7ribO4BcOXEylTa0VN9FHv2384/rJKqw3Rf0BQ5zyUJdbd2Hgs2vs
	 ersB9kTjEtnhJWhcLGzbybtKjJUyxU0EhlhfjRJ7GKVGj9WsQH8OgraYP4p6SeT2pWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZrXHlKXP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D623606A320;
	Thu, 19 Nov 2026 00:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZrXHlKXP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D52C61F000C5;
	Thu, 19 Nov 2026 00:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048830;
	bh=8+8Nk2A1kH9/pd1cXGuQrSHePnMV1Nded3x3evLnxJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZrXHlKXP0h9KAL5bRnp1b/txna4KZ5tn8MuGN2ZJP2mAYJGtQpuZUpDc+MQr8d62Z
	 vWYCoHbNr9sIs/AaAs7kgOS7u/mLeFJG6VwhKT8+dzht0Ryt1ukJhyZ26bhKvrSGUz
	 u674vFRjkf3qepkPBnhnnFy41LgncUoNXgDZDgWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2136/2857] time: Prevent time64_to_tm() day truncation on 32-bit
Date: Wed, 18 Nov 2026 15:52:50 +0100
Message-ID: <20261118150318.313046066@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 2927f7ca78448781e11a4623d347cd653c28adf6 ]

time64_to_tm() accepts a 64-bit seconds value, but stores the quotient in
long. On a 32-bit kernel the day count therefore wraps when it reaches
2^31, even though the corresponding year remains representable in
struct tm.

This is reachable when formatting externally supplied timestamps. For
example, NILFS recovery copies the little-endian 64-bit ss_create field
from an on-disk segment summary into time64_t. Its sysfs attributes then
print that value with %ptTs, whose formatter calls time64_to_tm(). A
corrupted image can consequently produce an architecture-dependent printed
date.

Keep the day quotient in s64 while leaving the seconds-within-day remainder
as long. Use div_s64_rem() for the weekday calculation so 32-bit builds do
not require compiler runtime division helpers.

Fixes: e6c2682a1da3 ("time: Add time64_to_tm()")
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Assisted-by: LLM
Reviewed-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Link: https://patch.msgid.link/20260925165702.51677-2-kmehltretter@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/timeconv.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/time/timeconv.c b/kernel/time/timeconv.c
index 59b922c826e77..aed3af950fa0b 100644
--- a/kernel/time/timeconv.c
+++ b/kernel/time/timeconv.c
@@ -49,8 +49,9 @@ void time64_to_tm(time64_t totalsecs, int offset, struct tm *result)
 	u32 u32tmp, day_of_century, year_of_century, day_of_year, month, day;
 	u64 u64tmp, udays, century, year;
 	bool is_Jan_or_Feb, is_leap_year;
-	long days, rem;
 	int remainder;
+	long rem;
+	s64 days;
 
 	days = div_s64_rem(totalsecs, SECS_PER_DAY, &remainder);
 	rem = remainder;
@@ -70,7 +71,8 @@ void time64_to_tm(time64_t totalsecs, int offset, struct tm *result)
 	result->tm_sec = rem % 60;
 
 	/* January 1, 1970 was a Thursday. */
-	result->tm_wday = (4 + days) % 7;
+	div_s64_rem(days + 4, 7, &remainder);
+	result->tm_wday = remainder;
 	if (result->tm_wday < 0)
 		result->tm_wday += 7;
 
-- 
2.53.0



