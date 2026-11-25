Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618331;
	b=W7Lww0QtzRJa+hLq7sARtDbOcX1APGytSMZp3ZN3umL0qI/RxmBLie6y1dFe9TWq9hfL
	 dYWvC8Nr+oCxcPUBg09tQ3oACib8PVvo4VfCRHtLMrGFdKGXUau1xopB5D+bkxWhAvAZy
	 JW3UqFFrkho4FCek9qSEzj9R58+J+f+hc2ueqI/e+cpIpLLibZwyrbc8DqVWAM60TNhqE
	 ChlCXiTpEEHPC//ho8UkWPLqUkhNE+xzlU2U5KQFGUjxR+3rIb5bfZCvjUy0bkF0QsYO3
	 AfiEqFK0lAh2YnemCZn9J7H6G3xf1fYg5IECKXk5fOfOtGtOVtFYwI6MLQcUq8joJZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618331;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1pWsC4csH3zT7fEosaw8xDHqeFUtgM2IRmhyh/DZLqM=;
	b=NbjyBccQTZjPTcBHpUF+N8WcEfGQ3tN489D2Wt75MtDYD7hqbEFY46/qixWsBrSsBO2n
	 4UbbpQ/aBcF0rlfmcCP9mwIBOwacXXbqIMfsGSU383PWevQquPlwH+SQOJAor+z81BOis
	 gqu1Jx0LcBgiUvtwv1BBRi7+TqnPOjlh630wChD820Sye7rvlLfMhOZE6JJ139SoL/L2Z
	 jRRDjPg0f+/vaSG+O/FeLjIMzTLrsn+OF7UXwurbekV+ri/VhUw0W6KucJp/btyaXiQE7
	 xnrPXShd1SX+lbORRPbfL3zLFm/QdPpSNUktihD3XNoQ/NLW+nKnHtpFLSM5kJ7ocAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=POwkTNmZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0D5606A321;
	Wed, 25 Nov 2026 14:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=POwkTNmZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A76A11F000D3;
	Wed, 25 Nov 2026 14:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618331;
	bh=1pWsC4csH3zT7fEosaw8xDHqeFUtgM2IRmhyh/DZLqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=POwkTNmZ34rwyQVuPYoYjmSBZCwmRXdDqVWN60y1UtTY/iTKPIz60TXM4VKObMLRe
	 UNYR5Nw00zT3gg9o6ZnveK1IFZSy7aersYZUrcD+EzwCQ/0TNS01lzKJEmFIboV44v
	 BjqHbiQsUx+myibciUj67141Vd0CytoNJNj98PNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nguyen Dinh Phi <phind.uet@gmail.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Bobby Eshleman <bobbyeshleman@meta.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0245/1005] vsock: reject negative tv_usec in SO_VM_SOCKETS_CONNECT_TIMEOUT
Date: Wed, 25 Nov 2026 15:26:23 +0100
Message-ID: <20261125143827.476958829@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 6ba8c85dc1613..9f9b02d1e0508 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -2101,7 +2101,8 @@ static int vsock_connectible_setsockopt(struct socket *sock,
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



