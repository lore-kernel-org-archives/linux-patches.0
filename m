Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058957;
	b=atwRVA829jPROsDwJCixbQFH+XD4fsFYmfVfmwR8OTfKBLmeaXKIpqC3A7AywQeORgit
	 gl+i+/NphIi4GMNvJ6wbLgFcuJHR24zAmoBFWQg8dLvkHeSClfnxqJ/z0lusD6lA2w8sq
	 c8iNmCGSojQ/wsheQCVKfgmNVlmK52jM3iFBot6E3dG6+pVBFwlJOeeAf57+xj+A0dETL
	 Mazf7IcZeGjaMjRy4CgcjnsMKPhUfYbUtn1vvzKv941oOXAsxoGtK3azWiNYLJYk+VDLw
	 X9zA7Zg/iYhVunxemN+qCltlhj2pfkgOsiNWmi2QCc+X0gSvomXyBxWpnBTMGpakt0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058957;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v6vhs8nqfOnCuoJMJ7Igf8pyLSCR9wmCXOL6PdHg+TQ=;
	b=H6cVZ5YorHQm2ZA6yy0tO36DWwDrl+OFSXsZJbSBCFX7SLIcNUiFHVfw6tcXHpt1zjm6
	 kZ6l59K7EbpkYTVXIg3Uj4E21OXso8BRy5xWgY3nwWY+MwFDz5g+opOo26t6xDDP9C+dN
	 Pq/bsBpfXkpbqEg6CTKdVOMz/u0xU18hbzOaVNSjEIZcSCSyebX5Wm9Ktc8vk6rv40SIh
	 K4O5RXR0hT5uv95+XgmtLj0IpfbtkLMqyz2OPHSk3bYIcf6OuP1lMGhRecNePdUZLitWR
	 pMV8A7GekfEZY5ihbLseb2ce4NRbtga8tDLh7tT6QvD8YDRQAbYZDw+6kNh8P/4aNEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RAILpvjd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350CF606A32F;
	Thu, 19 Nov 2026 03:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RAILpvjd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 508801F000C5;
	Thu, 19 Nov 2026 03:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058957;
	bh=v6vhs8nqfOnCuoJMJ7Igf8pyLSCR9wmCXOL6PdHg+TQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RAILpvjdT7+Ip8b6ufjOQyyO43U10c1HD1mofWGMYcE0BksFIdgjd5DrvBfVnZ9aF
	 gfOiphaaDB6DwyPhHAEe2hOnF7qkLjc0SMzLOsn+on4LYzNa+3H53RO4KgORwE9Pvg
	 hHFcQlve6H5AL83jH2ws4UuCI+L66nXO/3P96pB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0672/1848] posix-timers: Accept NULL clock_getres() output in stubs
Date: Wed, 18 Nov 2026 15:45:10 +0100
Message-ID: <20261118145943.991048992@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

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



