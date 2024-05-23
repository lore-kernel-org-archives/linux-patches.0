Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D593513BAE2;
	Thu, 23 May 2024 13:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470587; cv=none; b=eSOT8go+IqWhFXtbKpD+g3VSMBN9QK3fIcoAY9Kt9NptAIlQYPVOu2QMHTJ7dVoKFCTOTrO6pI8aGrlHhVpuuJ/fNqJJ3FodkS3cgCx14VlGEZC7WtzaabFZ5Ujj2pSt7R1uIGaDjHtEFBX6QrpMXEX8Dzrn4THrgm9Qvu4nSEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470587; c=relaxed/simple;
	bh=+Tz9Sd1B+RN/1INhTj+KZVFtZvyqt+mDwbu/vtC0FEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rDP6DduzPBJnugaasBee0kK79L2w6nkyuc0WGb0Ifh/ori9Zmowr4rpHoegQpME7Fwjr5inzxszFJdHBfXXf45YEXrJr1Sd/L18cCLSdNgJquYzcfjtVIpmVa1IGJha3JwYd55Gh6061X9WUY4TshOtZ6SZKcZ5YepfTjDven04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kd2k/DD4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kd2k/DD4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A450C3277B;
	Thu, 23 May 2024 13:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470587;
	bh=+Tz9Sd1B+RN/1INhTj+KZVFtZvyqt+mDwbu/vtC0FEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kd2k/DD4BY+TbltE7EtbMwM6reSAjWjQKmPByRC9V0awjoBEQW/720k7UgLAAUDJQ
	 kWIZKkQwOnWJj0fwys0RYaG6pCUlZNBPC8a5smBDIRbtHTB03yPvYRtDF27ZcRGC5v
	 oG7019H3IH6/DdId4IqWzXyEfQRxR/r2PBZnRs0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <longli@microsoft.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 006/102] smb3: minor RDMA cleanup
Date: Thu, 23 May 2024 15:12:31 +0200
Message-ID: <20240523130342.704380878@linuxfoundation.org>
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

[ Upstream commit 43960dc2328e554c4c61b22c47e77e8b1c48d854 ]

Some minor smbdirect debug cleanup spotted by checkpatch

Cc: Long Li <longli@microsoft.com>
Reviewed-by: Bharath SM <bharathsm@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifs_debug.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index 058e703107fc7..aa95fa95ca112 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -779,14 +779,14 @@ static ssize_t name##_write(struct file *file, const char __user *buffer, \
 	size_t count, loff_t *ppos) \
 { \
 	int rc; \
-	rc = kstrtoint_from_user(buffer, count, 10, & name); \
+	rc = kstrtoint_from_user(buffer, count, 10, &name); \
 	if (rc) \
 		return rc; \
 	return count; \
 } \
 static int name##_proc_show(struct seq_file *m, void *v) \
 { \
-	seq_printf(m, "%d\n", name ); \
+	seq_printf(m, "%d\n", name); \
 	return 0; \
 } \
 static int name##_open(struct inode *inode, struct file *file) \
-- 
2.43.0



