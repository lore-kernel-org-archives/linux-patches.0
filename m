Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7A438C2C3;
	Sat, 17 Oct 2026 16:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255854; cv=none; b=ZIuPld3oA8p3yoGKFefJfKKsN9t0iWff/42m9swXQQYU8VPIOwJXtWl8i21Imy9bUbN0sJbcMCAMF93p2dkM1Td9fysX8oHq2qQ/Ci8Pew2r+41aVgCXQIBA9Var1zOtMSWODsa20kkG4nycI9Bb8yIyWlt/xqN9IvSNKcxLHD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255854; c=relaxed/simple;
	bh=AV5i6pIsDiN2MokQBohokvcMLGd6vubpTMKWaa1btI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bs4jwhS9uBhdfU/GdJxp9RWXnWc33BNQreKx1qAKqC47GNfzXgQ0xgvGsf2crgCVvtccWakgAw8XCxD0nAKPTtdJKHP9UL4kUVGKa5U0S2CVQS4kbpQHDdlQJzBjSh/Ae/H4B65leVJC06Jdb8jVzCnrBP16XtU76wJkuhrnJNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0fVEhjhG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0fVEhjhG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 853C71F000C4;
	Sat, 17 Oct 2026 16:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255853;
	bh=WTRdITaShRKZB97REe+aj+QGwxw7d3z13cETAAD+8hI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0fVEhjhGqL6gogTSLL5uzURNZcV9FrKtxOqitqZfKP5tOC1vc4A4Ln1SZfFUkSViO
	 1vbywyR9iLPXQLqoqN/jtiKzHwqNR2f9fo5IoSX2HgXDnmkZtZFexojjTz2DhB7+bk
	 2PNZgueDmTmW2l8yGQdkHBuYe5SlraNtOTdKhrFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bharath SM <bharathsm@microsoft.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0043/1674] smb: mark the new channel addition log as informational log with cifs_info
Date: Sat, 17 Oct 2026 17:38:35 +0200
Message-ID: <20261017160432.246050864@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bharath SM <bharathsm@microsoft.com>

[ Upstream commit faf1b64888ff13caa94fa09835fcfdabee18b057 ]

For multichannel mounts, when a new channel is successfully opened
we currently log 'successfully opened new channel on iface: <>' as
cifs_dbg(VFS..)  which is eventually translated into a pr_err log.
Marking these informational logs as error logs may lead to confusion
for users so they will now be logged as info logs instead.

Signed-off-by: Bharath SM <bharathsm@microsoft.com>
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: d034e836eefd ("smb: client: fix use-after-free of iface in cifs_try_adding_channels()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/sess.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index 6fac7a1075920..d3619c8ab142b 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -279,7 +279,7 @@ int cifs_try_adding_channels(struct cifs_ses *ses)
 
 			iface->num_channels++;
 			iface->weight_fulfilled++;
-			cifs_dbg(VFS, "successfully opened new channel on iface:%pIS\n",
+			cifs_info("successfully opened new channel on iface:%pIS\n",
 				 &iface->sockaddr);
 			break;
 		}
-- 
2.53.0



