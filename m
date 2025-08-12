Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455AE2192F4;
	Tue, 12 Aug 2025 18:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022884; cv=none; b=Xa4yvYTT65V2jmAzoTne/n8+gCRpEqWOLsViWqHMqZJ1iwIjESaVZzXzg4w2GF8X3QF+KaQsvjoypZMiGXASbNqgIp99/dVXwuFG0QsNtRgyeblD4Ve2hNgxKgiyGRLqoXqsPBXZJXSZ3u6Ye4Vu+GQku1++GeDTYJkVmU6xNMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022884; c=relaxed/simple;
	bh=OZTfBvT1MLa3ETjZ2ztGH+Xkr8CSOVrt3oEvoJmn884=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NuaC2iLzv3RiwIINVFRuA39yE3L9UZJqsncNc4UgvlbkLys2WOXip6aa7eqJN5/w+3Ohuuv3OK5eT6UEwEKEaem6BIoNBrYkhmkZIylwInSiJEqJ4o2X51PEc2LyAzz7LIMeIMATf154QzsiGUvkkOXNEdwBcCdyCUZBD1QgnQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CDhMNb0o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CDhMNb0o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD7BBC4CEF0;
	Tue, 12 Aug 2025 18:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022884;
	bh=OZTfBvT1MLa3ETjZ2ztGH+Xkr8CSOVrt3oEvoJmn884=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CDhMNb0ofh8wjIIuN173dDHRDtvt3d+pkiC8uCd5XhiaQhmXILz0iFg0OckBb/Cyb
	 5O8EGAa7DrMCDUypohWRn4IZwqLZPM3U4cgF/fI0DVArGDAWhLslPs54AOXnU3u2Fw
	 pjLcnpCh1/2ZzhqAjjdSqt/0RlY+OSBOcQ+iZBtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 255/369] f2fs: doc: fix wrong quota mount option description
Date: Tue, 12 Aug 2025 19:29:12 +0200
Message-ID: <20250812173024.350430373@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 68a0885fb5e6..fdf31514fb1c 100644
--- a/Documentation/filesystems/f2fs.rst
+++ b/Documentation/filesystems/f2fs.rst
@@ -235,9 +235,9 @@ usrjquota=<file>	 Appoint specified file and type during mount, so that quota
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



