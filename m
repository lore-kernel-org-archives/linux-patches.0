Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051977;
	b=Rk7sfB0IMcGxKrAUH0u6+HW2Ryl2bg8q0Eo26/X/Qs0DZC3JuhLnBR6zuSdJRdlE03T8
	 auWrcE73Gry6rG3Ix/I57B8kNa0BAvoaKO56BzKuBwGIGz7WOcYmz3LKaSL/bnGS+OTXz
	 grMGY8GgVFrcFv5hRt9qKnMXK2AVJO1a07g0oRATqAXCxkdRLXqKm+fxEKqlugL2hwgst
	 3Ck32G7QSTEMux69T3THOReotcIjA/nfIqoJ7IkPkJoYRfEMFp+nF//APFkzAWIy/j13k
	 ZslzVdeXEbxG2z2Uj85yTbAsBE3k1K2waqkpL0hbIyMjMSSXKex1bblZY5Z8Vbfq19Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051977;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W6JZEXXre9TCYrPOGCKyVt+FKTc08TMXB+Ks9I3GmR8=;
	b=T9BS2p1hiw1L3NXNRrl6g+B5VR975DAIuN5KRh9LA0QMG6IdibEulDEJ9nGsLD/3Du9i
	 yjCKzCjWheu/BOmMjWq3MdF5owVhLc2JCQtdkiw7rp9keILCha0aFKHeIpatVtXYJdO8T
	 klgKqXz+yBm4DBTOT2s6vFB6AAKfF6WMz1P/jpmeQjbvF32kMYjuBh3Yrbp3DTTqdq7Kq
	 JniaPY82R/ogw7p3/a/g7CNK3t6UVB/QESya0FwQngCw3hcMk0xj30W1qNOdhSKNOpam7
	 v8SYIcDEir/zVX1yKLxvbAvlKiIWdl4/vyByKNqGMGtmJO0KYjjiQj6NKmk6pNxFnZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="EPKg/C9c";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC9B606A325;
	Thu, 19 Nov 2026 01:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EPKg/C9c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD41F1F000C4;
	Thu, 19 Nov 2026 01:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051977;
	bh=W6JZEXXre9TCYrPOGCKyVt+FKTc08TMXB+Ks9I3GmR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EPKg/C9cBcO2s1D4KQQHHKLRiU/RKk1BLZMPVN9//Zz41//5UKfjDmrzaFMx7JsIH
	 bpUyJFKWjZuKnR9P8ToZF5yy5vD/TmbSqzebfYMn7Di4lpN6t6m9smUqsVwNBkv/eW
	 pvAdgjreGkMXVSN+sPvD/EYckzvlPX+4rTG4Bgt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Zachariah Mithani (AploSec)" <zachariah@aplosai.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0399/2214] ksmbd: prevent share root removal through empty paths
Date: Wed, 18 Nov 2026 15:34:35 +0100
Message-ID: <20261118150026.722536290@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 9fd1fcbbf84986a7bcf601a2b90540899069d263 ]

A FileLinkInformation request can supply "/" as the new link name.
smb2_get_name() strips the trailing slash and passes an empty string to
ksmbd_vfs_kern_path_start_removing().

ksmbd_vfs_path_lookup() resolves an empty pathname as the configured share
path, without LOOKUP_BENEATH. With ReplaceIfExists set, smb2_create_link()
can therefore remove the share root from its parent before link creation
fails. An authenticated client with a writable share and DELETE access to
a file can trigger this if the share root is empty and the mapped user
has write and search permission on its parent directory.

Return -EINVAL for empty pathnames when for_remove is set, before
resolving the share path or acquiring removal resources. Ordinary lookups
continue to accept empty pathnames for opening the share root.

Fixes: 74d7970febf7 ("ksmbd: fix racy issue from using ->d_parent and ->d_name")
Cc: stable@vger.kernel.org
Reported-by: Zachariah Mithani (AploSec) <zachariah@aplosai.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
[ sashal: Moved the empty-name check from the shared lookup helper to smb2_create_link() because the helper lacks a for_remove parameter. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index a74605abee913..c2162321bd722 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -5712,7 +5712,8 @@ static int smb2_create_link(struct ksmbd_work *work,
 	link_name = smb2_get_name(file_info->FileName,
 				  le32_to_cpu(file_info->FileNameLength),
 				  local_nls);
-	if (IS_ERR(link_name) || S_ISDIR(file_inode(filp)->i_mode)) {
+	if (IS_ERR(link_name) || link_name[0] == '\0' ||
+	    S_ISDIR(file_inode(filp)->i_mode)) {
 		rc = -EINVAL;
 		goto out;
 	}
-- 
2.53.0



