Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322BE1B87E9;
	Tue, 12 Aug 2025 19:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026489; cv=none; b=V4UNsQAelYsv7sgYf6s5+d9S9ILXUQu8M44BrENqNtqpgMeLkhgmS0UdMUQfrqASxpkIVZHGJ7qjYbADje2xzQQynBDLfsEth4lGoZb5Dd4R0wEiap/OOzT6YHrvR8m4OFL3ZeGTgTzd7PJ92lz95UwzXFSH7TIPtjkDJ3L47ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026489; c=relaxed/simple;
	bh=aPlsBvxE9SVCtpAG19DNSrxnzgRwFveed21ZoOIWD40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U1Q9AozqulKyXs0lgNs9BtLDp6HsBH/Vss33hkvogz+3JQAxP7aVhIYM+0rm4iN9UYshOLPSOIEkLXuKbRvxOk9DCLznDZHVM0fTZXfXXvwetzHYO5WYdnpjNAIruX93C3+vWXqEs7LOlhXYnBrp5k7WOwuZsFOpKZVzNdx2kbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V90OK+py; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V90OK+py"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CD2DC4CEF0;
	Tue, 12 Aug 2025 19:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026488;
	bh=aPlsBvxE9SVCtpAG19DNSrxnzgRwFveed21ZoOIWD40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V90OK+pyg//eMoFGfh30ck+VEQJ+dIiofHrZnhgXottNgG1aLW5oDGwnw/vBMpMlf
	 xHIyu7Ep2Y1pk7gPoH81qVOIHibfuz/C+3jKTFgA21idZ0PdXkNNwWiEvFUP9aipVp
	 VK3bAWqXMuQQWWn/dXlrV/Yuuaj/sLx079R/8A/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 352/480] f2fs: doc: fix wrong quota mount option description
Date: Tue, 12 Aug 2025 19:49:20 +0200
Message-ID: <20250812174411.949584874@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 81b6ecca2f15922e8d653dc037df5871e754be6e ]

We should use "{usr,grp,prj}jquota=" to disable journaled quota,
rather than using off{usr,grp,prj}jquota.

Fixes: 4b2414d04e99 ("f2fs: support journalled quota")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/filesystems/f2fs.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/f2fs.rst b/Documentation/filesystems/f2fs.rst
index e15c4275862a..edfd30b198f7 100644
--- a/Documentation/filesystems/f2fs.rst
+++ b/Documentation/filesystems/f2fs.rst
@@ -236,9 +236,9 @@ usrjquota=<file>	 Appoint specified file and type during mount, so that quota
 grpjquota=<file>	 information can be properly updated during recovery flow,
 prjjquota=<file>	 <quota file>: must be in root directory;
 jqfmt=<quota type>	 <quota type>: [vfsold,vfsv0,vfsv1].
-offusrjquota		 Turn off user journalled quota.
-offgrpjquota		 Turn off group journalled quota.
-offprjjquota		 Turn off project journalled quota.
+usrjquota=		 Turn off user journalled quota.
+grpjquota=		 Turn off group journalled quota.
+prjjquota=		 Turn off project journalled quota.
 quota			 Enable plain user disk quota accounting.
 noquota			 Disable all plain disk quota option.
 alloc_mode=%s		 Adjust block allocation policy, which supports "reuse"
-- 
2.39.5



