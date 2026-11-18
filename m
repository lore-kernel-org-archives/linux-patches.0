Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037433;
	b=EG14K1Tta2a/+2t4fGjMqIgVFPVf2vLpsWJZC+Cq0Y/FtWF3SwWedWdra9t7QUvlHqsr
	 zS8m1VVCxnNLgE5dzc+ExOfsdALC5aVP9aCZS8Q5G9M6q4QtPfVGV055ZmqcfodsvDWEv
	 531S9JVmaHEM5nSNeU4OKYzH55viZiHUMkHQiIvt6mrXoekd9LaQ2fdX+4nBXmDcYfP63
	 3UiZSfuigU2+kjsUlo38Qo+tfFld4bbZ017yf/rpMjIQ2RxDSlCks5tW5Yi/rxuyxMGWq
	 fMk2nizUElCi4k38nQKW9tcOiuABux+NLH/vW4iPdfovA63CAnNZDFvZmPl6bolV4BA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037433;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UVrOUUhOcXG/dMoFLBUYiFYZuw98FXZ49XoS/ebjLgQ=;
	b=hNZzKMgyrhO0i53aW+cCK4u9T7Bd+J7wDc58GUhBiOA5VMPDB6mN4dFW9PhHtEbJFqf9
	 mJv5CuSKjly4ytWJzZVG/R3HugKiLVwd85lyzIz/kH59so6Rpyzddjx3cH8y4HLBq/31R
	 db3yyXHd4GbU8S6+NpMZzyeRUDr+hKHNGYZbiUWHQl7iJzNvaMjHdYyr257zMqB4hhbNy
	 A5N25UnEPAxWa+w0EqTYyRkqHpFTvpOjcy7raImBqg17G6VNo+LGJu8w/m5Qg5UsRSyT/
	 o0G+IxaX0jRNRIkNpkYF+JOfu0uWtO0CunXzQsPtghNkRKRUnA3CD2X5kgGFFmgeS7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="dP/R0tl+";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56AC606A31C;
	Wed, 18 Nov 2026 21:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dP/R0tl+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A84F71F000C4;
	Wed, 18 Nov 2026 21:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037433;
	bh=UVrOUUhOcXG/dMoFLBUYiFYZuw98FXZ49XoS/ebjLgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dP/R0tl+WewQxjBE/VRzZV8fQ3fEHHgSYZqFfyWwvb8a1cLriR96dEt6RZd+Ixly/
	 14MsyPksE9GzAKbD6qPZJJCPHTLeO9wVL0PWlU6EmyH1eqdZAB6aEcHQBcV0GGDfdV
	 rUolmDryurAOTK5lktNYtYi1gocCvahBb0+mAJM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1398/3318] posix-timers: Accept NULL clock_getres() output in stubs
Date: Wed, 18 Nov 2026 15:33:40 +0100
Message-ID: <20261118150402.543290991@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hungyu Lin <dennylin0707@gmail.com>

[ Upstream commit 5b819071e4346256c4edbae5cc2095dff25694fc ]

With CONFIG_POSIX_TIMERS disabled, clock_getres() returns -EFAULT for a
supported clock when the result pointer is NULL. POSIX permits a NULL
result pointer to suppress returning the clock resolution.

Only copy the result when a destination is provided, in both the native
and time32 stubs. This matches the full POSIX timer implementation and
preserves clock ID validation.

Fixes: baa73d9e478f ("posix-timers: Make them configurable")
Fixes: d822cdcce43f ("posix-timers: Move compat versions of clock_gettime/settime/getres")
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261020161121.85042-1-dennylin0707@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/posix-stubs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/time/posix-stubs.c b/kernel/time/posix-stubs.c
index 9b6fcb8d85e78..5a27335a917ec 100644
--- a/kernel/time/posix-stubs.c
+++ b/kernel/time/posix-stubs.c
@@ -83,7 +83,7 @@ SYSCALL_DEFINE2(clock_getres, const clockid_t, which_clock, struct __kernel_time
 	case CLOCK_REALTIME:
 	case CLOCK_MONOTONIC:
 	case CLOCK_BOOTTIME:
-		if (put_timespec64(&rtn_tp, tp))
+		if (tp && put_timespec64(&rtn_tp, tp))
 			return -EFAULT;
 		return 0;
 	default:
@@ -166,7 +166,7 @@ SYSCALL_DEFINE2(clock_getres_time32, clockid_t, which_clock,
 	case CLOCK_REALTIME:
 	case CLOCK_MONOTONIC:
 	case CLOCK_BOOTTIME:
-		if (put_old_timespec32(&rtn_tp, tp))
+		if (tp && put_old_timespec32(&rtn_tp, tp))
 			return -EFAULT;
 		return 0;
 	default:
-- 
2.53.0



