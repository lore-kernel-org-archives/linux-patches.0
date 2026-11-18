Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050323;
	b=Z4Ka4KumKsV02m55sgJlzhmkLtA3C0tuHVtblAakkXiKp5tCmh/1oR0drcO4EQyx/KP9
	 3HXR5cK7lxpQfBCBtrXoJELyh4PB+vdDNehhXR8WYJqO1BIZUdWG4XD1PL6BrOmCJ3EFK
	 6Nsf84lOkwIHmGEmG3cNUOVExHFSxBBd01PjuL0z6E+1oPatDrBb1NjF3B67ZlTSxKZGs
	 /MRYpAr8V5XKL/TmGmzD8XeqnsMW3e9ye1+vYdeJZLzAI7bffmRYK0AlB4NrqHvoDAflH
	 kafDo/6jPBdklzUeDlHo5QdN1f7TbIGFfE084aPgoEM7lydXCDqmXVosYJWzjm1rIGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050323;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xJH/bXMnAvWR0SKtvZo5YdLnZQoDA6+jdtPaauNmdh0=;
	b=mJv6dr2aR7HPhCHkItOcEF7a8dp9FSbIylf7i12McDUseYTPrkUzrU8/xm4nw8eun1mf
	 C+KE2iyMUV62mS47P4eGb+rgUm6pP5EQdbMh3tzrFymQfGK90BkFd2RS+JzUDJafg5fod
	 0PYd1Cf/Z7QrKcEdteJ363APRh9LP1cQfeKkvgXuPPm+LQ9Ch+HTHDJOVzwrr17vAtpU/
	 dgXj6mS8Cn1aZ1OIRpBJa56njFwFnWn2GoYwcn8MUndh6d0dEAsb7EYSkJhMPJpwUCR5Z
	 nRo8Mk7TRraO9N58OM+FG+Isn/T6P4Ro6KkkatQEboBXhfuNfjU9U5sNfOZLzOyb4Sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ofbP3pjO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CAE1606A33A;
	Thu, 19 Nov 2026 01:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ofbP3pjO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F1D21F000C4;
	Thu, 19 Nov 2026 01:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050322;
	bh=xJH/bXMnAvWR0SKtvZo5YdLnZQoDA6+jdtPaauNmdh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ofbP3pjORav6kmowYtpzE6zUQ07AjziDoMv0fnR0hoWDPH5qHBwJD2/0lamCog/7W
	 3jlhmehYG3PHUgzlv2tcab7cj6OphC4BE3J3dnn//Kd1K6tMLLsQQPs5ppBoSyN3hM
	 BG5bJPdnskAxlpPEleC1lpFunXElyA9M3PXHbtOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michail Andreas Michalopoulos <mike.michalo@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2665/2857] ksmbd: reject FILE_ATTRIBUTE_TEMPORARY on directories
Date: Wed, 18 Nov 2026 16:01:39 +0100
Message-ID: <20261118150337.535727149@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8956e548b7f70..5f86f9d81f1e3 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5967,6 +5967,11 @@ static int set_file_basic_info(struct ksmbd_file *fp,
 	inode = file_inode(filp);
 	user_ns = file_mnt_user_ns(filp);
 
+	/* MS-FSA FileBasicInformation: a directory can't be marked TEMPORARY */
+	if (S_ISDIR(inode->i_mode) &&
+	    (file_info->Attributes & FILE_ATTRIBUTE_TEMPORARY_LE))
+		return -EINVAL;
+
 	if (file_info->CreationTime)
 		fp->create_time = le64_to_cpu(file_info->CreationTime);
 
-- 
2.53.0



