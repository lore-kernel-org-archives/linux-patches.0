Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061038;
	b=MqQlz4UnR5ISwhgM9Y7cbdIi4KtfMdThxj1dO7vhGvlfeSGAsJN5cg1azgY+7bDhRnZg
	 v7aeirlFyMx+qftbJ0kbSYqp/fMZbNODksu6wwpcIzCTDu7q+EEMyWTbpAMCuk2aT3Hwd
	 5fpDIIvXZVgmK2cQbYBUw9Y9PHr6J+l04YcsdMRpMfqEMldZPr1cj0BH+Z+M9cOA98bdB
	 BC9UtYDVgDJFlPuPozVEC6Rzq1uGsBRnf/Jx3YnAtVBptxMJgnXtkGtDyGor8MS1IJQdy
	 AvVwrK1m2+8RNGPsfoy3l1FnKTVphjP1EES8N+LF7qd4dm9EawjO+sxNin15rKgvqIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061038;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=w/pFNQSegCAvtaYAwZKczKwGWSKTXhAu4NWNrAdnT94=;
	b=gqFnPa6ChNxViHYnAhlSi9Xs2ugE90qTKNLAKIgzt5I0XUdipoJHq9BlEh8Q23kl3eij
	 N7880k1IVVi1Zu+BfrFb6oxDV4K86QUB3/pUMsq/Ujmehz7tSRxCUdjNq8vq+2FRPg4Md
	 hiHaPH1w6lKMAFIlosasyiG5IaydVPeyJ6o/ao3tW7XAhFgCDtpakRfCgKH9EZdxtXmc7
	 gji3mqziFrHmN0IqqB0ZIOv82hlHXiPF4wfoqh/WIripK7F1v6FwTk1tWBl0szwqINJ9s
	 eCUpcWBbtfxgYbPmI8awGbtEg+WYALkdGypemctPEn6eZc/NDCxYoRCFPjKLy1+Limw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V1RFc6Uc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1D6606A326;
	Thu, 19 Nov 2026 04:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V1RFc6Uc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA3271F000C4;
	Thu, 19 Nov 2026 04:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061038;
	bh=w/pFNQSegCAvtaYAwZKczKwGWSKTXhAu4NWNrAdnT94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V1RFc6UcIBPL8m1mJd2pqfe8WEVEBJjRqjExO9prFSB/lQmRvL7qMjyM/lGR1jEzx
	 NiiInsemV1WOuv+5fvPg7xvJ5+nRV3+Sk7xRa45yE7k0Wh5MCcK5IpNHADvfKxct+O
	 ZtYTZ5Vm79lkK+YF2ph43dLy+ntVKwkJOugQbJa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1410/1848] time: Prevent time64_to_tm() day truncation on 32-bit
Date: Wed, 18 Nov 2026 15:57:28 +0100
Message-ID: <20261118150018.545633521@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index fad126a4bb8c9..32a9988bcfe94 100644
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



