Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044564;
	b=s8rbCWoiC/B0gVMJiX5xZyg94faP1orsPRgvGhWvlWKkljtU+58/KZKC/eCWukTMeWQf
	 8RNoy0L7ENPusDoP232ovpPKTHDdXyn/02X7lrCyyNY09um2AP2PTbT+RQ0I83KcnCO6H
	 WqdOS45aO88X60Jsdq65FuEZIFrZ6VAxTQrWWSIePBJ9JUHU89fdRYKHZKxZmkQI2J/Nl
	 AVb0yGMnUfbTeu3W4oU5zeL7WlFcYCIau7B3M38BZCxwdceNNztpSXayR7JwOG5EHa+sL
	 11VJUrJaTryDkkt5WpmHfq7u8f88YTJn7T3x7Mc+ORSUZe0znBJC19KW/thCawTLKTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044564;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0EXHz7VP6B6LBK2R275KLngfnYe1SiqPhUT76XnL1OU=;
	b=w35ZIjVG8ETJRBIcqIZaQF9F7o1lqSThtNXNKGy+gyl3JPtvpBH00XQNN8Gtpz29Lj6W
	 cLr2H0jStUuA3sPhVhFt9EsZYRN6jQ9ML+yAikPKa4uwRnzmcFM1MKBVU4a+ztuy0X/K7
	 HeWs29Xsc1PFRTO2EeQtXpmxml2/2gHf75CHSX/DqjE7CHC7LDKgUdgAVtQTZ5377+5fC
	 iyQqzSeixVG6aA3d0M9iKKedMngAdjDEBbtlKe+mWulyIOk6/7xoxzvky609MsolPIDvu
	 3wqS6CXwPEujpCE3f1mpmZQ+3YH6vXEE9lfQQZQOPgc/MC+GQNgwfUm2+BD0DA33jCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fC6lNez3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F5A606A31C;
	Wed, 18 Nov 2026 23:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fC6lNez3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A141F000C4;
	Wed, 18 Nov 2026 23:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044564;
	bh=0EXHz7VP6B6LBK2R275KLngfnYe1SiqPhUT76XnL1OU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fC6lNez3kPs/oImtM8LuQr1mFu6+0eftNrB4tuwiYLHDFcHncEtdnMt98EmjoRENP
	 gJyYFHkIzV1pwgUiZ9ruKC7aM6A4MfDccEq6HPlt9tdJfAbdH6s+FMLywAf3yoepV3
	 A9cwlMcDb7cS/A0XF6nTxVyBN9qt9EjHqzqpzYCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	AutonomousCodeSecurity@microsoft.com,
	"Cen Zhang (Microsoft Security FORGE Labs)" <blbllhy@gmail.com>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.1 0610/2857] nfsd: hold cl_lock in client_has_openowners()
Date: Wed, 18 Nov 2026 15:27:24 +0100
Message-ID: <20261118150223.453941158@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Cen Zhang (Microsoft Security FORGE Labs) <blbllhy@gmail.com>

commit 5336899b5491eaa2ac22c2925d87daab2b140eb3 upstream.

client_has_openowners() walks clp->cl_openowners and reads so_stateids
without clp->cl_lock. nfs4_put_stateowner() unhashes that openowner under
cl_lock and then frees it, so a concurrent EXCHANGE_ID with mismatched
creds can use-after-free the nfs4_openowner.

BUG: KASAN: slab-use-after-free in client_has_state+0x10a/0x140
  fs/nfsd/nfs4state.c:3718 client_has_openowners()
  nfsd4_exchange_id
  nfsd4_proc_compound
  nfsd_dispatch
  svc_process

Take clp->cl_lock while client_has_openowners() walks the openowner
list.

Fixes: 4eaea1342507 ("nfsd: improve client_has_state to check for unused openowners")
Cc: stable@vger.kernel.org
Reported-by: Xiang Mei (Microsoft) <xmei5@asu.edu>
Cc: AutonomousCodeSecurity@microsoft.com
Signed-off-by: Cen Zhang (Microsoft Security FORGE Labs) <blbllhy@gmail.com>
Link: https://patch.msgid.link/20260828041925.36758-1-blbllhy@gmail.com
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -3351,12 +3351,18 @@ nfsd4_set_ex_flags(struct nfs4_client *n
 static bool client_has_openowners(struct nfs4_client *clp)
 {
 	struct nfs4_openowner *oo;
+	bool found = false;
 
+	spin_lock(&clp->cl_lock);
 	list_for_each_entry(oo, &clp->cl_openowners, oo_perclient) {
-		if (!list_empty(&oo->oo_owner.so_stateids))
-			return true;
+		if (!list_empty(&oo->oo_owner.so_stateids)) {
+			found = true;
+			break;
+		}
 	}
-	return false;
+	spin_unlock(&clp->cl_lock);
+
+	return found;
 }
 
 static bool client_has_state(struct nfs4_client *clp)


