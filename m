Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212732;
	b=aVgko4+azZx7+EvSZSKomXG1OOVD7hHEkVhHU/BZuOI2SQ2OyJz13kRO2XAZvjwhY+Fq
	 kS6lGcisTnxnGCzKC0z9qfjgMb259MSmIjZuJM5pNhu4MxI6grX+BvSddBE+vI0pOKmuC
	 wKYqsvCwTvavEkFXk14Lj1vnhcehr7/zTPLqK4o07q/TWyui69oaLH4ARTc9CMFRtd6Va
	 F9li2vN0xOlyiGG/F+s+dpEfjCnquJ6OeFprILgz17nsnFs7IdV1LXvyNPsXzAQBlpO+T
	 6PdnwfqwxcEfeiMElvcVlFOkV1urTIKzGj8i9su9YgUvk9x/MpHdK58Va/+MThdZArA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212732;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Qov4edp1/pPdEYbMOj6D5R+xVddNHQeLkFl0M6oncSs=;
	b=GJSPdNMmH7qSeyaL/ENvJYJFRlLUR1P+XhexHt9CKdeTqObbKASVJHKib2gBzFWJLFrE
	 QwwzVwYCFCgGeG219RCPMEUOTTgGLfZIEB/+IHS2N9cZAdJ+JKXNHnLoJbe8j/9KQkMZE
	 GPnva1CuHKEb7OdfTvKGIKDEOxvug3HX2Jwxv6Bev5sgoCN8x2hE82GzGmReee2nnb0AG
	 MKdtTaz6P0dmn/nKk9n48ClT+36qAt111k5p5dLHLQYgVq92Pl8T7l2EM1S7KKo+NnkdF
	 js2f5DI8xs5zOP4QB/A90aE9kOnW3l7/g+RXbBVAmKsSyiJeSjSznN3wk2ECPViP7Ig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HDN+1Chw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF0E606A321;
	Wed, 28 Oct 2026 18:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HDN+1Chw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE971F01825;
	Wed, 28 Oct 2026 18:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212732;
	bh=Qov4edp1/pPdEYbMOj6D5R+xVddNHQeLkFl0M6oncSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HDN+1ChwmUPkXb36Z9fju2Yw9si/SWGwwYdLciqVIDRi8Gqey12TOO4apvSCZF34E
	 XMnBhqemclJlQylTKPgfO7BNP2tdVSbfHAS8b/4+T/SveCg5a8dOAVlzyy7Tvqg+Zn
	 csXwd5BkGLT4pXbA9/ee+xxDUFINYpidLn0k2vko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Tomer Pomeranc <tomerpo@gmail.com>,
	Carlos Llamas <cmllamas@google.com>,
	Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH 6.1 0258/1887] binder: fix leaked fd fixups on TF_UPDATE_TXN supersede
Date: Wed, 28 Oct 2026 17:39:14 +0100
Message-ID: <20261028170505.100312833@linuxfoundation.org>
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

commit c4c02084d6687d5cd5edccaf52cc45e5160f1184 upstream.

When a TF_UPDATE_TXN transaction supersedes a pending async transaction
in a frozen process, the outdated transaction is freed with kfree()
directly. This skips binder_free_txn_fixups(), leaking all
binder_txn_fd_fixup entries and their fget()'d struct file references.

The leaked file refcounts never reach zero, so the struct file objects
are permanently pinned in memory. They survive process exit and
accumulate across invocations until file-max exhaustion.

Every other transaction cleanup path (binder_free_transaction(),
binder_transaction() error paths, binder_release_work()) correctly
calls binder_free_txn_fixups(). Add the missing call before kfree()
in the t_outdated cleanup block.

Fixes: 9864bb480133 ("Binder: add TF_UPDATE_TXN to replace outdated txn")
Cc: stable <stable@kernel.org>
Signed-off-by: Tomer Pomeranc <tomerpo@gmail.com>
Acked-by: Carlos Llamas <cmllamas@google.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Link: https://patch.msgid.link/20260812195316.259136-2-tomerpo@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2835,6 +2835,7 @@ static int binder_proc_transaction(struc
 		trace_binder_transaction_update_buffer_release(buffer);
 		binder_release_entire_buffer(proc, NULL, buffer, true);
 		binder_alloc_free_buf(&proc->alloc, buffer);
+		binder_free_txn_fixups(t_outdated);
 		kfree(t_outdated);
 		binder_stats_deleted(BINDER_STAT_TRANSACTION);
 	}


