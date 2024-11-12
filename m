Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C32722ABF8;
	Tue, 12 Nov 2024 10:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407902; cv=none; b=c5LdKJttptZDI5XS9BvbboFHsPVBA5sB6MO4KYovn96ijHGXe5gjAXmAtcIsjB6zUiDa+ui3lCTk+LqpmO6T/KDTdtmVeRiAtKW4B3p9+T8Eaj1AbzE10HQKc+Dedq62DpJznOLjomNtBEs0KY+7QiVtZN9K4pktD6w+3Cxy3vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407902; c=relaxed/simple;
	bh=nufo/sIQvFxKhH/ijSRgAHDwBx5G2p/buSwFV/Mn+pU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QLUTt7sqQ+PprN5bK5Zqir12wunb+BSAar4Sn+SQNXEQWTvAEZGvwYeMuOSx8MffTN6UQbshJh2i9vCA9iHTkTE11EcmBb0+wF0/miDTLG0CKFRS7/5ouOCeEdikpf/X+Q5eXVKijYIYTjxs7B76FjZtz/D8ISy+uGrVp7thVEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kjbpJlR/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kjbpJlR/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD34BC4CECD;
	Tue, 12 Nov 2024 10:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407902;
	bh=nufo/sIQvFxKhH/ijSRgAHDwBx5G2p/buSwFV/Mn+pU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kjbpJlR/xakaVYr/GSqO6YzZQeGYkJBE94h7sOV77NDQIRl8UfHsK5a2jv3wfh9Rq
	 htMnJx4cMkCvYpfIhP+45f2rEbNp0whWBWbE7j3WhuEO56YYklHUplQxyiGD0frWU3
	 exaalzqS52qQkpMc3Y3mRN1650OeG39mmV5zq3ds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <v4bel@theori.io>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 118/119] hv_sock: Initializing vsk->trans to NULL to prevent a dangling pointer
Date: Tue, 12 Nov 2024 11:22:06 +0100
Message-ID: <20241112101853.224384298@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


