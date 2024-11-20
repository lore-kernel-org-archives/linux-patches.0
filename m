Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67A61DFEF;
	Wed, 20 Nov 2024 12:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107384; cv=none; b=bhZ7F6ihYAF9yngK/sUdmg+j3lkXr4MRplbbGJhDduGxbA1TBkf4AADgbE4T/zhGQ99LFEGrvmryaUVvb46rbX+iRNK/soXj28Cn6gZPsYUSNMEAmiHnBqm0wvhuqUyhuucChoYKgc9Hdn7DX9xdmjsdl5dNYwer55Oj7zMXc8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107384; c=relaxed/simple;
	bh=HuvczW81QUVCVKY7gX6edv5Aqw+MGBuLDiUoAL/bYvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YyYON8VMqSgmxxXQOyLB7WQETUv4hj0Q7ywDvkEyhAm2m9Vwyw6N4G6kQhCave3loGuJlm3PDgZurc5ym3H4hI+1s+tm1HjmBplsY9qcgK9DbSEHXhM8G66jVMcWTw9VN7dAEghOh4E9uTb9vv8FpNGGU7u0p2Bp3AOdJn6ee7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H01mT4Ka; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H01mT4Ka"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336A3C4CED9;
	Wed, 20 Nov 2024 12:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107384;
	bh=HuvczW81QUVCVKY7gX6edv5Aqw+MGBuLDiUoAL/bYvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H01mT4KaChaK5NuJK9LCqf18an4CqOE+PYrsA5nXHcssokYpIncJvhXA5oMihD8Nl
	 ZaFrWaGxqD1CXFOA/VWVkeOy/6luF7rxkCIzd8riC9OxSrS808OWfVwiS+CszrRh1M
	 mTmhjozf15h74N0Oa3zPQ4/pUdGBaB829rNpgmm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <v4bel@theori.io>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 1/3] hv_sock: Initializing vsk->trans to NULL to prevent a dangling pointer
Date: Wed, 20 Nov 2024 13:55:55 +0100
Message-ID: <20241120124100.479662012@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120124100.444648273@linuxfoundation.org>
References: <20241120124100.444648273@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -549,6 +549,7 @@ static void hvs_destruct(struct vsock_so
 		vmbus_hvsock_device_unregister(chan);
 
 	kfree(hvs);
+	vsk->trans = NULL;
 }
 
 static int hvs_dgram_bind(struct vsock_sock *vsk, struct sockaddr_vm *addr)


