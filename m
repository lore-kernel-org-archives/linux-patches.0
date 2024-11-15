Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA51E2BB1B;
	Fri, 15 Nov 2024 06:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653959; cv=none; b=gItaXalLK7OadmbPLeUp9OZg7OQuX/+VDVCsUu5z624H64AelkVsMvV/P90GrMmNsC75bfcJYfA0q4Sm4PWyHvhd31EU691tsGnpMCZPpx/PN04MbTDGeJbGUPNRDmPh80xtXsvZSpL+Bvrmxcl9YRJk7BeU8X73WWAJCB0SLOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653959; c=relaxed/simple;
	bh=AABEwKw7/gPraDx+gytFCqRjY9oqws7nRpCZtl/2OUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e2SbU2RF6v5MhnAJ+HGerxAWx/jlVF2atJkHcDKyncqKgE9Qr8m9FKg9FUeAzxnRxzX0L2NVVAIHmxD5DJ52LFMHQ+QYJkaSkNYJz8Z5rheGlqKnm9fznoq2/K5vawPbqxWXukGcV3rp8v/SMnbO3KBKZNCUmV04pR2Q8S2e0FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L4LvsxzX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L4LvsxzX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4430EC4CECF;
	Fri, 15 Nov 2024 06:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653959;
	bh=AABEwKw7/gPraDx+gytFCqRjY9oqws7nRpCZtl/2OUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L4LvsxzXinr53RzljT2VAvsF5TtuKZ0EU/ZAI2YL4t2Kqbusjzhtnr2/OwTVPWq1y
	 orfEj98c1c6y0sh+zfkMjBjfsUB0KPV2nJLkqhfc/IcDFbnPDJ/HdDBMnoaQF0cQLT
	 JvLWOQnhQ7sJOyxR8pNdC+JN6WfyErQlwiff5beY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <v4bel@theori.io>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 66/82] hv_sock: Initializing vsk->trans to NULL to prevent a dangling pointer
Date: Fri, 15 Nov 2024 07:38:43 +0100
Message-ID: <20241115063727.929809543@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.561151311@linuxfoundation.org>
References: <20241115063725.561151311@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyunwoo Kim <v4bel@theori.io>

commit e629295bd60abf4da1db85b82819ca6a4f6c1e79 upstream.

When hvs is released, there is a possibility that vsk->trans may not
be initialized to NULL, which could lead to a dangling pointer.
This issue is resolved by initializing vsk->trans to NULL.

Signed-off-by: Hyunwoo Kim <v4bel@theori.io>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Link: https://patch.msgid.link/Zys4hCj61V+mQfX2@v4bel-B760M-AORUS-ELITE-AX
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/hyperv_transport.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -538,6 +538,7 @@ static void hvs_destruct(struct vsock_so
 		vmbus_hvsock_device_unregister(chan);
 
 	kfree(hvs);
+	vsk->trans = NULL;
 }
 
 static int hvs_dgram_bind(struct vsock_sock *vsk, struct sockaddr_vm *addr)


