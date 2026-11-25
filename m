Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620390;
	b=afdTFNibVSWXcvZ9PcbcKcrLWVrgk9AOn+8kCiGz/b63stPHAFjTbCDQ4oQGi0gDdLCh
	 TN14auNHNY3RxPQLBNzNBzA6tdwLjTiPKwxVT2VfX4mxgKLPYUUFH0bK26rFqNo13qbe8
	 PoXQQAyNNHusXxAvLYY+Y7UbHEA/pBF2IGj0um5xEJCMl9PMVn5/1TKOSUEywfu854yB7
	 Y9V6RI5kmdwXQ7qTpiBhQ9xRg62J0QhjHhFVbAF/lqERoTvtBchMXQP0R7VvkgtO98HM3
	 CNu26K56C5ezQ8rkLKjdLID+I0yxDNYD5WXUKiw+f7tSLozGGDTbkPzgSycGGE6xZFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620390;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WtptMmUV2+pa+Kj63gcE6lSJ7PTWDxyGYid9jyr9Pr4=;
	b=xq/GU7s6DS1SDqjCXUvO7IkMlnMxld+nzzDUBJXdwYiBNQc2LYF8T2UF33byqJ/bVYa3
	 2PiTTodFXs3TOI0R5EcelXN520ExnQ1zb+82YZcAyiETNE9w/8tdcjOhI31bHhRRoahqU
	 vwodKmvgIbH96s+ZgjfoyTrtI/4DjqbRdrvbQQKJuLTvGBLLh18kquTM3csOG/MLBmxwI
	 D3D/PuT961qncupFUmDDiVP5gcfj+ErLQhbtUyJqO0uGXauKMOOg2EGVq3HyuHPIB4xq9
	 Vn9tfOMcBBmbTXlYd+8dUm5AAt8zXVu5A57SfusqokT+TRoNq6uJHFM8J/lTFhmqELg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z5MbZZSV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 187D4606A327;
	Wed, 25 Nov 2026 15:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z5MbZZSV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D1E31F000C0;
	Wed, 25 Nov 2026 15:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620389;
	bh=WtptMmUV2+pa+Kj63gcE6lSJ7PTWDxyGYid9jyr9Pr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z5MbZZSV0po9XUdPds8GMw/ykTCIpHqWeMkSu34YU3jidnKTT+qDcKO4+kFbli0mS
	 ZQnCKPnmxmfHos5B/4Ka+P1EKVrzc4RC/uQfMbYBLCF1Jd1ma2+2g8koN7FISVqzVD
	 hPSyxnAVXmwZf6lpfyQnO/9GBpjeAjt0Mz8O5v8o=
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
Subject: [PATCH 7.3 0902/1005] misc: vmw_vmci: wait for callbacks in event unsubscribe
Date: Wed, 25 Nov 2026 15:37:20 +0100
Message-ID: <20261125143842.821138146@linuxfoundation.org>
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


