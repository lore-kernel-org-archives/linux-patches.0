Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026847;
	b=1v7Ran2h0wYEHo8xvj3z2hMGvNueZyBTyLABCtpQAuJzoRe7s4LUoM5ot4J2THIb7Lqk
	 4NPTN97Ipl8JD4XVZ9UE4R5tLehtaIpFwexQoYG+NJ33rmGxh2tTeSwSsgwoKLJgL5KgC
	 X3Nx1hKrtsMElSCnYX4SR49fsl8WR1KJRFqWBrRdntY3IwZJWogl4+QAs04oym/A7t8Hv
	 svFkcD+JR4HqJjG5d+SVlAjrD3Oen6lgmMVJZrkS9p2UPb80vLHM9FHLgzZZCeun5LQBj
	 iRlkrl3xuYYh2k0V6yOH6Hx8PxmeDtfzOE4yEQs/rzPIbAGsKjILOJucHG8i9/7B9WA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026847;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KmCMJpP63OKUKoIpJ7qxaU3M3A2j7weoJSWiXR/Ba5U=;
	b=yp1/1mIqaopWJXoV9KFk+Y1mBHZ/onJOmHytYGWgnLXHp6Kx/m60FQFeuUwt/4m6PhgD
	 xA9Xi0BaWi4upb48eOETiABO/Iz01EOmRV2fH+5s4IS4DEjXQRX6duVBPwKgFsQI0NEB9
	 ubz52gr3m1o8sFklTK34lxYvEGxTh/0Qi50dHeAVdf/w1k/MGfum62QcvvRnaztwsbfGP
	 RC0iSysQAlafmGosyXzWblS4AEEipgvpbqvWC4+Gt2uThoTfGPzJCFN6EbSS+/hGV7nw9
	 sh7JkyGSUEJcRuQ/q6dix3sfXDMe+6E9+88M8KPhfpB7nJEuo1fjZQTDJG5eETEG/sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0EEgUoWt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E183C606A31C;
	Wed, 18 Nov 2026 18:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0EEgUoWt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A6C51F000C4;
	Wed, 18 Nov 2026 18:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026846;
	bh=KmCMJpP63OKUKoIpJ7qxaU3M3A2j7weoJSWiXR/Ba5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0EEgUoWt8DApz1+lNYM6XVoO3tY89QoE0tB2ljQZcrsGKdQCAcLZlHO3qtVo1/r9Q
	 5hQusVWWEAcOwkRD9t7drKHhGXJg2H5BakeMTrO0srLmUh3Dv9kmFhbIBrkPZ+Qv0c
	 Mttomd9OU3VJ3zMvhm4Tu0DR68ln7pXsASF0KMH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Jeffrey Altman <jaltman@auristor.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1580/2151] rxrpc: Fix rxperf test rxgk key kvno to be 0
Date: Wed, 18 Nov 2026 15:55:15 +0100
Message-ID: <20261118150219.435702569@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

[ Upstream commit a7c8c3ab072375fc667ee294b58bcb9071d6e3ca ]

Fix the test rxgk keys in the rxperf test server to have kvno 0 to match
other implementations.

Fixes: aa2199088a39 ("rxrpc: rxperf: Add test RxGK server keys")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Jeffrey Altman <jaltman@auristor.com>
cc: Eric Dumazet <edumazet@google.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
Link: https://patch.msgid.link/20261006133011.531806-3-dhowells@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/rxperf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rxrpc/rxperf.c b/net/rxrpc/rxperf.c
index c816820aedbdd..0c158d067307b 100644
--- a/net/rxrpc/rxperf.c
+++ b/net/rxrpc/rxperf.c
@@ -593,7 +593,7 @@ static int rxperf_add_yfs_rxgk_key(struct key *keyring, u32 enctype)
 	for (int i = 0; i < krb5->key_len; i++)
 		key[i] = i;
 
-	sprintf(name, "%u:6:1:%u", RX_PERF_SERVICE, enctype);
+	sprintf(name, "%u:6:0:%u", RX_PERF_SERVICE, enctype);
 
 	kref = key_create_or_update(make_key_ref(keyring, true),
 				    "rxrpc_s", name,
-- 
2.53.0



