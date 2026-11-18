Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057903;
	b=DRCKWqB0miyfHRPqAxp4XB0h8qzrsc8uqUJPo5RAOK1lfe7SqCgbNvzleQuggTYLjWyx
	 tXvLHCY/3h/cfZ85KopM+/pWngSzYGjlz7PHzmYTc/tJNSqFmd5IWmJhlyfPN+gumVl6u
	 4m3melLEvIwBY2z5si6Kxshkvc9bjUDuSwyWY+KA5XLjaUsUKVmgENtU5nx9rTqK53CZY
	 lpH27MML012UbDGOhobT9ZYqB3UYHvacpFeXzLG3C73aUnLTC+0oYy1NFSH8wT7BzIB0d
	 VN5adWxqv9EruaNLRllv4ZUlVeq/D3LAlE8I4W/7eE9Jfh3L6vlx8ww86lKk4VCxoIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057903;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fLNHCCTkcGkZdGZ/GlMFHT89DWGH6N2ab+tNkg4UEvM=;
	b=SbXCSRr5epKWTNlRjMYKf0a8+W890ukjYo8u2UnQQJN2i5ic+8GVbZwZbhTihSaV/Hrp
	 6BgYv4kMqmGpAH4PnttGqXxeeMQLOCPWkWqnCIfMltu1B9g2wToe93i82HAzRb6Preaqr
	 8Y4kDGJ2tBB+4cu6ySk1jIiAG0q50mF57oe/Pmz3oiU+mtmyxB/BBhMuBikRSNdecrG+y
	 OZOq07NVk8kjDsAIPC+LNqrmeL77zHrwRDY035GP0Z0IAG0y3k/JqE0JsVeYm6aXgZWs5
	 goaFQOalsN8Sn8Te3sKj6dOJfBMasL5eC1EQsZfwQkrNNML9N9sTO+GelG0DK1ud1oA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IM0AU+hq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B0F606A31C;
	Thu, 19 Nov 2026 03:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IM0AU+hq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9976A1F000C4;
	Thu, 19 Nov 2026 03:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057903;
	bh=fLNHCCTkcGkZdGZ/GlMFHT89DWGH6N2ab+tNkg4UEvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IM0AU+hqwX4/vF0ffa9Smd8TDVIxuDKYByYL+ya9PkM/DpcoSsMKVLo+Mqyu0UTsq
	 nrsjNv/ovL8sHmtkiLJD9dJqokylgM4NKNStUlNIMcx7Zmjql43yr6MrFaSZu5j7Yf
	 32pNCLpF24Yd94i5YyHSXWYks7ze7vETEzF9XnNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	AutonomousCodeSecurity@microsoft.com,
	"Cen Zhang (Microsoft Security FORGE Labs)" <blbllhy@gmail.com>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 5.10 0294/1848] nfsd: hold cl_lock in client_has_openowners()
Date: Wed, 18 Nov 2026 15:38:52 +0100
Message-ID: <20261118145924.378200475@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3331,12 +3331,18 @@ nfsd4_set_ex_flags(struct nfs4_client *n
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


