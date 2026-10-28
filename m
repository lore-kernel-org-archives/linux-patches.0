Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212854;
	b=RsKBU/d/Pc/UJI80fbBXZcJIskFMJPSghG6yz0sxxTX8MjcGDRWF0E17Bi0mZB9XQBMe
	 T2Tr3Q6hFQdwbZutRa6tYTJpcYeNk3DQ2+AFLUZbCaDoupANebkYG/RrCl9S+buEPza3H
	 POvS2B6xBJfLrPhBXwvv/+Yui6o8R02b63aerGpKo55icCfXuBj4E3Nt0uX/GTFoxboK+
	 7yYiwMEiy+0KnOcGIWlgEYJHmg9zRfFlxnNnZsbFO3yt7DMrf4Woa7GlJeiGSKgrAQadQ
	 DVv+Uz5KbO/rO2Z2BQB1u+FPFqA0dJ1YuOyKrYgvaQqWJMXA0x65DHs/Hlei+r47egg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212854;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NGL8HyhYv6Dcge+GicwXpD5ymhr7uEZpPv3wvpS2aic=;
	b=Lp7y/jQZbGOrvbvV5r8Uf2fylt445W4cZ+o7xkqsYMF3HEL7986PDAm6A60J5QKUGPUx
	 EQQz6GUEeoeFZ/NCiSyiUFkctkxSghQ9cyyjo3MGGUtNxFQuJf+Lx6c+0nuXqYOO1o6T7
	 Mq6KQWyctGLHp+mYwfeAAp+wDQgEMzSTj4MmhqbwfX+Of5NkTrdqWDkVVemzKPZZhexYQ
	 q4J8d89MgHqnGoQUvHMQFz9J7rQVTC7Zf5cBX4AVGWSqK/oLGZtaC77OmEF8GhPXQLwfA
	 cduhw12x+00k+QDPlBkNkNzUZMGTNwc4SjvqnmZ0qw9HtdMSInW7x47niZSpnyBQF4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TGthuHmO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A52E606A31A;
	Wed, 28 Oct 2026 18:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TGthuHmO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD451F01825;
	Wed, 28 Oct 2026 18:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212854;
	bh=NGL8HyhYv6Dcge+GicwXpD5ymhr7uEZpPv3wvpS2aic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TGthuHmOUjQSGFjc24sCWWtCAK289+7TV1ZBGrIagCwjTllmpT7RAzDj2E1fTIPC9
	 lIT8h7daP8Zg2fx+X806AoE75c5LAcyjPP68+tfrLCjlvpRLgFuASKwmbOSttaT4Ud
	 OikD5U0ZtSLWvHZyjFidGGMoCmIcZsGNtfHlVoUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Tomer Pomeranc <tomerpo@gmail.com>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 6.1 0257/1887] binder: fix is_failure flag for superseded transaction cleanup
Date: Wed, 28 Oct 2026 17:39:13 +0100
Message-ID: <20261028170505.077892551@linuxfoundation.org>
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

From: Tomer Pomeranc <tomerpo@gmail.com>

commit 22c135635fdd9816c0ef140d6de7b2e4fdf73e89 upstream.

When a TF_UPDATE_TXN transaction supersedes a pending async transaction,
binder_release_entire_buffer() is called with is_failure=false. Since the
superseded transaction was never delivered, binder_apply_fd_fixups() was
never called and no fds were installed in the target process.

With is_failure=false, the BINDER_TYPE_FDA cleanup handler interprets
stale buffer contents as installed fd numbers and passes them to
binder_deferred_fd_close(), closing unrelated file descriptors.

Pass is_failure=true since the transaction was never delivered to the
target, matching the semantics of all other undelivered-transaction
cleanup paths.

Fixes: 9864bb480133 ("Binder: add TF_UPDATE_TXN to replace outdated txn")
Cc: stable <stable@kernel.org>
Signed-off-by: Tomer Pomeranc <tomerpo@gmail.com>
Acked-by: Carlos Llamas <cmllamas@google.com>
Link: https://patch.msgid.link/20260812195316.259136-3-tomerpo@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2833,7 +2833,7 @@ static int binder_proc_transaction(struc
 		t_outdated->buffer = NULL;
 		buffer->transaction = NULL;
 		trace_binder_transaction_update_buffer_release(buffer);
-		binder_release_entire_buffer(proc, NULL, buffer, false);
+		binder_release_entire_buffer(proc, NULL, buffer, true);
 		binder_alloc_free_buf(&proc->alloc, buffer);
 		kfree(t_outdated);
 		binder_stats_deleted(BINDER_STAT_TRANSACTION);


