Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626098;
	b=O/h2dBq5ef7sfH/KCZXv9hypc7vvURQmImdINBtgtNJIpahcCVF/hKBxkQvDKtuq/GNT
	 T366Ta3Pd6opnBY0FcxVxvVR827lVFu0rOfSj3xG5x5DIZvfLruqi5LBK7/0Jlv3uQuPm
	 7o4EwCjK7SylAfb5TVnxs711UWQGD4hfwwHXHG+6Zyqe5h0ey1JDOzTkNjE6m3SoPuSyH
	 V0ooBs3+003US/IEa5PRCpBSe4aS5QEinZcg91yyBGXc3IF3mVGuJ/DOHuQ/u1bAKU6C6
	 awg0AB+CorTs15uNu69sYr4NIZNZcyUe9HgBZELfx80wmh9GLNhXJjSe5GVSCPbw/5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626098;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yoxYMoPu6EIHf4uzqwXc+lZDhRhhibXMkIEgpNI23c0=;
	b=DMprP6nfKEx5w95vac8hmcMWkZoSuFc7mQWfoWX7biv1e9HGVQ/j4WoXq/2qgHHU1leN
	 9liLMxrKUoQ/EYaFfAkv7cwv0O1KEJSd/Hn3xTdv3rFj61wg5pq7wA4IvXR+thcumUC/A
	 +t6dpnGDJaTrOI3jBcZqqEhsE7TUnaMUDaFfScc5Dzo+DLvKD/cqcjE9n/Fu+N88LFWYs
	 cLuEmvBCSHS6Bpjx5PYICSLASpZqb6+JVG7CwpnA/Be0vHrsRm7a8DlzDgi9e3YJ82NfX
	 BgMnueU5OUad+iaCTarbuSfbXD0IZg8CS4ZBRAtNIitYzAIbjRfleoXYI4wWjlmgKuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gVeDUnbD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0685606A31E;
	Wed, 25 Nov 2026 17:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gVeDUnbD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13B071F000D0;
	Wed, 25 Nov 2026 17:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626098;
	bh=yoxYMoPu6EIHf4uzqwXc+lZDhRhhibXMkIEgpNI23c0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gVeDUnbDO6LpT2TH1nsOC5dRBDvOM33EMxzNAwcdzpoczUoXNrHe9OExXaGKOijX1
	 Pn6EIFmNCYd1OD4I7QUWMOp8heyAWqM7JueGqp13e//knHBz1VZ4oQTGUPPYTKCO5R
	 0ecfSv18XtE5dD9UKPSM5ksWEE0rZYIUpyU2Me2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Bryan Tan <bryan-bt.tan@broadcom.com>,
	Vishnu Dasa <vishnu.dasa@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 6.12 731/816] misc: vmw_vmci: wait for callbacks in event unsubscribe
Date: Wed, 25 Nov 2026 15:37:59 +0100
Message-ID: <20261125143906.101880686@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

commit 824a27d391cf934d3232e8e2dabee221fc4e18ae upstream.

event_deliver() calls the callbacks of the subscribers inside an RCU read
side critical section. vmci_event_unsubscribe() used to call
synchronize_rcu() before it freed the subscription. This did more than
to protect the struct vmci_subscription: when the function returned, no
callback was running any more, and its callers rely on that.

vmci_transport_free_resources() unsubscribes from
VMCI_EVENT_QP_PEER_DETACH and frees the struct vmci_transport, which is
the callback data, a few lines later:

  CPU0                                CPU1
  event_deliver()
    rcu_read_lock()
    vmci_transport_peer_detach_cb()
                                      vmci_event_unsubscribe()
                                        list_del_rcu(&s->node)
                                        kvfree_rcu_mightsleep(s)
                                      kfree(transport)
      spin_lock_bh(&trans->lock)

The event is sent when the peer of the queue pair detaches, so the other
end of a vsock connection chooses the time. vmci_transport_exit() and
vmci_guest_remove_device() unsubscribe callbacks which are gone with
their module.

kvfree_rcu_mightsleep() only waits for a grace period if it cannot
allocate memory. Bring the synchronize_rcu() back. The cleanup work of
the vmci transport now waits for one grace period per socket again.

Fixes: 6da3f33770e0 ("misc: vmw_vmci: Switch to kvfree_rcu() API")
Cc: stable <stable@kernel.org>
Cc: Bryan Tan <bryan-bt.tan@broadcom.com>
Cc: Vishnu Dasa <vishnu.dasa@broadcom.com>
Cc: Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/2026102715-escapable-quaintly-8530@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/vmw_vmci/vmci_event.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/misc/vmw_vmci/vmci_event.c
+++ b/drivers/misc/vmw_vmci/vmci_event.c
@@ -213,7 +213,12 @@ int vmci_event_unsubscribe(u32 sub_id)
 	if (!s)
 		return VMCI_ERROR_NOT_FOUND;
 
-	kvfree_rcu_mightsleep(s);
+	/*
+	 * Wait for event_deliver(): the caller is going to free what the
+	 * callback works on.
+	 */
+	synchronize_rcu();
+	kfree(s);
 
 	return VMCI_SUCCESS;
 }


