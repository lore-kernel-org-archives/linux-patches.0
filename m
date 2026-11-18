Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027623;
	b=0aAh8TJ83I7/VyfXoUols+RzBlIMK6tJ0LGoA32ZMZOVUtPZ1tRqxR2K9+gBTiLicXES
	 qc6xmuf3U/WaYAsT7hQhfp2lKHRVq1IPox9gPagjD3NtOxuTpx/poVoBHUNCZGMTektwI
	 WAE+K85/wPyoMwJtDZl4GjXaj3wFWjmg8hDZv0WPKdI3sk8EFemhxzAt4WRXcU7TMf0Er
	 UAcuSFgSZL+21PsgPyOozVLybkVKxfcd7of34qlXPTy/iUcCOpzD5l2PBgktb3E0PxhcR
	 Vp/NcVgmu7/ivcT5sRxhKRwfQygxb29WHu6yuTVAJS+MjW22BRKBAX1nYEsBbauztng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027623;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g3F+47X/suPayVcOhHoDceZeU5i/SS6TAiRzQCIFYQM=;
	b=sUAJtNfQp195K8LyobwpAUYeZhkRS9eBT0tEKZktSX4bmd0tPpA41YW5lt6sHUPXNBSS
	 BPurDdAbUB+SR8o+uH0Ir98bz3ROCFl+Axpyb9twZTee+BAUIXC+X/zURIz8hCXRacAsO
	 I+c0qx7rbMDNXu/5AV52oMVwxCKgLWCFt4KOBe9+QPqqS8oGr/5PYETugYRZW6RCeg0jL
	 Ko5D7v/AUQjCMKJyolZh6qhF75N8YJUdrbd4ExMQn79fby4bNF7AArjDaTJ0oUINWn3+d
	 SUzkS0Zpzil7FEyw96FXZAsLHLzxuXkLBoIabKAZ0H7riWsl8KWjBqJJY361RcWNxCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nvL1WsEF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BECC860A2602;
	Wed, 18 Nov 2026 18:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nvL1WsEF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CE5E1F000C4;
	Wed, 18 Nov 2026 18:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027623;
	bh=g3F+47X/suPayVcOhHoDceZeU5i/SS6TAiRzQCIFYQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nvL1WsEFYvmApdqqih0awtqg3IRVDWfohbYbW5IU1D8KqrcyXDJMx4qMLkq8fttEo
	 C6xrDuQTHp+pfKsP18LTasyLeSm46f3AQKTQziNjLQhI/nYk1YaO5QVx4wnTbCw/g6
	 koxMjSZ6tb90Rpa3JKvbpz4mHv+PRrZN8rm8hz/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michail Andreas Michalopoulos <mike.michalo@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1854/2151] ksmbd: reject FILE_ATTRIBUTE_TEMPORARY on directories
Date: Wed, 18 Nov 2026 15:59:49 +0100
Message-ID: <20261118150229.332761699@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index ea04cb2662246..94a18e0ee9c20 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6486,6 +6486,11 @@ static int set_file_basic_info(struct ksmbd_file *fp,
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



