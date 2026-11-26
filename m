Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704662;
	b=IHheqFfnv5III4RTjU1wass6BgI+RGob6gbQaNPWAoCq2ZMADlA7vAxFJxIoKTHbz4jH
	 kd3jfLcnmW//A9ZeXVl6rd0zcTPfwyhTSQbeX5ou33Ub4Le4YzlL7Y1c+bYNXR0kpZRDJ
	 BxvgvAaou9XIVkpmX7L/8N9O5eg/q1IUuGhSO2oFnPjRTtSmxuA8XeGMYPjdeR37ZNIv6
	 wz/BxcdP7D9fpKog+aVrN7SBUrCBc751TSAT2gqX+ZB/yHdMcwXIRDskbkvgVcJRue8aC
	 Au16Io9r8x5yBqBJeQs91R0Vsgesmw486xAZClTtk+Oj++9AWnNdvftTSuoOJLsY0TA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704662;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rh1tIwfVxG98Z9y9r5PPvYd+UmxTIYdQHUWNbdbRS+8=;
	b=wv3p4GP45T72vHNETMHHilD6TEHaDbNptqflvCCA35nsCPmigQZGMN5LNcTbatvwB7iY
	 pH30BlR0xOQVb1Psg52ssJ1DD1nDRmsIsK0zHXrpIcFSUABuKEUQe2hd02kI8CMbUQ+7J
	 rCTYUR7FUWhZ5PqFLUrj18CTJczPUyysSagJxdoOiBa/1pCIg8IcwaDzOJTpequKRLzIM
	 coY0l0edo33tvCQMJf0bgVYkXEjvYX9DqBKqypaM9LTfPrH2NFs1UUTfRj8oOqZVvqJIJ
	 RZt6Fx7xvDniNXz1Dno2fNs+hF33iO72lkv2E1oJpYnwKwD3f7g7xm8OMzzIaNjReFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dm2djmYZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00EF7606A31E;
	Thu, 26 Nov 2026 14:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dm2djmYZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7F9B1F000C0;
	Thu, 26 Nov 2026 14:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704661;
	bh=rh1tIwfVxG98Z9y9r5PPvYd+UmxTIYdQHUWNbdbRS+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dm2djmYZsljGoppCwlYp2YMn5mSiuocbUhhLpsgBX3bluJ9WiD4648cwo6UMnP/k8
	 mHrCApUu2JMmw1x8hMH5jX6WLS0qDXpEejMUjm2t86siVIC0Vr4ljCDhDKsuHn+pgj
	 Rpgs/nOF+VDhnRIBxUgil55kdZlXl3EcBfWJa4mA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingjie Wang <x-professor@outlook.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.10 202/265] dm mpath: cap queue_if_no_path_timeout_secs
Date: Thu, 26 Nov 2026 15:38:52 +0100
Message-ID: <20261126143619.350186781@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

From: Yingjie Wang <x-professor@outlook.com>

commit ae5b40accbc06f93e6a513e0e9a07fd32b197e49 upstream.

enable_nopath_timeout() arms the no-path timer with
jiffies + queue_if_no_path_timeout_secs * HZ. The module parameter is an
unbounded unsigned long, so the delay can exceed what mod_timer()
handles: a delay above LONG_MAX is treated as already expired, and
values above ULONG_MAX / HZ also wrap in the multiplication. The timer
then clears queue_if_no_path right away, and I/O queued after the last
path fails gets -EIO instead of waiting for the configured time.

On x86-64 with HZ=1000, 9223372036854776 seconds failed a write after
124 ms while one second less remained queued throughout a 4.2-second
observation window. A value of 18446744073709552 seconds wrapped to 384
jiffies and failed the write after 455 ms. On 32-bit kernels with
HZ=1000 the delay passes LONG_MAX above 2147483 seconds, a little under
25 days.

Cap the seconds value at the largest whole-second delay not exceeding
MAX_JIFFY_OFFSET before multiplying by HZ. This prevents signed-delta
overflow and multiplication wrap. The timer wheel's existing handling
of very long delays is unchanged.

Fixes: be240ff5e402 ("dm mpath: Add timeout mechanism for queue_if_no_path")
Cc: stable@vger.kernel.org
Signed-off-by: Yingjie Wang <x-professor@outlook.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-mpath.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -792,7 +792,8 @@ static void queue_if_no_path_timeout_wor
 static void enable_nopath_timeout(struct multipath *m)
 {
 	unsigned long queue_if_no_path_timeout =
-		READ_ONCE(queue_if_no_path_timeout_secs) * HZ;
+		min_t(unsigned long, READ_ONCE(queue_if_no_path_timeout_secs),
+		      MAX_JIFFY_OFFSET / HZ) * HZ;
 
 	lockdep_assert_held(&m->lock);
 


