Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773902;
	b=jP2YoPOkxibxbh8wJqBx2CARmM+idS2BWyqcaj5/7Z9UzO1Vdve5weNVw8rLDTgGndXP
	 YNqX2OF7nLNQkyZT+Z9Meiy8qx9VWCReHKm34Y4O2oF8w1N1zUp/oAIud7+mBmMpRukc/
	 yxFqZewJqWIWVS2JJ1xmnEodn0KzCEmTNaaMXlUObI0ijhI5OaBl95D/++lqO8BNbUce4
	 5iKwPMw9U1+/ORLq1uPcVdQnH9waUZqChBWBHJoDXH7zuu5GN1MYPpAlmgx6Vna3T53YJ
	 3ayEPexe/b9OHgx+KSIhYtEubHDbMW1wFBQalgtaG0Ya3SCJ11b1z3CuK+6Rvg9cYoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773902;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e4CILzQQghMFpp/L5C0lsicraL2Zx7F+/cA63IazVqU=;
	b=adME0wLv+yR/WZOEW7YfsRk/40aQbjeDWn44PK+BFtvR//IGb6Evy6D6KlVk7Ewkz4j5
	 X7M2d+krb0lrS7Ro2S42QfINt4U9eQ5DamEMFvY5uZMxkagYG09cPzE1WMG7YEOcUhzZD
	 16jmbqxy+WA6EdFB9wYUQAj44cOwu2uWkGAuoR+BG35FVM0il1PXm+0FCuNLLCmf3JN6n
	 PlGvRRN+HT0rPWoyY5UOmo6Xhf/oS+SbEnNQOffEtUJ/sQYHGmRur2LBruWf8RdlqM2oF
	 3rIrXk24y8u4t8BFA5+/DB7JiPsfErET46QTOwvh1m7VyhsTVUCO2AArUbbfnKUTCFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E7QvtPXM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4AEA606A31B;
	Fri, 23 Oct 2026 16:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E7QvtPXM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF3511F01828;
	Fri, 23 Oct 2026 16:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773901;
	bh=e4CILzQQghMFpp/L5C0lsicraL2Zx7F+/cA63IazVqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E7QvtPXMQpN4BPvYAKeKcAhGcny8sSfoQ0oXIQt3qsedF11Z8PNP32NOhxkgkaYe5
	 46imwT8sj9xC7fX29qSm+O0PhOrqb6F6FlDjtI92p1saGYwQoaU/0VbVMKl4XC7mQw
	 6NLdDrJNp2YIPKx6tsEbsCtj/rOScyus5wRwuP6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Michael Kelley <mhklinux@outlook.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 015/193] Drivers: hv: Dont reset VMBus connection state on error/exit paths
Date: Fri, 23 Oct 2026 18:34:52 +0200
Message-ID: <20261023163714.564013541@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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
index 9be2af772867d..4a3bb9ae9250c 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -340,7 +340,6 @@ int vmbus_connect(void)
 cleanup:
 	pr_err("Unable to connect to host\n");
 
-	vmbus_connection.conn_state = DISCONNECTED;
 	vmbus_disconnect();
 
 	kfree(msginfo);
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index b1552a26b8d3e..1dc371eb53400 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -3018,7 +3018,6 @@ static void __exit vmbus_exit(void)
 
 	hv_remove_kexec_handler();
 	hv_remove_crash_handler();
-	vmbus_connection.conn_state = DISCONNECTED;
 	hv_stimer_global_cleanup();
 	vmbus_disconnect();
 	if (vmbus_irq == -1) {
-- 
2.53.0



