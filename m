Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795014405;
	b=0I+PpPf7R1F38bJMf48jHNdDUsXC57esFCTowZqivDlLm8+hprNxfTF2KH6p3/iwj3b4
	 yAj7FmHC/QdxDa6tT1b7D1ZNIrpubX/yCZO1gOafLIR9QXeoqG3lJJtIhFrLDymPQOCsP
	 XN054llojnf/pZ94X/jXANvOUHtpZXHpDNLGrcyz+IWWDaPwbAy3Mj0qKavsmkIAzfCfe
	 LsmrHFkidAzjCZ+NcUD5MfTB6A4DQpnAb1gnD/4QLtWsjZqG0SfJHBxkSGTCcTSvLZL0C
	 GKB4q45CqQ0Sw0vU0WzpSjCphV1rewWSK1pT6tX1IlmwnD39OExaVZylCo9/X/asLvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795014405;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L++NLD4nEO7GN/O0Po+QnWZHdejiNk/OEirqsAYiiSg=;
	b=1dgj3OV0+MMZHAUrfFjE7Mts/1ooXbgImnnchkTo6S72f4NpzRZdU4LO8a0YmSLDpYB9
	 ermjLTH+L85g7LRgErzTKGRvyy26KlpvjgrrSzTbCZ/iuppyGbRM5hs3TqQ6ZqIA8Sz/8
	 +AOs4xiOtNJ36hiX3V70NpngujpS+XrHNVhSx7lQLZxxQdu3xLvKTjHxCHl9RA5KzRjL6
	 knsijm0NihiNH4rZrVvdFG1aP/e2o6xFnPuBuTsJhE+DtClnfSBAVYeohwKsd4mGlnQfX
	 +QmXgXutDCX/uCiM35ipdJ6wBJZ4si296wBgJyEdf9xAtQDFGgE1ChvA5XZMx+mW3Mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q10Kh0jh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343EE606A339;
	Wed, 18 Nov 2026 15:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q10Kh0jh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82E851F000CB;
	Wed, 18 Nov 2026 15:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795014405;
	bh=L++NLD4nEO7GN/O0Po+QnWZHdejiNk/OEirqsAYiiSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q10Kh0jhCXWYOg+yqvmjFfqnnQVSdXJ/8kxJXl9aAR5bTKtSYm+8RZrFwEoadvbAS
	 8/o59rffCZ3MFOOrlM9R8heNtNiguZPPoEx2mnRSuXi4/9Z+LgaIEnXkLq5E/pmzOh
	 rNWLYTG97PZXHFxR8ZAQAm9M0QCvJ4PulVAOIUl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tu Dinh <ngoc-tu.dinh@vates.tech>
Subject: [PATCH 6.6 0002/3318] xen-netback: Fix XenBus connection failure cleanup
Date: Wed, 18 Nov 2026 15:10:24 +0100
Message-ID: <20261118150313.672001309@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tu Dinh <ngoc-tu.dinh@vates.tech>

commit dc6d814562b65813556933dbda1015cef61dabf8 upstream.

xenvif_get_stats and xenvif_get_ethtool_stats capture vif->num_queues
under rcu_read_lock. We need to unpublish vif->num_queues before
synchronize_net to ensure that readers that come afterwards will not
read a non-zero vif->num_queues and attempt to access invalid queues.

This is the same cleanup algorithm as used in backend_disconnect and
added in commit b17075d5c198 ("xen-netback: fix race condition on XenBus
disconnect").

This is XSA-531

Fixes: 5fb756f1bbec ("xen-netback: Fix UAF when reading statistics data")
Signed-off-by: Tu Dinh <ngoc-tu.dinh@vates.tech>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netback/xenbus.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -731,6 +731,7 @@ static void connect(struct backend_info
 	unsigned int queue_index;
 	unsigned int requested_num_queues;
 	struct xenvif_queue *queue;
+	unsigned int num_queues;
 
 	/* Check whether the frontend requested multiple queues
 	 * and read the number requested.
@@ -837,14 +838,15 @@ static void connect(struct backend_info
 	return;
 
 err:
-	if (be->vif->num_queues > 0)
+	num_queues = be->vif->num_queues;
+	if (num_queues > 0)
 		xenvif_disconnect_data(be->vif); /* Clean up existing queues */
+	be->vif->num_queues = 0;
 	synchronize_net();
-	for (queue_index = 0; queue_index < be->vif->num_queues; ++queue_index)
+	for (queue_index = 0; queue_index < num_queues; ++queue_index)
 		xenvif_deinit_queue(&be->vif->queues[queue_index]);
 	vfree(be->vif->queues);
 	be->vif->queues = NULL;
-	be->vif->num_queues = 0;
 	xenvif_disconnect_ctrl(be->vif);
 	return;
 }


