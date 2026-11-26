Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705019;
	b=x2NgaK+jFcsMNBaB6S3NqjiGGbHJKLWmk6mibddtulC6uMy6yhxlxrYa4DVQYNUeflbf
	 TOm8fmsr72g7XP8MxKu8CtvSurV4nJ+X/kLkujuPCYsK0Fp+aRKoy5ghYItNLRhmpl3ED
	 7PTG4ec6uEK9pBslDeW7QkBIljtGbIQcBSOVFb9pCeNvk6D7XUMLVxyxnnO8PU5zxTGdO
	 JtpQ/mgy1eea14yeKjOTAmVRhOlR0QyOsl4yos8Mii+WbzLxozEyywObVxRfJ58BbkTii
	 cYSLNShgQe+o3EK2SOei/tnhCu35FeRGDMbSYRVHqg2UkX6/f6UYTKKP7rFI9qM0dEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705019;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yJM7qEXS98xxKqTu0aJuehcmCmDf/zwZHuHaqC/FUYw=;
	b=LAXz48bXXRFQrCuKgp2XFgfXhfEIUvY5t/rs88vYp6TVHuxUGa/YuM1uQd2COlLzOC1B
	 nfS02WcYASb+uZHSOx3Me6pg97qCBNJMAwtzRpipWNJnwrs0kKpBsReaykK+G+XIkVX0M
	 PksviToRlzSTgfgAi5LY5sbmxMLFwhlw5Hv9AuJHZwALQDcfOZfxHorzwOV8AwzA4Wg90
	 5Xo2Jdg5zlYhf7Dze2SLor8jXVealRdEOMH9hHXgmKB8zo2mJUB4fv371dIIDTp0vKoX2
	 OagAMKyj1M4AhVg+qhgtqb5bEWFxiVb3H6Nvmt4CAPxemziuzlbyjziG2adqVMDZT5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JLPPl+Ut;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0954C606A33E;
	Thu, 26 Nov 2026 14:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JLPPl+Ut
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42D5C1F000C0;
	Thu, 26 Nov 2026 14:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705018;
	bh=yJM7qEXS98xxKqTu0aJuehcmCmDf/zwZHuHaqC/FUYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JLPPl+UtU9JLVQIcYlTDKUTjR2irYmSonZmGgaIzXkEZDQ5Xk0n8NtECYmmikS3kJ
	 ueU021wdtCNkH5m/kBxK4XArSPfvEcywheV5I5PMuDtUa7slLw1xh4u43/CLr6OwQs
	 g9dErLgVbDUuFsagf4yWmdruwSPxD0aFywCIDnCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Jia <physicalmtea@gmail.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 055/319] vhost-scsi: preserve event ordering
Date: Thu, 26 Nov 2026 15:37:03 +0100
Message-ID: <20261126144007.980580947@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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
index fde8e61c236ec..18d2b0c28c6dc 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -516,7 +516,7 @@ static void vhost_scsi_evt_work(struct vhost_work *work)
 	struct llist_node *llnode;
 
 	mutex_lock(&vq->mutex);
-	llnode = llist_del_all(&vs->vs_event_list);
+	llnode = llist_reverse_order(llist_del_all(&vs->vs_event_list));
 	llist_for_each_entry_safe(evt, t, llnode, list) {
 		vhost_scsi_do_evt_work(vs, evt);
 		vhost_scsi_free_evt(vs, evt);
-- 
2.53.0



