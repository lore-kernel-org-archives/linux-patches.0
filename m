Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051853;
	b=KH59SvMI2uSi1jX2c7uLBxfvUXLvKQVMTltx1f/T4/gon6FOpmrGQFvDZfqDyrewq/Qq
	 Jii3HqhGFHqQ93tdfq3HzifHovZ/26KmlVGmp6SdlUULMKOMHP5PpbuoFjXuQkVH8n0ac
	 5l+BGxYEDQ9B9Mc0ZJGakrNdNnUzqfc4V1INM6DJnnrDf6H0pA10pRz1V4qgZJtwd0M2E
	 1ypjXIf6RPyJ5lojb2K3HlV8lA6eBuzfXpEuPAwCmDXWXJ+gI8vMgNkdPga0iuyetvGlM
	 SpEFt3Csmu2DWTALunnXro+fLByj844nDwzMmzhFXu1zeDjWAhMDnvsZ+il/0jj4o9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051853;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0Z1yGbFpZU/lQj6oxXqKJcPbTCVgY3p3IE8Q4BlKrPs=;
	b=1zOxBddMkmqBoN0eL3wVMY74tfjCHnjwijbU5dF3YhytB+KWv6sJzOUxZSsJr+LGKMY6
	 rUFaueNOURW4k1Pu6v/Y/+/KQpaLsTr8j5uy218TeeOOERwWCJerhGU2ZHFxyeHjsZc8f
	 Fa+OcpPWX48BVBCAh2t9lGCTj0fYbcvIybwQ6ZnHlMQFC498tn5RCjUinZZkpmZuEs0jS
	 h6z2wOP+aMeDohk+RjrJQeKJj6VKI/UBtLdWG69CHHxxgs9pFu5x+pAaECwHfwaXtMOKk
	 IidQQrW/A8SJQuBSvVHy+vZK2sUwfx1+igp24ziQrmiOHpJkSuGX0iCywXhk8vBKGBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=omXFwY3s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16DA4606A325;
	Thu, 19 Nov 2026 01:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=omXFwY3s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A1761F000C4;
	Thu, 19 Nov 2026 01:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051852;
	bh=0Z1yGbFpZU/lQj6oxXqKJcPbTCVgY3p3IE8Q4BlKrPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=omXFwY3swvtbtCSZy6+URfIUa3EotDmSQITAgNbChCvh2V/AyQIZx2LyHCFoBULOY
	 nZcpFYojE8wJYbZYilMpfyFdrPnri9LVwv4Ye+0HAHCZJixcd0u+atYcXRVEQUpoT9
	 FB94mUnKOE+E+Bod0sxO5EWyiXbsqoVa260P0RH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	AutonomousCodeSecurity@microsoft.com,
	"Cen Zhang (Microsoft Security FORGE Labs)" <blbllhy@gmail.com>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 5.15 0354/2214] nfsd: hold cl_lock in client_has_openowners()
Date: Wed, 18 Nov 2026 15:33:50 +0100
Message-ID: <20261118150024.864959051@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3332,12 +3332,18 @@ nfsd4_set_ex_flags(struct nfs4_client *n
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


