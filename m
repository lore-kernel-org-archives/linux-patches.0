Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621419;
	b=uPJrmyd/VGCbRHxTCQ2p8n77YAzrCgvebZvqe5k8ECUDSvckHb4xI4U17bMGPQUnNXhn
	 8L9xQFoBlNJz6lklx9foiyivmbrl04vfCxVoE4VyK5R979TkyBem2LiNF2BTXp3S+X5co
	 Egerw8cAwhiJLg10BV04mxF/qE0Fei3+P3aKG9HU+Ob9yb7/mNbL9zzfO2tgBNiYtHaJ5
	 ZSJ7e1KI9HstencxZ8VaSJowlcuKmVsdN5E7I3di0Pgjd/mh0eIoYlYHb2MoZ0KuZdTBL
	 Cg8JrV2GB3J//jEy/csxBUF+YHCqQ7Jp13gKwZw57HfF7tNSxnPuxyHsFOC3D0FBZHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621419;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7F9i3Bad0NudBgfSizhxyeDSFPDitHODsmiRFwYgcgg=;
	b=KbSJjtu+EkXTA+M85T01YMQQjtPWNFgdmkNTKsqJkVAFNNSEBoJ2pE4n6gaczZwXojrG
	 tvmoOLNQajE1Ii8ZvhywW3IQnBWb6lYN05PsQ7Gg2C+J0Mu5uROf5EcULA0lrVS+cu4F5
	 Ede0fonC+wp8CBKyyj52GocAJyn3R50EcayMZeQjOrfketU+MTKdrSbu9lj4luexQw/kB
	 ThI8doyrZb1y9nAXjzLJ/666qT9omOXWIDc5LLNhklns2irKWrJLX/SFWT5NAYcGis4zT
	 icXvaWTMY7KRAombUdJB40byQBKh7a3Vt49bvziX0LblB7OPSesOURpiRobicAkB57A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Z/RgkOBl";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B98606A6A9;
	Wed, 25 Nov 2026 15:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z/RgkOBl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E0901F000E6;
	Wed, 25 Nov 2026 15:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621418;
	bh=7F9i3Bad0NudBgfSizhxyeDSFPDitHODsmiRFwYgcgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z/RgkOBl0R25qF5Y7Tfqgc4MmvfQWod18qHC1MQ1NzlWipN7VgxysXO4NIJYm6lB6
	 JxByy7eh2PWFVr3Dj1SWY7RT2bIphKoTOhdX/AEPc2gTTpoChebVFEi0Uu7eeBWxp2
	 /WXuYK39wqPGZ1bgTkflig1gMdDaNGhg/xx6EmYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nguyen Dinh Phi <phind.uet@gmail.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Bobby Eshleman <bobbyeshleman@meta.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 220/990] vsock: reject negative tv_usec in SO_VM_SOCKETS_CONNECT_TIMEOUT
Date: Wed, 25 Nov 2026 15:26:27 +0100
Message-ID: <20261125143827.244004383@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nguyen Dinh Phi <phind.uet@gmail.com>

[ Upstream commit c0ef6144b4d60afb90bc6d8db3ffdac043cd6ffc ]

The timeval validation checks tv_usec < USEC_PER_SEC but not
tv_usec >= 0, so a negative tv_usec makes the timeout computation
wrap into a bogus value, later tripping "schedule_timeout: wrong
timeout value" instead of being rejected.

Fixes: d021c344051a ("VSOCK: Introduce VM Sockets")
Signed-off-by: Nguyen Dinh Phi <phind.uet@gmail.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Bobby Eshleman <bobbyeshleman@meta.com>
Link: https://patch.msgid.link/20261030064428.73930-1-phind.uet@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/af_vsock.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 999b18f2d17f1..391ac6d2435b6 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1986,7 +1986,8 @@ static int vsock_connectible_setsockopt(struct socket *sock,
 					     optname == SO_VM_SOCKETS_CONNECT_TIMEOUT_OLD);
 		if (err)
 			break;
-		if (tv.tv_sec >= 0 && tv.tv_usec < USEC_PER_SEC &&
+		if (tv.tv_sec >= 0 && tv.tv_usec >= 0 &&
+		    tv.tv_usec < USEC_PER_SEC &&
 		    tv.tv_sec < (MAX_SCHEDULE_TIMEOUT / HZ - 1)) {
 			vsk->connect_timeout = tv.tv_sec * HZ +
 				DIV_ROUND_UP((unsigned long)tv.tv_usec, (USEC_PER_SEC / HZ));
-- 
2.53.0



