Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B97364BA;
	Fri, 24 Nov 2023 18:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jvSTPBYa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 902A3C433C7;
	Fri, 24 Nov 2023 18:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852307;
	bh=/s+I07zDty6/zSIfuGg2F4KpWSxECUVxeumLW51LO4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jvSTPBYasT1Neq/X6PjzqBE0lkCOLBIjD7KxdyW9XmD0mnSCB/zC47J396dNtZleQ
	 YWcwru6VUESr0oERsnopr68MIAf7wqpQ+OtEaiygjDLmGqPX4xk2OcdsolZfbnWuE3
	 HtrY5CDZw3k20NR7anfb/YOSghgWDxG1Ti7Vg3VA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Micah Veilleux <micah.veilleux@iba-group.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 269/372] smb3: fix touch -h of symlink
Date: Fri, 24 Nov 2023 17:50:56 +0000
Message-ID: <20231124172019.438320262@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <stfrench@microsoft.com>

commit 475efd9808a3094944a56240b2711349e433fb66 upstream.

For example:
      touch -h -t 02011200 testfile
where testfile is a symlink would not change the timestamp, but
      touch -t 02011200 testfile
does work to change the timestamp of the target

Suggested-by: David Howells <dhowells@redhat.com>
Reported-by: Micah Veilleux <micah.veilleux@iba-group.com>
Closes: https://bugzilla.samba.org/show_bug.cgi?id=14476
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsfs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -1186,6 +1186,7 @@ const char *cifs_get_link(struct dentry
 
 const struct inode_operations cifs_symlink_inode_ops = {
 	.get_link = cifs_get_link,
+	.setattr = cifs_setattr,
 	.permission = cifs_permission,
 	.listxattr = cifs_listxattr,
 };


