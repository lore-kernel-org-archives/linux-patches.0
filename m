Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619668;
	b=yWFdBArAKlK8aTa+6F1e+nRXnmuijJ79n7r10ePRE/zuVctzaWeDvaJ+lwIjOW4wN2rO
	 GttrxcGw8zM5BXJsjPtP0tGVYvPd8NLew2l3RvKqjh0w40ZOrwqAtfd7lQasGip/KFr9Q
	 ZG85Uck2ESUfjIPOeKpIMl/wQMRgrvkNjfao7yOx0qNmHhZJUnWGMWw2dkcrCu1sNWpEn
	 FoMOjo19vNGQflVEoiepShMsb9YdyZ9Exu0YGYLm8/2w+XbeeTRXMCQ5nKLPNOdspC7KP
	 AFLrXIMmld7pLNQfcPXUznlmgV3lTjhbKuxBzIep63PtiA4BqjZ02fDwyq6LZGXJ8NA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619668;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SUdyQoRiH4pXyy16ujuo5SfPN7+JZ1hR4ge5bYGts9E=;
	b=C9PjV5/wYfFbb+pJaXytPH47IBXvx4OFueOAGzd1lTXGkH1uiQzFxJBz/Bkq5j+pEVFn
	 5E8/Oydpt/Ki0FTzoYOhM6u9uVTVeRf6NPeb+1Ser5cviBVKF5u3pQtk1H9kxcVxSsCtb
	 vyX/7K1BtIK3Q8AcMluMqwHfj/YBGC6HA5r8ZzPYOABlYWK2+lZSmQbGt9Qv8bwAcI/QI
	 bfg0szEQcNjvrUGKOpIBDvDdfuu9izP0cbftVRKgyF6gItcKCbtgbHCtuR4WowXcaTa7P
	 YkdoF8EXp3/YiQrr5ytKlSBTvrUFdGziQZ/MjA6FjHRZE0eQmWuciYsVOkTCqGE1dJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CF6436Ko;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FCAA60A2601;
	Wed, 25 Nov 2026 15:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CF6436Ko
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E05F41F01801;
	Wed, 25 Nov 2026 15:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619668;
	bh=SUdyQoRiH4pXyy16ujuo5SfPN7+JZ1hR4ge5bYGts9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CF6436KoUGuSbubW9fZx2+a6wR2B2s48ZF0LsijDSCDlFbnh7ZRpC4+1MkFePYBmt
	 UbL6hDOvZHBQTp3Tr/BisTScOcksFwPIPxj2joFf1w/yXrE7eCE9sqU3nXZ+AT5esb
	 yfNdX+HMwu2oRQuQ37O9oDkmbuzs2Ut0pgFA800o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Menninger <tmenninger@everpuredata.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>
Subject: [PATCH 7.3 0671/1005] NFSv4: Prevent indefinite waits for out-of-order OPEN stateids
Date: Wed, 25 Nov 2026 15:33:29 +0100
Message-ID: <20261125143837.470710651@linuxfoundation.org>
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

From: Tim Menninger <tmenninger@everpuredata.com>

commit 151d95a1e696979a7d54b23c96338754be2fcc1f upstream.

When processing an out-of-order OPEN stateid on an NFSv4.1 or later
mount, nfs_set_open_stateid_locked() waits for stateid updates to be
processed in order. A five-second timeout is intended to prevent
indefinite waits when preceding updates never arrive.

However, each iteration calls schedule_timeout() with a fresh
five-second timeout. An update to the shared open state can wake the
caller without satisfying its ordering check. The remaining timeout
is then discarded, and the next iteration starts another full wait.

Under sustained concurrent OPEN/CLOSE activity on the same open state,
repeated wakeups can prevent the timeout from ever expiring. Some
tasks can remain stuck in update_open_stateid() while others continue
making progress.

Compute a single deadline on entry and pass only the remaining time
to schedule_timeout(). Once the deadline expires, take the existing
timeout path rather than starting another wait. This prevents
wakeups from extending the wait indefinitely.

Observed on Linux 6.8.0 and reproduced on 7.3.0 with 96 concurrent
O_RDWR|O_TRUNC open/close loops on one NFSv4.1/TCP file (nconnect=16).
Ten workers made no progress for over 300 seconds while others ran.
With the fix, all workers resumed after transient stalls.

Fixes: c9399f21c215 ("NFSv4: Fix OPEN / CLOSE race")
Cc: stable@vger.kernel.org
Signed-off-by: Tim Menninger <tmenninger@everpuredata.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/nfs4proc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1722,6 +1722,8 @@ static void nfs_set_open_stateid_locked(
 {
 	DEFINE_WAIT(wait);
 	int status = 0;
+	unsigned long deadline = jiffies + 5 * HZ;
+	signed long remaining;
 	for (;;) {
 
 		if (nfs_stateid_is_sequential(state, stateid))
@@ -1756,7 +1758,8 @@ static void nfs_set_open_stateid_locked(
 
 		if (!fatal_signal_pending(current) &&
 		    !nfs_current_task_exiting()) {
-			if (schedule_timeout(5*HZ) == 0)
+			remaining = (long)(deadline - jiffies);
+			if (remaining <= 0 || schedule_timeout(remaining) == 0)
 				status = -EAGAIN;
 			else
 				status = 0;


