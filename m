Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026922;
	b=oasWtYdEzcwA6Wa83VZTATicgduPLxexUlh3B6IXrjesGIFpiXcqmsqtCCN3KnnEZ7Pn
	 TuGTRNekHR06cXRAI7aha/6dKpH/SUghouGlhEqoUmfNR9C3lpsO19CylBew+PwDuPr2k
	 FNnHwuvtz+dRuDJZ1YSilegWCoFAtznCFWQ6oaNhVEExAfsaNgk88av9TcQKz8JLVRwOh
	 AO9KjdhNVk2mwUUT+Nn/ePEpIY9+EYYo8KS5+O/TvZnsIz//zlgwxlEWvwEGA7cjO283T
	 BJX94Dejb5+zuCu3RQ5KkSonehTnRL046BrjiiIwTw8+DtnFSM6fhrUpbciwGQ0b7zw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026922;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=NTE3yKkTPhfE+B19d6dMD+jnQ9mN50Dp10NfMHDcBjY=;
	b=N34adBF4U6hVs9VvqYFHDgs+ilE+TC9ru3JV9EO2YqpDbMck5CV3ZHRpzB4gJmiAQwdj
	 Xt1t3h4ZeIrWuZ1CMLL0efbOllLeYfSVD6tx1YbFx0dd3hwC1zsGz72q85oVJ7f5fJYFz
	 7PfUEjq1YO25FZuZIq8Fs/+rFBo30PzpzQHaj4X+2ahdKclcR77d0bHk9NwNDa1skNsDF
	 mJwyq6gTswjByKW+Lq7AOxVkgkpabsGhrGjk7kbbnbtCxIF5uHWxbcyM5G4KnH6G+jIWT
	 I3nYDjbPGzksnMS0Pww3jDEMMh0ILUYQfY8rgqb+Pr1UIhp3zCiF8Ybd7yp9vDvGTDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gfiproSe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E879606A31C;
	Wed, 18 Nov 2026 18:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gfiproSe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D0F81F000C4;
	Wed, 18 Nov 2026 18:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026922;
	bh=NTE3yKkTPhfE+B19d6dMD+jnQ9mN50Dp10NfMHDcBjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gfiproSeiXezvjLGi2VCyEXVTPAKZKLN//HZxJrDRcvLvC75S4RVC1PGm8xls0W+c
	 tCDnL+z+qm4gELx2PS9LuqSjgZS7SIxwwWoDBoLZouZ5l2EbxttA1aGtxtKLT/F6oq
	 sGNiR5zYKS6qq0wSD8WAOaVbCG1a0nx9ZOwiluto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight.linux@gmail.com>,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Thomas Gleixner <tglx@kernel.org>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1608/2151] vdso/math64: Add and use __iter_div64_u64_rem()
Date: Wed, 18 Nov 2026 15:55:43 +0100
Message-ID: <20261118150220.445504991@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhan Xusheng <zhanxusheng1024@gmail.com>

[ Upstream commit dcd65074e2c593a06bed36178bba6d49d6b6883c ]

The vDSO basetimes for CLOCK_MONOTONIC and CLOCK_BOOTTIME are stored in
the scaled nanoseconds of tkr_mono, so normalising them requires a
division by NSEC_PER_SEC << shift.  That divisor does not fit the u32
parameter of __iter_div_u64_rem(), so update_vdso_time_data() open-codes
the same iterative division twice.

Repeated subtraction is the appropriate form at these two sites because
the quotient never exceeds one.  accumulate_nsecs_to_secs() keeps
xtime_nsec below one scaled second, and the offset added to it is a
normalised timespec64 fraction, so the dividend stays below twice the
divisor.  That bound holds on every architecture, which matters more here
than the cost of a division on any particular one.

Add __iter_div64_u64_rem(), the u64-divisor counterpart of
__iter_div_u64_rem(), and use it at both sites.  Return the quotient as a
u32 for consistency with the u32-divisor variant; the bound above leaves
no use for a wider type.

Store the remainder directly into the basetime, as the coarse clocks
already do.  The CLOCK_BOOTTIME copy of the CLOCK_MONOTONIC values then
takes both fields from the same place.

Folding the two open-coded loops into one inlined helper removes 16 bytes
of vsyscall.o text on x86-64 with gcc 13.

No functional change.

Suggested-by: David Laight <david.laight.linux@gmail.com>
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Link: https://patch.msgid.link/20261002153104.1347978-3-zhanxusheng@xiaomi.com
Stable-dep-of: 8d17190fae2c ("vdso/vsyscall: Keep the CLOCK_AUX base scaled")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/vdso/math64.h  | 20 ++++++++++++++++++++
 kernel/time/vsyscall.c | 16 +++++-----------
 2 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/include/vdso/math64.h b/include/vdso/math64.h
index 22ae212f8b28f..2ef4905585c59 100644
--- a/include/vdso/math64.h
+++ b/include/vdso/math64.h
@@ -21,6 +21,26 @@ __iter_div_u64_rem(u64 dividend, u32 divisor, u64 *remainder)
 	return ret;
 }
 
+static __always_inline u32 __iter_div64_u64_rem(u64 dividend, u64 divisor, u64 *remainder)
+{
+	u32 ret = 0;
+
+	while (dividend >= divisor) {
+		/*
+		 * Prevent the compiler from optimising this loop into a
+		 * modulo operation.
+		 */
+		OPTIMIZER_HIDE_VAR(dividend);
+
+		dividend -= divisor;
+		ret++;
+	}
+
+	*remainder = dividend;
+
+	return ret;
+}
+
 #if defined(CONFIG_ARCH_SUPPORTS_INT128) && defined(__SIZEOF_INT128__)
 
 #ifndef mul_u64_u32_add_u64_shr
diff --git a/kernel/time/vsyscall.c b/kernel/time/vsyscall.c
index aa59919b8f2c2..f43dd3f4744b5 100644
--- a/kernel/time/vsyscall.c
+++ b/kernel/time/vsyscall.c
@@ -41,14 +41,12 @@ static inline void update_vdso_time_data(struct vdso_time_data *vdata, struct ti
 
 	nsec = tk->tkr_mono.xtime_nsec;
 	nsec += ((u64)tk->wall_to_monotonic.tv_nsec << tk->tkr_mono.shift);
-	while (nsec >= (((u64)NSEC_PER_SEC) << tk->tkr_mono.shift)) {
-		nsec -= (((u64)NSEC_PER_SEC) << tk->tkr_mono.shift);
-		vdso_ts->sec++;
-	}
-	vdso_ts->nsec	= nsec;
+	vdso_ts->sec	+= __iter_div64_u64_rem(nsec, (u64)NSEC_PER_SEC << tk->tkr_mono.shift,
+						&vdso_ts->nsec);
 
 	/* Copy MONOTONIC time for BOOTTIME */
 	sec	= vdso_ts->sec;
+	nsec	= vdso_ts->nsec;
 	/* Add the boot offset */
 	sec	+= tk->monotonic_to_boot.tv_sec;
 	nsec	+= (u64)tk->monotonic_to_boot.tv_nsec << tk->tkr_mono.shift;
@@ -56,12 +54,8 @@ static inline void update_vdso_time_data(struct vdso_time_data *vdata, struct ti
 	/* CLOCK_BOOTTIME */
 	vdso_ts		= &vc[CS_HRES_COARSE].basetime[CLOCK_BOOTTIME];
 	vdso_ts->sec	= sec;
-
-	while (nsec >= (((u64)NSEC_PER_SEC) << tk->tkr_mono.shift)) {
-		nsec -= (((u64)NSEC_PER_SEC) << tk->tkr_mono.shift);
-		vdso_ts->sec++;
-	}
-	vdso_ts->nsec	= nsec;
+	vdso_ts->sec	+= __iter_div64_u64_rem(nsec, (u64)NSEC_PER_SEC << tk->tkr_mono.shift,
+						&vdso_ts->nsec);
 
 	/* CLOCK_MONOTONIC_RAW */
 	vdso_ts		= &vc[CS_RAW].basetime[CLOCK_MONOTONIC_RAW];
-- 
2.53.0



