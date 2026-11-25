Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623537;
	b=G25pO0Yeg7wNWrvB2qgh+ddYh8x6b9OeLoD6rh+It2xNZANfLXFYmH3eFDMTy8+M3aJj
	 Pk/oCON+neeDOblNxHwj3/ox/IVxuSXXy3VE/VcYF3U5yjf0yBcHMuycnn4ME3B/ukBNp
	 zoIxTypMuDOPnIHQLv/T4Dlxz95gQ45wJVLHMpaDZwDoL6OjJ70sI1pHTrh9R9XsgeKqE
	 +ahK9plQNnmN+9bPSaym5KnZWEDgN2kjZxxF6Qf60AjlwV6mKQZ5vb5dfmYboREDsC+rN
	 HQawH0RyPH5Ed6YyiehNpcjs5NNudfyhZByTzRWbVh8SiT5gBmbjdrAU7xIMZZgmhmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623537;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B/IUsZ7u2mslkO9YLHJtYFJZVck7mpAXQjVy+OGcpqk=;
	b=JpATiMhEx6XzY0idy8Ecnchtsk8h7ZSgeRhmEw2JP0w6KjxPGIn7UGpRYkHExr9vARkw
	 RN032v1nOeFPDxMzoBOQSSPo5c2hp64nfDoGl5Ah2I8/0xZf1HB/6POJMlWaxNwoTeHS+
	 3zdAlcoPWWlM/+ECu37jll38n0gaeosS1BcwlG+dwF45I5ox4w6rL1ea7u4c33FIavOyq
	 ooe+rt+bXJdDoVH3VZGjSs6+5ck/e6zhj35h60v7OOWzDxSeyRNZfkVGDZ2u5YWfUHYPO
	 +XoUqig5L6uRANO3B3osOYwGzvz+cjbvuXhSXWnWejND8UnhazaoQV68VFluuXIFOiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UEM5ocsF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D4B606A329;
	Wed, 25 Nov 2026 16:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UEM5ocsF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2A5F1F000D3;
	Wed, 25 Nov 2026 16:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623537;
	bh=B/IUsZ7u2mslkO9YLHJtYFJZVck7mpAXQjVy+OGcpqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UEM5ocsFx0e5CY1skaNTZmDCfDj54wAdjqQALRnsXvbPFPo9ePqALT5VwECt4pI5H
	 165BNciIrO+nge0mYpxq2zhx2zHi8GqvV9YaHwSw0Igl5OaG+rN1hmWLAW7kYl++WF
	 GzqchfpVq5OlcjJQ94wFXbgOIO/UcH+X2zYCqBEk=
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
Subject: [PATCH 6.18 893/990] misc: vmw_vmci: wait for callbacks in event unsubscribe
Date: Wed, 25 Nov 2026 15:37:40 +0100
Message-ID: <20261125143842.929191063@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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


