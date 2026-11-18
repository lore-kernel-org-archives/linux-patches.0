Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027601;
	b=FOiMCyRHzc1rkhYd1N5tSMZzty/idWOQgy8klDAgZTVuA7RCPiauAlIsEp9O/kVLMA3J
	 1+Ku7pVRN3FN7297ReKL76owQ61XoHEVzL5COfSo+AvQ6vkUK0DFD+dS2tz8UWF6MpwGs
	 xO2z6SG8GxVIUu+JOb5rqLkwqd7BUsQ/QYDQ55lE7RcQwbD/ErSK77HbvOdmc4aVTR5RG
	 ke9xRzW/kOsJIgUp2vtpYrs55CitIyxK9lxuDbHghEW7Dr+jo+M6Q17KONFImCwSrrm+L
	 q5i84cBlxCA0vdfBKs6QGMOxGdvUo02mnw3+aTXlwk43chiTvKMyRDh+4fgRMCrtvDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027601;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4E8l74bzAMuL2mC8gVLd8JB+XxmR5ate9TTIYFO8HJs=;
	b=LDzby3ccHdj5Or2Tkgzn3MpEi3bHccEIz1Ug4wQjCmrfeMdvLY8+q5QXKA5TLtiK25Jf
	 +LkOMg33KJ1bPMfAQENZ9mgHuTkX040TSjFZ+Btfblo3Ed6FCh0WNXSeqiFxoQ/Ey5c8N
	 7m2lhW+MDG0IgJOm6t3wMDVhJEq7bf1QpjBcVjLy1fL87iBwphPJiGv6lBBAjNBKzQm9K
	 1pQQk87ZK9n7QUkODr1HXMi1tffCTlP4BbhuvJ1TuAe0+fOTWuFbcWzVT3tYL0uX9pAUP
	 r6EGPmqBL0Hx7eu9x6tv48svkj6aS5nD0v6C3FWhs4Rwxsgx/fwXmEXrQyx2ZGLfWzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qd1vXXCH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC2A60A2609;
	Wed, 18 Nov 2026 18:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qd1vXXCH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFE291F000C4;
	Wed, 18 Nov 2026 18:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027601;
	bh=4E8l74bzAMuL2mC8gVLd8JB+XxmR5ate9TTIYFO8HJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qd1vXXCHyQMy9Rq4QIprwJft+KbJT3WNVsGv/Kcs3ABKJaxDlP+7pzFj9U2joGZZv
	 l6ySrjAY4zJVJzAItnqN+j6kIvORhcri6nlf8bmWMvzMsemr6o3kD/rUKtRk6SFTyj
	 vMI0OUOgPERGCQLyGGe5EUOarooIheZL5Ef8DbsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1847/2151] smb/server: fix trailing period in generated short names
Date: Wed, 18 Nov 2026 15:59:42 +0100
Message-ID: <20261118150229.083365939@linuxfoundation.org>
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
index b8ddc5d2249aa..3a4b7b380a6bc 100644
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



