Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C6420FAB3;
	Tue, 12 Nov 2024 10:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407509; cv=none; b=oldlF75QwdccM5QfChAdQWXKCgSfo86Wjp0HEosb3cpoAdkiIRJLR0fmoOtAmOSeGhw8sQIX4InUdaPKyU7xncBUL7yMwmp1dGKFZFBSCrw8SOjzFCExnuJOp7Eb3oz263bq+xUobUqeONXKRe9J2PBTZEHdy5/f9JANj/cmUPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407509; c=relaxed/simple;
	bh=89MKE5koedVdN8kd/l8BpakxiSppni/2udcDpv0RpsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ne0IChmcH5dExBfudrKFXfH4LdAe1kmD9R7x5etcNQhkP9/lA+XCR/txtrxzkSLCYQzweWWkRmPc5hhW507Vva8rdSGkAK57zZMEo1xcg3F9aGwA/gio6J8G+d9MekKnDjWPChi8UAE1wS52Zq9vfcjAMleo0x9JqUsBAyU6XWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yD4GOmJS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yD4GOmJS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F91BC4CECD;
	Tue, 12 Nov 2024 10:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407509;
	bh=89MKE5koedVdN8kd/l8BpakxiSppni/2udcDpv0RpsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yD4GOmJSEECLuPjx+KRLMO6kJ8Ykdu2wJszFBJkbYNwoapaaKw+11OakS0nDUdpef
	 El5nHmyRCyQj32bwOZr4BdSu/+96N5O0EfP36MTd0N9uMxOJITeSwMhiInCqI+i13J
	 FcCjSjBr22l7WEnQUJnwJIKqkkDm8YQRcPAfqdhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <v4bel@theori.io>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 96/98] hv_sock: Initializing vsk->trans to NULL to prevent a dangling pointer
Date: Tue, 12 Nov 2024 11:21:51 +0100
Message-ID: <20241112101847.899629716@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>
References: <20241112101844.263449965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


