Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053196;
	b=lYof6QUxTw7zteYeVg5hmwtbZlC32Z96jWqc64V/EJnZTMn2fJqthWqQ3iw7oxfA2g9y
	 XQpYl3p9dvZ6tDL7PHiCGxkEdWzzY7/a7zpLdQvNtoHFJg9P/9mAcEGmZABgV+L6rbl8M
	 xWtA99KcEPG3tI7tjF5+0qF78dmewtUM/qNsiVOC77tEkOPU0RCluZlca5uMRNaCowlba
	 TexZyaDS1wUkcJxrQ6TK0x0hxSiaNhzl+Y20IStI+pou3YKxIBeM1QBhVedhhPuu3luJ2
	 0/UYlDmSWnV1NemXpJFIf0cDgT90OKsjk7mywVnDfxqjU18WOEstYTfNjvaXyWM4QKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053196;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hYGv2kOOF6r4TFfWZ3+TPguAaQK+bj2ap8rmsmjTxD0=;
	b=hSXRz3u9Z2QrEr0uswwnJnSWWsySNXA6li4Vk34nql6lac3TUiBPldyBjvCnSKlg6p9n
	 pN1pNm2vWWT/erlc3ZT6qzw4mOqR61kiGoOdFSLWLJHMGAwjxDDBbdmqYFyZdoN/+5Mb+
	 7fLv5qdBKs6XSMNo/zqyYoAHX9hI8ib3YZU2aCev7hVW2AGh51fPZK7tXF8gfONwr7zxl
	 FRhrsrZcy5MgYdLWtljXxmSehzOtL7FINUd26B5Wzsegtk8efcAPUwNPBY9E/SrCUlflD
	 Q1pbLuz6SUnKusAt+TX1l/8XUoX37p1fsSZkUg7VvGp8PBAOjhuEMSvOsz9Ecd//a8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="tMd/j1DR";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB353606A325;
	Thu, 19 Nov 2026 01:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tMd/j1DR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1029A1F000C4;
	Thu, 19 Nov 2026 01:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053195;
	bh=hYGv2kOOF6r4TFfWZ3+TPguAaQK+bj2ap8rmsmjTxD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tMd/j1DRZ15GdzFL6FKHlfBK+AiyoegWer3NyUBgtxAyZoPLXSHVo7ob2n6hMPgmg
	 gcPUBidaipFt1nAKDi5xiYAU+vNWHbxqkfjMfINNzBWTSpanZvau7QlP+BCGsyIkxv
	 5Qi5XSRA3dct6JIouLMsfuBW8qZ06DU6G5yq0rp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0831/2214] posix-timers: Accept NULL clock_getres() output in stubs
Date: Wed, 18 Nov 2026 15:41:47 +0100
Message-ID: <20261118150045.262307961@linuxfoundation.org>
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
index 3783d07d60ba0..4eb4d7cb6179a 100644
--- a/kernel/time/posix-stubs.c
+++ b/kernel/time/posix-stubs.c
@@ -116,7 +116,7 @@ SYSCALL_DEFINE2(clock_getres, const clockid_t, which_clock, struct __kernel_time
 	case CLOCK_REALTIME:
 	case CLOCK_MONOTONIC:
 	case CLOCK_BOOTTIME:
-		if (put_timespec64(&rtn_tp, tp))
+		if (tp && put_timespec64(&rtn_tp, tp))
 			return -EFAULT;
 		return 0;
 	default:
@@ -210,7 +210,7 @@ SYSCALL_DEFINE2(clock_getres_time32, clockid_t, which_clock,
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



