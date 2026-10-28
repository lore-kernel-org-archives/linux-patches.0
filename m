Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211016;
	b=IPPJ+E4gExdx+iwfPIVctJv8e+V4YpqeD5R10etFI70n7OX7Xft0fa6hiiMpVvHJHALl
	 LkAAR1dxptqBTKPmzoY8f00BcrU21yOobufRB/nVXcl/v5pMuF3XksDUNLLCIDH0JuY/n
	 YoxFR6M0QZbekzjgsaStACeE4WftOJto1YiqaRBozL4HCIIGj/RAhzFECSlMIokGgx+Dy
	 E8l9VN9F7iKqthmxnq3Xr4VKF9EU89jKPLYJyDyAGh7Ns1UVTOwHbBZFi15gmmJLnBVlQ
	 wHZjkyaAiR7txEk6xEQyyFYyfKkKiTDTiAz1eCAnhJMvNwTF/II1ggS7ShLCEkbDu5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211016;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XCX53C7pDpbxkWOOBGDJf1Usa+MWux91njk6PhTIUvs=;
	b=sdjL0cw43Cbgp6b0MYPlzlYkQh1o8PjB9M6FovWmv+VZ7uKQ7V2dVH3fB/uU+IVGQmc5
	 coBW1gZfkFaewdnN9y+kvfV+21ucKgmY+fgOdtE0L33shq2t0nkDrP3LAav2rgXfSuHGn
	 u+rtYF7Shzx/Zfb7GStyisoleimr/fi73CJ4pPgTzY+ND+D+26fe7hAHDtdB3W2gE6jfu
	 D7tR8cIQ6sN6PcE50L+x5uCGmd5PoiqBKtf2BncttvRvG/pGd49UzC0OgbFiU4ZGBcCib
	 Dx77NY7zVYYvlN5sVQJBOwiSqWsaxp4FEtgjL24ZK4DcrYo923m0M3mcDerimdjc1bQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yQTdKpGz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE578606A31A;
	Wed, 28 Oct 2026 18:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yQTdKpGz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6091F01825;
	Wed, 28 Oct 2026 18:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211015;
	bh=XCX53C7pDpbxkWOOBGDJf1Usa+MWux91njk6PhTIUvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yQTdKpGz5Lhmgn3jopj6xXy8FTZuF9vIS0iTxe2gU7miOwkvecCcQFYlOjPocYOzP
	 IUx3Tlk6VZK342dGqv6Oy4TDp1BswMQKQYw+hZMsyUyrKYNhKshuewAg6Pt3ItF/xV
	 i8X+yBbshRBc1j0hiBsmtpgAKRa24W/j5XJBdVwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Deng <18983559317@163.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 174/571] net/mctp: publish the mctp_dev only after it is initialised
Date: Wed, 28 Oct 2026 17:55:21 +0100
Message-ID: <20261028170012.142502613@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b248bca58c7c0..639d2c6641780 100644
--- a/net/mctp/device.c
+++ b/net/mctp/device.c
@@ -282,13 +282,13 @@ static struct mctp_dev *mctp_add_dev(struct net_device *dev)
 
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



