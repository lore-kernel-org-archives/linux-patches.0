Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619982;
	b=Mw7Z/ExnzZ556IIt64RZOOnelxi6VgPfunVTUASHyOUCZFPh9v0/DL2WOORe89ccFcbx
	 Alv1VRMe1Sa1q1OeXVcpmYNZYY7ERvQv9Qkrq15VTy0mODylI24gNyobH2C6uzsiiQAYi
	 cKafB0wji+kqYmJtwyyimgeKEhs/StcXS6vs+6TOBvlg7NjPuT8aFzx8Gr0gBecaCjluD
	 0UbfOuq/eUFZzSwX6hqY4W7ngzQSnj0+VNeXhih8nT20WeoinTV6TbHSpw6bjxIAeZmv1
	 z4Oa0mMVOiU4wjQa3cn44cNvxb93eThKCX6fOz+kHrtzIRLwa3pGoQywBErc7TDOMTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619982;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X77da1GwgWSQr8swi/jNIaHk0zigVp3SU+fZCaUKiKI=;
	b=djc06oyDFH0bLBVrKjERnK8RaI4o/Sakl7mTrgIKMNMB5wSfW51eL9acR9e0WXnyYrGR
	 mlt0QhBCA7fvBjcuifdBb70an7gvKdwbWxSMAxF7g6qrwEDQsRWvr84V4zfmw1iNaZz6N
	 02YCIWgJ6dZZYoH2RLw81y+l0uQ6cm+Swx7q/rEikHOQUZIe3Fmz9kKfhwfW3Y9FValJK
	 dnQ0l0n+irXxyUilm/X+M9XQjam74FVeiYL7voCAOVqTdRV1uz2nkax4t/0jwHsRSkd7p
	 gsW9Qtvn79irH4OMIDIfwD211ncXp99KwB4Z5Xm6P8ZJ3mlcui8wHQFA1MNyiyue4Kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WVjWwtJ3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976A7606A31E;
	Wed, 25 Nov 2026 15:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WVjWwtJ3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF10C1F000C4;
	Wed, 25 Nov 2026 15:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619982;
	bh=X77da1GwgWSQr8swi/jNIaHk0zigVp3SU+fZCaUKiKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WVjWwtJ319YowbhOqIth4KNj+AQqxrYpiDSBcZC0ev8e8d8Dm9ZhBy3nqO/bUaGV1
	 KvcCdfTIqctnj8MS5GEfonNRr9tb1RMIdJaFdNta4rBlQQrNNSaGY6k9KQqrdD69lB
	 S/wIxmKiAE+VmNYfyaQIRDerWTgLRIdw9y2CU5nM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Stabellini <sstabellini@kernel.org>,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 7.3 0743/1005] xen/pvcalls: destroy the per-socket workqueue on release
Date: Wed, 25 Nov 2026 15:34:41 +0100
Message-ID: <20261125143839.157947484@linuxfoundation.org>
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

From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

commit 6b3feb6bfa9ac384f7a3ec25c40b9b4d3da96d25 upstream.

pvcalls_new_active_socket() gives every active socket its own ordered
workqueue:

	map->ioworker.wq = alloc_ordered_workqueue("pvcalls_io", 0);

and nothing ever destroys it.  pvcalls_back_release_active() flushes
map->ioworker.register_work and frees map, but the workqueue and its
pool_workqueues stay allocated, so a frontend leaks a workqueue per socket
it connects and releases - a loop a guest can run as long as it likes.

Destroy it right after flush_work(): the IRQ is disabled and sk_data_ready
restored by then, so nothing can queue new work, and the rings are still
mapped while it drains - pvcalls_conn_back_read() reads map->ring and
map->data, which xenbus_unmap_ring_vfree() takes away a few lines later.
pvcalls_back_ioworker() does not take fedata->socket_lock, which the
backend_disconnect() caller holds here - only the socket's own
sk_receive_queue lock - so draining it from this point is safe; the
flush_work() just above already has the same requirement.

Fixes: 5db4d286a8ef ("xen/pvcalls: implement connect command")
Cc: stable@vger.kernel.org
Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20261110125002.46683-3-yhlee@isslab.korea.ac.kr>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/pvcalls-back.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/xen/pvcalls-back.c
+++ b/drivers/xen/pvcalls-back.c
@@ -452,6 +452,7 @@ static int pvcalls_back_release_active(s
 
 	atomic_set(&map->release, 1);
 	flush_work(&map->ioworker.register_work);
+	destroy_workqueue(map->ioworker.wq);
 
 	xenbus_unmap_ring_vfree(dev, map->bytes);
 	xenbus_unmap_ring_vfree(dev, (void *)map->ring);


