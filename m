Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058838;
	b=cTD8IzVEkowPRC6QTRImPiJXxHdeSSDU1FsjAkw42wpa9xD2uJWpxx2DFuzeeaPmFgHE
	 15KCsEDsOTLhzmzzcCA86GXEeMYFMbsGjtviAG1QfrkOo2SqW4bJmYgc/0ZiZaAp2d+XW
	 PFSvCZQlUToyUhhOxJiAYIB+hf6oVKnwqF5no9JC5GzHY6iOxlAMb0FyhHgKL/8NSYrL3
	 ZF/lAfyR3X+owVbm08mZ4WIS6Y4NQlCovBd20cgLiY+8Avtmszvs5v4bhRbWs0l/i5jrq
	 +yIaNZC57esk0gEfwlhjKJ4qBr9o7UPRfkjjO/4PVfKZbi1+2g0K7HUHSHS9Z0AqjlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058838;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8iaZ9G0a+MZ943badtH06j6OGYUskbBXm21030r16NY=;
	b=OWnUUpIU1GJi2+ecqROAtl6aNEEueYl9MLh1mhaV3pksyS/UxkLPng4l1sVAdz+3pTos
	 L+sT7xZ5mcqgf/ijlsqjBf5AHhAlbD3Z7iauAJ1BaQS74beIX574Y8i+/jttsMtrzT6Mp
	 OROhmCSDzy2yIZxzVo0EH7tTwwKO6swSTVY9k3eGSNNvaqM6TmJg+iLGCIW9LhGODmmSZ
	 RwTUy9/+n0YN4z8Quun5r8XLY1swIhMvQAtPUAJIDDsNIu8bd6xb8OUvwp7GOmFCCaKq5
	 KUnQiuqmqPINth8NdoT3lSlyo+JqSCTzjfefWsp5BQpWKf+VlIoHgeMKHp35vFidgxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vqn6bPCe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90E160A2609;
	Thu, 19 Nov 2026 03:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vqn6bPCe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 264B61F000C5;
	Thu, 19 Nov 2026 03:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058838;
	bh=8iaZ9G0a+MZ943badtH06j6OGYUskbBXm21030r16NY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vqn6bPCeYXfy+fLfhf1+utbxPqWrceYmbf7FoBRSrUcdWWS3l3XcrUd4Ngjcrikwb
	 v+2oJucWBO+fB0keCd56MxGqUg5eEzdZCLpsTHBKBp0OdkguDzPm0fV4Pbuit1/b7+
	 OS2qfaJovPsqJeS+Dcx0JSB1w+TxUOFIy+fG7gX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benji Wiebe <itsme@benjiwiebe.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0630/1848] nfsd: dont offer flexfiles layouts when NFSv3 isnt being served
Date: Wed, 18 Nov 2026 15:44:28 +0100
Message-ID: <20261118145941.980354659@linuxfoundation.org>
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
[ sashal: adapted the flexfiles condition to replace an #ifdef guard instead of extending an existing IS_ENABLED() check ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4layouts.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/nfs4layouts.c b/fs/nfsd/nfs4layouts.c
index bcf16dd07d488..f55092c66f42b 100644
--- a/fs/nfsd/nfs4layouts.c
+++ b/fs/nfsd/nfs4layouts.c
@@ -125,6 +125,7 @@ nfsd4_set_deviceid(struct nfsd4_deviceid *id, const struct svc_fh *fhp,
 
 void nfsd4_setup_layout_type(struct svc_export *exp)
 {
+	struct nfsd_net *nn = net_generic(exp->cd->net, nfsd_net_id);
 #if defined(CONFIG_NFSD_BLOCKLAYOUT) || defined(CONFIG_NFSD_SCSILAYOUT)
 	struct super_block *sb = exp->ex_path.mnt->mnt_sb;
 #endif
@@ -132,9 +133,9 @@ void nfsd4_setup_layout_type(struct svc_export *exp)
 	if (!(exp->ex_flags & NFSEXP_PNFS))
 		return;
 
-#ifdef CONFIG_NFSD_FLEXFILELAYOUT
-	exp->ex_layout_types |= 1 << LAYOUT_FLEX_FILES;
-#endif
+	if (IS_ENABLED(CONFIG_NFSD_FLEXFILELAYOUT) &&
+	    nfsd_vers(nn, 3, NFSD_TEST))
+		exp->ex_layout_types |= 1 << LAYOUT_FLEX_FILES;
 #ifdef CONFIG_NFSD_BLOCKLAYOUT
 	if (sb->s_export_op->get_uuid &&
 	    sb->s_export_op->map_blocks &&
-- 
2.53.0



