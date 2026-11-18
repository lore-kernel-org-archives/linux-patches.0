Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020606;
	b=bSFGiWYn9UNuuFnLEgj1cK1AbgpC8itspzMzSH2DulFrCtrB3gwRVhQOAujxvh0hx/+o
	 bgZ0x4LS6vYAgrPDDAx6CtUt+LKSCE6N43FqAc13Q358hMbXSa/h2nqabFgogvB57xNN8
	 KsSuYHFC0622IbVOWfigWsmkB16yeMOSniMnXY8ltqjqWZUSUb0eHkHfBsw/SJyjCYSL2
	 N+reNVnD8CAdyKi5OrOsfsdKxN81cNWlcITtkvkLdp4SNaeRGQLzGeuCHuJgaK7AmHfUO
	 7qUhu7h+SNPYF2w77wJ66fo9XAGV2HyJ0Qg7hxj+5pfJFZIfm3prMF2QUkDBdgKBlKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020606;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=bYHbi8nnWIUgpDzn/fRh882KFU2lFUW58it41kuh56M=;
	b=PzcG3KGsDfb5miaUs4gD4mqylLRgTm2tEJPVz0Z4Q5qAJb1c4QI3VJqy5UIVU12BZS77
	 VCBrh0FlwmTxDzPLm7uHPxKLcV/joR3HtN/Xtm4tiUViHH7vvIcolbg5RkGZmlDq2LWGs
	 fKvwI0ohhd0o9Hf0vbUZYOu2ENbjYOaxEUFnCBRI72dA3B/S9JWZjNXFhb0rsH50/g4db
	 RwklPHbDjU/oiGAlTK3q7pHpwK8ht3jxGx9udl+ILVDwo+LWDr3yXB0BRYG0n0gd8ChQe
	 RUtXh2xJJHsGQ/h4Y2wFwplPyZcKFYEY2osrTyTcymFeTu45kRkaG+slkrQ/GhwRHSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gzv1dxd1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F338606A338;
	Wed, 18 Nov 2026 16:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gzv1dxd1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 140B11F000C4;
	Wed, 18 Nov 2026 16:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020605;
	bh=bYHbi8nnWIUgpDzn/fRh882KFU2lFUW58it41kuh56M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gzv1dxd1SA6/9IEtNZN/0ClMOcZPtpQQWLaO7aFyANUpXXrV1YHJPAU2zAFDvtrFU
	 7SDv/ZoA/si3NuydEOOuCFOl0swC1agGifCcUo/1prOACFPhiiEBwmgqReKZxSZ6D7
	 4HpD/LdFV8JfY74SNesIYC8t0oaSQ1ohNpr6YkMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Thomas Gleixner <tglx@kernel.org>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1971/2651] vdso/vsyscall: Keep the CLOCK_AUX base scaled
Date: Wed, 18 Nov 2026 15:53:31 +0100
Message-ID: <20261118150357.419335874@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhan Xusheng <zhanxusheng1024@gmail.com>

[ Upstream commit 8d17190fae2caab89cd5df19257ed9dac0739e3b ]

The vDSO basetime of a clock is stored in the scaled nanoseconds of
tkr_mono, so that the reader can floor the base and the cycle delta
together in vdso_calc_ns().

vdso_time_update_aux() instead shifts the base down to nanoseconds, adds
the offset, and shifts it back up, which zeroes the fractional nanoseconds
of xtime_nsec.  The reader then floors the base and the delta separately:

  ktime_get_aux():  base + ((delta * mult + xtime_nsec) >> shift)
  vdso:             base + (xtime_nsec >> shift)
                         + ((delta * mult) >> shift)

Since floor(a) + floor(b) <= floor(a + b), the vDSO reports 0 or 1 ns
below the syscall for the same clock.  It is not a monotonicity problem:
across an update the step is floor(a + d) - floor(a) - floor(d), which is
0 or 1, never negative.

Add the offset in scaled nanoseconds as the other high resolution clocks
do, and normalise with __iter_div64_u64_rem() so that the stored base
stays below one second and the userspace fast-path does not iterate more
in __iter_div_u64_rem().

Only the sub-second field changes.  (a + (b << shift)) >> shift is exactly
(a >> shift) + b, so the seconds carried out of the normalisation are the
same as before; what the old form dropped was the low shift bits of the
remainder.

monotonic_to_aux.tv_nsec is a normalised timespec64 fraction, so it stays
below NSEC_PER_SEC even for a negative offset, and the sum stays below
2 * (NSEC_PER_SEC << shift).  The largest shift clocks_calc_mult_shift()
can pick is 32, which makes that 8.6e18 against a u64 limit of 1.8e19.

Fixes: 380b84e168e5 ("vdso/vsyscall: Update auxiliary clock data in the datapage")
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Link: https://patch.msgid.link/20261002153104.1347978-4-zhanxusheng@xiaomi.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/vsyscall.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/time/vsyscall.c b/kernel/time/vsyscall.c
index f43dd3f4744b5..0e4b499328c08 100644
--- a/kernel/time/vsyscall.c
+++ b/kernel/time/vsyscall.c
@@ -155,11 +155,11 @@ void vdso_time_update_aux(struct timekeeper *tk)
 
 		vdso_ts->sec = tk->xtime_sec + tk->monotonic_to_aux.tv_sec;
 
-		nsec = tk->tkr_mono.xtime_nsec >> tk->tkr_mono.shift;
-		nsec += tk->monotonic_to_aux.tv_nsec;
-		vdso_ts->sec += __iter_div_u64_rem(nsec, NSEC_PER_SEC, &nsec);
-		nsec = nsec << tk->tkr_mono.shift;
-		vdso_ts->nsec = nsec;
+		nsec = tk->tkr_mono.xtime_nsec;
+		nsec += (u64)tk->monotonic_to_aux.tv_nsec << tk->tkr_mono.shift;
+		vdso_ts->sec += __iter_div64_u64_rem(nsec,
+						     (u64)NSEC_PER_SEC << tk->tkr_mono.shift,
+						     &vdso_ts->nsec);
 	}
 
 	__arch_update_vdso_clock(vc);
-- 
2.53.0



