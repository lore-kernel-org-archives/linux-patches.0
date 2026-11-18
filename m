Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037177;
	b=yklkQfq6NL+QPZ1APyzntHLxhhOjcMsmUN/6/HJzWIZ/yHXzHRM/FdS2HcVI/DJXfzIx
	 nNl+KC5LVwVF4yrgNO94ZJhucQyxLAi0CxfqT4LCMkBLX7BpJ7kyXMW4vdH/gMxy6QaEs
	 4zG2kJUBZnQ86f00mx4IlVEUFHvfcwfERKYSBxG6FDbyMYSssVJ+80PPNjsxqp3o/g+fw
	 fM5rqUbyl1jCRawsVZDqlk0sykzlXou/QjUmka1dlCzCqQZX4ZE+WmjP7wfSxefez9H13
	 0KkqNvYAuL2+WQ+l1Ji3Dg0bw7pWBo8lL8j3yB+0oZXLoMyp2vaVJlxiC7GQnX/oJdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037177;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AKMPFth2RZWmq+j4ASH6onYxWhogXasBzdO3LDYQa2I=;
	b=nsOBiMQ0Be3V7lBHQ/RVZnqmUGfykORKJ1hpHAFWwEvzC4QHuEbWOsTUWRWCrOMlUDUt
	 esQiweXGqYlym6Uu7pKqgordGEp7Z240aCbTTcaFZ/W4y6kNr+dj3ylX8rJM2YXlzMZ90
	 QjIzAMuUfMlEZE8aQA8dTiY1yCZIKI9rdJu0LW/stCRJ/pAsik85KsR4bUPlSFy7hfVDE
	 aim2mV7xUSyYlpk8ArRSzs9G1fL5PvFXb0N5Fl7IqrXaDPtDRWHkJ5rUxkMrIjSa5mpxy
	 Q9vVX2SToiJdm84PgZvR4f9YwP4RZ/Aq1WFmAzicYDH6H7EYkb6f4cOSeiDptSgsycw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C8sP7QaC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72252606A408;
	Wed, 18 Nov 2026 21:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C8sP7QaC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8343D1F000C4;
	Wed, 18 Nov 2026 21:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037177;
	bh=AKMPFth2RZWmq+j4ASH6onYxWhogXasBzdO3LDYQa2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C8sP7QaCDKASaB04fKwRp7YxtnH6vehS6Iwle7DFlYR84ReMZiuLsm49sBgxwq/tW
	 LBK90UKWnyXISjSWAfDoYj9kDA7QX2jvrEvjtfDATTTicAzMkeakRW8DWjN0JHLBxK
	 I8fkL/dXjJdR2qiqXYqjDCQ+AkuJu4rVH/O6Di0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benji Wiebe <itsme@benjiwiebe.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1320/3318] nfsd: dont offer flexfiles layouts when NFSv3 isnt being served
Date: Wed, 18 Nov 2026 15:32:22 +0100
Message-ID: <20261118150359.915693969@linuxfoundation.org>
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
[ sashal: replaced the existing CONFIG_NFSD_FLEXFILELAYOUT preprocessor guard instead of extending an IS_ENABLED() check ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4layouts.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/nfs4layouts.c b/fs/nfsd/nfs4layouts.c
index bea7513a0de90..821e7ab13211d 100644
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



