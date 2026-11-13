Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590817;
	b=NnkumDrI1V6YlJ1bShY6V8Olk1d6hEp9R71kfNRLdvr1gbQxrDLqnye4ygEBo+OGddc3
	 6sAT16VKOnO/STZ7jPwT+pzVdyoG0RNtdxny81WFBFCOZokiLPQLuo7czzDdCUtf9ds2n
	 +IXqd3pOFMV6yyS4ZAUPEiGVnSxrbIKOc+O9UHaWJ/Nz8MS02z7A5p9eWX3dOaEXsQfCp
	 y4KbVMVWNFSzjv0a5X8r+wXnW9eQVHtJOTJZGpg332vrdaNZZpH6mZ+53B2yHreswhDzL
	 RwPRq0ZaFgd5ae3XJMzgRrpZ0H+dAHj2pMKX2rdITGnlNLspliBXt6mm1G4f7Ac4C0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590817;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gmWLcpV4G/CSyOGRk+YtQf8kaqmCgsqTEZWUhaXDhiM=;
	b=IPUQqH0jCy4AEXHf8W1Fr9C2ZvReTsQYmXqfAdlg7+vomppFk5AwMS5CEAzaPa5jHgD9
	 8U0rap2qVmM1ni7drxN8W1ZdKC+YJfGqd8aFe8GdmSR8dBMLWBWhPumNh+EXB7u7wFbI2
	 o16OoGfMzekrzj2DJXQHTgOgZ8BHFzzTRvcH/CnTw9PkOY8Olr/BYfiGeUbuMH4hfyU7H
	 9ayzq5pVIQAwNpxKGhiYRtO7ixv0dI7hbMeprrVQK2DbJsocVkbnXMdo6D3J3YCCHLbnE
	 iAIr2/IDs2NleyDcNJCM7u016beSoE+Qo/eJRICLEkRCZtSnVmPoG4qzuGDEuuOhZ6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uMVDUraD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D1A6607E053;
	Fri, 13 Nov 2026 17:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uMVDUraD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED9801F000C4;
	Fri, 13 Nov 2026 17:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590817;
	bh=gmWLcpV4G/CSyOGRk+YtQf8kaqmCgsqTEZWUhaXDhiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uMVDUraD3bA0RV/ABa0ORvejPuYl7xvoIWXIXSvkNWTHKycVDYui8ww3M+cOPkrTA
	 WZeX3MebOh4EPgQsQXWaddBy8BWBAXZA2VeKBEujbSnU7hnB+U+HJHIlSCRn4AZp5i
	 mBImSgEro7eo1LYUneNGWCNkGZyCU6FiDMPvB3WI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benji Wiebe <itsme@benjiwiebe.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 025/670] nfsd: dont offer flexfiles layouts when NFSv3 isnt being served
Date: Fri, 13 Nov 2026 10:43:09 -0500
Message-ID: <20261113153812.037512897@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted the flexfiles condition to the older layout-selection code that uses direct block/SCSI checks ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4layouts.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/nfs4layouts.c b/fs/nfsd/nfs4layouts.c
index 0ff8994752637..a78e0bfdc9363 100644
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



