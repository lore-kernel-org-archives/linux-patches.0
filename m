Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826829;
	b=IQdWzTAiJkRtEe/p5B4Z5ljCk9OhzPv5h0nd/ksIWcL/ls7/5KGdAWqjI8rKeeG0uzvK
	 cl+6sT3p3S70ndrSpUkU/kVIw4mq8h2FCBwfnHZb6uMqE8nm1WUwVZDs/8Gs0LvVkiw7I
	 ziU+bdHFLBSrkBz/wsJhwlxiAX040o7O4Aami0rks4Y0teVJfbJPeY0HNv8iZaG3ATo0/
	 JnvNqNTMja9PGdZ7q7EmO0o18kbGzq3vCMs5BrzDKLSXjJluBz4y7J4lCDnSJXTMplkWx
	 l6zTanY10zWyie7TpNwfna19YL/XTCfA02uxkUkyMJxSRHH8rqW7bpN+rXaHJ59UdgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826829;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6urfN93JqBoU/iWrYZ3dRcZw5bh2T0ZTjpCIzmI7BvU=;
	b=AO9KSvPVvgtbGLs5h1cTrreoaNg5jl2r3oGWffMr9gIlD57COPjnmn/onKgayqbjcHGG
	 pUIAapk82BH3tymfcfVdc25UZ7kid/4b1sBEVRPkyGGMWUBoMSadidyfTbseJbEYDgGHP
	 J59oUj71MydTkKg3Z1s47BAGrxBgmcoiUDaZkCCGz9V3HNXYefaxaNphRNkhGWsVyyK2b
	 LRLSLQKjgssikEFkHYxLEIFtzTVLCB+M/qd94/7Nvea3c151KunvPmwoMvg0HP5OGRnvX
	 +4JLVpSogKMrGgN9gO8chM+dGz7DbRkK5Ogy2WOm3VeHG+usrb+4eSSQ/YQlQ2Hac/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wESFBv3P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E126072F4A;
	Wed,  4 Nov 2026 21:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wESFBv3P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F44E1F00A15;
	Wed,  4 Nov 2026 21:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826829;
	bh=6urfN93JqBoU/iWrYZ3dRcZw5bh2T0ZTjpCIzmI7BvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wESFBv3P4iJy0FoiNwWiNHm9xFmj6Yvgg+K2JS6FO2BgaQII6biAyZRRt3G7ILpty
	 7oCXXy/xZj0pccQifVmzxRldmyoqXQlH+tKj6hCAQyQXv4RR1jofxPMkS4W/hcF+xZ
	 n8qLtiCaCgJTW6RppA+9mlIMfF8iQuJzq0PQXh1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 033/547] io_uring/cancel: recognize "no timeout" on 32-bit
Date: Wed,  4 Nov 2026 16:03:37 -0500
Message-ID: <20261104211039.284315084@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 3774e4d4c8533da2caae95556c4d635c7c4f45b8 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/cancel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index e9988a9dbb144..9732002449b94 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -319,7 +319,7 @@ int io_sync_cancel(struct io_ring_ctx *ctx, void __user *arg)
 	if (ret != -EALREADY)
 		goto out;
 
-	if (sc.timeout.tv_sec != -1UL || sc.timeout.tv_nsec != -1UL) {
+	if (sc.timeout.tv_sec != -1 || sc.timeout.tv_nsec != -1) {
 		struct timespec64 ts = {
 			.tv_sec		= sc.timeout.tv_sec,
 			.tv_nsec	= sc.timeout.tv_nsec
-- 
2.53.0



