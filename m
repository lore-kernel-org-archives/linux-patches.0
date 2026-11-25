Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620233;
	b=N/XOLLA0y6R86vFhgDgREYy4ZVoqy3ktBnSMJFL3UZbs7R+ZuIe02D/fklz7PJX6bXli
	 X3KsmjCTa0V3Zcr3SjRkXXJCeRa3zxiqKViCPaNBWkr2FxwKTHWu9fVOyPQOMe0K4rKBO
	 7xwGOcORJY1FacAvj49pQvagjnCi3706eVTUAEEpTyRL5PwVJFVpr7vTFkUcNeOEHuVjB
	 BfT1evCl0xz9OEp5vDTfk2C+L1C9kJ3WEvvePatuTCL7LouBT6fRqgW7+wjLilhgI5fM3
	 jy9AAOLpE5uc6UXDVBMIN1+nkAeiQ8lHjJdardzMDGJQJpSbfJ0ia3p3hyNo7GuCWRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620233;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F/xTcJibMVyGuW2IOO8L5cUZBd20yZ4F1Jz4NJY9Rbs=;
	b=OhhBM0DD/bwjHLNz3lYnt7P29ZO4pB5Bs1bancxLBijdDrHflq9Gunr0RZMIMHYvexIO
	 z/OcJMw/fkV5ekUXiGpxuswgwqsQrNOtuN5aKDNh/hxDvFhzr7udc8jnfXVBUGj12nEDV
	 AACyK5wV+H8A8DvM8R/Fsy4MG0F8IeoIvXAOwghFbcQMjvXrHkTWRlHSmMxYrVdQsL2Ev
	 bIJl00Lzt3Nndy2uXQSUMf0l/rgyRtnbMFZ3pSXt3Vxu/R1OwQECPEUUCzGw+U21kDKti
	 cBYHJ/NHZ0mh0nNOJ7NzYb8402I0Nip+9/buS6dI539iH2kHb9MbNQGuSPLlpHB7iuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TA0Toa8f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1747606A6A0;
	Wed, 25 Nov 2026 15:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TA0Toa8f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 155681F000EC;
	Wed, 25 Nov 2026 15:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620233;
	bh=F/xTcJibMVyGuW2IOO8L5cUZBd20yZ4F1Jz4NJY9Rbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TA0Toa8fzJEUqNI0OMzBjbeRKyBc69m3Z9z26sMSdIbnH6f0SHEkfPq6DT1KHtJMd
	 +MfW3tRoYoDzaZOurZviFdxSx8ziLQ0p0N4S+W6zWvNuNflWH+102ZfK+PZ5GJ10lC
	 f6aCSS6vjIpYEfKOf+zQz/ATp6oOQeSf/XF15mHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yaohan Li <shunsheng1218@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.3 0853/1005] dm: avoid double-dropping the zone reset submission reference
Date: Wed, 25 Nov 2026 15:36:31 +0100
Message-ID: <20261125143841.690768891@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Yaohan Li <shunsheng1218@gmail.com>

commit c4965effbe15f837a8089e79c0fc17ab19363cce upstream.

On an error in __send_zone_reset_all(), the submission reference
held by the dm_io can be decremented there and again by the caller's
error path. If another clone is still outstanding, the second drop
can release the dm_io before that clone completes.

Only drop the submission reference in __send_zone_reset_all() on
success. On failure, leave the reference for the caller's existing
error handling to release once.

The error path was reproduced under KASAN with an injected GFP_NOIO
allocation failure while another zone-reset clone remained in
flight. With the change, the same failure was reported normally,
without the observed use-after-free, and ordinary zone resets
continued to work.

Fixes: 81e7706345f06 ("dm: handle REQ_OP_ZONE_RESET_ALL")
Cc: stable@vger.kernel.org
Assisted-by: ZCode:GLM-4
Signed-off-by: Yaohan Li <shunsheng1218@gmail.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1929,8 +1929,13 @@ static blk_status_t __send_zone_reset_al
 			break;
 	}
 
-	/* Release the reference that alloc_io() took for submission. */
-	atomic_sub(1, &ci->io->io_count);
+	/*
+	 * Release the reference that alloc_io() took for submission. On error,
+	 * that reference was not consumed: dm_split_and_process_bio() releases
+	 * it on the error path, so do not release it here a second time.
+	 */
+	if (sts == BLK_STS_OK)
+		atomic_dec(&ci->io->io_count);
 
 	return sts;
 }


