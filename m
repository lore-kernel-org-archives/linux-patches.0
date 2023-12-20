Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92BC4A9B2;
	Wed, 20 Dec 2023 16:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ITc3C796"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FFA6C433C8;
	Wed, 20 Dec 2023 16:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703089061;
	bh=a/u9opOPD8NeEgm8jDdQqxZ93dUFB6+wbdjv902FDCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ITc3C796Bho9kiZDoEVyub2S7kwHi2qBAs5aKegwPKZPhv7S8iL7NTDctnrE9CloV
	 V5rkqMPJ6dJxFtVEI/WrLMaDgyiZ6RjlqXmYYukvw+1SXg3nGSdbuMC6h0S/uloJPE
	 kiHyfZzE15opDjxI7gooK5WSuExuk50+1x2evV28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 127/159] ksmbd: remove unneeded mark_inode_dirty in set_info_sec()
Date: Wed, 20 Dec 2023 17:09:52 +0100
Message-ID: <20231220160937.248747739@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160931.251686445@linuxfoundation.org>
References: <20231220160931.251686445@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit e4e14095cc68a2efefba6f77d95efe1137e751d4 ]

mark_inode_dirty will be called in notify_change().
This patch remove unneeded mark_inode_dirty in set_info_sec().

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smbacl.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/ksmbd/smbacl.c
+++ b/fs/ksmbd/smbacl.c
@@ -1441,7 +1441,6 @@ int set_info_sec(struct ksmbd_conn *conn
 out:
 	posix_acl_release(fattr.cf_acls);
 	posix_acl_release(fattr.cf_dacls);
-	mark_inode_dirty(inode);
 	return rc;
 }
 


