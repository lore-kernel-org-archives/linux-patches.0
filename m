Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826791;
	b=YBzsz1RNKre5OIlnEW04HHTU8CvbXvnRAlJYqeecwf218PeckHDNdGPSfS9eM166MY7B
	 vpm+sewfr0UANh4+d5ouewF5ru+oEpnsCEJkofU1NvFNMlWOahlB0eCjBrLy2IkJld6wL
	 y57zFZqKFQTgMAhRSfj0nqdYDzZ9NciVs76VrKkJwIXEU6Vya/KkcyY+OgSYu4KkHyGLF
	 0w2yUUAdoR5GaVHOp3cEDagXZHCvCysPyE3skptb3k8HbP+BhnXAoeOrRctxnfgUVSE7R
	 Oq6yz1sx6c2bpKc0UwxC0zIGF7+Btu9gWWeGwnh3lrJIEPLTy/d5E52QecwQtIitjUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826791;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uTw2DiBW9l42YAemMchIWlcGftJB2+wgbO/sXMEeHIk=;
	b=UqWobq4SgrSZC9UKIXVX/giMNGQSUNrrZR+L1EkeLTHc9aBnhVyyWSVF7zxqe1WKhQS2
	 3It/8OlKNPOgqN1reQyyvk0x2E//v3KacCgXMr84j76SrfZEX2FXVhQY4iwInTyRt96av
	 2knrNB0Tgc1hzwEua4f9BgdRBBqEl9mm1fMHg2FrBh5LqFnpvuTZeer4sJaEyF/zVFtWc
	 58a64cAQdqb0lQdrvSkZfHILl61lVJwjHWs2vFX/bfvxIFetrKY0uuED7Py9IT4uJzqYw
	 dUh3VCW+x8OxgrwR1bvBnn5KC8K7ziMwva74IBOb4NqMPoSzZy2cW2yqIrlq/lRHdKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BP1ahgna;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4DF6071A00;
	Wed,  4 Nov 2026 21:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BP1ahgna
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E34EF1F00A15;
	Wed,  4 Nov 2026 21:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826791;
	bh=uTw2DiBW9l42YAemMchIWlcGftJB2+wgbO/sXMEeHIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BP1ahgnamgSGWGHby9f4xLBllKSUu/FArT/4ddfKK66VcKTBsnVmqgvfTDNTBztuz
	 tPsRARkIwpfvjLH97txmCXRbyx/9z/YZLTExuSKiuEYoMsStZY/Hqt07wp+se4+AY/
	 HALHSkj38bmUXoY6tr48JGM3XlFfU26RMZmc84xI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0011/1005] coredump: prevent TIF_NOTIFY_SIGNAL from interrupting coredumps
Date: Wed,  4 Nov 2026 15:55:44 -0500
Message-ID: <20261104211043.854490153@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit a58d647acfdc62561f3570d114025b3bf38ae41b ]

TIF_NOTIFY_SIGNAL is used to kick a task in uninterruptible sleep to
return to userspace and run task work and then go back to sleep. This
mechanism works well but breaks coredumps. dump_interrupted() only
allows fatal signals to interrupt a coredump and the whole regular write
path going to actual filesystems is impervious to TIF_NOTIFY_SIGNAL as
well.

However, both the usermodehelper pipe and the coredump socket will bail
early on TIF_NOTIFY_SIGNAL. This affects the following codepaths:

- coredump_sock_recv() -> unix_stream_read_generic()
  The request/ack handshake is abandoned before any coredump data is
  sent.

- anon_pipe_write() returning -ERESTARTSYS
  Once the pipe is full this truncates the coredump.

- unix_stream_sendmsg() returning -ERESTARTSYS
  Once the send buffer is full this truncates the coredump.

- coredump_sock_wait() -> __kernel_read()
  This reports a failure that didn't happen.

- wait_for_dump_helpers() -> wait_event_interruptible()
  This stops waiting for the coredump helpers.

Such truncation is entirely invisible to userspace and all uapi bits
still indicate that a successful coredump happened. A crashing process
with a bunch of file backed mappings and io_uring thrown in loses most
of the coredump data. If the NT_FILE note goes past PAGE_SIZE mappings
it's gonzo.

TIF_NOTIFY_SIGNAL is sent by io_uring for the common case. And it uses
poll without sleeping so a completion callback runs task_work_add() from
interrupt context against the task that submitted the request. This is
the task that is running the coredump. Since that task hasn't set
work_exited (it hasn't exited yet after all) TIF_NOTIFY_SIGNAL keeps
reappearing.

A coredumping task doesn't return to userspace. The task work is run at
exit. So interrupting it doesn't buy anything and just loses the
coredump which is quite valuable.

Note that this isn't specific to io_uring. There's also
klp_send_signals(), bpf_task_work_schedule_signal(), landlock's tsync
and then  technically, kthread_stop() and the printk kunit test set the
bit raw.

Link: https://patch.msgid.link/20260824-work-tif_notify_signal-v2-2-6609e42b3157@kernel.org
Fixes: 12db8b690010 ("entry: Add support for TIF_NOTIFY_SIGNAL")
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
[ sashal: adjusted context for inline coredump handling with override_creds() instead of scoped_with_creds(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/coredump.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/coredump.c b/fs/coredump.c
index 3e927378bf5bf..b3cc7c0531ee1 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -1131,6 +1131,8 @@ void vfs_coredump(const kernel_siginfo_t *siginfo)
 	if (coredump_wait(siginfo->si_signo, &core_state) < 0)
 		return;
 
+	/* Task work must not cut the dump short, see signal_pending(). */
+	guard(no_notify_signal)();
 	old_cred = override_creds(cred);
 
 	if (!coredump_parse(&cn, &cprm, &argv, &argc)) {
-- 
2.53.0



