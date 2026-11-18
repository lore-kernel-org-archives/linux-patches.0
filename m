Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035412;
	b=BZGwVyxN7hnRUQvMAaaMHXeBO7gV9TLrVfpWTXPVwatuIOc1z5+XRDhRxVeSywECWIr3
	 cLTIh9fLLglMvp4AbPiMqI8eHEVF+8UufSsSFcrc1yixs8RdRE+klKUUdGnFM/2EgxRUx
	 +1te5YyYrht/yrKonn4inUJSLibSLpyIh7K8seJGxsusalilUSAwDx+xilBlma+5EhYk8
	 ErsKPiIJcqhViVkyqg8AZKmmadbSpbWze40G1R7THNCO/EhHTAnd2swSLWaKhelAPzcHx
	 VJPLjAZ5UegsKVO9R7XXQ6jjbxxAb7x70VWyvCXsgPMAK6Txg3VNvqKZ9HjeI6YBeSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035412;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QDMsceB+T9OyhaqB3ZXUb74hci6axTyb/TihULMjiro=;
	b=Pm1pFDfHNRau0rPRzGIVuJ3hFsPkW27Gf8AU7RlfFnnANIJ9P+wvUPRIYbBJeLp7KGs1
	 csUqQq6ZO4gNG9/CMmzAD7tV2gYnvp0of6LOPKGI0WjPV1Ka20QpeQHbjFQAHO1y0YYmg
	 hdZ3sWvFRj7DUIYfaxB9kcJHi5jdH0GiTk0yctOZgoqofYjBryfiSMbP63DzNjHNVnTM7
	 5nOGxYyxZ6vP2RKwpcCy49lSH/irR8csth3abT0llfxwsvvrLA4jaVxEspZ1lPUdv64us
	 Nxmmo8XvZss7YzL5mpsgbOb/piiwNn5QGnN5KXcPwHphzHt/LxR7Krh8UPY72KO3SmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DxzV4hsx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80AE606A330;
	Wed, 18 Nov 2026 20:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DxzV4hsx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C0B51F000C4;
	Wed, 18 Nov 2026 20:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035412;
	bh=QDMsceB+T9OyhaqB3ZXUb74hci6axTyb/TihULMjiro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DxzV4hsxlLDcps0nOkIKfgIvPuVZgMirUwjW9taMGSi87iRg5TzG9chwNda5oF0LF
	 kSN7mQUSH1Z/U0m55YV3uwN724mhykUP0Cr8HnNvI+wpX+YRu77zN0htcjESEqd4w7
	 MJVNg9swxl+Fe/6vQAE1fOKYZrMX9DkHvvZiBMOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	AutonomousCodeSecurity@microsoft.com,
	"Cen Zhang (Microsoft Security FORGE Labs)" <blbllhy@gmail.com>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.6 0692/3318] nfsd: hold cl_lock in client_has_openowners()
Date: Wed, 18 Nov 2026 15:21:54 +0100
Message-ID: <20261118150339.033500662@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3349,12 +3349,18 @@ nfsd4_set_ex_flags(struct nfs4_client *n
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


