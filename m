Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42491E497;
	Thu, 23 May 2024 13:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470610; cv=none; b=EMa3gg11MtITsUA0zmvHGDuVDOoEzrEOcl8kl4/H7j9uu1UyXabaLpROMUVwTMJdN8FUTV2NWlRcfYE8BlH7t4nzFsmGXZHgQBnT9r4HN8iFt1E6rkb+pAn0ZL2gRuK3/FL5ugKIWiwT3S0NZkHkTQv+p2evCHjHX7UAIPwwBmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470610; c=relaxed/simple;
	bh=cloQlFnegdgOpTOMNgbuYBfXONtw4jermmanivCkqgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MeYz74XVicL2nsWvXnEMOlMKVfEDKuKmWZ/m1mhGXNkVJn2vVsiZ5S8E9A4yGQE9bLnpgZbGW08XXF48Tyoqxg+A3+A8lp07f/pdXO62CAKlLbuvgZ/bJ4eyvL57gyt1fMKzSaiyYwlshjC+JeyhE6ac2gH2EehbZEGNi3NG7OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZvlORF/+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZvlORF/+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EEDDC32782;
	Thu, 23 May 2024 13:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470610;
	bh=cloQlFnegdgOpTOMNgbuYBfXONtw4jermmanivCkqgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZvlORF/+HGIVyDuhXrmDrc8qum4ET1AOk7hN0LuGkiSTA8CUSkG0CXUmGkOUI1o31
	 jjA8eDI126M/K4JvrQ7+7lsPqHJouLBjlLp2Wk3lTlof+4tChyDKcwX9Gt7ay8sDoF
	 KJWh2npRrcYm2oHOx0eLhOuE5XtbFdNEhVuROswY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bharath SM <bharathsm@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 027/102] cifs: minor comment cleanup
Date: Thu, 23 May 2024 15:12:52 +0200
Message-ID: <20240523130343.487564523@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <stfrench@microsoft.com>

[ Upstream commit 0b549c4f594167d7ef056393c6a06ac77f5690ff ]

minor comment cleanup and trivial camelCase removal

Reviewed-by: Bharath SM <bharathsm@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/readdir.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index 56033e4e4bae9..47f5a82bc2507 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -647,10 +647,10 @@ static int cifs_entry_is_dot(struct cifs_dirent *de, bool is_unicode)
 static int is_dir_changed(struct file *file)
 {
 	struct inode *inode = file_inode(file);
-	struct cifsInodeInfo *cifsInfo = CIFS_I(inode);
+	struct cifsInodeInfo *cifs_inode_info = CIFS_I(inode);
 
-	if (cifsInfo->time == 0)
-		return 1; /* directory was changed, perhaps due to unlink */
+	if (cifs_inode_info->time == 0)
+		return 1; /* directory was changed, e.g. unlink or new file */
 	else
 		return 0;
 
-- 
2.43.0



