Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214507;
	b=JbefnzMSyZRQytpzKiP7eKGKRkRw/mBuWK8mNKVzdgTT1pLFwe+Y6tXhOXiccMnNU46/
	 vq/C2bQ6jmjqF45NKVJyTlRBYgg6aK/umUkkGd4bZCPHDnHCaANlqI9EMri0j8czvwCAV
	 BUxKQn3T0tvt3R978gLiHYI0Rc04b/GpUUJoTCkjC/cQ+I9v7+B1LABfdFwJXJPS02q2m
	 FbkxeFmJBniCwmc2meqc2W9cT5yyunHawz1N6GxQLsA13/3EIJT/ykmFsVug0l0lOD+3b
	 RHs9ydfDPJh94zPWCiixGYIIIx/+m5T2UXDF8AqovFCqoPfMDDfIAqrj7ntuuA0Tjbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214507;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8lBVzV5D1BD4w+8qqLwrQ4xbwykawaJuQf4koQr/OVY=;
	b=NkGHJ9F0GJyJsG3MvibpQuOSinYM8auYSrLuY1p3HSL0ACzUEOvKXu6I/MyX82diWHbP
	 20W+iam1K2CTPd5IGwS/TRyX2zwbiHYoEzXxvV9PyRcMSuvrAivZyrv4P1zv3+dRltqIV
	 GW6Z96WQ+LLxMKmtsS977+yLbKGnwHxHL1rKiuxqjJlFzfDy8WFY/niWKsaDJ2ZWRi2ZJ
	 Zy5qptijdeKv1GFKKUXBuTcDU3SyOXesNVNv4bzrgguKyE+Rg8kcJfeZPNxowjFtCz0C4
	 8dZF4q4LjrlzzUgSD3ItshjzWkqZV7pjHIGi/URLKSPWYNsWTJP57Op9Ncv5Svo7jAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NdPdwhGK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6968A606BFBD;
	Wed, 28 Oct 2026 19:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NdPdwhGK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 891121F031E1;
	Wed, 28 Oct 2026 19:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214507;
	bh=8lBVzV5D1BD4w+8qqLwrQ4xbwykawaJuQf4koQr/OVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NdPdwhGKds9qK0eEeWutiFR++VX9+ecEO52X/IAE1OgaG0f4LX3lwtXky4xRFaF5v
	 O59gkg46RZRJDMVyUda5x489zW97WUZlmKsriJ6m8J32XoSQvmX6KX+pY6mJbxNDjP
	 rz0TJb4bJbXaMOa0wygCq0d4ZryygD5fS6UJWvaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Starke <daniel.starke@siemens.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0856/1887] tty: n_gsm: introduce macro for minimal unit size
Date: Wed, 28 Oct 2026 17:49:12 +0100
Message-ID: <20261028170518.903123487@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Starke <daniel.starke@siemens.com>

[ Upstream commit 7a1212475f5e313c11300272f34ffa32462bbeef ]

n_gsm has a minimal protocol overhead of 7 bytes. The current code already
checks whether the configured MRU/MTU size is at least one byte more than
this.

Introduce the macro MIN_MTU to make this value more obvious.

Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20221103091743.2119-1-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 3cf0b3c243e5 ("tty: n_gsm: Don't block input queue by waiting MSC")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/n_gsm.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index fc52a7a38df32..165a70ab1f004 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -89,6 +89,7 @@ module_param(debug, int, 0600);
  */
 #define MAX_MRU 1500
 #define MAX_MTU 1500
+#define MIN_MTU (PROT_OVERHEAD + 1)
 /* SOF, ADDR, CTRL, LEN1, LEN2, ..., FCS, EOF */
 #define PROT_OVERHEAD 7
 #define	GSM_NET_TX_TIMEOUT (HZ*10)
@@ -2771,7 +2772,9 @@ static int gsm_config(struct gsm_mux *gsm, struct gsm_config *c)
 	if ((c->adaption != 1 && c->adaption != 2) || c->k)
 		return -EOPNOTSUPP;
 	/* Check the MRU/MTU range looks sane */
-	if (c->mru > MAX_MRU || c->mtu > MAX_MTU || c->mru < 8 || c->mtu < 8)
+	if (c->mru < MIN_MTU || c->mtu < MIN_MTU)
+		return -EINVAL;
+	if (c->mru > MAX_MRU || c->mtu > MAX_MTU)
 		return -EINVAL;
 	if (c->n2 > 255)
 		return -EINVAL;
@@ -3360,7 +3363,7 @@ static int gsm_create_network(struct gsm_dlci *dlci, struct gsm_netconfig *nc)
 		return -ENOMEM;
 	}
 	net->mtu = dlci->gsm->mtu;
-	net->min_mtu = 8;
+	net->min_mtu = MIN_MTU;
 	net->max_mtu = dlci->gsm->mtu;
 	mux_net = netdev_priv(net);
 	mux_net->dlci = dlci;
-- 
2.53.0



