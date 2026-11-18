Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053060;
	b=49ib3IUEckovPsZ8I3FIz2Ez14zYDDHtWYA73PmRlVCh5daDUGK1PK9ii7ZJdZJxWbWi
	 qt/mYgyUeAV839nABXY20f+RMwBDtESaIJgpiDBhyzlL9vHISAVlHhnhwgWGQTsSCy0in
	 RQXGL9MhQg4B/EnfAPOw8qoN88n+8k5eDxzvVj6Muoku8lBvyNEVdIZXkhoWFuGENm5OW
	 5I6PXiAmm/r99yCiQjMYob0bO94+s3z3xNZokG4Vh/716FYGHS8Xa6QX771YTXRA15df6
	 BYdZjuIQ63Akv7ChPwzp/N3qwv06YqocZ4HXUtj+w4ulZwrKFuYFG12x1H7CAaXrHvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053060;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7Wkr4FlYomwl4GoF7UQdghkODbXOtXmjj2uHASiOZDI=;
	b=nfmtLanSMeATG1+PntF/gcxKeZTmLoe8eL93CICMNp/sQo02dnSbqVnD9GocuzzSUqWn
	 9/NPcaQCvi19Tcr/1uyWgsZAy4JEJP1BvQ/pCIM6y905Y2WYG7Tzzn5btHnCVXaIzpxrg
	 Uk3/HqpxVCJB2vqRAmCUl/59N5NvmZS8SPC54GBWzrj8rzjm0X3/funQ+zjFwBI71MPQa
	 uCUxCHjYDMRIoaN/4Sy8ZT993GN1lnSp59gH3+WdVXXbsCCXl9CzwBrkrutZ9dKw4Drbe
	 i0YQ219uO6kwKmwERvJe8tQw8BU6lfo+TLHw6Mc3ZrZcP5ejBWKOlQi1Hq07H65AxZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WkEBqyDe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DAF0606A325;
	Thu, 19 Nov 2026 01:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WkEBqyDe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F931F000C4;
	Thu, 19 Nov 2026 01:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053060;
	bh=7Wkr4FlYomwl4GoF7UQdghkODbXOtXmjj2uHASiOZDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WkEBqyDeDVYPLEUzaeBAZh5ZW7ZgUV4ad4NyM3KKTs9adVGsSEnvBvjr92ShKPIdI
	 UNfEEtAwo+UqF4hUHhCl1WJGVUiomcIqm6AAGfKVgKovBXZJ1KBw6RWP0vgNe26mHZ
	 87gUgi7OFmlfmDvV1OdooJEBNVR1nRBp4eAHtT2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benji Wiebe <itsme@benjiwiebe.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0782/2214] nfsd: dont offer flexfiles layouts when NFSv3 isnt being served
Date: Wed, 18 Nov 2026 15:40:58 +0100
Message-ID: <20261118150042.900685948@linuxfoundation.org>
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
[ sashal: replaced the CONFIG_NFSD_FLEXFILELAYOUT preprocessor guard instead of extending an existing IS_ENABLED() check ]
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



