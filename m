Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624419;
	b=GUbUnnsD+2aDd3UEU1AFXRc3DiJ18JgWOoEihj4k7cQqO0bEAUCxjVQGIg3huShkoSN2
	 d/OEfHhbCQkLFSe68eTqjsvEe2elApCVvrwVOFNmwvMVoMngSC+NdRHQ4o8wkIpOmAxoq
	 udTNBanEmNMzyZ9M7den0F/8gbZbyTcOaJZ6XnRfJ74buAN8e99GU97Zx24haqA9zgMCE
	 kqmGBPND5R4h2EkIWpmkmZTQxb7ymnQnL9R/m3wk3w8ebkN96zqLjLu+vjZV6lTFEfvJH
	 p2UUxzNIc8UN6XAxZadPB06d01V3+lhxEcxOUXBZr0pPgDmxDM3c0ycAx1MgkZYEe+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624419;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZDA1vY9wXGY920o8YD5wALnvYNZSthG9NBQUgjcFKmk=;
	b=oUidFyl8ix92t1Cc9mh9+dlS4WUfGrw1k1gc64lbkyhsYDIcvA4I9q+14WHwk83CuBiJ
	 c+Qz2AcNpKbJlMwmFc/A1ssEBTYWQnNhc7ISZREPUY6tYTw3Hogo3htg5mweQK2PiCh+O
	 wAZ1367W7AeyieNRq9qD9vT1vQO0rpzi79+YHk0daRFz0geauZrGJobCSiqbKSTR8b9HI
	 GehtF5VJBJL1v82UXn+RUhy81sOD5Rs2lYHo97wE95FZh+8jsgT4NQJye/a01oEV0DAl3
	 XaFghPq4cXIy2qOvYBahkqmiD6rutwiOa85B9q39Rrr0NHQif9etGLS7UkGWcitT1qw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QUEUFdQI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FFFD606A685;
	Wed, 25 Nov 2026 16:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QUEUFdQI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 320171F000C6;
	Wed, 25 Nov 2026 16:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624418;
	bh=ZDA1vY9wXGY920o8YD5wALnvYNZSthG9NBQUgjcFKmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QUEUFdQIo6XPBvWAFeqstsxB3+hOucTTrsWhAZGS7MiMD+rOt7gkx2UkRm37wKkTK
	 ZXQLExVEC/QlD9sOv1wsJZAzFzJZRSXtiTMEjTyQ0XAWLvlQ+H32agZkw4U673ldQ2
	 3TtJrV3OV1XlsFFUhOev01DMvku2hGDON7NgrNjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nguyen Dinh Phi <phind.uet@gmail.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Bobby Eshleman <bobbyeshleman@meta.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 187/816] vsock: reject negative tv_usec in SO_VM_SOCKETS_CONNECT_TIMEOUT
Date: Wed, 25 Nov 2026 15:28:55 +0100
Message-ID: <20261125143853.524938774@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 999cccb323f79..4a790db5d01b3 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1941,7 +1941,8 @@ static int vsock_connectible_setsockopt(struct socket *sock,
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



