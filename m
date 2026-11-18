Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020389;
	b=t+mh4XwzjEmzsGX+c36o5oRUP6srO03qJKnAGwBoeRqgrqOe7f6wuuTYixvnQGPb3JBh
	 rQ6NwhI0wzxmF9WzmhG0bWvWDRlXWjVbJt5L/87j9ztS10Xdr4NC47r8wiIwWh6GsL5H1
	 JxIkStzIft/TObfwUxiAz0+OLJX3iP+vXBxzfr81Oaw9SqAONhxZ4DnQdftZ+YcdG7LUU
	 jpnn8RnQF8cO0pZsDqcRiir2bngEde3ruuLyk+62tXpprGq7Gvy6Cvog3dOpjxn3ee0Nh
	 cPVODOLXon3iJaAaH/fjOXK9QMLE5s8iA5pF4kQCd9XkgbWXUEq8/mXwdOkcqWfxZWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020389;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0gMDs7FUITOAiIzqt/KfAaZSNAGxYYAC762Mr8ilHYw=;
	b=RP1ybOWogq1TrL8BK4gYQMbjWv/P3kX5PelmG+omCBPTLVSX2vp95sA+qUdEWbQfS92C
	 +ktHIQCmCkhFMGbCeEclMCs8cCnd7l00WDloHDgwx5hurV5alewQeyqovJtU4qil1TWZ4
	 aMIplt2xiuffBmEZjohS/COilmg7Syu9pLIwNFORg/45zpgPQp063wwQTVxAJf2L4e3Yq
	 ZV8BqOjwJLWUj0yzLFkKf9ouAcc6xRZQ81O1AD8rYx4Wpc+ZttjAhMZM/MLG/t8NZ1yMa
	 OZ+nR0QFb7kds95n/TDSRs0YV/eexD3Wvx1MWbTEcc5kdcJLVxl62FrtttrCgisBQdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N7jab7Zq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00F4606A32A;
	Wed, 18 Nov 2026 16:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N7jab7Zq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49A5A1F000C4;
	Wed, 18 Nov 2026 16:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020388;
	bh=0gMDs7FUITOAiIzqt/KfAaZSNAGxYYAC762Mr8ilHYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N7jab7ZqfteOgyVDyB2FUCaxhqruanfa5xK7EcwXxOkjkvz7bZ34BDwLoMw4eaMRv
	 P9CY8oCD0ZXlmZ0dA8x8A1MScfK41pFmk3vCwn0tYemfc2+1z4yvIZtFwSIZLQM6h9
	 jzrwewrwf3/878yV9JnZfYFC+IPoB2jJXVtOHIZo=
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
Subject: [PATCH 7.3 1935/2651] rxrpc: Fix rxperf test rxgk key kvno to be 0
Date: Wed, 18 Nov 2026 15:52:55 +0100
Message-ID: <20261118150356.319831703@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 02f8ed2f74c05..441beb077742e 100644
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



