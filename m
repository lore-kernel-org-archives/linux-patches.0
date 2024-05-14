Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6027C3B79C;
	Tue, 14 May 2024 11:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685263; cv=none; b=hXSIPlEw1TrrvCjklr/fHw798omj194KRmybp93uiYh+iZ8m4Iex3eHHqiSqdcMNA1QQijSBkzV9fzHSOUBde7xO15pmSP5+hSn7P4rlqoreQqE45Fb4gtsySV9tOWSgM94/UUUboYOHL0iKuAC605BmKKKI1PXcc2CvuLyoVAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685263; c=relaxed/simple;
	bh=iKjY4nEtgCpAdkRMkXptKCr9ernj/2Fc8mhhj0wbI/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C/ltIFd2Fq3f4Vd48hlWf31s9vLiopnDhr/skHyZs9lVNL3iwekvgSYKdrStMFU2KZSD9dh9ff9a0yVU02Vkl21uUL9YYRhsrDsYY7ZKbTYHFt0VObZrb4hSE7Efkp/QwN3BSTTdgwUxqTendN8vmlJ8htiWyiw8yo93u8SLWTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fWWbqeWl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fWWbqeWl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1704C2BD10;
	Tue, 14 May 2024 11:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685263;
	bh=iKjY4nEtgCpAdkRMkXptKCr9ernj/2Fc8mhhj0wbI/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fWWbqeWll+mNAmkiEh+cv/YDrpCJe2s56atA+nhdpOCAXjoaWsy4isHR/NngO2AIU
	 9AyUC/NPN8ILYcrdVzqqSdJr+K+Y2fpY0NkHF04zyRkXi0qqk/tW1ZGhc89Jog8DlH
	 qSud2c7gC42rv82iQ+Fwilgtu7McjxZGuQnwy+0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joakim Sindholt <opensource@zhasha.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 159/301] fs/9p: translate O_TRUNC into OTRUNC
Date: Tue, 14 May 2024 12:17:10 +0200
Message-ID: <20240514101038.261709657@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

From: Joakim Sindholt <opensource@zhasha.com>

[ Upstream commit 87de39e70503e04ddb58965520b15eb9efa7eef3 ]

This one hits both 9P2000 and .u as it appears v9fs has never translated
the O_TRUNC flag.

Signed-off-by: Joakim Sindholt <opensource@zhasha.com>
Signed-off-by: Eric Van Hensbergen <ericvh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/9p/vfs_inode.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 3bdf6df4b553e..853c63b836815 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -178,6 +178,9 @@ int v9fs_uflags2omode(int uflags, int extended)
 		break;
 	}
 
+	if (uflags & O_TRUNC)
+		ret |= P9_OTRUNC;
+
 	if (extended) {
 		if (uflags & O_EXCL)
 			ret |= P9_OEXCL;
-- 
2.43.0



