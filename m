Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618047;
	b=h4GligDY+1y3NEP56QrnJ7Z8Lz6LlDSmDFC9ymySifxUGoiYEqs2vlN89yejLzs7U/BA
	 BkUj5+4+oQBIKC84VOyNCmv5+YLYGyWwFMEOOGBL0JxQcpU+yziIzOrx/09IkIwNxE8BT
	 P+s75H+pQUwf9TEAdnfOGsiseRdOARH6vvgb9Qn0eCfTTFZCklldlTZNLFBH1NwWh5GqZ
	 WXRPkJLRG8Ubor90z7G5+uXMidyFcmfUf6a+afQZD1W97esa0yrk4fW4aIvk/W3KS6JcM
	 9q7K/qtZ4oZi7iDmBA0pW2Yw8LSq3dTO3D2gr6Re1tKSMdt2aDINHbYABboB9oAPM8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618047;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GmGKcL4vJj17IhFQiR6hX5m5t6I0P3xT27qcLLuxF6Q=;
	b=XtIjTflfhQ2n6DW604NqtfL+4ImeqVOoIs8XxzfiDPRyS8oQlbBaa/be75gOmJ9s7XO6
	 vbf9fVmEBIdEK0Jj+GGYNEUgMx60Mle4noqBMIVnwZjjMNxL3wIRr0pUSmYxApbhqOWsl
	 EKXfVoXZCQJvA1Pqjh6D6tYmky7JemCy07//E/B0qAWJV9UOZdnSkePoTi6qtbHyii63p
	 mwW71y7YGZClZWckkAsfzXclMZsdA8xcdNKv2le08n3OFTGUFt6WUMN+527vicIy+q/9c
	 mR9ySm6Ulx/V8l/LKMQmpVh6Vh3KEAGRHQI+jAeQhpehBpeUMUEfXt2V2P+AGwbqDTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iG9Oj3lJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3FD606A32C;
	Wed, 25 Nov 2026 14:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iG9Oj3lJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 351D81F000CA;
	Wed, 25 Nov 2026 14:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618047;
	bh=GmGKcL4vJj17IhFQiR6hX5m5t6I0P3xT27qcLLuxF6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iG9Oj3lJnBFK5zmezSkEY7SiZn8GQJj8mei0OToqn7JtdOqwPuH7Ah3Q/iuafb1k7
	 y10FGJjSdbXMtceax0gF3J++HiG+y4eB7mxzgo8wnsUdRyRuXsjfjEVaL/xuw2gPFp
	 U4xMXldaa8m1U3cD6urBNsn7Ph9MAcWCOzwrxiek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Jia <physicalmtea@gmail.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0155/1005] vhost-scsi: preserve event ordering
Date: Wed, 25 Nov 2026 15:24:53 +0100
Message-ID: <20261125143825.368607956@linuxfoundation.org>
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

From: Jia Jia <physicalmtea@gmail.com>

[ Upstream commit a9a428115b7d8aa45e12e41899f90f60551bfa82 ]

vhost_scsi_send_evt() uses llist_add(), so pending events are LIFO.
vhost_scsi_complete_events() walks the detached list directly.
This can deliver a later hotplug or hotunplug event before an earlier
one.

Reverse the detached list before processing it.
This keeps delivery in enqueue order.

Fixes: a6c9af87363c ("tcm_vhost: Add hotplug/hotunplug support")
Signed-off-by: Jia Jia <physicalmtea@gmail.com>
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260915094244.7900-2-physicalmtea@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index ddc9bea190ded..738db166cb5db 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -667,7 +667,7 @@ static void vhost_scsi_complete_events(struct vhost_scsi *vs, bool drop)
 	struct llist_node *llnode;
 
 	mutex_lock(&vq->mutex);
-	llnode = llist_del_all(&vs->vs_event_list);
+	llnode = llist_reverse_order(llist_del_all(&vs->vs_event_list));
 	llist_for_each_entry_safe(evt, t, llnode, list) {
 		if (!drop)
 			vhost_scsi_do_evt_work(vs, evt);
-- 
2.53.0



