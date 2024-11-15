Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1256814EC77;
	Fri, 15 Nov 2024 06:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653155; cv=none; b=bcgMObr2V7VUc1zH+LLN9hwvB5761unjrIbi0vcsJ2/EuHZEAD+FcDi83rOK7PPrBtOoeiiI2mJJ/EpZ2kYkdIG6ZvosFC6PzZ8S2nm4oR5EgpDhg8EqL5KoS5UugHrnNNj/PoRY+8OAykJ8SqsaGa2mWCDWJELxzgtZ0sOxuP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653155; c=relaxed/simple;
	bh=5eNn9dDsBWsYQWTZM8PUa1L++znggBKDS7y7HlGMPbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Egm0TuykT42Tfk/tCyU0pGNL2p7dmHVraWcsdvPEg2xJS4ATKJ1+s0dfLbkvaX+Gh3PV2xscnOKJ+0eHi07241OfY+5iVWzg844cLkZBPUOq9CLNWPAprAbCgEU4vtB4uIwIlmpmMgIGcu4Zheq97PiQIukXTZlLvdXrvejS9B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Hsb4gyI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Hsb4gyI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30671C4CECF;
	Fri, 15 Nov 2024 06:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653154;
	bh=5eNn9dDsBWsYQWTZM8PUa1L++znggBKDS7y7HlGMPbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Hsb4gyIsqv+bTWwMWsvjuiSvEmE3DvliFzPpMEdgab12CqxnSEAo4XXTp1q4902u
	 +I8TPB7t030AO8EoCcR8Ygj91IrQChCaRurSWE/Acyblsx9EWNiukm+u6G3wgYjZg2
	 QDZZ1UiLa5y3v64QqRbUpmvkgIvJBlGrvyYkiCBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <v4bel@theori.io>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 51/66] hv_sock: Initializing vsk->trans to NULL to prevent a dangling pointer
Date: Fri, 15 Nov 2024 07:38:00 +0100
Message-ID: <20241115063724.683844585@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.834793938@linuxfoundation.org>
References: <20241115063722.834793938@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -531,6 +531,7 @@ static void hvs_destruct(struct vsock_so
 		vmbus_hvsock_device_unregister(chan);
 
 	kfree(hvs);
+	vsk->trans = NULL;
 }
 
 static int hvs_dgram_bind(struct vsock_sock *vsk, struct sockaddr_vm *addr)


