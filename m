Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585999;
	b=fevKWqsKnlLiPLoTRKpSyaTtdZg62ZZwXYudK9oG6CugH22YB33mBzKIH0vpVMsgt4Zp
	 UxKLgZAEXqUEzaML/Gwb0WXvlLdQzSBN+bYFeUY6OAuReQkfKk1/6iSKHGvvgewQ3AnS4
	 0CxW/jO2VbRydoTQgG6dFZOL2gbZwEeoSx6fR74nb2ngQKR+lMm4augosTXVUJcs91Rvg
	 ltSemiZKK8iLXsFb7/0CzHMhpmeqRXPK/v382Pu0R2tB6tP67ehs6Rb3GB87kGGeW59rW
	 R8VUF+k9k3MZ+6jn6NOSLDLtuE5PhJwOAQb9eTtKNKyvjpzjCeL80E6LloEFw4vF9Aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585999;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zHCRIqK1qBC0Ofnx7nx6Lg1ip05g7zewcRo1RJsGykk=;
	b=XVf6+Ou4U1SsUhQVuaQkv5c+9dTEBV9bxcvklY7qr/iWDQNlBZWGuYv2/kpvkkcmMSOv
	 cNR6xg1sBHbQrOuoKdA7ascHrrc/HrbSiAQFo7uRsYU4ei9nrJBeRXTFhGo8NR5fopz+b
	 +KGK1GGhEJrfM3diZBbldWXQKCEiRcX1ky/UZx6NNYprNcNeO1GHaAJfYEmJakakNPcsQ
	 3Fdry7Zqr3shfmAN5Y4eDHezBqN9w9AS1rjzxkh3wEFTjehcSdb2brtPgA7I6U/IJn1BH
	 FEMk4+in/NAO/FOE8pnqN3RGaS5mHZTUY+Hke7ZtxYAhbPNgETXaPdzrsdoUgH3mP6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vLj2iuGk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A59ED606B2C5;
	Fri, 13 Nov 2026 16:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vLj2iuGk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 502961F000C4;
	Fri, 13 Nov 2026 16:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585999;
	bh=zHCRIqK1qBC0Ofnx7nx6Lg1ip05g7zewcRo1RJsGykk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vLj2iuGkb88GjGwXi+PG+NTI1V+OelfT5/HTYxGLPMXMaZN59ku6tLPvhQ3ZMCr+1
	 nqs3vTSa4TBAWbOWF3Ao4izOKtEK908M710MCGRdall91Ct42g9DWI1fi0ffXnfTPz
	 DWdunQeyjnD2KZ/dKduJ8lPskqjnEzkqxkGsWUlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benji Wiebe <itsme@benjiwiebe.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 040/686] nfsd: dont offer flexfiles layouts when NFSv3 isnt being served
Date: Fri, 13 Nov 2026 10:42:53 -0500
Message-ID: <20261113153822.327586646@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 5d28b2c920d9d9d3c45b41769342ad785eb372a7 ]

The flexfiles layout driver hands out a deviceinfo that names this server
as an NFSv3 DS (flexfilelayout.c hardcodes da->version = 3). With v3
disabled, the client can't talk to the DS: it loops on v3 NULL calls that
the server answers with PROG_MISMATCH, and I/O hangs in D state.

Skip LAYOUT_FLEX_FILES in nfsd4_setup_layout_type() unless v3 is enabled.

Reported-by: Benji Wiebe <itsme@benjiwiebe.com>
Closes: https://lore.kernel.org/linux-nfs/c734eeb8-8486-4491-bb4d-b9656cbaffbe@app.fastmail.com/
Fixes: 9b9960a0ca47 ("nfsd: Add a super simple flex file server")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260904-pnfs-ff-v1-1-5f502cf25401@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4layouts.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4layouts.c b/fs/nfsd/nfs4layouts.c
index c2d435c99bf5e..8ec980c69bec5 100644
--- a/fs/nfsd/nfs4layouts.c
+++ b/fs/nfsd/nfs4layouts.c
@@ -125,10 +125,12 @@ nfsd4_set_deviceid(struct nfsd4_deviceid *id, const struct svc_fh *fhp,
 
 void nfsd4_setup_layout_type(struct svc_export *exp)
 {
+	struct nfsd_net *nn = net_generic(exp->cd->net, nfsd_net_id);
 	struct super_block *sb = exp->ex_path.mnt->mnt_sb;
 	expfs_block_layouts_t block_supported = exportfs_layouts_supported(sb);
 
-	if (IS_ENABLED(CONFIG_NFSD_FLEXFILELAYOUT))
+	if (IS_ENABLED(CONFIG_NFSD_FLEXFILELAYOUT) &&
+	    nfsd_vers(nn, 3, NFSD_TEST))
 		exp->ex_layout_types |= 1 << LAYOUT_FLEX_FILES;
 	if (IS_ENABLED(CONFIG_NFSD_BLOCKLAYOUT) &&
 	    (block_supported & EXPFS_BLOCK_IN_BAND_ID))
-- 
2.53.0



