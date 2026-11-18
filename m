Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021417;
	b=MEprXRDHJmYiukRE32Cbd/nsBR6CBvJ2UcJ2TaD6rj6l7Sp/BzlXSgnIjq5PLBKKAIaO
	 Ua0RLuRVdbRDkDfHKJG9eHRgCFQQYCjkdI4+RLphxB8ThddWmu6VUvvphvnD3WlZM5sXo
	 qQp71SyvyXU4B0BErmmJa4lre0nr9xZ4ZoAY/wUkaQ07J0n2FN5C4lSW200nqz3/ikWct
	 7mXsZh75NnU2WVxhVO+MpVV9yaF6SsVh528ucHQT4TH0k4WZfj01fuhlG87YAvw23e66K
	 4FpBjJk1UtUcOhwFqT7dLa5oBdlwGCa38w8gG+1w0btCn6gdUP9Q7e3BXx9KJd0Q7pQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021417;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/pzGjPTURJEZOHNk4ZOX7lFGb7DkjSiB11yd1mYplFs=;
	b=GKPGJm5JyS/e+urXUXrZ7bP0XXIFETu1c4WSxbeSYqGaMCYbc1Tp/yvX2Pol54r6r1JI
	 HtgJboFtibtXY9EZKov7Svgvvt6vwDIkDUofj4IPPfFmnwaGXale0UpYSnBs0iTdhw7gw
	 /5CLhf/Own8GlN3Cv4wZAWu5XYbCOXuM8iqH75sdvbA67A3L1SClD+/O7qeRNuaXKaI3F
	 84riJ2RMeB4RO9uzepyVl8jHNPOQLQvhwJAMb6Gk9pec8EQA5T2PbGiDqdnUfWDY9kI6c
	 4owpJe4dnn2Z9360yGKM6ymO8W69s5jXoefkqht3cCCvkAMH/7LsmzKguDiCa4WhafQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="o/n7YLbf";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF747606A32F;
	Wed, 18 Nov 2026 17:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o/n7YLbf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09F851F000C4;
	Wed, 18 Nov 2026 17:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021416;
	bh=/pzGjPTURJEZOHNk4ZOX7lFGb7DkjSiB11yd1mYplFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o/n7YLbfXRtkyt+n0s0/WePAfbIGaFqhPSmWLYt2P9OdYpQNFmpuISU4pLdkKFLyx
	 JS8IfiWqpYEP0283XCTUgOwJ9NBXdc+L+8CPcoI/9f/XYuFcuC7k9rp/Moc7eU+ZDd
	 i5upWnNtBxzkEZoGfe5oh5ftMqBeythgsAN6yAzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michail Andreas Michalopoulos <mike.michalo@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2299/2651] ksmbd: reject FILE_ATTRIBUTE_TEMPORARY on directories
Date: Wed, 18 Nov 2026 15:58:59 +0100
Message-ID: <20261118150407.989965759@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 8bd0800a48f7e..55aa09a07aed4 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8408,6 +8408,11 @@ static int set_file_basic_info(struct ksmbd_file *fp,
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



