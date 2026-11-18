Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046403;
	b=Gh5vPTDBabsgfl+uBBRM8SwjBI++R7REsrr7SMd5mnHwKSxT0lHq/9lYBDPvCLnyPxy+
	 qqmoqkX1AafA1hTXaTVlzgchtsemU7ju6abzhagy/5qQ7FnGMeLQnYwveZ3tzX8aI4jtG
	 XgCsv29D/qxnj6SH7Q29VWchcUJIm3Qm8v/NGCr7IEQgAKZWl+pbSpxffiw+LHGRpZq9r
	 zuNSKGF1Q9QRY4EKwG4Imi8U7LIlZiKYj/jOzwmQbdbIERODgA3RjXTB8bo7lKx6TT2sm
	 lkF2w02AOC8Dfqc9XYBR1NZGBBpZjx+VVvG7Tw+v8JBvNJHY0MoAor+EyQkMKyPRB0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046403;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S9b0QtqQY1MA6xXrg0evXgcMaFqJJWUktDIes932La4=;
	b=1o21Nho2NLpFwQZFsgexYmsoo8pE95AZ4oR4n5wAX9eBDFG3mcCRgY0CaOLu66jBa7uJ
	 dAtrCsPltdCaGwcYIRbYhPnr3yKygQGzMwAVscx4KKcSE6POH3h4xEBaMk8O9FqZX9M1C
	 TcVI6Eymkh/V1i4pFj3wIcUU+VgpCNqidhqLAJvxrMHoAn5gxeiUOe7nW8L4EBX5LN0so
	 wsHj+7LllE2lZlM60BnGlFHQVQe5wBeS0NPJ6x7vPHe+ibZdfSUAAPRXwl1C0iGfImPW3
	 Xpm2DGONuxWccAEYWH1MhhxcKxzihmonTgC0CKCIciyq86leGDJYFadKMZGi5qXOkZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NbK0B9tX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04716606A320;
	Thu, 19 Nov 2026 00:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NbK0B9tX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70A9C1F000C4;
	Thu, 19 Nov 2026 00:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046402;
	bh=S9b0QtqQY1MA6xXrg0evXgcMaFqJJWUktDIes932La4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NbK0B9tX6L32jXrEptlIbzM4aN0Z2xpkRT0CVaVyUdCXQG+2hIWfFNxphDfeCZ9vw
	 +aKL2RI9V3YSzWgUfJankrn0bUYdzemUZPqNn2mYNIi9eqH/Homxd7fSVpBowkHSHD
	 RMsn7awKc5ldQN+KmF3vqNKa55zkn8T5i7MVhUqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Hungyu Lin <dennylin0707@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1268/2857] inotify: do not coalesce rename events
Date: Wed, 18 Nov 2026 15:38:22 +0100
Message-ID: <20261118150247.178528599@linuxfoundation.org>
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

[ Upstream commit 581230d2ec3c0380917d1255792508851e7c4627 ]

inotify compares the mask, watch descriptor and name when coalescing
adjacent unread events, but ignores their rename cookies. Distinct
IN_MOVED_FROM events can therefore be coalesced, losing the cookie needed
to match a later IN_MOVED_TO event.

For example, watch two directories with IN_MOVE. Move an entry from the
first directory into an unwatched directory, recreate it under the same
name, then move it from the first directory into the second watched
directory before reading the events. The second IN_MOVED_FROM is merged
with the first, while the IN_MOVED_TO retains the second rename's cookie.
Userspace can no longer pair the second rename's events.

The original inotify implementation compared cookies before coalescing.
The fsnotify conversion lost this comparison. Do not coalesce
IN_MOVED_FROM or IN_MOVED_TO events, which carry the identity of their
respective renames. Leave coalescing of other event types unchanged.

Fixes: 63c882a05416 ("inotify: reimplement inotify using fsnotify")
Cc: stable@vger.kernel.org
Suggested-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Link: https://patch.msgid.link/20261027192027.8617-1-dennylin0707@gmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/inotify/inotify_fsnotify.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/inotify_fsnotify.c
index 993375f0db673..ff0af29745a8c 100644
--- a/fs/notify/inotify/inotify_fsnotify.c
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -36,7 +36,7 @@ static bool event_compare(struct fsnotify_event *old_fsn,
 
 	old = INOTIFY_E(old_fsn);
 	new = INOTIFY_E(new_fsn);
-	if (old->mask & FS_IN_IGNORED)
+	if (old->mask & (FS_IN_IGNORED | FS_MOVE))
 		return false;
 	if ((old->mask == new->mask) &&
 	    (old->wd == new->wd) &&
-- 
2.53.0



