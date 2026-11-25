Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626002;
	b=dZqwvbVZnFm6svAB87FpyChEpt/ri2smTvfhuci7NcQAaXTn8U4Xlvs0VF3ox8+NSKzG
	 L4Kadjmkb0/AtcepTPHCIExyk6SHJSLzR8VXaut3/EPJxNa24GTTdcksrrXNpBQMGk5C4
	 KaqRhYVCj9JoKVvIY3tnZ+dgDpxQ2ktf23PqUfuR4ViGiGHCPn3Z/I2WZGygiOLnzM5jk
	 jqBKjsPChB+qF3ZzSTsfA1DEHSFtv0R2o9Haj+Og9/B2Te6wsvcIjyJYu2A60RmsSCVmS
	 soSSTyKAkt7BAs9+2jyGDp7YmS2ZIXV4uzAN+CdBwHzxkJ+MBu5GXxpeJnkCWn8fsoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626002;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w/xWa7OXokOtpslVO/CRhwb0JP1AA9hPYDR1o9jVkkg=;
	b=N4U+s4tmb+I/VPhIZxDa64lrjC4ctoAcR/go1HUX1qQDx+ktfuiUMWU4DUp2C9QIHDlF
	 2gsJlStTUBOzo3qEjhkrUGWv5M4F4gAv5C/Es3anFd4bAOnKiRNNAhzQ9XTbwnediYUfT
	 JNlX4QgBwsMbgWI904q9ljJjdCbevwfO3MFh2bInU+2fj1WWAAW8khSKUHYAgfocC1nkZ
	 wnsSoRfMYYsib3W3Sw8IwIWbnnGSgWoVrtEGIM27+T0xmq1e4gVKaFysMwvA8xEwudeRH
	 3Tqd/nAffoZuyQRaV0XabZM2XMVRSAQUPmr5pgyhK+Dz3IdOo0kZ0QYFikpOxKPp+Ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="x/Qb2e6f";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B67B606A326;
	Wed, 25 Nov 2026 17:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x/Qb2e6f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F9081F000C6;
	Wed, 25 Nov 2026 17:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626001;
	bh=w/xWa7OXokOtpslVO/CRhwb0JP1AA9hPYDR1o9jVkkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x/Qb2e6fW8Bx/hpz1Ug61wCoG0gJ/v/QrYGyWXjwpMcwOlN4VOPAhhoNt5CcoIypL
	 wir02V2UzWgDdavrQJj5pIFIHWLNb0SjGe7V3m+S2VNbUScFPVzufyHJKMgscAaVBH
	 +CzFeLfGYXiTnRpHQ1kMN313x+6wgNbUOlp6k0Ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingjie Wang <x-professor@outlook.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 697/816] dm mpath: cap queue_if_no_path_timeout_secs
Date: Wed, 25 Nov 2026 15:37:25 +0100
Message-ID: <20261125143905.316396439@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
@@ -801,7 +801,8 @@ static void queue_if_no_path_timeout_wor
 static void enable_nopath_timeout(struct multipath *m)
 {
 	unsigned long queue_if_no_path_timeout =
-		READ_ONCE(queue_if_no_path_timeout_secs) * HZ;
+		min_t(unsigned long, READ_ONCE(queue_if_no_path_timeout_secs),
+		      MAX_JIFFY_OFFSET / HZ) * HZ;
 
 	lockdep_assert_held(&m->lock);
 


