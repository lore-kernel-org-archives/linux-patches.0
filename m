Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003DC221F1E;
	Mon,  2 Jun 2025 15:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877460; cv=none; b=USIH+RvtemeiPFuh23iLJqyKjC3jMixU0P+OjAEOtKnsPIX+xRMcGW1DixRulOwkooURhbrZPVIC5KWLfvk+99AMYVQYegMyU3oIQcU7RtvG2LqFPTvzVmFKw1E4JplDBpV9N94yON7tPUbxvwbb0H4noxbGcj/lIp3TfDwofPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877460; c=relaxed/simple;
	bh=76vHNv3MnwbkkfQ2b2baTyqmcaUo96fvkplPbM1Em2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lhk/lXrSTM4/jiVV6R+QeqIMjrepgWZQ0vCzgodVk0pdAUnkr14qIH4FvgkDUkMkGp1t8Eg0e4wNdJBT8/ABIKrytMGE01uyIbTnY8tPnV7V1PCPHXzQANmft7jf5d18+I4KxEtdXxxlcGsVx4WKYsUNWw7GxH55q0fWTGAJxqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kcZ57PA5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kcZ57PA5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A11EC4CEEB;
	Mon,  2 Jun 2025 15:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877459;
	bh=76vHNv3MnwbkkfQ2b2baTyqmcaUo96fvkplPbM1Em2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kcZ57PA5w9m8SrLSZsJ3tIcjKJOEuP/ck8YsAdo86s9AriN9lUwNrhIAr3Uvf84ZD
	 3XwyXDLjxPDi5KQDgYckJ2w7TeYAKCwSzvqxsMkakIIIq6FL4NZ9imNl7nXs8mxt+7
	 aPmABpdyiz1MnKLqBlymXH/v4F0OpVeXvwq6Q/G4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jens Axboe <axboe@kernel.dk>,
	Jakub Kicinski <kuba@kernel.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.1 285/325] af_unix: Replace BUG_ON() with WARN_ON_ONCE().
Date: Mon,  2 Jun 2025 15:49:21 +0200
Message-ID: <20250602134331.343151029@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

commit d0f6dc26346863e1f4a23117f5468614e54df064 upstream.

This is a prep patch for the last patch in this series so that
checkpatch will not warn about BUG_ON().

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Acked-by: Jens Axboe <axboe@kernel.dk>
Link: https://lore.kernel.org/r/20240129190435.57228-2-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/unix/garbage.c |    8 ++++----
 net/unix/scm.c     |    8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
@@ -145,7 +145,7 @@ static void scan_children(struct sock *x
 			/* An embryo cannot be in-flight, so it's safe
 			 * to use the list link.
 			 */
-			BUG_ON(!list_empty(&u->link));
+			WARN_ON_ONCE(!list_empty(&u->link));
 			list_add_tail(&u->link, &embryos);
 		}
 		spin_unlock(&x->sk_receive_queue.lock);
@@ -224,8 +224,8 @@ static void __unix_gc(struct work_struct
 
 		total_refs = file_count(sk->sk_socket->file);
 
-		BUG_ON(!u->inflight);
-		BUG_ON(total_refs < u->inflight);
+		WARN_ON_ONCE(!u->inflight);
+		WARN_ON_ONCE(total_refs < u->inflight);
 		if (total_refs == u->inflight) {
 			list_move_tail(&u->link, &gc_candidates);
 			__set_bit(UNIX_GC_CANDIDATE, &u->gc_flags);
@@ -318,7 +318,7 @@ static void __unix_gc(struct work_struct
 		list_move_tail(&u->link, &gc_inflight_list);
 
 	/* All candidates should have been detached by now. */
-	BUG_ON(!list_empty(&gc_candidates));
+	WARN_ON_ONCE(!list_empty(&gc_candidates));
 
 	/* Paired with READ_ONCE() in wait_for_unix_gc(). */
 	WRITE_ONCE(gc_in_progress, false);
--- a/net/unix/scm.c
+++ b/net/unix/scm.c
@@ -50,10 +50,10 @@ void unix_inflight(struct user_struct *u
 
 	if (u) {
 		if (!u->inflight) {
-			BUG_ON(!list_empty(&u->link));
+			WARN_ON_ONCE(!list_empty(&u->link));
 			list_add_tail(&u->link, &gc_inflight_list);
 		} else {
-			BUG_ON(list_empty(&u->link));
+			WARN_ON_ONCE(list_empty(&u->link));
 		}
 		u->inflight++;
 		/* Paired with READ_ONCE() in wait_for_unix_gc() */
@@ -70,8 +70,8 @@ void unix_notinflight(struct user_struct
 	spin_lock(&unix_gc_lock);
 
 	if (u) {
-		BUG_ON(!u->inflight);
-		BUG_ON(list_empty(&u->link));
+		WARN_ON_ONCE(!u->inflight);
+		WARN_ON_ONCE(list_empty(&u->link));
 
 		u->inflight--;
 		if (!u->inflight)


