Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016219;
	b=S5oY8vFBm40dHaVAYvAHRwFb2pqh7pqnVShiTT7a+zgMePD/uXJN9ARPk9zJ15KyMJdP
	 zJimGK57O+JV/Q7cgdewDjFJne/CiJnYprhB7xpRywwz+kpoYtFL4ar44L+YCLGrojlMO
	 3I/uZMqRtpyOVZf9aLQotOzDkINn3Zr/lGijOGG/K2R68C2pJbP2E8dTaCmfcgiVJ5sOJ
	 Wwd7b1B9b0tooTUtF7Hd0TRJYVxj3XZLOTlEAYKYiHg76uDwQyiYbHQLWY16Ofzmy2Dk6
	 YeGVBmRZBhisJ19lNNHWRt46+s6D2AKTZdzVLtnFsl7c6311F6vB8ahvOkZCWhmaGyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016219;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TknLLh0dDuoJAgBiwFiyCpF/kmVSfTHPdyi1GnXXSsY=;
	b=sI8yCEXNkAt0UnnhdvJ/D8PxN1685I2bG1McrIWCHQtrMpQVs9jQ5X8xRfR1t9aJvy8I
	 LOgUjV9Buo1luX0i4i6ooEar8EQ40GL/b+cl4q2p/To3tExJoHOnTJGyw2aNDhmjYOGrR
	 9tN9WoHVz4Aj8bgxztStA0xLBHqSnMIyKzsQRzQS7f2Btv+z908fh0v3HQIFBu/itFJT/
	 joOkIIsB7VJuVHLNik1WWWISmAJdGo8pXjO73m5S8Nw/JDzhxF7ti3Vy9fJ/qxHdsT8er
	 k5Hkd1T4I4o2VkJGhayQdFWaTCpogO+nuM7X2QTXXDnhsbqE34fZaTYtyTU+P6Cnx3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c5m+85W3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B454F606A31C;
	Wed, 18 Nov 2026 15:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c5m+85W3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09BE61F000C5;
	Wed, 18 Nov 2026 15:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016219;
	bh=TknLLh0dDuoJAgBiwFiyCpF/kmVSfTHPdyi1GnXXSsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c5m+85W3E+LnAsE8+Tafg8mo0eicrjaexKqhsFaruKnrYPNQEXuAjcYTAUmgIE5H7
	 1bVVHDFrKuBeZ7vYsGPYcvJcAfrtnk9QFTbiN9cDpd/fGTfSXbzsqpX+GXOrG8hgA0
	 xbClnJrlS4CFFOIO9CujGKpC/jXQ4x+twGz88Lrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Liu <liubaolin@kylinos.cn>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0451/2651] fs/ntfs3: update ctime only on successful setxattr
Date: Wed, 18 Nov 2026 15:28:11 +0100
Message-ID: <20261118150304.050391423@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baolin Liu <liubaolin@kylinos.cn>

[ Upstream commit bfa6296bb6a0e2333796a9507beb4605b92a9fdf ]

ntfs_setxattr() updates ctime and marks the inode dirty even when the
xattr operation fails.

Do that only on success.

Fixes: 2d44667c306e ("fs/ntfs3: Update i_ctime when xattr is added")
Signed-off-by: Baolin Liu <liubaolin@kylinos.cn>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/xattr.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs3/xattr.c b/fs/ntfs3/xattr.c
index fb7276d4a4285..3a43a431f3bf4 100644
--- a/fs/ntfs3/xattr.c
+++ b/fs/ntfs3/xattr.c
@@ -979,8 +979,10 @@ static noinline int ntfs_setxattr(const struct xattr_handler *handler,
 			  NULL);
 
 out:
-	inode_set_ctime_current(inode);
-	mark_inode_dirty(inode);
+	if (!err) {
+		inode_set_ctime_current(inode);
+		mark_inode_dirty(inode);
+	}
 
 	return err;
 }
-- 
2.53.0



