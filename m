Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063650;
	b=ByW/k0773Zc/x1KZU+yXGY5HqgH6/Zp9XWI9mv+C8oanbn3GYVr01PeY+EOq2FJJw+h1
	 S6EkB4Xe6ViVcFF7n5A3CcKOlOHWk+ZQMM4l53zRrrbNa7H3wgn0Jn8AuUFmGyBkYHRmT
	 r17btVbsazE+iEfrjGjKcmposnxYlDlq/+bhXEAls0BSdkCMOK2IMSHEZD9qfOxU/yaOd
	 W4OaRSJxOAurZ4LziOGoxSFARMFOctcq/OVgnXwIvRKAO/ITjOtHfQlMH6biIyqC/XnLH
	 eBx7x4jpcEj8NJyPGZTX6+2kdVFWme2pRBpOk2nD+/9fUvBaZPpuH8yle664+q5O2kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063650;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=SEBs4hWpdq7WIvmY5xrrhDsXSV1KC+5Kge1TD/w0PA8=;
	b=Sa/k8ZGA8pIE8ba7milfAj3Jrrlccu3HoUbzM2mBaz/112SUHIGmXTJsordw4cwrc5LE
	 N6XpwfqEhcbQZFl7itbFFiH6Vzp+0pTcBsoGssXNPJteT573SAegIaRlevr5X8PzK9IuD
	 1i+qveDzmWIliKWojd9GxG1nPnWKbLJY4PB6zgpzc9C68RtYfgIhE4gUT6gFiQtO3v1ZG
	 6u1fEoaW+jNGLR9ORpQAJLmznSybhqZF3JFVYOU552ryaBmvlpccjERWkxH+MoMSkkvz7
	 qQ5R5xyY7fruUT1xTVzEQMDqpcytKewtiCMTRTjF5d8xqvkScV8s+BGiAqqd38EfD7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ciwqvOGF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BEE5606A9C9;
	Sat,  7 Nov 2026 15:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ciwqvOGF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F5C41F0089F;
	Sat,  7 Nov 2026 15:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063649;
	bh=SEBs4hWpdq7WIvmY5xrrhDsXSV1KC+5Kge1TD/w0PA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ciwqvOGFDYzKKMyZGwdA9PbOCX7mMQarPayZwFlTVruzgsLn/fwFVcHQad3XVc8Df
	 RT/lQYcI3G+Czt9gjliyO1FffGXxD89YfZ6+EHoF6EVdpLNymmneI/s3msn5nrIuJ6
	 1a61qp5he48D47IUY9twg3Subcne22Ivl00Kc5FU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh=20 ?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 726/869] timekeeping: Update offsets on sequence counter retry in ktime_get_update_offsets_now()
Date: Sat,  7 Nov 2026 08:56:48 -0500
Message-ID: <20261107134917.414303856@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Thomas Weißschuh (Schneider Electric) <thomas.weissschuh@linutronix.de>

[ Upstream commit 6541fbc942f3b63bb8bd44e34eee6223e0abe719 ]

The sequence counter of the cwsseq target is modified during the
sequence counter loop. If the loop retries, cwsseq will now match
but the offsets contain the values from the previous loop iteration.
These are not guaranteed to be consistent in themselves or with the
current loops "now.

Save the target's original sequence counter value so that the update
also happens on loop retries.

Fixes: 868a3e915f7f ("hrtimer: Make offset update smarter")
Signed-off-by: Thomas Weißschuh (Schneider Electric) <thomas.weissschuh@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261023-timekeeping-clock_was_set_seq-v1-1-61c4c53d031c@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/timekeeping.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 377e29ca5a521..32f59de2ba4ce 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -2569,6 +2569,7 @@ ktime_t ktime_get_update_offsets_now(unsigned int *cwsseq, ktime_t *offs_real,
 				     ktime_t *offs_boot, ktime_t *offs_tai)
 {
 	struct timekeeper *tk = &tk_core.timekeeper;
+	u32 cwsseq_orig = *cwsseq;
 	unsigned int seq;
 	ktime_t base;
 	u64 nsecs;
@@ -2580,7 +2581,7 @@ ktime_t ktime_get_update_offsets_now(unsigned int *cwsseq, ktime_t *offs_real,
 		nsecs = timekeeping_get_ns(&tk->tkr_mono);
 		base = ktime_add_ns(base, nsecs);
 
-		if (*cwsseq != tk->clock_was_set_seq) {
+		if (cwsseq_orig != tk->clock_was_set_seq) {
 			*cwsseq = tk->clock_was_set_seq;
 			*offs_real = tk->offs_real;
 			*offs_boot = tk->offs_boot;
-- 
2.53.0



