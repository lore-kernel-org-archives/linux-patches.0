Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046178;
	b=mfyJdkRutmCuf+l7nHaaWhzEsAqBJUJx5wzfWDg9OTZS+mgQJu8qStFSvmLALaI45AiI
	 C6R9KqFpP6ye+F24ZzNiBU/t6Z3XENnYCMDYLM179piVLNvT9Y5YQy+7UawJVT+VC8NNn
	 lFTnG2oxtfrgIQcJEKRUvQzp3c+Ubig3Tej1GOTKRtBAf+7blivAW5Ulq0as4LASL3WZe
	 iQ0AhpxbTvf7v8cV9onhfrEYmms024PHgkWA5KsjEdubs4iU8M9+iDxXkobzWunzeFLg2
	 0P5eKQNXH7dn7hFQYsYokNrPTvC4zC42IBnV5EctQOi4m67dPpdMLr2gfpQckk7rRpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046178;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QeODakCetYIXOidz7k0HXSHN5di+WhgNcp2isNqVRng=;
	b=J2inScOsDZquY3eEDVY8HZvzvXKWxr5BaADVQRiLdBAtYE6j0Nc4peuoDYBmHUkZzzmn
	 YJSu18eybteB8g2U0Y3xAXeBVQ/hgukkQ86JdNNK7P10zc6jL3+SB3ajGQrGsE8O33Xn4
	 S8q15F4iKklKo3CN0HKDkVDVDoAJQQbNbF9xiJwNrg9gEZjPGxhxuV+T5m5QPTXsl9fLs
	 wlAoZnw0B6pfsrhsNPbm1gKxBvKDyjWBvoTYyxIkiY08yLZAWRvFy9KZ3p0w3ch090kDd
	 XoV2t0IqyQcVeqqPdFZ7yGOK+LopX8vdedktu15IczsV7PvJoNM440l/KRWSbMJcpUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FPVqb762;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7A5606A320;
	Wed, 18 Nov 2026 23:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FPVqb762
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB5C1F000C4;
	Wed, 18 Nov 2026 23:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046178;
	bh=QeODakCetYIXOidz7k0HXSHN5di+WhgNcp2isNqVRng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FPVqb7627hlrgEU29eBULh3hukgn5ucUjaTxSYpyu0wjryhoNtqZJ9TnuAP6fyZ3D
	 ZiZi7YoSGQHY6yvSBFk1f6u/cD8oieZifVPC6qRO5lH3NsUexIftCFOHZBza/f5SzW
	 pJjnRiyHAqm3sNBELmSFAFCVSuqwMPK2RosRqEM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1188/2857] posix-timers: Accept NULL clock_getres() output in stubs
Date: Wed, 18 Nov 2026 15:37:02 +0100
Message-ID: <20261118150244.382332916@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 828aeecbd1e8a..b2bb38e78520f 100644
--- a/kernel/time/posix-stubs.c
+++ b/kernel/time/posix-stubs.c
@@ -117,7 +117,7 @@ SYSCALL_DEFINE2(clock_getres, const clockid_t, which_clock, struct __kernel_time
 	case CLOCK_REALTIME:
 	case CLOCK_MONOTONIC:
 	case CLOCK_BOOTTIME:
-		if (put_timespec64(&rtn_tp, tp))
+		if (tp && put_timespec64(&rtn_tp, tp))
 			return -EFAULT;
 		return 0;
 	default:
@@ -211,7 +211,7 @@ SYSCALL_DEFINE2(clock_getres_time32, clockid_t, which_clock,
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



