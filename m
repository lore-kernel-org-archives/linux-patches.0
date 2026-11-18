Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046001;
	b=K+jJIZMhQDCdVSmuXzlZZU3boIosxZkFcIU2vhNb4TjI1ZeQjVLUMU6tCluDjmu/IBHE
	 P/g7D6FS8dLP4AaUmWC+CvV7nWA9psHAMHcxXVE6oUo/pr41x94EzDRLGYVIk1MGNtldU
	 UVezOt2W+KKoS9G2nFoveA37Rh/qcw8ts5Un1PKIjiiLcZWxCOfyJTEq56UcfHCg1jHhY
	 NHbtC679YTr/oK1VNImJb8NJwalQ9ZLF4y8UJVWa7M0b65QQj3CscHtDjzG0AJEnke9AK
	 DInT6f0lHGrjTrVpONUZiHupgecJPnzJbLh9UHOuT3t2m0BzcZwabHJNMTFUqEuKCtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046001;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3DCcNTWFsOptUd+W/kNaFAV3bFnzBPmfzu+CILcbDug=;
	b=u/ZG57Hr4YgoAPe8QFVGgsjPkIopaa9T1PLhVndHCHTjJyApO1/PYEX4IOqQN/4EaPyw
	 RDrDULuLCFytmKlU8+6fFbXJHfJ9bYc5ljWTy3dXaqaOk/70uqblb8c0SzC8llBP9vPtR
	 u3FYhWcm6bnt3cUvqSNBEWf3z7/4922JDa0AXy1jx2HP04MCaYG1612Xd0/fZ3gLsi1TU
	 4rtJXAcMeAWxgSw4Hxr9bQ1j+kcgAkGNiwvpWS114mM2oD8oBuTdXmY5nxmyRzysi/Kbf
	 R+sCJ2frRnsc6AtdrE4fdwzRqv2TK+sbqwFDHOCY6tZ2yD35roHaP/NdMQtjWTqN0hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dBvoMNGT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A59C606A32C;
	Wed, 18 Nov 2026 23:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dBvoMNGT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7738B1F000C5;
	Wed, 18 Nov 2026 23:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046001;
	bh=3DCcNTWFsOptUd+W/kNaFAV3bFnzBPmfzu+CILcbDug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dBvoMNGT56B1W0X/pJV91i/FUgyoB5Bkrctm2DpCP62kXjJoYgnc94Dpc6QJM7lqV
	 roqBXg1DOqg4Rvklllkot2eA6UHXtGPT/R60cGMp23f0u+1n81wjoeQGain7ObNCcj
	 K+s6C1utk1H04LG3fx3oDn++Q8HdZRL4bBwHqXQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benji Wiebe <itsme@benjiwiebe.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1126/2857] nfsd: dont offer flexfiles layouts when NFSv3 isnt being served
Date: Wed, 18 Nov 2026 15:36:00 +0100
Message-ID: <20261118150242.151576649@linuxfoundation.org>
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
[ sashal: adapted the flexfiles condition to replace an existing preprocessor guard instead of an IS_ENABLED() check ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4layouts.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/nfs4layouts.c b/fs/nfsd/nfs4layouts.c
index 03c8e71d1974a..747f28deb80c4 100644
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



