Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA7C189BAC;
	Fri, 15 Nov 2024 06:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731652879; cv=none; b=VKoHDm1oe5DO0n++2ol5WX2r4dTHW5JSpmpT5A4S7xtLbwA0uFeGYU+TwD3/m0jV/LBiSsl2fCK42xL2Ee2TZJDqh/wjxI3K3G5xrEOnBEHEd7/aQygB7dQ2/+EeCyAoA3jZq9ijP8WaNhkMF3j2RHpbBTLNg1YrjaKAKF/pqSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731652879; c=relaxed/simple;
	bh=mI2zIaVScuaMAHnNZfcI8LQulejFZDutd2ZkPypUz6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f4pf0hzAGlZqk3WOWoLQ/c10TxcWcw1GRAgMjAvDjOaykW/I3ZMRXXIQ85w5dwydt1Timuig31vDHTzKZG+S6JXvGl2lrMQHaaiNduyaSWHwCBniz7QLyg9Q+qxiBoLRVqCPY+6CAkBnKAxHNZFcscvB9IUwmOiHP9l948xF1c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IJu0xKV2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IJu0xKV2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5027AC4CED7;
	Fri, 15 Nov 2024 06:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731652878;
	bh=mI2zIaVScuaMAHnNZfcI8LQulejFZDutd2ZkPypUz6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IJu0xKV2E6sUyuAppeZeijOtUdt0SHvp0MSZ7qBROEZBWtVIsnTC0PJTLvWbpdkGU
	 xT5RFqqrLQ0z0Z3npr3s5sUTy6lVxJx9pLPaslJKTc96DJLzancDWcjeYCzwuGHCH3
	 LluLum9WAQts/qqMTGFTqwTVF4m3zJEjmX+4IKZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <v4bel@theori.io>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 42/52] hv_sock: Initializing vsk->trans to NULL to prevent a dangling pointer
Date: Fri, 15 Nov 2024 07:37:55 +0100
Message-ID: <20241115063724.374487696@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.845867306@linuxfoundation.org>
References: <20241115063722.845867306@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -510,6 +510,7 @@ static void hvs_destruct(struct vsock_so
 		vmbus_hvsock_device_unregister(chan);
 
 	kfree(hvs);
+	vsk->trans = NULL;
 }
 
 static int hvs_dgram_bind(struct vsock_sock *vsk, struct sockaddr_vm *addr)


