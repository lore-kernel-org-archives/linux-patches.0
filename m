Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216860;
	b=quIlMCbTNNyFMyKQnqzfVa8HTs0mPS6IBmEUurouwxVXe71ZqVebTOteut56CxZf7YRq
	 Yk1bdfyyD45B+5vStJCdlFnJ7+ZGEVDAwAEz4TfTbBz2oVk0QJFNBymVQi1W6T66HDxwA
	 ruzTktk8rYPP4+l3kQKCdCduhtTEe/LPB025xK2/70k05xp/m+XjEO/yArndfadYzXpju
	 w2fl3u9yQonQe5zhx6hmMLXUFgPCHosN9HSaM20eMVS2/IteoMpv6S6MdOOpXuP1+3dzw
	 L2Zdk2e6a5Of9RxbJjaPpru0vNRq3Oz2jjSbxbVUxbUNomcuqOIG9fOwjxfhgAl51eA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216860;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WySrW0ek7kHApOIa1/5ClxMIkQaSSjve7kpa5CGFX7s=;
	b=Hgu04+3+/+bCycxPrFleFiaUAyqAFAUMW8jLBCLq9L8uhxleZS9l9HoduV8VV1D8Wf/o
	 /diKUFB6qdVguvXkfZ8LkMuRyAZ3+tVFgKC8wz31JJq0SdObgUKcAT4BeLOoYI3LusOAU
	 x63xoozPlhE5aQPNZXZdLfEAJvBrI1gVGjwIeyly/PTC0zrYOsfPmsf/RNTVYuRxnuFF4
	 G3KybMQlKEMa6lX/2V5z/XSA5wrRsilXAyEJ7iJOS4aZZGcmH17CwrCIhs68C5wG+oj7T
	 mSh5feJeerDRerzP5ru3fihO32lwKV++hpXYevG+kDh3rsQEnDRqHvFvP2MDGql6XNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eegm2NFM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF92606A31A;
	Wed, 28 Oct 2026 19:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eegm2NFM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B0AA1F01825;
	Wed, 28 Oct 2026 19:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216859;
	bh=WySrW0ek7kHApOIa1/5ClxMIkQaSSjve7kpa5CGFX7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eegm2NFMdN1bAVX+YyNCnEkNhcHiHVRKSx0d55jRqMwIgVEsv7YAMucipArkjZ/JL
	 PvBKV4AVVBCAbyoZUnA6YS3L8m1X3OCmHBBEn9c88qdUzeqCXr1t7pX8B/rJvHsj2u
	 z/7Nsl87/vkju8o2FKfpvesFPnGubrVYihSYNT9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Michael Kelley <mhklinux@outlook.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1705/1887] Drivers: hv: Dont reset VMBus connection state on error/exit paths
Date: Wed, 28 Oct 2026 18:03:21 +0100
Message-ID: <20261028170538.256194078@linuxfoundation.org>
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

From: Michael Kelley <mhkelley58@gmail.com>

[ Upstream commit ec31dc39e835ccde0930daccece8c492d28282fc ]

In two places, current code forces vmbus_connection.conn_state to
DISCONNECTED prior to calling vmbus_disconnect(). But vmbus_disconnect()
calls vmbus_initiate_unload(), which unloads the VMBus connection
only if the conn_state is CONNECTED. Consequently, the connection
remains and the Hyper-V host might continue to send messages or post
VMBus interrupts.

The problem was introduced in commit 74347a99e73ae ("x86/Hyper-V:
Unload vmbus channel in hv panic callback"), in that
vmbus_initiate_unload() started checking the current connection
state before doing the unload. This commit removed some occurrences
where conn_state was forced to DISCONNECTED, but these two remained,
apparently due to an oversight at the time.

Fix this by not forcing conn_state to DISCONNECTED during VMBus exit,
or if a failure occurs when establishing the connection in the first
place. Whatever value conn_state has at the time is then read by
vmbus_initiate_unload() to determine if there is a connection to
be unloaded.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-hyperv/20260805205806.B5AC31F000E9@smtp.kernel.org/
Fixes: 74347a99e73ae ("x86/Hyper-V: Unload vmbus channel in hv panic callback")
Signed-off-by: Michael Kelley <mhklinux@outlook.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/connection.c | 1 -
 drivers/hv/vmbus_drv.c  | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 7bb94e0dd0f66..2eccdc9a6e785 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -322,7 +322,6 @@ int vmbus_connect(void)
 cleanup:
 	pr_err("Unable to connect to host\n");
 
-	vmbus_connection.conn_state = DISCONNECTED;
 	vmbus_disconnect();
 
 	kfree(msginfo);
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index fe9a1e1ad0c2d..7d0d2c026127e 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -2662,7 +2662,6 @@ static void __exit vmbus_exit(void)
 
 	hv_remove_kexec_handler();
 	hv_remove_crash_handler();
-	vmbus_connection.conn_state = DISCONNECTED;
 	hv_stimer_global_cleanup();
 	vmbus_disconnect();
 	if (vmbus_irq == -1) {
-- 
2.53.0



