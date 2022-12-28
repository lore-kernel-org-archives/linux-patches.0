Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99AF1C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:31:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A503C433EF;
	Wed, 28 Dec 2022 16:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245069;
	bh=PlHBVn08YpjN7k+XsOfJZRjQJPmkDDTrkLM3CKK5tBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pCt1wcqzoVC58JJu+YQ+jWAQuwhzi/GyxLjfrf61bLNUuOlYPmNfl83ZQ8xNoDQPo
	 iQvMK+KvDpKpCYRvn2zjef46Q83HeZtiZd/UajzfcYkpBt3HVz2fCF2LDkELOF+gXs
	 LcswhCgh26rzGLACWkKLn094G4pHwpPivFqo/sMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0791/1146] fs/ntfs3: Harden against integer overflows
Date: Wed, 28 Dec 2022 15:38:50 +0100
Message-Id: <20221228144351.633958159@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit e001e60869390686809663c02bceb1d3922548fb ]

Smatch complains that the "add_bytes" is not to be trusted.  Use
size_add() to prevent an integer overflow.

Fixes: be71b5cba2e6 ("fs/ntfs3: Add attrib operations")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/xattr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/xattr.c b/fs/ntfs3/xattr.c
index 7de8718c68a9..ea582b4fe1d9 100644
--- a/fs/ntfs3/xattr.c
+++ b/fs/ntfs3/xattr.c
@@ -107,7 +107,7 @@ static int ntfs_read_ea(struct ntfs_inode *ni, struct EA_FULL **ea,
 		return -EFBIG;
 
 	/* Allocate memory for packed Ea. */
-	ea_p = kmalloc(size + add_bytes, GFP_NOFS);
+	ea_p = kmalloc(size_add(size, add_bytes), GFP_NOFS);
 	if (!ea_p)
 		return -ENOMEM;
 
-- 
2.35.1



