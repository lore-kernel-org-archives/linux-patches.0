Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030420;
	b=ySBsV1m+huXB3Oe3DpNIZGyGNZ6aj51WQyet7vm0HNWOPl2qdGfIkyc6QPrs0RSHrxsO
	 ygebN+VrzhQ1RkeWz8PqRtFZSjEm6a/2GAMQGx31190WO9aSqgDJAvNztPrfubIJb9/VB
	 MFrt7FLl9lQFEE0yQsxxWBG3T105sm7nNu0oJkFhh4z0YKPcUN4MolIHg7iwy/gQjEaPo
	 bS7Gde2eJaOg5HXiadcf+4dDeFxGqblvHoBe4hDmfwHAXF5QKsSIS77N1ENlOfdOJjGCD
	 DwILIo1KA/gj9G780yrMN1wEjbWWNaNRWppnRO3yZYlpxLWbc32n7i+fPflo+ZnykWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030420;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=yYLtyd8TVdHp/DnazWP58mTZcBp/cW/GeyPxJa9bcUc=;
	b=hHLBeK4g8N329dh2iurfUpR6FeDMKI/UfAmG43ehYwQUllp7D3FAVRYIrL0+c+mLuh3x
	 +PeyrneVM6rYYR4zou/aRRbn9IsLOkhIXSdwjHZxF4zYPA1ZdYvuO8/S2KwQ2rC2nxluM
	 W+w9d5cBT6EPoccla2W96spDTaGrm4dvUJ/tcPE3pzj5CSf3hGsBcXgyZAaBA46tUl0Td
	 cBNUH7ZXH4O+YfwOeaZZbEGzYEJtQQeKzLfRhdkMt7TOGD7V2bscKRpUd2zPFb35LDoGp
	 FyzmCS13LkNRSb9e4xDoQCvfIeYycFa1SOUOdbYzw1TVGJMtn+2IEDZ579DXWKUbQYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L8xRUA5d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B59606A336;
	Wed, 18 Nov 2026 19:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L8xRUA5d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8B471F000C4;
	Wed, 18 Nov 2026 19:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030420;
	bh=yYLtyd8TVdHp/DnazWP58mTZcBp/cW/GeyPxJa9bcUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L8xRUA5dc4rk7Hg+pEi/LDcIFyh1ZWUVFhgaUa8vznCpJaFXMtGdBRj7pYMl/anXg
	 p4aHx0GHV5VBfUZQW3DIdmYJbQs3ybplDYwtJebWvNSSUFckFBFyHaty7ZnfBgBPix
	 ZQi+kE10ajySzQ28UPTqCyr+M+KA1ZM8lMtG5Bz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0699/1756] time: Prevent time64_to_tm() day truncation on 32-bit
Date: Wed, 18 Nov 2026 15:47:06 +0100
Message-ID: <20261118150037.020664721@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



