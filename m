Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059093;
	b=pboMHPywK52lK2IBWUZ/i1MCEDD4zEfNX/yP/lX2Je+pZtqGQRPjeKTWiMzYlTBJCH4Z
	 F0QZJWjWw3tQb100lX6BIQ/qpEkW8GCSzmxAM1xCN2OMGbH93r1seTM/F+a/O0yvMf30T
	 zlR/p8uPPqBiBr1hUFmqvGr2KBJCtIRY3GBaqY+QjDBQzPHJv4Vsbm0kACziAMhAxkQZ4
	 QBfvYmr/PNXtfx7X5AYGN8Zr9j7SqxgLw1pMbLvsvL4LrRVUO3mmr0+RX+K2+LjbOjEvi
	 N2ydzw8T/RuIlFvkV4OpqYj3ydzdfCJHme+L/8g9f/mwPor3KUtlclsvTo3mrsOEG4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059093;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g3KMXc+iXoV7vx/z3NfGZasdfqqTzCwTF5/boUQJV5M=;
	b=NjVX0aZknY7FsO0P+g0NjGEQHBbMSCjzgzyo7HmP4Ch8dqaStqoe7lOHZX9+Uptj8d/v
	 ieSBodYJDuag8Iafo3YauMZ6aP9GnBGeLCCopuHH50OkNHr72CRS7VgKbfspYqIC8dlbQ
	 abiu11sMLZtkQE7bayNGUBtYr2URXZi+YIhh6z7WaWtuBVfhOO+urDWXCC+km5wLmB8Zs
	 gaNmHiLCHTbBTjz0is/BzWfThmpekSOHvejNmo4E9iuSyok0BATtTMHdnHZ8yTzHEZiUD
	 ZJKPAFl+EywQbXtD4tygyEwG3A5JmU2UgJ3UeMc1SABvEB1akHoZcWz1IK7+TH03sXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZGmF6FQn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80340606A31C;
	Thu, 19 Nov 2026 03:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZGmF6FQn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAC211F000C8;
	Thu, 19 Nov 2026 03:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059093;
	bh=g3KMXc+iXoV7vx/z3NfGZasdfqqTzCwTF5/boUQJV5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZGmF6FQnHBKBUoQ0/vKZRVwDuZMRac1UrRifiQvgK+oA8rZKRDiq/k0G4rSXQFnZw
	 cLEi1xdk/rUC1q/BDuSKHQW4Cq8aDGhu7kNEmWI+2nYT1fqUscdEI26CaCZfbXh/qc
	 8IeP/VxDDzKJwY9mjldfovF4liH1fiCZZ8xjClCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Hungyu Lin <dennylin0707@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0720/1848] inotify: do not coalesce rename events
Date: Wed, 18 Nov 2026 15:45:58 +0100
Message-ID: <20261118145945.972702488@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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



