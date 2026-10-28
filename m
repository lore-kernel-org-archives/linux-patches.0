Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212018;
	b=jSgbI1ilVP+YwnOFM8TeAuxBCiKP7twXmglF9uDxhvP5TgboM7z9PIzxOF1tzrWINRBy
	 67sCPXT7g08eqJiG/j1br6WcQ8SZc9ijvYYoBoixBlIuFpPG5vuACX5OVfl6Y9S/4F7JV
	 AFifqpuSIaFAUETQL/Fs42b3IbWSWz3F6jVsaYRODB97pJDSsW+8kXpQWAyIAQqImexO9
	 IIk2bK8rMTmPk8GC1lJ/hGkykpPNzY1GtyNNczTRoP+plj+IFtPT6ga/8id8VmHbpSMPs
	 puCERLuP6Ea2AsqEiuNQ4QJkv7m0/QFvngEWj04QunLzQ3+qVKHoUDhTCM/pfoL3vvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212018;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=azcnJ1F+Ru2eiyN6mBdekYJwS9/AdKJypomQnriSoDM=;
	b=Pu+agSb++NjvtxsQkBsN2vvlHWUGvxjK58uLYQYzYnnvNya7DI9xnpt4+qyQnPn5ph81
	 WDkLd+VE8xoHHf2KWdFVTP95v7jv84D6mdrN7CfMc875Cu6QeUe+FXDmisD86DTfZOf6e
	 xkZbu6G4Rf0QUUyHSME8eec2Q5EY1N/Lxh2tmdtag9FT7Urw9a3WLGcEN1Zkqu6a14Fs6
	 iP7cZk0lfdUhCklEf81iiZJRZr+GJXjwszoSUCXHYE5p0sPiG59ZLUTAiq8QzljRtg21q
	 iFZpr6hHaHdgfw59HdYPUIKfd8LY2azeGUNOKKgoYej7GexYUEZCqgXyjbqmmjKZ3Pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=io634r9P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78005606A31E;
	Wed, 28 Oct 2026 18:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=io634r9P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C978B1F01828;
	Wed, 28 Oct 2026 18:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212018;
	bh=azcnJ1F+Ru2eiyN6mBdekYJwS9/AdKJypomQnriSoDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=io634r9PVdiv+YIWsWtlOqzSOOFF73AqLnEu6is83mZgyP2yf+iiIxqoRl6kxBRf1
	 iuT5J8H6uGTLBKOtpxTSPCxiD1a/sPmvDvxxoK4+vZjrpX2BC2sfEKCWzB2KDLAMOp
	 +fvO7epKHOu0s8b2S8RwSWW3U2/KQWR0DSxX60wQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 0010/1887] io_uring/cancel: recognize "no timeout" on 32-bit
Date: Wed, 28 Oct 2026 17:35:06 +0100
Message-ID: <20261028170459.456891130@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

Commit 3774e4d4c8533da2caae95556c4d635c7c4f45b8 upstream.

IORING_REGISTER_SYNC_CANCEL waits without a limit if both fields of
io_uring_sync_cancel_reg::timeout are -1. io_sync_cancel() compares them
with -1UL. They are of type long long. With a long of 32 bits -1UL is
4294967295, which is what it stays when it is converted for the
comparison, and the fields are never equal to it.

So { -1, -1 } is taken for a timeout. ktime_set() takes the nanoseconds as
an unsigned long, so what becomes of it is -1s + 4294967295ns = 3.29s.

If the request is being run by io-wq and can't be interrupted, the call
returns -ETIME after that time, rather than waiting for the request to be
gone. On i386, with a buffered read from a null_blk device that takes 4s
to complete a request, IOSQE_ASYNC, that is what each call does.

Fixes: 78a861b94959 ("io_uring: add sync cancelation API through io_uring_register()")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-17-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/cancel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -306,7 +306,7 @@ int io_sync_cancel(struct io_ring_ctx *c
 	if (ret != -EALREADY)
 		goto out;
 
-	if (sc.timeout.tv_sec != -1UL || sc.timeout.tv_nsec != -1UL) {
+	if (sc.timeout.tv_sec != -1 || sc.timeout.tv_nsec != -1) {
 		struct timespec64 ts = {
 			.tv_sec		= sc.timeout.tv_sec,
 			.tv_nsec	= sc.timeout.tv_nsec


