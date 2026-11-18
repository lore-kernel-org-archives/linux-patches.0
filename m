Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057864;
	b=1XoJjhO8bSlziuopU/Kqh7RWlMJLPeSQV1M96by01Qif2jwZddF9Sp5ePPDMUzVeAm6U
	 H7awhSh9V/ILFej0d+DKDL4RCnux8GdPkSFN8YazgPd6jwvhvCbwHEYE/Ig9bCM+MCDxJ
	 AncC5uKCHCw3AqxLcokSK7d9rgF1E59zaDR3aIfx63JKZihCJTwqhenAvy62n+2w4vZ6R
	 yxXup9bVFZuUlZ3sWLNyowLkTB38p3zcjV0pQBQ/va2xobKNBA1NUsDDAFnQ0PDVY+1j1
	 tOilhiMgacPzagwIQ/AMz9V0lH6KY4bM8KiC94F+1Q7UwmUIzeGYjT9K11Rpl+DX7ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057864;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S5QzVH/Idcf5mdUImk1ygJIkjcifjDB6XErha+/Yy3o=;
	b=L9A4vQg+LR+K0bE1odG/HVKxdt7mm4hoE330yEa1rhg/BX9Eh3Y6LotLsVAbc6TyRoUX
	 0dPySsCz6bweoBCctU7qL6+QYMzF9I7+a/I6wwnTcl6YKlrBYDxM+qEr1xe5btynhQXXd
	 b8Sq0NehllRtgFA8EgrG5inxddXgiILAThn2oeT8bf/bRQW/9u0GMQG0H1DJv4pL3BBk4
	 JEQGUhhAivkMyyQTF/vWuaomoAM7zx8Cn4oEQmk0STSJTgWU0qBSOthzxDPRgg7zxVOip
	 s2yK2CWHdATbmluRiy1LtQHFQ7xxDsxtFuG1z7tF2N85w6e7buDBLo6C0I2KeO9Z6Ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=umfUFsA7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F238B606A320;
	Thu, 19 Nov 2026 03:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=umfUFsA7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E901F000C9;
	Thu, 19 Nov 2026 03:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057863;
	bh=S5QzVH/Idcf5mdUImk1ygJIkjcifjDB6XErha+/Yy3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=umfUFsA7FKoW6HXLdfZ2p1aYPa7ydDPFBrN+jnIuX00IuZDhdxF8FfyNZKpwfY8Iq
	 v/0h1yvpXsJjXZ4cm0YEyocM4bPr7OCvr0iYBKhfdzXGTy+hnvVYvkO9rKXuxxnU/p
	 oMAsKNS1iwFks/MKfrizMCJ0DhNysTsuxn0H36po=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>
Subject: [PATCH 5.10 0264/1848] ocfs2/dlm: hold the lookup reference across convert AST enqueue
Date: Wed, 18 Nov 2026 15:38:22 +0100
Message-ID: <20261118145923.339367524@linuxfoundation.org>
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

From: Joseph Qi <joseph.qi@linux.alibaba.com>

commit 125fe08ff6cfa064e1212f586f01993ee45c0330 upstream.

dlm_convert_lock_handler() drops the reference it took when it found the
lock on res->granted at its leave label, one statement before it calls
dlm_queue_ast().  dlm_free_dead_locks() takes res->spinlock and drops the
list and base references, so a peer death landing in that gap leaves the
handler's own put as the one that frees the lock, and __dlm_queue_ast()
then reads lock->lockres from freed memory.

The handler is registered next to dlm_create_lock_handler(), so a convert
message buffered on a dying peer's socket arrives on the same o2net
receive work that o2net_disconnect_node() does not wait for.  The two can
interleave as follows, with the reference counts as they are before this
fix:

  Socket data-ready       Node-down thread      Receive worker
  -----------------       ----------------      --------------
  o2net_data_ready()
    select sc under
    callback read lock
                          o2net_disconnect_node()
                            queue shutdown
                            begin flush; new color
    queue sc_rx_work
    in the new color
    release callback lock
                            shutdown socket
                            flush returns
                                                read buffered convert_lock
                                                dlm_convert_lock_handler()
                                                  find lock on res->granted
                                                  dlm_lock_get()  refs = 3
                                                  lock res->spinlock
                                                  __dlmconvert_master()
                                                    call_ast = 1
                                                  unlock res->spinlock
                          DLM node-down cleanup
                            lock res->spinlock
                            dlm_free_dead_locks()
                              unlink lock
                              put list ref  refs = 2
                              put base ref  refs = 1
                            unlock res->spinlock
                                                dlm_lock_put()  refs = 0
                                                  free lock
                                                dlm_queue_ast()
                                                  __dlm_queue_ast()
                                                  read lock->lockres
                                                  (use-after-free)

__dlmconvert_master() only moves the lock between lists, so the count
entering the gap is base, list and lookup.  Drop the lookup reference
after the AST is queued instead of before it and the race ends with the
one __dlm_queue_ast() took, which dlm_flush_asts() releases later with
ast_pending cleared and ast_list unlinked.  No extra get is needed, and
the normal case ends with the same count as before.

dlmconvert_master() has the same shape but is only reached from dlmlock()
for a lock this node owns, which dlm_free_dead_locks() never matches.

Link: https://lore.kernel.org/20261014112321.2955584-1-joseph.qi@linux.alibaba.com
Fixes: 2c5c54aca9d0 ("ocfs2/dlm: Add missing dlm_lock_put()s")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/dlm/dlmconvert.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/fs/ocfs2/dlm/dlmconvert.c
+++ b/fs/ocfs2/dlm/dlmconvert.c
@@ -536,15 +536,19 @@ int dlm_convert_lock_handler(struct o2ne
 	}
 
 leave:
-	if (lock)
-		dlm_lock_put(lock);
-
 	/* either queue the ast or release it, if reserved */
 	if (call_ast)
 		dlm_queue_ast(dlm, lock);
 	else if (ast_reserved)
 		dlm_lockres_release_ast(dlm, res);
 
+	/*
+	 * Keep the lock alive through AST enqueue: a concurrent
+	 * dlm_free_dead_locks() drops the list and base references.
+	 */
+	if (lock)
+		dlm_lock_put(lock);
+
 	if (kick_thread)
 		dlm_kick_thread(dlm, res);
 


