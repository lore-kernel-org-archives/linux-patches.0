Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98E91CFEA9;
	Tue, 15 Oct 2024 11:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992942; cv=none; b=jAJIPbGVPMl4tg1DF0StrkcTTMc+/Shlogo5m9ramCTK+NMEQJMr7B5g4+wy0D1VtVHY1C0XceHIsBFWkBnume9Zk0wPQDnMZoUVea+jrPZiwPDd+UwiSFeMx3ocqgauC3scOpJ23WJaJjZ+7h/WaqKJJ/NvcO2RBUcO6zriHJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992942; c=relaxed/simple;
	bh=4EBqSkPT1vFE3lZZ4PGFK8gg2A8j1n1ej1sHuaK5Uvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gpeHyahXjr6hIHKUArpSAV4nAtOeYiGyoSJ3wZ3zxKDnR8ifu1PnncSSkqqRsGzML/HE2mlZAevfNylHll8GrzFOubpczolMOu0kst0MGfnAWt6vU5tstVMohyqgsLMs/7HMBhXyrjim5pZd3N0Oxl5gmY/2hHjOvl0Rw4tFUZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gCb7y9Q7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gCb7y9Q7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36E1AC4CECE;
	Tue, 15 Oct 2024 11:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992942;
	bh=4EBqSkPT1vFE3lZZ4PGFK8gg2A8j1n1ej1sHuaK5Uvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gCb7y9Q749LrC/5hZY85wYIQO0PQCLf/tvT0mfPfohY/VDtaTYwDnaLswnduPEexK
	 YeRIyZwUJA+qf1Y8DjjrkUUG7CkYGh5UozKuBbQFRt7c//GxqjlbRjdq7DPe73428y
	 bViOzbGxXudTZr1xQ0UWzSuyY0QGYkIQMC/Cwbt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 264/691] f2fs: remove unneeded check condition in __f2fs_setxattr()
Date: Tue, 15 Oct 2024 13:23:32 +0200
Message-ID: <20241015112450.828111373@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit bc3994ffa4cf23f55171943c713366132c3ff45d ]

It has checked return value of write_all_xattrs(), remove unneeded
following check condition.

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: aaf8c0b9ae04 ("f2fs: reduce expensive checkpoint trigger frequency")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/xattr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/xattr.c b/fs/f2fs/xattr.c
index 4f2069bf2b4bc..ec019feab062e 100644
--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -760,7 +760,7 @@ static int __f2fs_setxattr(struct inode *inode, int index,
 	if (index == F2FS_XATTR_INDEX_ENCRYPTION &&
 			!strcmp(name, F2FS_XATTR_NAME_ENCRYPTION_CONTEXT))
 		f2fs_set_encrypted_inode(inode);
-	if (!error && S_ISDIR(inode->i_mode))
+	if (S_ISDIR(inode->i_mode))
 		set_sbi_flag(F2FS_I_SB(inode), SBI_NEED_CP);
 
 same:
-- 
2.43.0



