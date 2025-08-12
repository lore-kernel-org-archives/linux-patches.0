Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C11199385;
	Tue, 12 Aug 2025 18:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021614; cv=none; b=gfvfhbpVz5FJ8843j/vWLD67vPtGSxeWgw4fakP3AM7/9pz7nmj3lxWBnfIQcp7uvCqU9+5OulP1rwFMQvNLWnA+ZzFUa7OoUuolVJVpCyiaEcrwr/jTx+4Jz6zp3NuZEydtsRxuoWKej+dD3SxONWrItqOUcBiEjg9+Oe8r46s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021614; c=relaxed/simple;
	bh=e7ZobGTx0CNUH9ymHlDRk26czFtE3Z8/hufBYO9/vYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MXUpVVmC2XSxIP1OWHtFEDMbj+Kpyn8mTnxFo+HNDj0vlwgwXwdiXGW/ycFlh6M+k2KP4QLj2YpfSEqbkEs0t/xdgHTgy96MeOob9FC+FK3+8nPvqSIuaX3N+j++QxuDO7zE2owh/XZdOQ/4rRcSlmEiawz2/5OJZ2rF86bZF54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0cNKEFhl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0cNKEFhl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C992DC4CEF0;
	Tue, 12 Aug 2025 18:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021614;
	bh=e7ZobGTx0CNUH9ymHlDRk26czFtE3Z8/hufBYO9/vYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0cNKEFhlmqxtuaVdu+rKmpxmG3XPQZXVny+mfmhtjCPq7IIpJ7ZRkg0TJaLpDnTM2
	 MwSGGncLqOjIKQDYulI6Tvu3M9W6VUCgx3/fFn7PyotbCRTn1OGi5oUL764nfjxX5o
	 vDqEC0Sl1mjPXivkaXz+foZBZngPKZXMx2veVzxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 173/262] f2fs: doc: fix wrong quota mount option description
Date: Tue, 12 Aug 2025 19:29:21 +0200
Message-ID: <20250812173000.478581280@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index dbfbbe9ab28b..961684e9466e 100644
--- a/Documentation/filesystems/f2fs.rst
+++ b/Documentation/filesystems/f2fs.rst
@@ -233,9 +233,9 @@ usrjquota=<file>	 Appoint specified file and type during mount, so that quota
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



