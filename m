Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619425;
	b=VWhs/ztu/9iXerdUipCX6FFGwWeMCGDSXisZ/L9+Q/hmBOVfick1qIES5Q9BVSnHs3JA
	 W7JL778VXV8rxRePqgDCIcmonDXbqktyjSYhXHtypOQtKhNrLQ81pkEBlGoPZPL00ZJNr
	 kgUYhCPfcnTYwn2Wl3XWqPfFPRYBf8fD10CAzur9bdWrIW3DFE4XXKDZgw9bztVQFStTq
	 SDfu4WOgoNRzm7TyOerxK246Ug5bRqydNS3klDmGfrBgaMFlK1WAgm8i8x4dWkEjLpcbm
	 wozP8MO78+GsjKVNANxevzsEUUYrPK2pA3dFOEboLDhJ1cvRqwR1U5d524TKy/ueXhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619425;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P3Lhth/iApjWj/iTieCQQQUPjgtTDh9W1lS+Oikrcs0=;
	b=FSq1lY+cRP8CUcCMQF+Z+kbXe2sdxa4rwkcji1ppEFPaOIaJATP4EG7prXlSq2vWbv9u
	 xrJ7YLCFk517bf9cSXj0Ai53GUcbItnHI9mZ3JyM9FPe7FWEU6kNDd3DawOScE1fG9kzq
	 zHb/HfXBa9KCVIEMQMxrsfkKjTfwaVrffTmjo7Ke5Z5MCiSFnzT0KA/tHOizMYL9lqwKv
	 22Ycg58UD+cHgVOqeyNN90qE9uxu1mGA7owtjloJgSalIxPdYcXubAY9Y3E51qm+hgQt+
	 n8VXgWHAEie9sm0Gl9jOYriECmLjyQKS1uOQMg13XRrY7/toHk7vi5lQHCRy4NnjoMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="QoX3E/aJ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8133C606A31E;
	Wed, 25 Nov 2026 15:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QoX3E/aJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D39E11F000C0;
	Wed, 25 Nov 2026 15:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619425;
	bh=P3Lhth/iApjWj/iTieCQQQUPjgtTDh9W1lS+Oikrcs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QoX3E/aJMdXgRsolFfIXNh0Ub2eQe8Py4AoVxZnlpH5w4p55sfLbI61h2BghVA1HM
	 f4ddTP878Y1c9Coqrkeo/zm43nO1otKJ9WtSIG3U0Pw/GLy14xb/pLsRWnRiVWvpp0
	 rPd6LEURqlp0LCtW2YV5z7q5rj3TUe6kAIHeasD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mani Tofigh <mt4022@columbia.edu>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.3 0590/1005] eventpoll: wake the next waiter when a woken waiter is killed
Date: Wed, 25 Nov 2026 15:32:08 +0100
Message-ID: <20261125143835.566368106@linuxfoundation.org>
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

From: Mani Tofigh <mt4022@columbia.edu>

commit 9f4413e522faed76f4cf610098b2369eb3ba1f1c upstream.

Processes sharing an epoll instance can sleep forever while an event is
ready.  An event wakes only one waiter, which then wakes the next one in
ep_done_scan() if events are still ready.  Since commit c257a340ede0
("fs, epoll: short circuit fetching events if thread has been killed"),
ep_send_events() returns before the scan when the waiter has a fatal
signal.  If the woken waiter is killed before it runs, nobody wakes the
next one:

  Task A                     Task B                 Task C
  epoll_wait(ep, -1)         epoll_wait(ep, -1)
                                                    write(efd)
                                                      /* wakes A only */
                                                    kill(A, SIGKILL)
  ep_send_events()
    return -EINTR
      /* skips ep_done_scan() */
                             /* still asleep */

B then sleeps until another file on the instance becomes ready, if ever.
This can hit eg a pre-fork server whose worker gets OOM killed.  Commit
7fab29e35630 ("fs/epoll: restore waking from ep_done_scan()") fixed the
same kind of hang when the wakeup in ep_done_scan() was removed.

Keep the early return so that a dying task still doesn't take events
nobody will see, but wake the next waiter there if events are ready, as
ep_done_scan() would have.  With the fix, B gets the event.

This bug was identified and confirmed with the help of a deterministic
hypervisor currently under development.  The C reproducer below however
hits it within about 2s.

Fixes: c257a340ede0 ("fs, epoll: short circuit fetching events if thread has been killed")
Cc: stable@vger.kernel.org
Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
Link: https://patch.msgid.link/20261103-epoll-killed-waiter-v1-1-36e08c16b8a2@columbia.edu
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/eventpoll.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -2144,10 +2144,17 @@ static int ep_send_events(struct eventpo
 	/*
 	 * Always short-circuit for fatal signals to allow threads to make a
 	 * timely exit without the chance of finding more events available and
-	 * fetching repeatedly.
+	 * fetching repeatedly. The wakeup that got us here may have been the
+	 * only one for the events on ->rdllist, so pass it on to the next
+	 * waiter, as ep_done_scan() would have.
 	 */
-	if (fatal_signal_pending(current))
+	if (fatal_signal_pending(current)) {
+		spin_lock_irq(&ep->lock);
+		if (!list_empty(&ep->rdllist))
+			wake_up(&ep->wq);
+		spin_unlock_irq(&ep->lock);
 		return -EINTR;
+	}
 
 	init_poll_funcptr(&pt, NULL);
 


