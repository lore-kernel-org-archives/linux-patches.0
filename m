Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831760;
	b=MB11lYKQNx32b6MPmYYK0Kfh+KWTpvsDcuWx7CW0JECyQ5Py9cwvr+bqeVCp3IZF3E98
	 4H4880aWIdvR6dK4GXUrRcTdxPYdYmAn9GtZJgK1YpUF/Q6CNBimPC8k9fDkaqlaAtEo0
	 UWdiiZ3a9TDEIMbZ9+Fb5Qhiz1BYHD+bsxQdkSAf6Mkjhve1VoXUiN61sO9DNpnnADKnA
	 U72tt2Vj1lvpU7C9ZrPjfVAZQx4khyQ8701y/ZRjztWnp2b0takF7OYMwzBaBXUY4MQoq
	 f7QJv6htwgQ/JxTyG44idFkguPbBI1ZSASoCqR3aSty/UD0el8UYZKGz28Z84kM7QWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831760;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zQw7x93FI4XdwbZFOsj1NHAcrjlbqfEnXoJqWJ+PG6Y=;
	b=TI1kGsOOwY/73yQa7vdvFEUOLFXRkLDxrNuq0B6Jf3sK96SW0KQG4BUfhkNUcmzXFHwF
	 ZoGwl2o+7jrSaiUKmimeAGAnkiPqWUEOeNv+EhPC8t1a2AfcEJ1grbcFwhsLPpTrOoVR5
	 sxPvWtMVeHn3VLb6/zHdxqbApkxZyCHERzTHQ81C2PM7wfYq7hCuuBf8UVQoLpmoEAjiU
	 eeTjqWwfJSnNzlb/ASgc1vhuTsBV0ltXNwnfgmX9SHoKqKgU5lh7xqOFDuLiDGe/975FN
	 b1oD0HFLqalAAF2DUdwsrArhn4yPyj0ScHPIMOJ5ze/r7Xf1Aoqfcku/QQfZbIyhIiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="sfVqeog/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2103606A31B;
	Wed,  4 Nov 2026 22:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sfVqeog/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BE311F00919;
	Wed,  4 Nov 2026 22:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831759;
	bh=zQw7x93FI4XdwbZFOsj1NHAcrjlbqfEnXoJqWJ+PG6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sfVqeog/xxaYCcYjC7BfT4FqVmfFq1X6/cRTa+YARGHNuqV6pQ8QlkGnT9nfCnhWl
	 bIUlM2acdzb9xZGK5vuf/KhscU0ErG2lY2CKHhNX4bDKzH+c/Ir5XcGlEkQjYHhyJ+
	 BBuhqECqP2Ko5N2nQ246+mWxjKOmDLhzakQuMvyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	AutonomousCodeSecurity@microsoft.com,
	"Cen Zhang (Microsoft Security FORGE Labs)" <blbllhy@gmail.com>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.18 0895/1005] nfsd: hold cl_lock in client_has_openowners()
Date: Wed,  4 Nov 2026 16:10:28 -0500
Message-ID: <20261104211108.280736744@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
@@ -3759,12 +3759,18 @@ nfsd4_set_ex_flags(struct nfs4_client *n
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


