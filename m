Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619413;
	b=eNC9+LxMjPonJ4warLM6X1CraziBECLifHqgqh6r3irjt/uvIa1b2h5UdLZmCrBKzMul
	 hn3oGcfUvhI+54YrDUGCKwfCBcCEslTmtGSgAiQpBW1faWREh1E3cF1to4qDkOHhR27WO
	 H8A1hOKHEEHfCg6Y6JKmmGHZazFpSE4mLQ9B9spx2LvkVOnPhEXrrKmQMdeK+tgV2cWnC
	 N93AnfkXRzXNxz0OfGIK2hcw99tgvYNkR2ncv1SCA8UA+Jh100fjmv9WAzKAWg3Rkaj26
	 w2GnNwdIEumeoXrd42s0m1cBjyWh2bfjAzubRnXjFpLE5IKn8257Vxyv9ygajqGphFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619413;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Tceifa3OWSzxcwfRzCiwvmnSs1vQMCiUjBZWWcADBs8=;
	b=FzF61jVf+jkKlEnKjeyd2U2wCRunwY+rsWECeSjXct7R58hW54Cvzd22NPbkglyVyKw6
	 CwRgS2M7aujEQRHbSYA73DBuWm1FaUKULQCn+gMnHC+lud3GEKutfKm/u64oULjgaVerE
	 23IdhY0PNtTv2neT9NRWsTtKgnx05fdq40JAR/gRHOGjg9WaaVxNuRzcERk4sD//nCenx
	 HO+vngnFYkRxI82ba82HmtS5yVVppUdntKQaHLd324OEhXWzY7dRdwMWs6ABJ1UUcc+t9
	 WDuWwYwnNPPzlwPT1XZkqLBPcVvAvjc9nS8g6/QRiRhaiJmFvtxum4hKeK0lqOiJECQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ugDnv1EV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1C1606A321;
	Wed, 25 Nov 2026 15:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ugDnv1EV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A3E31F000CA;
	Wed, 25 Nov 2026 15:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619413;
	bh=Tceifa3OWSzxcwfRzCiwvmnSs1vQMCiUjBZWWcADBs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ugDnv1EVgIxt22NWO0ckhFyqa2q0+QoZmWBuza0Jfp6PamjSriJBMQNaJyX57VY+f
	 ex6gzhgiRkf1+P5puzxvjA0dFxzMQNk7m5+8uITo7RAE+xti6geswAHuhQ8neOy9Ru
	 TKx9ArNTQ/eG9FbjJQjGb9eixDto2xzZTFnbMOxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shashank Mohan Jain <jain.sm@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.3 0587/1005] errseq: dont let errseq_check_and_advance() hide later errors
Date: Wed, 25 Nov 2026 15:32:05 +0100
Message-ID: <20261125143835.498325224@linuxfoundation.org>
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

From: Shashank Mohan Jain <jain.sm@gmail.com>

commit 94defd41d80f10bbe883c0c8d1b28d1665b6b153 upstream.

errseq_check_and_advance() reads the errseq_t, sets ERRSEQ_SEEN with a
cmpxchg() and then advances *since to the value it computed, ignoring
whether the cmpxchg() succeeded. When it fails because errseq_set()
recorded a different error in the meantime, *since ends up holding a
value that was never stored in the errseq_t.

errseq_set() only bumps the counter when ERRSEQ_SEEN is set. So as long
as nobody has seen the new error, recording the original errno again
recreates exactly the old value, and once another subscriber marks it
seen, it is equal to the stale *since. The next check through that
cursor then reports nothing, although -ENOSPC was recorded after the
value that check reported, and -EIO was recorded again after it
returned:

  cursor f                writeback              cursor g
  --------                ---------              --------
                          set(-EIO)
  check_and_advance(&f)
    old = [c, EIO]
                          set(-ENOSPC)
                          -> [c, ENOSPC]
    cmpxchg() fails
    f = [c, EIO, SEEN]
    returns -EIO
                          set(-EIO)
                          -> [c, EIO]
                          (no bump: unseen)
                                                 check_and_advance(&g)
                                                 -> [c, EIO, SEEN]
                                                 returns -EIO
  check_and_advance(&f)
    [c, EIO, SEEN] == f
    returns 0             <- -ENOSPC and the second -EIO are lost

For file->f_wb_err this means that fsync() on one descriptor can return
0 although writeback failed after the previous fsync() on that
descriptor returned, when writeback errors race with fsync() on another
descriptor of the same file. The same applies to syncfs() through
sb->s_wb_err, which every file on the filesystem shares, and to the
ext4 and jbd2 cursors on the block device mapping. The kernel-doc
promises "Negative errno if one has been stored, or 0 if no new error
has occurred".

Retry with the value found when the cmpxchg() fails, so that *since is
only ever advanced to a value that was actually stored with ERRSEQ_SEEN
set. Every later errseq_set() then has to bump the counter, and the
error is reported. The retry loop terminates because each iteration
needs a concurrent update, like the loop in errseq_set().

A TLA+ model of errseq_set() and errseq_check_and_advance(), checked
with the TLC model checker, finds the lost error with the current code;
with this change TLC checks that an error recorded after a check
returned is always reported by the next check (exhaustively for two
subscribers with three checks each, and one writer recording four
errors or two writers recording two each). The KUnit race test added
in the next patch misses the error in 1-6% of 2 million rounds on
4-CPU UML before this change (depending on host load), and in none
after it.

Fixes: 84cbadadc6ea ("lib: add errseq_t type and infrastructure for handling it")
Cc: stable@vger.kernel.org
Signed-off-by: Shashank Mohan Jain <jain.sm@gmail.com>
Link: https://patch.msgid.link/20260927051726.71337-2-jain.sm@gmail.com
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/errseq.c |   29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

--- a/lib/errseq.c
+++ b/lib/errseq.c
@@ -162,7 +162,8 @@ EXPORT_SYMBOL(errseq_check);
  * points to. If it does, then just return 0.
  *
  * If it doesn't, then the value has changed. Set the "seen" flag, and try to
- * swap it into place as the new eseq value. Then, set that value as the new
+ * swap it into place as the new eseq value. If the swap fails because the
+ * value changed, retry with the new value. Then, set that value as the new
  * "since" value, and return whatever the error portion is set to.
  *
  * Note that no locking is provided here for concurrent updates to the "since"
@@ -184,24 +185,30 @@ int errseq_check_and_advance(errseq_t *e
 	 * to take the lock that protects the "since" value.
 	 */
 	old = READ_ONCE(*eseq);
-	if (old != *since) {
+	while (old != *since) {
 		/*
 		 * Set the flag and try to swap it into place if it has
 		 * changed.
 		 *
-		 * We don't care about the outcome of the swap here. If the
-		 * swap doesn't occur, then it has either been updated by a
-		 * writer who is altering the value in some way (updating
-		 * counter or resetting the error), or another reader who is
-		 * just setting the "seen" flag. Either outcome is OK, and we
-		 * can advance "since" and return an error based on what we
-		 * have.
+		 * If the swap fails, a writer or another reader changed the
+		 * value under us, so retry with the new value.  "since" must
+		 * only ever be set to a value that was stored with the SEEN
+		 * flag: errseq_set() does not bump the counter while the
+		 * flag is clear, so an unstored value could come back later
+		 * and hide the errors that were recorded in the meantime.
 		 */
 		new = old | ERRSEQ_SEEN;
-		if (new != old)
-			cmpxchg(eseq, old, new);
+		if (new != old) {
+			errseq_t cur = cmpxchg(eseq, old, new);
+
+			if (cur != old) {
+				old = cur;
+				continue;
+			}
+		}
 		*since = new;
 		err = -(new & ERRNO_MASK);
+		break;
 	}
 	return err;
 }


