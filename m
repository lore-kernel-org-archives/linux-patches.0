Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212365;
	b=rcDsGN4P00Hhksf7hD8pUKVbR7NAcEvO7VNKv9QDrO+zuKbp2M5kPYSV20Q+cwd1apF1
	 KNZARGlEYq7/dFMgYEnoaMVsHFgDrEEgEUJy7AQaPnL1Fqe6x3fn30HCyBK7A2DtqW+6V
	 LKnl9FXY+QkwKmos6QwDmwEx49aXLjqIkl0JkmspRAD7D21EdVbmNq+P+oB6ToyqeQLxy
	 NsxvCFPGC3A5IF8hjQUFhKE/aksFCFBuJovH7wYa8jifVVjbzT4XAbLtF/h7KOG4yrShq
	 Cr646seEv884R4dSS1a0cXduxDxRB1gpab49AoptzhmKVWfIR5krVuYCg0grjlIwddg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212365;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zuyqDdWQ1E1Mn3NFkO+qzuriNqUJjfcb8WzlQdZbvl8=;
	b=e2q/8l7lsP/8EVPEf587MZrg+gzdWsW2hOCt8cepG1+v56sZeUE9q+xAgrD/cF82Acak
	 hee/Bg/9Hz+Ikf4Y+3MOL1fR6qIhZyCfBUXNPUrp04Waxi2c1f8fDjUw0NQO0vwiKMVVF
	 PIc95pjoc4eyaBiDpo2oSMR9RO+Ep3QWPkxEf49hp+wrAll0hQFQhAIo4Pk476hUXAh5X
	 tWATLoJrePOyIUYIODfEz0yVM4RBcnZNtTlOivdxg4mrTDCgcSWrwmFUMcQEFx0NJgjTX
	 ksGi2VLutW8tQ0XpWGMKk02Z4vQ1f6aFLPLHwJ6HwRkvFDzqsPiQra+NED+fQsCbtew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KxxMbyO2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2113A606A31A;
	Wed, 28 Oct 2026 18:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KxxMbyO2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C2C1F01825;
	Wed, 28 Oct 2026 18:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212365;
	bh=zuyqDdWQ1E1Mn3NFkO+qzuriNqUJjfcb8WzlQdZbvl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KxxMbyO2FbMW0Oay4iteu1reJCXme1RQw+5wIef6jW1j+1IiUlmixnDP4SvJCNwCp
	 BOXPp6CGEO3UKbknQoiu1xZ03utTHYJaaRF4JWJ3aycbjRzAlCwB59GxGIVaJ6fQ0X
	 cn53Q2YmtXWec97KjpX/67owk52haZIyW9CfBCmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0128/1887] smb: client: fix file type corruption in cifs_reparse_point_to_fattr()
Date: Wed, 28 Oct 2026 17:37:04 +0100
Message-ID: <20261028170502.150448814@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit 6bd360447941357e959414a525aa62576a448116 ]

Setting the file type in cf_mode without clearing the existing S_IFMT
bits first is wrong as it corrupts the file type when cf_mode already
has type bits set (e.g. S_IFREG | S_IFLNK == S_IFDIR | S_IFREG).

Clear S_IFMT before setting S_IFLNK for native and SMB1 symlinks.

Closes: https://sashiko.dev/#/patchset/20260906181540.647469-1-pc%40manguebit.org
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
[ Moved the fix from missing reparse.c to smb311_posix_info_to_fattr() in inode.c. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 51d38449ca855..5d21cb051a602 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -672,6 +672,7 @@ static void smb311_posix_info_to_fattr(struct cifs_fattr *fattr, struct cifs_ope
 	/* fattr->cf_rdev = le32_to_cpu(info->DeviceId); */
 
 	if (symlink) {
+		fattr->cf_mode &= ~S_IFMT;
 		fattr->cf_mode |= S_IFLNK;
 		fattr->cf_dtype = DT_LNK;
 		fattr->cf_symlink_target = data->symlink_target;
-- 
2.53.0



