Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032632;
	b=nxFADfPl8CoRg2JGSixgx3bIBkKZb5kbnoQm8A35bS9n32kWWEuXE0Zd0UnZiPUONNak
	 GzJEq/9pqcJGg0jDNzq5F561mAGGs3dUuYsWtkqhfFYioSvtBjm0Kjzz4i5Wzj8ugrLbW
	 p1Sy36vBhAOjTHTzJC8URPCfhOuVYPEhsXHTOFzbi5kHIrDf4TiVovUhfSZQZXmmnAn+n
	 Dcb5+aaEWptgfWueHn8VM3zQE7GRdRWkvXJg3A6HdJuxNIxCOot5C+8SfLS1m+0f77Yhj
	 MuhbGOPDBVzrzll3v0ic3yMVCWjfY5YwEWoU8WlKdScAxAThal3Q2GVUrAed8Xy6q0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032632;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Owp0ScqhAy/VOml4Xe9SeZHYu7EHpdt4nO/xnQM4q8I=;
	b=PRypKlXeSuI3qTkMvLDzQ1YiGtMu6WQuXWRopadIZYPg6Dka9NoQNBkLLw13S+Glaq0E
	 6uWuRSs+ykoIp3TL1rkm+IorUa1E2fNX59cqoSZjt9bHkLsvuFNQ4THwBQ3UH68sIuZJa
	 jztpQ2WxcJJhlwO7JsmDo4xpylf0HOTvPZBX3gt718hrSgrrBhaQgStt3/gQsIZNQ50Cl
	 Bc7rv65F5CMpVga28Sdh9d5b/WebBzoOh45NNIkEsAOlIFNO1EIWML+NQj/cweeOFpgJc
	 ntGmkS7Sw51XFMEDlyIIyTW28ouVMGzr3hn70VYrbnAfT3qlpuKrvRl1erWRMh7eVdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RR7IyxLi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF264606A332;
	Wed, 18 Nov 2026 20:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RR7IyxLi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CE231F000C4;
	Wed, 18 Nov 2026 20:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032631;
	bh=Owp0ScqhAy/VOml4Xe9SeZHYu7EHpdt4nO/xnQM4q8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RR7IyxLipM/vWg9FmVYfXLrQQ+lI5PgxC5Qj7BufxnMBIli2YyFJgtncpquztiSFz
	 fNFC3J55P6XnYXhUtJWzEKQLAKhxqPfv4vqAHqMiKKknxz2uImg9BESJfyLABg4KG4
	 afTD+m8mE7g2LU+uCFX/kUQFPMtDc2dgHrdzkpSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1481/1756] smb/server: fix trailing period in generated short names
Date: Wed, 18 Nov 2026 16:00:08 +0100
Message-ID: <20261118150107.938695021@linuxfoundation.org>
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

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

[ Upstream commit e8486c5cfbdd07811afa4196060bafbf78ccdae2 ]

Reproducer:

  1. touch /mnt/file
  2. smbinfo filealternatenameinfo /mnt/file
     Alternate Name: FILE~9!.

See MS-FSCC 2.1.5.2.1. The base filename MUST be 1-8 characters in length
and MUST NOT contain a "." period character.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb_common.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/smb/server/smb_common.c b/fs/smb/server/smb_common.c
index 9f183a6d85d6d..a836b117f756f 100644
--- a/fs/smb/server/smb_common.c
+++ b/fs/smb/server/smb_common.c
@@ -494,8 +494,6 @@ int ksmbd_populate_dot_dotdot_entries(struct ksmbd_work *work, int info_level,
  * @shortname:	destination short filename
  *
  * Return:	shortname length or 0 when source long name is '.' or '..'
- * TODO: Though this function conforms the restriction of 8.3 Filename spec,
- * but the result is different with Windows 7's one. need to check.
  */
 int ksmbd_extract_shortname(struct ksmbd_conn *conn, const char *longname,
 			    char *shortname)
@@ -559,7 +557,7 @@ int ksmbd_extract_shortname(struct ksmbd_conn *conn, const char *longname,
 	if (dot_present)
 		memcpy(out + baselen + 4, extension, 4);
 	else
-		out[baselen + 4] = '\0';
+		out[baselen + 3] = '\0';
 	smbConvertToUTF16((__le16 *)shortname, out, PATH_MAX,
 			  conn->local_nls, 0);
 	len = strlen(out) * 2;
-- 
2.53.0



