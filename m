Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032643;
	b=TIZvQoLb99B7lRuK0SvTpFpu7jAbeT3I3G1iNHeQcmWqgq8oDD/K9MdhL8UWsmFW4ssd
	 1seuaZ9yW0bjLpJ8qQGwVs/WzN3cWxC4TpYLjn2xKMf+8U76UnbT+PzMxFCM6Uvwq/t9S
	 bgxLFqXpKdynyRN2J9hQAPrbGnBJ44CT6CA8ODLz8TYcw4hLX13Xh0Lmh0HdThpzeyCAs
	 t6BVoSUjezgrMRqK8ZHpV7590HHgWVCFKGsNZzs0MkzVK4GhX7mdnkXmVCK5g/667fUGf
	 H3FX9gzxE0bNLfEEoj6KuWipI2/plJh6iw7pTori2RcPepMHr8cGJzz+nq81IyLhCjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032643;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TGTt9KRDiZkl9Cyy7to/uJaYEEODp7kAK2c2S9elgJ4=;
	b=Y0xqN5seQBbzZY0oGyb+QPZaLFUpLoNU8KAl2LZXzM18nRM5xl8UGvfjf3YwbbtJUJ+f
	 Kw65uTtolqyKS+9oK5g4LIiZA+hT/anwnPCXkYlRSqOtFXTPBfgRCdiOlKgQqCect66zS
	 lStGrNOJXhVh3A1s8ywSsadgIRAzK6Vv7HI7HBcPU4V3TKGOZIo1scuPZwRfH3LAlBffe
	 +2dggUjIqwoU5rbdHD+cyklFqE1YC1IAPOMrsd1W1IQIBkZXE0Vl5UWKKSLpuse2Kt2Td
	 I/psUm7gvMISJsrfT8E+a4K/9O+S8UlPGczK4dXOPwtwu/D8YmrLGoJQNDnVCJCLoMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jKclsbwe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20071606A325;
	Wed, 18 Nov 2026 20:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jKclsbwe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58CB51F000C4;
	Wed, 18 Nov 2026 20:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032643;
	bh=TGTt9KRDiZkl9Cyy7to/uJaYEEODp7kAK2c2S9elgJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jKclsbweXm8DXMIQFTuD3/UMMua4Kcg1lTCRbOhNVktGtWEhgkgDiz/AoTujYnW26
	 DqBY0Z9VufUrk9aCcVetxqHK4gEabJspCGfgcC+QfiwKgtIIyVRMEVaRW4Po5XS+Py
	 C698VKJGq1xbwVqPt8Jwauik/j53hNFHrFFRiQds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michail Andreas Michalopoulos <mike.michalo@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1484/1756] ksmbd: reject FILE_ATTRIBUTE_TEMPORARY on directories
Date: Wed, 18 Nov 2026 16:00:11 +0100
Message-ID: <20261118150108.046939170@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michail Andreas Michalopoulos <mike.michalo@gmail.com>

[ Upstream commit 8323aab48525b83f750e712f66e6e9387b550cf4 ]

Setting FILE_ATTRIBUTE_TEMPORARY on a directory with SMB2 SET_INFO
(FileBasicInformation) succeeds: ksmbd keeps the attribute and, with
"store dos attributes" enabled, also writes it to the DOS attribute
xattr.

MS-FSA (FileBasicInformation) says the request must fail with
STATUS_INVALID_PARAMETER when FILE_ATTRIBUTE_TEMPORARY is set on a
directory, and Samba rejects it too. smbtorture's
smb2.create.dosattr_tmp_dir checks this and fails against ksmbd.

Return -EINVAL, which is sent as STATUS_INVALID_PARAMETER, when a
directory is asked to become TEMPORARY. Do the check before any
timestamp is changed, so a rejected request leaves the open file and
the inode unchanged.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Assisted-by: LLM
Signed-off-by: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index c33d2de8c8cd4..f5587687dd6a4 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6450,6 +6450,11 @@ static int set_file_basic_info(struct ksmbd_file *fp,
 	inode = file_inode(filp);
 	idmap = file_mnt_idmap(filp);
 
+	/* MS-FSA FileBasicInformation: a directory can't be marked TEMPORARY */
+	if (S_ISDIR(inode->i_mode) &&
+	    (file_info->Attributes & FILE_ATTRIBUTE_TEMPORARY_LE))
+		return -EINVAL;
+
 	if (file_info->CreationTime)
 		fp->create_time = le64_to_cpu(file_info->CreationTime);
 
-- 
2.53.0



