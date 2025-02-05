Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644DE1632C8;
	Wed,  5 Feb 2025 14:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766323; cv=none; b=OVO127V5yLGibD435RIZSSun6eRHk7yhDT0oP5/sKJsOeh4l083cI3XptMIMqTUX//r0WjmB7zyCpXOselXhAgL7EKOBBRCMpZv2XDo+P+ev38LH5yFjn6aO7MXgQoJfcMnEN+Q/xfrKSqxCYXrwIbxPmspZv+P0RyW6lbVALz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766323; c=relaxed/simple;
	bh=pNNzTnHvwL7m4TvQeQzmRCmby/bGgatwk8V2m5KJR9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CQCYuiWJoa2L2qpBpfk6ZbS86TS2+TxQf3x157PjNOQqweJEZLbSt+90RBphuT6r3GdSUrepHnUX9g3pXFEhXUpeDX9BhPz+A4iiwNZ0A8bLMJ5Vf20gAPmmHDwuvltHfR9T+pOjdpynu8SvGrd7ZKWsdbzHPi5cvDJkCzmUHpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rTLEoU2T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rTLEoU2T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6BEBC4CED1;
	Wed,  5 Feb 2025 14:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766323;
	bh=pNNzTnHvwL7m4TvQeQzmRCmby/bGgatwk8V2m5KJR9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rTLEoU2TM+ddZMh5k08qxGV0RmB7Yy1dAa/N3piDM0/8/Je68+gdNuRZScoBBqjYZ
	 xaKB3xW/idb5WdcGGPGxuAAzi53MvTrhb/g5IvM7mVvEBJKTARMBnlXGNLBQyGP82D
	 ztV2auTHSpd2L/C0iznLpGDauwDv8kqrqTr6lpcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Richard Weinberger <richard@nod.at>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.6 352/393] hostfs: Add const qualifier to host_root in hostfs_fill_super()
Date: Wed,  5 Feb 2025 14:44:31 +0100
Message-ID: <20250205134433.773810540@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Nathan Chancellor <nathan@kernel.org>

commit 104eef133fd9c17e4dc28bf43f592a86f26d8a59 upstream.

After the recent conversion to the new mount API, there is a warning
when building hostfs (which may be upgraded to an error via
CONFIG_WERROR=y):

  fs/hostfs/hostfs_kern.c: In function 'hostfs_fill_super':
  fs/hostfs/hostfs_kern.c:942:27: warning: initialization discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
    942 |         char *host_root = fc->source;
        |                           ^~

Add the 'const' qualifier, as host_root will not be modified after its
assignment. Move the assignment to keep the existing reverse Christmas
tree order intact.

Fixes: cd140ce9f611 ("hostfs: convert hostfs to use the new mount API")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20240611-hostfs-fix-mount-api-conversion-v1-1-ef75bbc77f44@kernel.org
Acked-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/hostfs/hostfs_kern.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -925,8 +925,8 @@ static const struct inode_operations hos
 static int hostfs_fill_super(struct super_block *sb, struct fs_context *fc)
 {
 	struct hostfs_fs_info *fsi = sb->s_fs_info;
+	const char *host_root = fc->source;
 	struct inode *root_inode;
-	char *host_root = fc->source;
 	int err;
 
 	sb->s_blocksize = 1024;


