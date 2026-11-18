Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052850;
	b=4TwF1TY67r55ufKgKIHmikWuKfhvbB0QF22UZ/RkUZgl1lNOMXfk6qBTXI3NbsUBSYqK
	 X3uwS6N1c/mIpMRYirmbIa1wlSyN3zMqDfTKckio9c2W8tUBDLryOK0rEwgRbuXVm1mos
	 j76tlWO9akb+3oBPRiuEU3ntZGm7APoQaIehmBDNCbBaKwVl2mAzCLRKMMaJFrXjGuK/l
	 87qozs1OBS5XjU2GT1lB5TkJW4SJML4sY+cUwhTJvG/aM5mFGljztuGaLhCnEpJXuK0EA
	 uzRDiLsZD1wOOnzJn0MRSNLxrr7gW8lmy6hvKV4b3I9cGncf8Yf3e7XQKyCPEVhIktw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052850;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fcaSAODYk+CS279KcA2nNq/mJFKYjOGhr5iiNDSuiyA=;
	b=pBGlHvmAilu/SLfxV+228m0iyBFWJkPoRawYNzJSHNLaFx7+YJuTK48P0Iu2Xo+8ZnOc
	 2xkVy0h/vwtR1uCAfIn/5Ym8pyM53+4L4bW/GaNJMivlcfTct+/0Yx2CFu2wnPkjjOJ2F
	 EJpKUzHBx/S4mVoSYKDVe/YM/5eTD3e02AXuH/8bzUdnWAlF9yP0/q31okBF1Et1nJYMm
	 qnnevvb+uGJYZlOzd4pZfCvKFt9zV1XAkK0i0wDzYlGsh7iaQn7dVxr32rg6Cmx3tNmq6
	 yqRZluvgeLz+1558fpC1zO+JIqw129xpsUMgW2ZV+wz2fxxU8eG8lWo55Vg9Zp3JQaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uxxR10QK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 762AD606A32C;
	Thu, 19 Nov 2026 01:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uxxR10QK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D791F000C4;
	Thu, 19 Nov 2026 01:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052850;
	bh=fcaSAODYk+CS279KcA2nNq/mJFKYjOGhr5iiNDSuiyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uxxR10QKv8HhWvD97qUhmp21xqeKBU5BBk9NiTyvOzb4J5Edx4suboxQEZeEAG1zb
	 JgV4sHqSZXU5qM0zo7OjJyjNOYPqr0KFy3STrr2v4QWMb/hMvOXM/C+wrFgcB16Wc7
	 gqzq21kcZyJuVFuLpMSAxqswCZ7oQ/MtbkzzyVIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0709/2214] time/namespace: Fix overflow when converting absolute deadlines
Date: Wed, 18 Nov 2026 15:39:45 +0100
Message-ID: <20261118150040.159903291@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hungyu Lin <dennylin0707@gmail.com>

[ Upstream commit d69cfd33b5a8d176124c564513b9ceb933595d93 ]

do_timens_ktime_to_host() subtracts the namespace offset from an absolute
deadline and clamps the result to [0, KTIME_MAX]. A negative offset can
make a large deadline overflow to a negative value. Since ktime_t is
signed and KTIME_MAX is its maximum value, the subsequent comparison
against KTIME_MAX can never detect this overflow.

For example, with a -1 second boottime offset, an absolute CLOCK_BOOTTIME
timerfd deadline of KTIME_MAX can expire immediately. An absolute
clock_nanosleep() using the same clock and deadline can also return
immediately instead of waiting.

The earlier tim < offset check already handles the lower bound. A
negative subtraction result in the remaining branch therefore indicates
overflow. Detect that result and clamp it to KTIME_MAX.

Fixes: 89dd8eecfe961 ("time: Add do_timens_ktime_to_host() helper")
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261020233433.20997-1-dennylin0707@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/namespace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/namespace.c b/kernel/time/namespace.c
index aec832801c26c..ea8bd7cb5c196 100644
--- a/kernel/time/namespace.c
+++ b/kernel/time/namespace.c
@@ -49,7 +49,7 @@ ktime_t do_timens_ktime_to_host(clockid_t clockid, ktime_t tim,
 		tim = 0;
 	} else {
 		tim = ktime_sub(tim, offset);
-		if (unlikely(tim > KTIME_MAX))
+		if (unlikely(tim < 0))
 			tim = KTIME_MAX;
 	}
 
-- 
2.53.0



