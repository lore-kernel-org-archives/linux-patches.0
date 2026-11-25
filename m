Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617668;
	b=fnrHB06jApIx+mLhyoM9NQQPrGwOtsbh+XwFWQQwu0JY15NudjRpycWhoXmUsJusWSyc
	 M7AtyUBBt3Ly5rWVHhY27VJVIoZg+ocG5KTfJcJgGWdGI69YMTUzfs2ei3HKpvExWl6mA
	 eCOsQgt8bCyqxx8g6oE5ZGlhsBHzDO+dgbIKUnRdqsJ/fdaVU5OoGnSH5Rn+U3WKBptmy
	 UEz+H2yYOcyKb7mUrZAj5UqkjusSbFul99xFKjruA9Ep7/kGMOLMjNb0M7VMHcGk/1BAL
	 z6jHgaG438enonRxUhh9o1dV5LU4e5mKo+IqGwtws1f516GN1EV85J33xp9PaK24XGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617668;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O2EKX3iJoXsDzP73UfxkSkqgj8dTtQlatayz4MZuyUg=;
	b=x/mNkw7ReqEwEeRXb3VkHwKOZZgDzAJBeSvjQcm4NI7O7nOs0Q7gXk1f9yyPX/Bbc03/
	 zR7YTWnyEMHZejrpjnYxP4T9uxLZuMj6vq4zWxNlBjyEEZOYsmrkltfNd6gpLl3j14k21
	 RoxoSAvI5E1aNQtqERGAl1MZ3aWmFj4TaoENYiVFyilN40MBygMEHootSCbg10/pZlYch
	 6e2AYu3a2VQFV1uIE8w8WnzJK/fScTeyPlTagSnw79AKA4p1KsikbuQFI65XBlltFuHja
	 w/h04O9yj9ncCMIvMLNmqfHOsG2+8F8jp0AOlSd3ibX6M4qEmQCLfDGlSLJdbfX4Q5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DbSyw8U+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CAE0606A327;
	Wed, 25 Nov 2026 14:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DbSyw8U+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0D41F000C0;
	Wed, 25 Nov 2026 14:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617668;
	bh=O2EKX3iJoXsDzP73UfxkSkqgj8dTtQlatayz4MZuyUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DbSyw8U+hWvrJ91gxSBpCD12iw4VCFfxy0mlM1GnUVrZ06mjIL6Iln1PvyWHVJ9lR
	 DaHB5wscTFbRZAKEiXrpMXKHSYJqKoK/2zT30PQGBesNSavfz2zhuaNXgOsINrxUjJ
	 Kqqrhgw9vCm6NdY2mK8CHBbHOTbBeGeKDX1h0p3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antony Antony <antony.antony@secunet.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0038/1005] xfrm: pass extack through to xfrm_init_replay() from xfrm_init_state()
Date: Wed, 25 Nov 2026 15:22:56 +0100
Message-ID: <20261125143822.633001947@linuxfoundation.org>
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

From: Antony Antony <antony.antony@secunet.com>

[ Upstream commit 24bc5e549913c37fa30693fd3a62a16757c14327 ]

xfrm_init_state() takes an extack parameter but doesn't pass it to
xfrm_init_replay(), so replay-window errors can't be reported via
extack.

Fixes: 231a1744dc43 ("xfrm: add extack to xfrm_init_state")
Signed-off-by: Antony Antony <antony.antony@secunet.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_state.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index d340dc9d73461..5b241dfcae62b 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -3387,7 +3387,7 @@ int xfrm_init_state(struct xfrm_state *x, struct netlink_ext_ack *extack)
 	if (err)
 		return err;
 
-	err = xfrm_init_replay(x, NULL);
+	err = xfrm_init_replay(x, extack);
 	if (err)
 		return err;
 
-- 
2.53.0



