Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4123E3B9D90;
	Mon, 23 Mar 2026 16:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282639; cv=none; b=aVgPoMBsnL58riul7aN9qjZj63TqBEY9gHnKT4G38peKIaQtVoHQjB2ZoDEBqb623553lLgKl5gy+i/BHvEDhIuZjkH5/dApNNKfwfAPv3A86+9cRww/cSf0P6ybwsOd3LXcbsnOEfP3fTcXhhIX9j1UZEhB4w5doNcVdG4QXcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282639; c=relaxed/simple;
	bh=5PUeDAbHDTu6wq4dQ47hPuwz6+nS0aDTxsinDPKiV1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tQWmJE2zhfeRWDy0zsKQvY68XDSFVza4JBJ/5/IyVBPdkvogzrlN/4f3c6tmlCyYvRpn4wP6cWz/hN/OhDJixaw5XomC7HZYQAQmg/EUWSzTvSv0Y87ySRkzOrmMhZJjv6AchEXoEnaGFdZfjzOhosgpNGlJBRO2ye/dbWNixWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BrSsQ+UQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BrSsQ+UQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D91AC4CEF7;
	Mon, 23 Mar 2026 16:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282638;
	bh=5PUeDAbHDTu6wq4dQ47hPuwz6+nS0aDTxsinDPKiV1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BrSsQ+UQtAWHx+yHPWW46ebQpk9YRhYZC40P3u5FmFC7JA8ws1AqNuN2jy9XMDxnh
	 LBUuLhER+BEyf/1ci3+P/xlgE5Ff1/ZKmvaTXJ/nKmA5x5sweRsXEaSUACh90Z54vk
	 9b09bCoF81DNQ53ff0T3YPc1m9ZzSRSIC2H1X9gs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	John Stultz <jstultz@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Stephen Boyd <sboyd@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 229/481] time: add kernel-doc in time.c
Date: Mon, 23 Mar 2026 14:43:31 +0100
Message-ID: <20260323134530.720347788@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 67b3f564cb1e769ef8e45835129a4866152fcfdb ]

Add kernel-doc for all APIs that do not already have it.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: John Stultz <jstultz@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
Acked-by: John Stultz <jstultz@google.com>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Link: https://lore.kernel.org/r/20230704052405.5089-3-rdunlap@infradead.org
Stable-dep-of: 755a648e78f1 ("time/jiffies: Mark jiffies_64_to_clock_t() notrace")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/time.c | 169 ++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 158 insertions(+), 11 deletions(-)

diff --git a/kernel/time/time.c b/kernel/time/time.c
index a92c7f3277ad6..be42ace51255c 100644
--- a/kernel/time/time.c
+++ b/kernel/time/time.c
@@ -365,11 +365,14 @@ SYSCALL_DEFINE1(adjtimex_time32, struct old_timex32 __user *, utp)
 }
 #endif
 
-/*
- * Convert jiffies to milliseconds and back.
+/**
+ * jiffies_to_msecs - Convert jiffies to milliseconds
+ * @j: jiffies value
  *
  * Avoid unnecessary multiplications/divisions in the
- * two most common HZ cases:
+ * two most common HZ cases.
+ *
+ * Return: milliseconds value
  */
 unsigned int jiffies_to_msecs(const unsigned long j)
 {
@@ -388,6 +391,12 @@ unsigned int jiffies_to_msecs(const unsigned long j)
 }
 EXPORT_SYMBOL(jiffies_to_msecs);
 
+/**
+ * jiffies_to_usecs - Convert jiffies to microseconds
+ * @j: jiffies value
+ *
+ * Return: microseconds value
+ */
 unsigned int jiffies_to_usecs(const unsigned long j)
 {
 	/*
@@ -408,8 +417,15 @@ unsigned int jiffies_to_usecs(const unsigned long j)
 }
 EXPORT_SYMBOL(jiffies_to_usecs);
 
-/*
+/**
  * mktime64 - Converts date to seconds.
+ * @year0: year to convert
+ * @mon0: month to convert
+ * @day: day to convert
+ * @hour: hour to convert
+ * @min: minute to convert
+ * @sec: second to convert
+ *
  * Converts Gregorian date to seconds since 1970-01-01 00:00:00.
  * Assumes input in normal date format, i.e. 1980-12-31 23:59:59
  * => year=1980, mon=12, day=31, hour=23, min=59, sec=59.
@@ -427,6 +443,8 @@ EXPORT_SYMBOL(jiffies_to_usecs);
  *
  * An encoding of midnight at the end of the day as 24:00:00 - ie. midnight
  * tomorrow - (allowable under ISO 8601) is supported.
+ *
+ * Return: seconds since the epoch time for the given input date
  */
 time64_t mktime64(const unsigned int year0, const unsigned int mon0,
 		const unsigned int day, const unsigned int hour,
@@ -471,8 +489,7 @@ EXPORT_SYMBOL(ns_to_kernel_old_timeval);
  * Set seconds and nanoseconds field of a timespec variable and
  * normalize to the timespec storage format
  *
- * Note: The tv_nsec part is always in the range of
- *	0 <= tv_nsec < NSEC_PER_SEC
+ * Note: The tv_nsec part is always in the range of 0 <= tv_nsec < NSEC_PER_SEC.
  * For negative values only the tv_sec field is negative !
  */
 void set_normalized_timespec64(struct timespec64 *ts, time64_t sec, s64 nsec)
@@ -501,7 +518,7 @@ EXPORT_SYMBOL(set_normalized_timespec64);
  * ns_to_timespec64 - Convert nanoseconds to timespec64
  * @nsec:       the nanoseconds value to be converted
  *
- * Returns the timespec64 representation of the nsec parameter.
+ * Return: the timespec64 representation of the nsec parameter.
  */
 struct timespec64 ns_to_timespec64(s64 nsec)
 {
@@ -548,6 +565,8 @@ EXPORT_SYMBOL(ns_to_timespec64);
  * runtime.
  * the _msecs_to_jiffies helpers are the HZ dependent conversion
  * routines found in include/linux/jiffies.h
+ *
+ * Return: jiffies value
  */
 unsigned long __msecs_to_jiffies(const unsigned int m)
 {
@@ -560,6 +579,12 @@ unsigned long __msecs_to_jiffies(const unsigned int m)
 }
 EXPORT_SYMBOL(__msecs_to_jiffies);
 
+/**
+ * __usecs_to_jiffies: - convert microseconds to jiffies
+ * @u:	time in milliseconds
+ *
+ * Return: jiffies value
+ */
 unsigned long __usecs_to_jiffies(const unsigned int u)
 {
 	if (u > jiffies_to_usecs(MAX_JIFFY_OFFSET))
@@ -568,7 +593,10 @@ unsigned long __usecs_to_jiffies(const unsigned int u)
 }
 EXPORT_SYMBOL(__usecs_to_jiffies);
 
-/*
+/**
+ * timespec64_to_jiffies - convert a timespec64 value to jiffies
+ * @value: pointer to &struct timespec64
+ *
  * The TICK_NSEC - 1 rounds up the value to the next resolution.  Note
  * that a remainder subtract here would not do the right thing as the
  * resolution values don't fall on second boundaries.  I.e. the line:
@@ -582,8 +610,9 @@ EXPORT_SYMBOL(__usecs_to_jiffies);
  *
  * The >> (NSEC_JIFFIE_SC - SEC_JIFFIE_SC) converts the scaled nsec
  * value to a scaled second value.
+ *
+ * Return: jiffies value
  */
-
 unsigned long
 timespec64_to_jiffies(const struct timespec64 *value)
 {
@@ -601,6 +630,11 @@ timespec64_to_jiffies(const struct timespec64 *value)
 }
 EXPORT_SYMBOL(timespec64_to_jiffies);
 
+/**
+ * jiffies_to_timespec64 - convert jiffies value to &struct timespec64
+ * @jiffies: jiffies value
+ * @value: pointer to &struct timespec64
+ */
 void
 jiffies_to_timespec64(const unsigned long jiffies, struct timespec64 *value)
 {
@@ -618,6 +652,13 @@ EXPORT_SYMBOL(jiffies_to_timespec64);
 /*
  * Convert jiffies/jiffies_64 to clock_t and back.
  */
+
+/**
+ * jiffies_to_clock_t - Convert jiffies to clock_t
+ * @x: jiffies value
+ *
+ * Return: jiffies converted to clock_t (CLOCKS_PER_SEC)
+ */
 clock_t jiffies_to_clock_t(unsigned long x)
 {
 #if (TICK_NSEC % (NSEC_PER_SEC / USER_HZ)) == 0
@@ -632,6 +673,12 @@ clock_t jiffies_to_clock_t(unsigned long x)
 }
 EXPORT_SYMBOL(jiffies_to_clock_t);
 
+/**
+ * clock_t_to_jiffies - Convert clock_t to jiffies
+ * @x: clock_t value
+ *
+ * Return: clock_t value converted to jiffies
+ */
 unsigned long clock_t_to_jiffies(unsigned long x)
 {
 #if (HZ % USER_HZ)==0
@@ -649,6 +696,12 @@ unsigned long clock_t_to_jiffies(unsigned long x)
 }
 EXPORT_SYMBOL(clock_t_to_jiffies);
 
+/**
+ * jiffies_64_to_clock_t - Convert jiffies_64 to clock_t
+ * @x: jiffies_64 value
+ *
+ * Return: jiffies_64 value converted to 64-bit "clock_t" (CLOCKS_PER_SEC)
+ */
 u64 jiffies_64_to_clock_t(u64 x)
 {
 #if (TICK_NSEC % (NSEC_PER_SEC / USER_HZ)) == 0
@@ -671,6 +724,12 @@ u64 jiffies_64_to_clock_t(u64 x)
 }
 EXPORT_SYMBOL(jiffies_64_to_clock_t);
 
+/**
+ * nsec_to_clock_t - Convert nsec value to clock_t
+ * @x: nsec value
+ *
+ * Return: nsec value converted to 64-bit "clock_t" (CLOCKS_PER_SEC)
+ */
 u64 nsec_to_clock_t(u64 x)
 {
 #if (NSEC_PER_SEC % USER_HZ) == 0
@@ -687,6 +746,12 @@ u64 nsec_to_clock_t(u64 x)
 #endif
 }
 
+/**
+ * jiffies64_to_nsecs - Convert jiffies64 to nanoseconds
+ * @j: jiffies64 value
+ *
+ * Return: nanoseconds value
+ */
 u64 jiffies64_to_nsecs(u64 j)
 {
 #if !(NSEC_PER_SEC % HZ)
@@ -697,6 +762,12 @@ u64 jiffies64_to_nsecs(u64 j)
 }
 EXPORT_SYMBOL(jiffies64_to_nsecs);
 
+/**
+ * jiffies64_to_msecs - Convert jiffies64 to milliseconds
+ * @j: jiffies64 value
+ *
+ * Return: milliseconds value
+ */
 u64 jiffies64_to_msecs(const u64 j)
 {
 #if HZ <= MSEC_PER_SEC && !(MSEC_PER_SEC % HZ)
@@ -719,6 +790,8 @@ EXPORT_SYMBOL(jiffies64_to_msecs);
  * note:
  *   NSEC_PER_SEC = 10^9 = (5^9 * 2^9) = (1953125 * 512)
  *   ULLONG_MAX ns = 18446744073.709551615 secs = about 584 years
+ *
+ * Return: nsecs converted to jiffies64 value
  */
 u64 nsecs_to_jiffies64(u64 n)
 {
@@ -750,6 +823,8 @@ EXPORT_SYMBOL(nsecs_to_jiffies64);
  * note:
  *   NSEC_PER_SEC = 10^9 = (5^9 * 2^9) = (1953125 * 512)
  *   ULLONG_MAX ns = 18446744073.709551615 secs = about 584 years
+ *
+ * Return: nsecs converted to jiffies value
  */
 unsigned long nsecs_to_jiffies(u64 n)
 {
@@ -757,10 +832,16 @@ unsigned long nsecs_to_jiffies(u64 n)
 }
 EXPORT_SYMBOL_GPL(nsecs_to_jiffies);
 
-/*
- * Add two timespec64 values and do a safety check for overflow.
+/**
+ * timespec64_add_safe - Add two timespec64 values and do a safety check
+ * for overflow.
+ * @lhs: first (left) timespec64 to add
+ * @rhs: second (right) timespec64 to add
+ *
  * It's assumed that both values are valid (>= 0).
  * And, each timespec64 is in normalized form.
+ *
+ * Return: sum of @lhs + @rhs
  */
 struct timespec64 timespec64_add_safe(const struct timespec64 lhs,
 				const struct timespec64 rhs)
@@ -778,6 +859,15 @@ struct timespec64 timespec64_add_safe(const struct timespec64 lhs,
 	return res;
 }
 
+/**
+ * get_timespec64 - get user's time value into kernel space
+ * @ts: destination &struct timespec64
+ * @uts: user's time value as &struct __kernel_timespec
+ *
+ * Handles compat or 32-bit modes.
+ *
+ * Return: %0 on success or negative errno on error
+ */
 int get_timespec64(struct timespec64 *ts,
 		   const struct __kernel_timespec __user *uts)
 {
@@ -801,6 +891,14 @@ int get_timespec64(struct timespec64 *ts,
 }
 EXPORT_SYMBOL_GPL(get_timespec64);
 
+/**
+ * put_timespec64 - convert timespec64 value to __kernel_timespec format and
+ * 		    copy the latter to userspace
+ * @ts: input &struct timespec64
+ * @uts: user's &struct __kernel_timespec
+ *
+ * Return: %0 on success or negative errno on error
+ */
 int put_timespec64(const struct timespec64 *ts,
 		   struct __kernel_timespec __user *uts)
 {
@@ -839,6 +937,15 @@ static int __put_old_timespec32(const struct timespec64 *ts64,
 	return copy_to_user(cts, &ts, sizeof(ts)) ? -EFAULT : 0;
 }
 
+/**
+ * get_old_timespec32 - get user's old-format time value into kernel space
+ * @ts: destination &struct timespec64
+ * @uts: user's old-format time value (&struct old_timespec32)
+ *
+ * Handles X86_X32_ABI compatibility conversion.
+ *
+ * Return: %0 on success or negative errno on error
+ */
 int get_old_timespec32(struct timespec64 *ts, const void __user *uts)
 {
 	if (COMPAT_USE_64BIT_TIME)
@@ -848,6 +955,16 @@ int get_old_timespec32(struct timespec64 *ts, const void __user *uts)
 }
 EXPORT_SYMBOL_GPL(get_old_timespec32);
 
+/**
+ * put_old_timespec32 - convert timespec64 value to &struct old_timespec32 and
+ * 			copy the latter to userspace
+ * @ts: input &struct timespec64
+ * @uts: user's &struct old_timespec32
+ *
+ * Handles X86_X32_ABI compatibility conversion.
+ *
+ * Return: %0 on success or negative errno on error
+ */
 int put_old_timespec32(const struct timespec64 *ts, void __user *uts)
 {
 	if (COMPAT_USE_64BIT_TIME)
@@ -857,6 +974,13 @@ int put_old_timespec32(const struct timespec64 *ts, void __user *uts)
 }
 EXPORT_SYMBOL_GPL(put_old_timespec32);
 
+/**
+ * get_itimerspec64 - get user's &struct __kernel_itimerspec into kernel space
+ * @it: destination &struct itimerspec64
+ * @uit: user's &struct __kernel_itimerspec
+ *
+ * Return: %0 on success or negative errno on error
+ */
 int get_itimerspec64(struct itimerspec64 *it,
 			const struct __kernel_itimerspec __user *uit)
 {
@@ -872,6 +996,14 @@ int get_itimerspec64(struct itimerspec64 *it,
 }
 EXPORT_SYMBOL_GPL(get_itimerspec64);
 
+/**
+ * put_itimerspec64 - convert &struct itimerspec64 to __kernel_itimerspec format
+ * 		      and copy the latter to userspace
+ * @it: input &struct itimerspec64
+ * @uit: user's &struct __kernel_itimerspec
+ *
+ * Return: %0 on success or negative errno on error
+ */
 int put_itimerspec64(const struct itimerspec64 *it,
 			struct __kernel_itimerspec __user *uit)
 {
@@ -887,6 +1019,13 @@ int put_itimerspec64(const struct itimerspec64 *it,
 }
 EXPORT_SYMBOL_GPL(put_itimerspec64);
 
+/**
+ * get_old_itimerspec32 - get user's &struct old_itimerspec32 into kernel space
+ * @its: destination &struct itimerspec64
+ * @uits: user's &struct old_itimerspec32
+ *
+ * Return: %0 on success or negative errno on error
+ */
 int get_old_itimerspec32(struct itimerspec64 *its,
 			const struct old_itimerspec32 __user *uits)
 {
@@ -898,6 +1037,14 @@ int get_old_itimerspec32(struct itimerspec64 *its,
 }
 EXPORT_SYMBOL_GPL(get_old_itimerspec32);
 
+/**
+ * put_old_itimerspec32 - convert &struct itimerspec64 to &struct
+ *			  old_itimerspec32 and copy the latter to userspace
+ * @its: input &struct itimerspec64
+ * @uits: user's &struct old_itimerspec32
+ *
+ * Return: %0 on success or negative errno on error
+ */
 int put_old_itimerspec32(const struct itimerspec64 *its,
 			struct old_itimerspec32 __user *uits)
 {
-- 
2.51.0



