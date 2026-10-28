Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215503;
	b=CWrwp4KKKldEyLr7cstGyuRZV2KBb0RTklRcSNeycbwXGQYnaYXgXpNlnqHMD6dlTgDa
	 7/hsw74MyDmrELKrQIuT+tVnReKphIQ/LRPxLphqreECKyIxtcL95AHmOZQ3uM3bfdxX7
	 SxPQTQYNbGdbydPuIStySWmNzn9+6ffnKI+IAfWhDKxzPaZCrAACuveYJHytHCENghQ+n
	 mkyLzxkYHPGSdjTIUElz7gMFUHVkbiKdyEa50g8+bw2JuJQqO+U6B2mnAwk5Y5q7W4lHK
	 clp+KpCSKIZ+1/MbFUbvcN6wdMYU3S1OpvEe4YaZ8izd0MWeiCwdRE2JLMhMilct93w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215503;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Rk6JKHOp7P3cqnf85urBJUXiNjbglWIb3Ol4PocAPyI=;
	b=3OX5OyHpYqHJiPDTN4HPDfe5CzJz43Bn8ckLoiX4IDDRdKd4QcfwniXi4KgnNbXVF3in
	 tDOsZVup0X4JheN/Na9GOOnkJo3Xs/MMjkKfWZeL8pnw5QZMvFk4jbzjqhd7cv/91J8B4
	 XCmEPJdpTARouwwN++FxB1f1xDq4iIl3Qubi+R0NWdrqaUG7O0uqzI0er0NgL33+5OQYh
	 /Ez0X4vX3UUGEjrUKqcDT1xDxTae1BJ10G1CCuNQQFDJv/KPHs1w70JEP7Q0gN9wbTqGK
	 fP8qOM4Igy3L7BDSUJaQhApNYpcDuwOaWC+3+z07zq79ONTypDdDFv1Mtv1E7Yx7yVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uSC2qf4x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0306606A31C;
	Wed, 28 Oct 2026 19:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uSC2qf4x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B6A61F01828;
	Wed, 28 Oct 2026 19:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215502;
	bh=Rk6JKHOp7P3cqnf85urBJUXiNjbglWIb3Ol4PocAPyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uSC2qf4xnU6QrFIpoiSB6A0/f+rfsRuCEU6Wcfkh3ZHlDKmyJm+2T36ZAAMt8LGXm
	 k0nlrwhOFjIOLdjB+okubbpkHS+HIUzOVPgLnzR7AYT+NoWoZ91zTVFvf3ui9Rm6HA
	 BEZKMwTLpUSj+/+9wVsp5U60+RUOMvwRqI+GtIo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1226/1887] Bluetooth: 6lowpan: avoid untracked enable work
Date: Wed, 28 Oct 2026 17:55:22 +0100
Message-ID: <20261028170527.323562458@linuxfoundation.org>
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

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit 352a59dc1f4a41314b6f827c17e16af7ca88271a ]

lowpan_enable_set() allocates a temporary work item and schedules
do_enable_set() on system_wq, then returns to debugfs. The debugfs active
operation has ended at that point, but the worker still executes module
text and manipulates enable_6lowpan and listen_chan.

bt_6lowpan_exit() removes the debugfs files and immediately closes and
puts listen_chan. It has no pointer to the queued work item, so it cannot
cancel or flush it before tearing down the state that the worker uses.

The buggy scenario involves two paths, with each column showing the order
within that path:

debugfs enable write              module exit
1. lowpan_enable_set() allocates  1. bt_6lowpan_exit() removes
   set_enable work                   the debugfs file
2. schedule_work() queues         2. bt_6lowpan_exit() closes
   do_enable_set()                   and puts listen_chan
3. the write operation returns    3. module teardown can continue
4. do_enable_set() later runs
   against stale state

Run the enable state transition synchronously in lowpan_enable_set()
instead. The simple debugfs setter can sleep, and this file already handles
the 6LoWPAN control write synchronously under the same set_lock. Once the
setter returns, debugfs removal covers the whole operation and exit can no
longer race with an untracked work item.

Validation reproduced this kernel report:
BUG: KASAN: slab-use-after-free in do_enable_set+0x113/0x2e0
Workqueue: events do_enable_set [bluetooth_6lowpan]
The buggy address belongs to the object at ffff888109cb8000

Fixes: 90305829635d ("Bluetooth: 6lowpan: Converting rwlocks to use RCU")
Assisted-by: Codex:gpt-5.5
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/6lowpan.c | 27 ++++-----------------------
 1 file changed, 4 insertions(+), 23 deletions(-)

diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
index 723ead2c04f16..e59032c67116a 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -1062,23 +1062,15 @@ static void disconnect_all_peers(void)
 	} while (nchans);
 }
 
-struct set_enable {
-	struct work_struct work;
-	bool flag;
-};
-
-static void do_enable_set(struct work_struct *work)
+static void do_enable_set(bool flag)
 {
-	struct set_enable *set_enable = container_of(work,
-						     struct set_enable, work);
-
-	if (!set_enable->flag || enable_6lowpan != set_enable->flag)
+	if (!flag || enable_6lowpan != flag)
 		/* Disconnect existing connections if 6lowpan is
 		 * disabled
 		 */
 		disconnect_all_peers();
 
-	enable_6lowpan = set_enable->flag;
+	enable_6lowpan = flag;
 
 	mutex_lock(&set_lock);
 	if (listen_chan) {
@@ -1088,22 +1080,11 @@ static void do_enable_set(struct work_struct *work)
 
 	listen_chan = bt_6lowpan_listen();
 	mutex_unlock(&set_lock);
-
-	kfree(set_enable);
 }
 
 static int lowpan_enable_set(void *data, u64 val)
 {
-	struct set_enable *set_enable;
-
-	set_enable = kzalloc(sizeof(*set_enable), GFP_KERNEL);
-	if (!set_enable)
-		return -ENOMEM;
-
-	set_enable->flag = !!val;
-	INIT_WORK(&set_enable->work, do_enable_set);
-
-	schedule_work(&set_enable->work);
+	do_enable_set(!!val);
 
 	return 0;
 }
-- 
2.53.0



