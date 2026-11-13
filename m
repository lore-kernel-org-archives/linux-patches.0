Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590356;
	b=zHH66tmBJ6lIBurysVqMMCVFt07zqMY+02uQ4lo7H7zz/XPzyOammIqODafiUBJvm7VK
	 oBDwsRjxtzxwyPbqj+IwzUsaN/ggOM0IA7nvC+EwL+m6eBk2i3TBaxLow1fv7FDTp0hPw
	 qxZckMGVco3mpLo2yL3+i9/ZhI2ZOJnJpm56bRsb+F5xNHLxn51MF33GRWh1gp69Le5AY
	 PkBm6tn9WHMnfU6fPwDwge8a7PXTCujO7SoRjpkoO4yIOKMNMbPOR0EW9R3nfU4JreewS
	 Ah/KnD2el+WF1Rzdl6kS2LB1I/9AK1z29U4yFopyo8wW4LIh+qUiTY4gwFi/Au+cDGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590356;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q3PGDCxjvcB9nP6tkN46pmJLIkGNrpdjhG8f+gbsKfI=;
	b=3MwZKDb4DvhkNQ1uDuzWRKKNg45gkuotBXpCWe0fWjI73Om5iyZZeZLTbHNniFldC0q3
	 Db3zGCk2BYE+GxAKSWwIccd3a6t39b24ORq4DlpyT55chSrHmf73JIPzYa3diaNiPICpl
	 xRscSnVPI3ceyJGviMGNf2AHb3FTpyKxiY15n2GkN0WMK4VQjbSxi6paycxlkHVa8vbQj
	 jfPCTzuZtrLGOEPhEyoFrTlxMO+iivlz6s2+sChBMRnePXNR/l27LGgTlj6A4O+ksJ6R3
	 ZrC2DwNsZMPFG5+sp2p0v43lrLO0DV0wly73HFbkf7QIxNiwomRG7PdKaD/fTw+lZjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kLkJyv3T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A41DE606E23E;
	Fri, 13 Nov 2026 17:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kLkJyv3T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19F2E1F000C4;
	Fri, 13 Nov 2026 17:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590356;
	bh=Q3PGDCxjvcB9nP6tkN46pmJLIkGNrpdjhG8f+gbsKfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kLkJyv3TDpV+71CU3OfFiRIJLgizHmHAlmCUJ0CwBi4VY4EKZu9jFnZqgKdRW5emJ
	 bLLodVXzj2n1N8XuLoYZDEdcK7VwxAGfBnL35725sQ807Qxpy3R1bnCVg1MaiM4hTd
	 AHESHaPaViBpW8ogIABJ5fS3DdwiGw3AJcsanoQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Heming Zhao <heming.zhao@suse.com>,
	Kees Cook <kees@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Jia-Ju Bai <baijiaju1990@gmail.com>,
	jjzuming@gmail.com,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 333/686] ocfs2/cluster: unlink socket containers before releasing resources
Date: Fri, 13 Nov 2026 10:47:46 -0500
Message-ID: <20261113153832.230029680@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit 0988f0c0c7c908f0ff77fd8b90ce9918a1f41479 ]

A socket container's node and socket must remain alive while the
container is on sock_containers. The debugfs formatter reads sc_node
and sc_sock under o2net_debug_lock without taking their references, but
sc_kref_release() releases both before taking that lock to unlink the
container.

With CONFIG_DEBUG_FS enabled, a synchronous sender can retain its last
socket-container reference after o2net_disconnect_node() has detached
the connection and flushed o2net_wq. The caller runs outside that
workqueue. After the sender removes its configfs dependency, node
removal can proceed without waiting for the sender's final sc_put():

  Sender (final sc_put)    Configfs rmdir        Debugfs reader
  --------------------    --------------        --------------
  o2nm_undepend_item()
                          Drop node item refs
  o2nm_node_put()
    [node can be freed]
                                               sc_seq_show()
                                                 Lock debug lock
                                                 Read sc_node->nd_name
                                                 Unlock debug lock
  sc_node = NULL
  o2net_debug_del_sc()

The earlier socket release has a similar window. The container is
still selectable while its socket has been released and sc_sock has
not yet been cleared:

  Sender (final sc_put)                       Debugfs reader
  --------------------                       --------------
  sock_release(sc->sc_sock)
    [socket can be freed]
                                             sc_seq_show()
                                               Lock debug lock
                                               Read sc_sock->sk fields
                                               Unlock debug lock
  sc_sock = NULL
  ...
  o2net_debug_del_sc()

Move o2net_debug_del_sc() before releasing either resource. Unlinking
under the existing debug lock waits for an active formatter to finish
and prevents later readers from selecting the container. This covers
both socket fields and node fields, including nd_num in the stats
formatter.

KASAN report as below:

    BUG: KASAN: slab-use-after-free in string+0x42b/0x470
    Read of size 1 at addr ffff88810f56fc90 by task python3/506

    CPU: 0 UID: 0 PID: 506 Comm: python3 Not tainted 7.3.0-rc4-next-20260921-pmb-ocfs2-functional-v1+ #1 PREEMPT(lazy)
    Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
    Call Trace:
     <TASK>
     dump_stack_lvl+0x93/0xd0
     print_report+0xce/0x630
     kasan_report+0xe0/0x110
     string+0x42b/0x470
     vsnprintf+0x330/0x1110
     seq_printf+0x1a8/0x260
     sc_seq_show+0x604/0x9f0
     seq_read_iter+0x480/0x1110
     seq_read+0x362/0x5a0
     full_proxy_read+0x11f/0x180
     vfs_read+0x1a0/0xc20
     ksys_read+0x111/0x200
     do_syscall_64+0x114/0x620
     entry_SYSCALL_64_after_hwframe+0x77/0x7f

(User register dump omitted.)

     </TASK>

    Allocated by task 497:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     __kasan_kmalloc+0xaa/0xb0
     __kmalloc_cache_noprof+0x28d/0x610
     o2nm_node_group_make_item+0xea/0x1a0
     configfs_mkdir+0x762/0xca0
     vfs_mkdir+0x399/0x7e0
     filename_mkdirat+0x129/0x450
     __x64_sys_mkdir+0x70/0xa0
     do_syscall_64+0x114/0x620
     entry_SYSCALL_64_after_hwframe+0x77/0x7f

    Freed by task 505:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     kasan_save_free_info+0x3b/0x60
     __kasan_slab_free+0x5f/0x80
     kfree+0x308/0x580
     config_item_cleanup+0x14b/0x230
     config_item_put+0x79/0x90
     sc_put+0x454/0x6e0
     o2net_send_message_vec+0x63d/0x1560
     o2net_send_message+0xa6/0xe0
     validation_send_write+0x17f/0x1d0
     full_proxy_write+0x11f/0x180
     vfs_write+0x25a/0x1010
     ksys_write+0x111/0x200
     do_syscall_64+0x114/0x620
     entry_SYSCALL_64_after_hwframe+0x77/0x7f

    The buggy address belongs to the object at ffff88810f56fc00
     which belongs to the cache kmalloc-512 of size 512
    The buggy address is located 144 bytes inside of
     freed 512-byte region [ffff88810f56fc00, ffff88810f56fe00)

(Page and shadow-memory dumps omitted.)

Link: https://lore.kernel.org/pm-ocfs2-objects-candidate-0065-v6-3090153fd7cacb810214@gmail.com
Fixes: 2309e9e040fe ("ocfs2/net: Add debug interface to o2net")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Sunil Mushran <sunil.mushran@oracle.com>
Cc: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: <jjzuming@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/cluster/tcp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 32048c65b66ba..07b2252779410 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -391,6 +391,9 @@ static void sc_kref_release(struct kref *kref)
 
 	sclog(sc, "releasing\n");
 
+	/* Unlink before freeing anything the debugfs readers dereference. */
+	o2net_debug_del_sc(sc);
+
 	if (sc->sc_sock) {
 		sock_release(sc->sc_sock);
 		sc->sc_sock = NULL;
@@ -400,8 +403,6 @@ static void sc_kref_release(struct kref *kref)
 	o2nm_node_put(sc->sc_node);
 	sc->sc_node = NULL;
 
-	o2net_debug_del_sc(sc);
-
 	if (sc->sc_page)
 		__free_page(sc->sc_page);
 	kfree(sc);
-- 
2.53.0



