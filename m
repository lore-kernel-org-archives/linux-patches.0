Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF532FAC06;
	Tue, 12 Aug 2025 18:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024799; cv=none; b=LUJNgO7Nj/qya54q9wRAcHTqfnsoUBdaefNwIBW/odDlUL93xfgFbaT/7xjhsFpDWKNK9bUZ2IeyiE0Xh3MPlRiAp83Kqe/71PYjKBp4dIrZf94HHKG88dwqGQEzI2U+OfUoJ0vjJXgIhaYcUk3pmzlGfSWAIpZVUWAmKE85SPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024799; c=relaxed/simple;
	bh=5VKT0TNGQzsI835xvu1m0heeunMZ4fN5dDCfwWu184o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RKp8cT/UEj1TctbNaWHU9sqGUpzBlp6O0xKcFbfrx04Up+KOphh3NFitP/UDFgKGzn5FS/i9PGc+AgVHmeHPVdASQs2FMVUYnqB/DixhbHrc92fGAVtKlL5BoKNKiZWfrwCzHZAvlq74ZgOlffZeDhQcwbNpUOmmpaSLdBbgsP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RYoNtvJ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RYoNtvJ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A15C4CEF0;
	Tue, 12 Aug 2025 18:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024798;
	bh=5VKT0TNGQzsI835xvu1m0heeunMZ4fN5dDCfwWu184o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RYoNtvJ0qFBj1X5+JDFZD88hZXN9zQXyT0fkRwZiWt14hJwN5+WptbqlDTJrW508K
	 9t8RnyrgVsC8TF+McwvAdEc3Z1RhY4jSZAOGOGsqbPA/ArJjV5PI8nAS8/uOjr6xgw
	 37qkVd+FX86x7kG2Fsdab7T+bKjD7n6coO5Y6S9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 480/627] f2fs: doc: fix wrong quota mount option description
Date: Tue, 12 Aug 2025 19:32:55 +0200
Message-ID: <20250812173442.950370143@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 440e4ae74e44..03b1efa6d3b2 100644
--- a/Documentation/filesystems/f2fs.rst
+++ b/Documentation/filesystems/f2fs.rst
@@ -238,9 +238,9 @@ usrjquota=<file>	 Appoint specified file and type during mount, so that quota
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



