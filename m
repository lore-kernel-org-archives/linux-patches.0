Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590989;
	b=k5LpmP2tchuUX3eyZMOd9dkMyKYoE3YCo+HgdHFahDFgyG/IlEEvxcA78pu2DIcEFxsL
	 2xKADNylcuWIq+IqnEjE5AqdfF3ad76qmCUg5/285wXAhcZ0iw1388vkCoTDwa7M9gARg
	 oUeLoPxtTX1cf6y1zRGc6OqE80iAwojaVd+N1+gO4KzCUJ11ZVjzZMZAQlk1S8sIntTZU
	 NDaxVnvRyRXc6ihbjSkOdOCSiaJuKA9nsoNw61VPCY8bvaWtcuMAVzJI1LKcHeaZbWmya
	 iWpoGwMttJkyA0iqeKRILY53lVo3jPdkEGADqFF5iW3k4hTbyHigaBXNsTWQAgHmbeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590989;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UVX6FTxCmF1MOFDv3J6bKBFIilTHbrSGmZ+RaFdMIsY=;
	b=AfzbFWtYVM81pNwiI+YMLA30akaIkd9CSJs6Ex7KY9xJ8r5h8krsikct1TOOVhZigMhU
	 O7NmuVLvy94KfmNVMxHdhU03mO1cGrCBLYk8jsfdzBmgZJ4mZHVh68xjWRnobLGVLL117
	 QMVVPMxrnoLOrRiqKlQLs0jkRNU/vZokDxYPZT4PwKAVOF7KY9WbEa753aRL5xrUBdQSd
	 4Lpj7t1N2PuOwGhyXZ4KFt5lDv2v6wCmlo2LKr5rLZVNc2x/T1g8ZGy+vX0st7XGZefFY
	 H8NQvuEKLL0Q04tnp4fWK4CTtuZagvGqKJNEZ94XoR3Z2ekE4WbdxKFQdWURv0QOY0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XJG8G6yO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D603660703F6;
	Fri, 13 Nov 2026 17:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XJG8G6yO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80DDF1F000C4;
	Fri, 13 Nov 2026 17:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590989;
	bh=UVX6FTxCmF1MOFDv3J6bKBFIilTHbrSGmZ+RaFdMIsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XJG8G6yOPy9n8vZUFRSGuVC3pnnLlCxrtUW96hGihw6SszN1G/6Rif349LjMpb2W0
	 TPEGB/5tv3ZDEjVRMZykLOIqJGzVNMfgl2J7ubk151lyRKhOeNqIiFESr/I8vs0mGM
	 nkIRJUL6LrQ6+h8k24RgRG1jNoWavCcPfHQ6JqGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 164/670] posix-timers: Accept NULL clock_getres() output in stubs
Date: Fri, 13 Nov 2026 10:45:28 -0500
Message-ID: <20261113153817.643938959@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



