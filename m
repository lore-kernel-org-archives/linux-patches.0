Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065379;
	b=yeavDv/S7tjNFeVY/2udUg7kv8+IhPjDTq6BTyRsgG23crR3ujdi5W9yTa7qB0u8ZQHV
	 wGeojdS+VVwBu2Ar1GEnE5TAP+UAspOiI2635E/PMAEvAaF3SaNA7OeUV6n4FSAYpXSTI
	 aMwsOBB6SGfCiyRi5XKBDdMqsh4BEheAYq0DQN4eHl3AaMRSV35wwi7+ufFm6vGNJ8aFM
	 vwkdY9utT8WpIEduSTkeJQLsjar49iF579G1it99I805QTJQyzMKw4xS5sER27H+62cK8
	 JfxUs0gqrgnySB4xMxmalg6BQUdLoPHjFuil41QXr01iYqzfDN8YQmwsd95fgfIxHIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065379;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/Lu6IAco07RARuInpSjacHw422jfpzYsg9SETYPe9hQ=;
	b=rA8akwcJu71hxH5nK7PiQhHp88bRpZvy9I4CUixUemfO8X4Eo/3Q6vVczSWx4alSd/xU
	 Nf68tZIOLB3gi6Lu8oo8gp4HPVd0FjVp29xCKl970BZzV9jjkwp/jI3QxqjVw3eit2Cu0
	 sGzKoj3vejFFD8rG6rPGdbvD0eR+k1AcwUwTjTC95RvE2qdSWEsfi7BhNHWtdrk86YX/N
	 yQcmHA3hOrYj9rOeYd0XVZHc8uXsn1bo3gV5xVC13MLj/ceYVWXPNsntpvegP57Vi5Vwv
	 q92qG1EoB3e1ZVfF1qa68X5ACsmK5fQelemRtKccnGqmJFlaIYf+bFz63y6vGmTzUtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x9F25EFH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60390606A32C;
	Sat,  7 Nov 2026 15:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x9F25EFH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DE211F0089F;
	Sat,  7 Nov 2026 15:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065379;
	bh=/Lu6IAco07RARuInpSjacHw422jfpzYsg9SETYPe9hQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x9F25EFHriGwCBftn7fh7byfCgVDwDocG+2IJd2dMUJcba1mZjoV1bbBPGZ7G7W8h
	 ndptfAFXYShOn+aBixU9Sl5riWLa+hXVcYGissWjB5Go1ty3VZcSBV5Dqulmllju8D
	 41ujv8dySLfhwHWm5/BfxgKsoZSynioU5L6mfiZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1106/1257] posix-timers: Accept NULL clock_getres() output in stubs
Date: Sat,  7 Nov 2026 08:56:42 -0500
Message-ID: <20261107135009.803884503@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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



