Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622059;
	b=IvU/k1BcOH6tRVP7mOrKljLTZDZ/bamjPRFcyq36nlPb6Aol+QGzF0eqTFe/wRmzWEo1
	 agRcNJqsczdjy5itFWYFxyW3e3pLkSujKdTHuPNXxQsByQnxUNZ8+otvw/GCcaBA5oEPK
	 bQEbH1sJTdOPvjGSghZn7KDkfBm29yZRGsMz5kYE66Zi116oufU5OhsRlntDcBEif+Sdl
	 os5RY7vN4F9ep8pbmI3nQ++rMcjh4aPgspoZ3z680VT8c6u8hy8ZbEALVfL70SBeVYl33
	 gsrS2JN1TUasT16L1iWORiKnL48f0IliZtfsEnD1Xbj8a0aJz7Mu/mB2lZ6cp9+1F6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622059;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fn6BbnpKC1gz/wq+d32O0bSDuDS+XZ7InDAiROYjMIs=;
	b=OzxXREfDIhNE2B36q/RtE1uLghejlbpLOvYX0F8VzWzgObAA/sAaWioKbc99b9puT5Wi
	 thKQdXC+UcPQ2toZjckFe6IyRR7Nu2Oe4DSXnYzpouLfMoh4Q/VkZBVjvF1vsBqn9n9m1
	 sXv9n7TSx4eDN34yaQsTj1a71Ix+74bXOxAOTzHs7SDHcrC5BeJiT2uluwX7w9lBK7rLP
	 ZksZ8qc9/I3/NE5Nyp54cWHPY4ElgCumVSASbiR7qiq+484I9Au3GasQGZEYhoCQeBLj7
	 PIx7/8oA7LSTHxMaMRSqKbCmsd0cn+KbduCjl4IAjapGRHKPdCynnDWD8LF1jcsSi4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yihVgE51;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B32606A337;
	Wed, 25 Nov 2026 15:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yihVgE51
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 354F71F000C4;
	Wed, 25 Nov 2026 15:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622058;
	bh=fn6BbnpKC1gz/wq+d32O0bSDuDS+XZ7InDAiROYjMIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yihVgE51EjAusi8Sjw6K6JZUeDg3S4mgRIAIq/PjFbT1iXraunejY1VU8+aGAhS/K
	 3rUyEEkjWllixt2dm4kASxzw9zKlZAH5OG83z5oAjbpqAltsIFfRDNuCsci/KEkGDH
	 r+9B06SerR9IX7djEtBIzSHb1/3vRFDzoDa76OaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 418/990] ovl: allow idmapping overlay mounts
Date: Wed, 25 Nov 2026 15:29:45 +0100
Message-ID: <20261125143831.890380138@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit adedb6a00a1e4c77b1de9ea1f63b5008ad0c21f5 ]

Now that every overlay inode operation honors the overlay mount idmap,
allow the merged overlay mount itself to be idmapped by setting
FS_ALLOW_IDMAP on ovl_fs_type.  mount_setattr(MOUNT_ATTR_IDMAP) can
then apply an idmapping to an overlay mount, exposing the merged tree
under a different ownership view.

The composition is clean because overlayfs already normalizes every
underlying id through the relevant layer idmap when it copies
attributes into the overlay inode (ovl_copyattr()); the overlay inode's
i_{u,g}id are thus "overlay-final" ids.  The overlay mount idmap
composes on top of that pivot: it is applied to (getattr) and removed
from (setattr, create) those ids at the overlay-inode boundary -
permission, getattr, setattr, ACL owner checks and inode_init_owner() -
while the underlying layers keep being accessed with the mounter's
credentials through their own, possibly idmapped, mounts.  The mount
idmap therefore only changes how the caller sees the overlay inode and
never widens the mounter's access to the layers.

This is deliberately the final code patch of the series: only once
every operation honors the mount idmap is it safe to make overlay
mounts idmappable.

Link: https://patch.msgid.link/20260615-work-idmapped-overlayfs-v1-6-7381632aa402@kernel.org
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Stable-dep-of: cb6c084182d4 ("ovl: release the upperdir/workdir in-use locks before the umount sync")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 52d6f32a5a7c3..71ce12e203ea0 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1611,7 +1611,7 @@ struct file_system_type ovl_fs_type = {
 	.name			= "overlay",
 	.init_fs_context	= ovl_init_fs_context,
 	.parameters		= ovl_parameter_spec,
-	.fs_flags		= FS_USERNS_MOUNT,
+	.fs_flags		= FS_USERNS_MOUNT | FS_ALLOW_IDMAP,
 	.kill_sb		= kill_anon_super,
 };
 MODULE_ALIAS_FS("overlay");
-- 
2.53.0



