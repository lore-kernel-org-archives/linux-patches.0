Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051294;
	b=YgsAs+mIAaUjocHPL7GT9sgcUznjpmnXGm1QCDl23I0ws4EBIP8Hl+0hw6mDOR8tYY2H
	 yNtalJZ7vmDDdijboE09xgTTV2lfBh91Ruw9E2MTzeP1DA9kjxV7jHBCsAfeEErclsNoe
	 r1Wi2Yy+7w1EtU1+5g9+n1GBFdzch2z7oGgkIK1ECotuzz2NV4dqEe0Eg5+Btc67rXmB+
	 mnOTT8syWAu4vevUZOo057c1ZwqJFmq+DzhHm3azvwxgRfRJ3Sewu8vGlBMS4DexIKD79
	 pCHJFArP5gG28dkKLDbF3/7cN+QPc7u+B97MHPIQijLGz1BBPiMTZfgA1YlHEn/Z99w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051294;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=X7Xu/iqFh5kIbEGmFCfDL4pGHs2x2wM/BQGVJZub9YQ=;
	b=RL1h59OZtrT/6n8iwjHbfbiMjmhnyoyvG4PTIa/uZVTD7vSN3Znw3vIMr6CtBUtqaVUk
	 0hw26UxujBbNSiL25iZ2XSKQYWIAQdO4j9i4920GmlnRvscVJCrRYdOXepxMcnMH44TH5
	 ztDphJjMFndYc3JxY57HzQPXcg1NXxUntU3bdv0CtfgMmaVv8sAELAKIADPHHeux7ELPT
	 QBKQwopuXK+DEms3bmYWvJobjHcUMAvXePU937RWMmVB1MPUXhAKTbeUjrwmg4M17n2ma
	 tuyLZOQGYSO+CUPnaU0mQYJDNdy2HFQH02js7RUt1amaW9PbR1hqAX3pretGheGeUsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="luz6vZ/O";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65097606A31C;
	Thu, 19 Nov 2026 01:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=luz6vZ/O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF6D1F000C4;
	Thu, 19 Nov 2026 01:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051294;
	bh=X7Xu/iqFh5kIbEGmFCfDL4pGHs2x2wM/BQGVJZub9YQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=luz6vZ/OmXrQpMgp48i+++mefjeHz7HAHHJD6Juxy7X0/sgb7fhN0LjP+ZPtGYWYa
	 ayNJcnke4jMifbBELv/061DA48zuInTs8Dwa88pOkDeIYj3YP3AoMU1+5LbZ8/SNv6
	 EEFtZxejLevKtvSdrl2GbUimAQ/VtdXK5ZK55umk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=EC=9D=B4=EC=83=81=ED=98=B8?= <kudo3228@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0156/2214] romfs: detect hard link cycles
Date: Wed, 18 Nov 2026 15:30:32 +0100
Message-ID: <20261118150016.381474678@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6f31e720c9561..61b9882a3aa4c 100644
--- a/fs/romfs/super.c
+++ b/fs/romfs/super.c
@@ -249,6 +249,8 @@ static struct dentry *romfs_lookup(struct inode *dir, struct dentry *dentry,
 			if ((be32_to_cpu(ri.next) & ROMFH_TYPE) == ROMFH_HRD)
 				offset = be32_to_cpu(ri.spec) & ROMFH_MASK;
 			inode = romfs_iget(dir->i_sb, offset);
+			if (IS_ERR(inode))
+				return ERR_CAST(inode);
 			break;
 		}
 
@@ -271,6 +273,8 @@ static const struct inode_operations romfs_dir_inode_operations = {
 	.lookup		= romfs_lookup,
 };
 
+#define ROMFS_MAX_HARDLINK_DEPTH 64
+
 /*
  * get a romfs inode based on its position in the image (which doubles as the
  * inode number)
@@ -282,6 +286,7 @@ static struct inode *romfs_iget(struct super_block *sb, unsigned long pos)
 	struct inode *i;
 	unsigned long nlen;
 	unsigned nextfh;
+	unsigned int depth = 0;
 	int ret;
 	umode_t mode;
 
@@ -298,6 +303,9 @@ static struct inode *romfs_iget(struct super_block *sb, unsigned long pos)
 		if ((nextfh & ROMFH_TYPE) != ROMFH_HRD)
 			break;
 
+		if (++depth > ROMFS_MAX_HARDLINK_DEPTH)
+			return ERR_PTR(-ELOOP);
+
 		pos = be32_to_cpu(ri.spec) & ROMFH_MASK;
 	}
 
-- 
2.53.0



