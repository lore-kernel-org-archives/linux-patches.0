Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212655;
	b=EJNEZEdEM3UUBu6pDBnFOZo4VdAnSl+vkBvEwDt061TwpqNsulWkA11g1lKJ6JzeWugC
	 sF7TLDMIJAWGaVGQR2Ei1vTTXLa1ZpL5srbKL0P9Va9a4yJ/ctSft1ylfQ2s3EdU8zFPP
	 XsK8N9TcTKILKhH1DKgovaoRbwx3457/eC+E96qM8ksGjkz2p8JyVUzdtyb/R7Smnf8Ag
	 aC0rHp2/oCXAeW3S4j7lI8eJYpPus1XQZe4ZP2hzROePwdS3mpXV8Ld0KwP06t36XLsZR
	 fvBZgLe91+H3NMCISC4dApFBPmEuWBqxc9T8HD4+EsE5e3E9FOZeyqaTHWprswZRrxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212655;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DArGWEaQecfLCdsu7CcYxYmbr04ivOZsnBAadLmRpzc=;
	b=xetcDoF//Rg97XJAQMwhf8bM0VwWrdSHj5BPKV1W0yQLavaUPvzHPhzD5m8UfHK+sxwi
	 ibyzMmVDqr7Oa35sfF21vdUIYG+kkERhMGABC1tbER1oLla3+u52c3lVKoMf67LxZXPcZ
	 M6uHh5RY8dM2E6Pwoi9+IU0IF6SHMak4NmjWFIDNOmtFDRpDyrpN3K88pI8q5An1GxZMJ
	 zf82j5zQ+XbTKJAx8lhYxUIMTijkiygr7vnxmSnFqTqoaw7bgK8CKxi73CAfiFh2iKCAd
	 Wf/cNQmNr9yDUcBSWpyeAm4PkY58D/2INPAc/kml5gvQOHkwsIwYrenDeB+RpufPXOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qmreAPd9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24EDB606A31A;
	Wed, 28 Oct 2026 18:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qmreAPd9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74C811F01825;
	Wed, 28 Oct 2026 18:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212655;
	bh=DArGWEaQecfLCdsu7CcYxYmbr04ivOZsnBAadLmRpzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qmreAPd945bqwaAdHhaOtQUcCeJi/tC3D9EKeteehm19sd60yxoaX1gkn30zHd+xB
	 nktA9+AEhFuNU0wTUOiskKPnUIAUvFk88iQFo4eG+G5C0mW7N1bTJTGuQnJXa/djkf
	 VUbTkw8hkEBEMypBdgug3wWkU/IEyMDJi26jQbZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Deng <18983559317@163.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0230/1887] net/mctp: publish the mctp_dev only after it is initialised
Date: Wed, 28 Oct 2026 17:38:46 +0100
Message-ID: <20261028170504.465764738@linuxfoundation.org>
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

From: Binbin Deng <18983559317@163.com>

[ Upstream commit aadf655e8ea9a8ffa24bb8d69f504572e8d18181 ]

mctp_add_dev() links the new mctp_dev into dev->mctp_ptr before mdev->dev
is assigned, so a reader that picks the device up in that window
dereferences a net_device pointer that is still NULL:

KASAN: null-ptr-deref in range [0x00000000000000b0-0x00000000000000b7]
Call Trace:
 <TASK>
 ? __pfx_mctp_sendmsg (./include/linux/sockptr.h:49)
 ? __pfx_mctp_dst_output (net/mctp/route.c:41)
 ? selinux_socket_sendmsg (security/selinux/hooks.c:5278)
 ____sys_sendmsg (net/socket.c:775 (discriminator 1) net/socket.c:790
 (discriminator 1) net/socket.c:2684 (discriminator 1))
 ? __pfx_____sys_sendmsg (net/socket.c:1131)
 ? __pfx_copy_msghdr_from_user (net/socket.c:2590)
 ? update_cfs_rq_load_avg (kernel/sched/fair.c:5478)
 ___sys_sendmsg (net/socket.c:2738)
 ? __pfx____sys_sendmsg (net/socket.c:2625)
 ? perf_event_task_tick (./include/linux/rcupdate.h:838)
 ? sched_tick (kernel/sched/core.c:5818)
 ? clockevents_program_event (kernel/time/clockevents.c:372)
 ? fdget (./include/linux/rcupdate.h:873 fs/file.c:1100)
 __sys_sendmsg (net/socket.c:2770)
 ? __pfx___sys_sendmsg (net/socket.c:2751)
 do_syscall_64 (arch/x86/entry/syscall_64.c:63)
 entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
 </TASK>

Fix by publishing only once the object is fully initialised:
__mctp_dev_get() runs under rcu_read_lock() only and hands
this object to readers as soon as mctp_ptr is assigned, so
they must never observe mdev->dev == NULL.

Fixes: 583be982d934 ("mctp: Add device handling and netlink interface")
Signed-off-by: Binbin Deng <18983559317@163.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/729830b8.130.1a0c945579d.Coremail.18983559317@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mctp/device.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mctp/device.c b/net/mctp/device.c
index fd368249246df..47407c07afc27 100644
--- a/net/mctp/device.c
+++ b/net/mctp/device.c
@@ -352,13 +352,13 @@ static struct mctp_dev *mctp_add_dev(struct net_device *dev)
 
 	mdev->net = mctp_default_net(dev_net(dev));
 
-	/* associate to net_device */
 	refcount_set(&mdev->refs, 1);
-	rcu_assign_pointer(dev->mctp_ptr, mdev);
-
 	dev_hold(dev);
 	mdev->dev = dev;
 
+	/* Associate to net_device, publish the mdev. */
+	rcu_assign_pointer(dev->mctp_ptr, mdev);
+
 	return mdev;
 }
 
-- 
2.53.0



