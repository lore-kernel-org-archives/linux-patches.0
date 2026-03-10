Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A5C389E1D;
	Tue, 10 Mar 2026 11:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142178; cv=none; b=R2XCEyOvCAbfSKLrBml8xwxyxsy5QbbZxz03srZJwYULfRaNps1NsGWVBjBK49Yf40/jggWbAAyvnzxdEVz2zQAPQWxgTjxcW077tbvig4RtO7UIOQ2cmyfH1IC/n04UmWQ7OLAF/KM4nz8KW40jkSIUoA66kMbAxEmPczoxQlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142178; c=relaxed/simple;
	bh=WWd5tGYvYbEzsfIutDg1J8sEQmxr4WR4epsyN200upc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cg5OXHDMFHJvM4NMxHcUHv2H4U1C4O4x2RO2j7emApDEqykK51kDDCW9P6j8CpbEfxcl2sx5WW7A/+QGO7spp3ks9MyqHtHElTJPphVTB0tQUyF2N6qZaGFpqd6ezVEyJ9JHQ3kb1ehiVi+B2HISYivOAXdIiz3p0WcPF0zoTFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XG1e+b1W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XG1e+b1W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49229C2BC86;
	Tue, 10 Mar 2026 11:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142178;
	bh=WWd5tGYvYbEzsfIutDg1J8sEQmxr4WR4epsyN200upc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XG1e+b1WkUp4kg+7HvcvbWHRnvY4B2q/qyuiApglpLrq8pq4KKhxR9Du7lNP2vzYM
	 pXFPlQMjVznnzbFMcZrFYLqCFkd69rRHgpjCADBin9bv56wbO/MK/YcCsV41FcYQS1
	 X8yLeKPRYPhSrhRusvYaGk0QM3+bU/ib+JgjVYPKcbOEXp3e96UMF5YMWCfS+JEHty
	 2byUHeRkVVlD46VKnw4nloPpAk9m/es0MF1aC36iiweyFvfSVEHYaTYha1lBosrI0s
	 E2UnxWX9G1SrmQQVLSJSBCT2EMZpGgZEQu8xtCcb/p+jHp/QxQ4BY3lcocr1DxgSNb
	 JLitT+8btZyQQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 266/314] smb/client: fix buffer size for smb311_posix_qinfo in smb2_compound_op()
Date: Tue, 10 Mar 2026 07:18:45 -0400
Message-ID: <08640a940462cc4df143e1b85a2bb3cd632df346.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: ZhangGuoDong <zhangguodong@kylinos.cn>

[ Upstream commit 12c43a062acb0ac137fc2a4a106d4d084b8c5416 ]

Use `sizeof(struct smb311_posix_qinfo)` instead of sizeof its pointer,
so the allocated buffer matches the actual struct size.

Fixes: 6a5f6592a0b6 ("SMB311: Add support for query info using posix extensions (level 100)")
Reported-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 5c25f25aa2efb..a5f9f73ac91b9 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -322,7 +322,7 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 							  cfile->fid.volatile_fid,
 							  SMB_FIND_FILE_POSIX_INFO,
 							  SMB2_O_INFO_FILE, 0,
-							  sizeof(struct smb311_posix_qinfo *) +
+							  sizeof(struct smb311_posix_qinfo) +
 							  (PATH_MAX * 2) +
 							  (sizeof(struct smb_sid) * 2), 0, NULL);
 			} else {
@@ -332,7 +332,7 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 							  COMPOUND_FID,
 							  SMB_FIND_FILE_POSIX_INFO,
 							  SMB2_O_INFO_FILE, 0,
-							  sizeof(struct smb311_posix_qinfo *) +
+							  sizeof(struct smb311_posix_qinfo) +
 							  (PATH_MAX * 2) +
 							  (sizeof(struct smb_sid) * 2), 0, NULL);
 			}
-- 
2.51.0

