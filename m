Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620528;
	b=InGv6QlnW5ZYTWH21ZUWk9eA+p2FN9f7B0bw8gn5FVYPOKIcx5VkYKB+cqpyBB7RhQlk
	 ihwocPLIYFhWlb4oSYceYInRyIGgoHJXQzry/OQ3v5faZxIyPzmke1TDbw4QBoyC+suhn
	 Zb3RYHx6wXkRw0jEALLnIsWrj6VyKg7OsTcnKErJywYnCFLANAjbSQha47jhmhU3oiRqr
	 fAYDOpoM3aA8L2eYAY2rL9EJw1mONZER7QF5QNFX4L7ixuxgOko0SEVWNNto/vDDJxMdw
	 +vcO96oWBHFG1rDXXYBh0co7wGh/6jQPQ+RFYQkcyqI2Igyjx5+/XRKlu12ZERB/TkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620528;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u7nWFJXhzAjInubbR/c0KjFQGOM/m9QCD3q3QBXLJ+8=;
	b=W2i96zkXsseH3mQR4ZbAKz6V+ISIRK2hSrIveO61pCQGxvqLPjlyDZ5PMdei9y++LHXH
	 /HOcRg07X1vLMkeM2IozzA7RVCfLI/epgTDyFpGplxsPBsgTcGTiESBY6J+yBw2hvBDAc
	 3xuGV8NWwpeKKt+ph+3fy14Ts685W+1PGwABADzHZRhvsufChCaS/XdvMWtjmtmfUpppC
	 o+tck/N3DhWLPA1XeZOWjPbHAMmJTsLX/M1MA/vbiWolP+peI7AcvDnR36h12+o/7qmNy
	 OIbc+DqWaHulhui6lEbhW5eEgm9ouS3GLm3OS06FeHMJQdlJp3oJ6jYZKE1Lb4+JNbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IItrWTr9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4DF606A321;
	Wed, 25 Nov 2026 15:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IItrWTr9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7A381F000C6;
	Wed, 25 Nov 2026 15:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620527;
	bh=u7nWFJXhzAjInubbR/c0KjFQGOM/m9QCD3q3QBXLJ+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IItrWTr9VvWJafeo/Nq/jqQz1aPmoCvLAJSvoQ028711rgtz5v0ZzccTcaZsSzUfH
	 77x4zGCHK0PLG+gK7a11892EsCUAOt+jrVPnQ/Hw5FDjBUta3ANx3VWqDUsbqDt3mh
	 Y0YHxnyhrSEZ9dommtgrhAy8Iabju37H3sxnoW2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Subject: [PATCH 7.3 0948/1005] w1: remove the masters files before taking its locks
Date: Wed, 25 Nov 2026 15:38:06 +0100
Message-ID: <20261125143843.883984579@linuxfoundation.org>
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

commit dfc57752ec53c3cc6105656d3037fb2f5e80e9cc upstream.

__w1_remove_master_device() calls w1_destroy_master_attributes() with
both the mutex of the master and list_mutex held.  Removing the files
waits for the callbacks which are running, and nearly all of them take
one of these two locks:

  __w1_remove_master_device()           read() of .../w1_master_slaves
    mutex_lock(&dev->mutex)               kernfs active reference
    mutex_lock(&dev->list_mutex)          w1_master_attribute_show_slaves()
    w1_destroy_master_attributes()          mutex_lock(&md->list_mutex)
      sysfs_remove_group()                    waits
        waits for the reference

The files are readable for everybody, and a bus master goes away when, for
instance, a DS2490 USB adapter is unplugged.

Remove the files first, before the locks are taken.  That has to be done
before the slaves are detached and not afterwards: as long as the files
exist, a write to w1_master_add could attach a new slave behind the back
of this function, which would then wait for the reference count of the
master for ever.  And it is done before the thread is stopped, because a
write to w1_master_search wakes the thread up.

Fixes: c30c9b15187e ("W1: fix deadlocks and remove w1_control_thread")
Cc: stable <stable@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://patch.msgid.link/20261027-llm-char-misc-w1-v1-2-d2e6bfafb6a4@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/w1/w1_int.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/w1/w1_int.c
+++ b/drivers/w1/w1_int.c
@@ -176,6 +176,13 @@ void __w1_remove_master_device(struct w1
 	mutex_unlock(&w1_mlock);
 
 	set_bit(W1_ABORT_SEARCH, &dev->flags);
+
+	/*
+	 * This waits for the callbacks, which take the locks below. One of
+	 * them wakes the thread up.
+	 */
+	w1_destroy_master_attributes(dev);
+
 	kthread_stop(dev->thread);
 
 	mutex_lock(&dev->mutex);
@@ -185,7 +192,6 @@ void __w1_remove_master_device(struct w1
 		w1_slave_detach(sl);
 		mutex_lock(&dev->list_mutex);
 	}
-	w1_destroy_master_attributes(dev);
 	mutex_unlock(&dev->list_mutex);
 	mutex_unlock(&dev->mutex);
 	atomic_dec(&dev->refcnt);


