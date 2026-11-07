Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060853;
	b=j7yKEZNw99WRrGjfNrtMgpFrNb3NpNst2w86yMfMuIj5yFC+hOY6MnHel9wTMdETrrYl
	 x915a7S5mMyh7TMCSs0wrPzucVx8U/l/3fUVt13PqYiKl2FYjLhxRU/IAYuAuj85s0izP
	 KmQXkgoKqIRAx+aKJlcIu9V2Gn1v3iyDVhCmyjjTGPHG7H4x0A2yTnFPeQPwoGx1as7Av
	 XWuNV+dKg25iprtxyloNiy+lWPg+J2niMFlPywJ73qRkZPRVKfMVZ1uEPlVY2bib3BHUo
	 9+3Zxhu12V302SW+dRFzcIdKi7P9PxyjP/uU5ccNLpJT8yLNnjAcYtjb1/rsRAaW8IQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060853;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=YBK8xRJXUAXofHkXb+BkObHYqrbfo5yOngwJILfWKFI=;
	b=YT8C93qpEkS4QYrDETMITV4l4uHlIdszn3rvTq7FM/noIFXJx8U79H739xGLJRcbPUFJ
	 couSN5xFtc0ld5LWeLaLmME+aPZb0UqSiIaWV/rSYBEP4eRVs15kAlifhgp1xzzHn4IKS
	 0phzLo9pxfi/kfIqc71FZeEDkoQiPfQ5wjH/hLcZA47bQqaYOj/MbcXa/i+Jr3BQs8uCJ
	 7lFHfUO2bbLJy8CF5yHXJrQkwPXOe3BI+U87J/2qzbh+hspHFKGkJuNN1f21SXYf/SnBH
	 4vCo4hS4KX+6eW2/B6WZNEOVcHlByxiZS1w9dTdZCgvI04arBkLfOWe8VBcTaaNlyKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d30Gg6Kg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF50606D824;
	Sat,  7 Nov 2026 14:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d30Gg6Kg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 460C51F008A3;
	Sat,  7 Nov 2026 14:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060852;
	bh=YBK8xRJXUAXofHkXb+BkObHYqrbfo5yOngwJILfWKFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d30Gg6Kg6gentegn7RizPpzOCzP1JL/39nIU0zg6dy3FysWydZlqiPsyN9ynUVDYs
	 coMeZuEMmghM68hJZxGYGkvo3e1jYBqZsEc5rDBAY47VK3lU1UFFKzb+/FulZuwVrO
	 QcCKmgPCcy7o+j7pN3ow8zFL/a4khjkJv0jGgrXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=EC=9D=B4=EC=83=81=ED=98=B8?= <kudo3228@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0238/1536] romfs: detect hard link cycles
Date: Sat,  7 Nov 2026 08:37:34 -0500
Message-ID: <20261107135004.359417228@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: 이상호 <kudo3228@gmail.com>

[ Upstream commit d30b5a954e0a4dcc16bba9c310c13709a6169a52 ]

romfs_iget() follows on-disk hard link entries until it reaches a non-hard
link inode:

	pos = be32_to_cpu(ri.spec) & ROMFH_MASK;

The target position is image-controlled, and the loop does not detect
cycles. A crafted romfs image can make the root inode a hard link. The hard
link can point back to itself and leave mount(2) spinning in the kernel.

Reject excessive hard link indirection with -ELOOP. Normal romfs images do
not need long hard link chains. This bounds corrupted-image traversal.
Propagate romfs_iget() errors from lookup because hard link traversal can
now fail with -ELOOP.

Signed-off-by: 이상호 <kudo3228@gmail.com>
Link: https://patch.msgid.link/20260701220729.822112-1-kudo3228@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/romfs/super.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/romfs/super.c b/fs/romfs/super.c
index e83f9b78d7a16..9b997831a46bc 100644
--- a/fs/romfs/super.c
+++ b/fs/romfs/super.c
@@ -240,6 +240,8 @@ static struct dentry *romfs_lookup(struct inode *dir, struct dentry *dentry,
 			if ((be32_to_cpu(ri.next) & ROMFH_TYPE) == ROMFH_HRD)
 				offset = be32_to_cpu(ri.spec) & ROMFH_MASK;
 			inode = romfs_iget(dir->i_sb, offset);
+			if (IS_ERR(inode))
+				return ERR_CAST(inode);
 			break;
 		}
 
@@ -262,6 +264,8 @@ static const struct inode_operations romfs_dir_inode_operations = {
 	.lookup		= romfs_lookup,
 };
 
+#define ROMFS_MAX_HARDLINK_DEPTH 64
+
 /*
  * get a romfs inode based on its position in the image (which doubles as the
  * inode number)
@@ -273,6 +277,7 @@ static struct inode *romfs_iget(struct super_block *sb, unsigned long pos)
 	struct inode *i;
 	unsigned long nlen;
 	unsigned nextfh;
+	unsigned int depth = 0;
 	int ret;
 	umode_t mode;
 
@@ -289,6 +294,9 @@ static struct inode *romfs_iget(struct super_block *sb, unsigned long pos)
 		if ((nextfh & ROMFH_TYPE) != ROMFH_HRD)
 			break;
 
+		if (++depth > ROMFS_MAX_HARDLINK_DEPTH)
+			return ERR_PTR(-ELOOP);
+
 		pos = be32_to_cpu(ri.spec) & ROMFH_MASK;
 	}
 
-- 
2.53.0



