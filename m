Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042246;
	b=Lq4cSo3rrJJ67IBfCOCPSh+rFx7ILei40ckNTOVR4OKuteQgOLAypGRGw/2uGM/y6eG5
	 273P8R7BaZ/AiSl3/KrPG8OCkBA0VX2/enAjKyZZZIJ2HS1ANvajbX8u6LsyCca02ND+p
	 lYpF23NxKA6zjEU4w7+IaGuIYz6c3L6p405MqstMiM2SURThdKROjsZPwcR+/z/pjIaYV
	 NTOp0ZP7MPnvMZbKIRBoShT5yibCu6/ebAqYCq9xnUryInO9LTyp13EQfAiiw218gVFi6
	 T24sXf1bxUCUTAEhYRi9tWjC6M/bO6uhEEhZKmrD+5MAP3pnCGM5ru1LJPpc/fD3T+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042246;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=77KRuuSe6Zt/3DcJf0QPNqUzWM4U8qsfbPHaKTtB0lo=;
	b=ciyTezUbyuK9TD8oYj+fbrrOyrzbHoOg5Wtqf5CIJit2gOcwkQqH9WFW1pghHzIGGykS
	 0Jq0wW+zXF5U9osku/aUPmO4H3oQtQ1NjW9elXYYUg6IwL/y1NUXlBKLZSWTxQ2J2Bprk
	 +ZnIRfZZE0j7ZIyH2XG9cDlBpFtjp7AQ8oz8K6xPrgWgsfG53yuG3ysdz/q/kqbOv2xDa
	 wJEdXQtAllTNNG7TRHmeXJlwQcK7l69O0KytLK7UlGW1a2C19pGFAQigu8OMVXNnl8iE2
	 r6ffce0orUBEQt6pCcbXQkIQD9PACVhUAEl280hMAku6K1aSHtMtLjEU45hL/nzNjOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aMLyXeKs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC575606A31C;
	Wed, 18 Nov 2026 22:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aMLyXeKs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 401A11F000C4;
	Wed, 18 Nov 2026 22:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042246;
	bh=77KRuuSe6Zt/3DcJf0QPNqUzWM4U8qsfbPHaKTtB0lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aMLyXeKsfv2qkZ4xufmM/YaqzsYZZ3Y7pm8NLT0mFgm6W6yi4MyaxLQ15pDERbkzO
	 td+epoGzccHGhS7fTaxK0LVXfPVPS5yixyMygNxTMoqr448aqqSAD/OLvXnqm+MnJE
	 T1Da06Ll64qPjIRebwpo0MeOTVUvRYyEHOqKcVag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michail Andreas Michalopoulos <mike.michalo@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3101/3318] ksmbd: reject FILE_ATTRIBUTE_TEMPORARY on directories
Date: Wed, 18 Nov 2026 16:02:03 +0100
Message-ID: <20261118150453.035331184@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1c96df8000123..7794a35ba3552 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6422,6 +6422,11 @@ static int set_file_basic_info(struct ksmbd_file *fp,
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



