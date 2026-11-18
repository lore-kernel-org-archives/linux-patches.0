Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021383;
	b=nebwpKwfM63L7pausule9WGDo5v/6z+5dMBCjAQ6olOChqYnBq/Yw04LNC0M/34XWG45
	 4pksA6RpBlvBY0FycQQuSr9Adz7/cszs1DfUmQltdPzcFwRJRlC3hiLj84kIkQlL76m4W
	 88LDuQz3iukSE/d/ABc54uv4dIg4vIY+VfGzEhhQqwu5OaYIJZTo7T4ZjqXfF2TxS9Qph
	 QNk9dcoI/Y0zIvVgb4XTftFl6yBXyVevBS936Px7+92vAx0bUXjmdLydiM9iu+sI6f4ys
	 j03RspAKG+ZmSiX0ODLi92w2XMzyeF984/s3mdY3R4XsGcdvS/lfL7+emRzsRi+VFlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021383;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FkCwQrAreL6CW3D6YV0VxR+bE0biTHtwTvomU0glMEE=;
	b=HLP2/bFqqN6JhZqFERduWv49kG2jRsyLL471U/AKlywtL6bTwPADdtzbgWuQ9LgRP/Ck
	 x/KAjZqSVGt69SYrYr0pgiba8B6VA6ulGmFXlKLLNdoOvzra/581rkEOK70KdtMnXB8p0
	 kJqityrWuJMJOCd6xWCGGGOHjvsIEG/zaVi+zZhq3LMm9B3bU+UuDLwAeB3/vsIPNRtUC
	 7UEvzi9/IzhsInNaTQz2nSAlDncU43Ze7CX623ZYf2sk764vUoL7Qp9ggIRQ79gB1IxxV
	 uZAMVP+QTzxn+LHu13fbKznGw0ZkCxX9u/iiPkhR7iD8/5Y/pozTUQcQlV5NsgtqoKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w9S9wLx7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF52A606A33B;
	Wed, 18 Nov 2026 17:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w9S9wLx7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42E6D1F000C5;
	Wed, 18 Nov 2026 17:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021383;
	bh=FkCwQrAreL6CW3D6YV0VxR+bE0biTHtwTvomU0glMEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w9S9wLx71JamNC1S6RSeaP9Xlnjc5n4cFvztUiFkvpyc/+mrfiv5JqRuc4T4DLavR
	 hTCIXpxx/2ip+nPpCgyZ0wBWFgIoPY24FoIMC7WpOjRHGkV2RyJGlgHYS/e7LoBq8v
	 eJiIKu5N2eDeMYw36NV0tnbQIPZ/pyrn8YDSs+0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2289/2651] smb/server: fix trailing period in generated short names
Date: Wed, 18 Nov 2026 15:58:49 +0100
Message-ID: <20261118150407.684661794@linuxfoundation.org>
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
index 21ba0ce5abbf4..5ddefb5a7078c 100644
--- a/fs/smb/server/smb_common.c
+++ b/fs/smb/server/smb_common.c
@@ -525,8 +525,6 @@ int ksmbd_populate_dot_dotdot_entries(struct ksmbd_work *work, int info_level,
  * @shortname:	destination short filename
  *
  * Return:	shortname length or 0 when source long name is '.' or '..'
- * TODO: Though this function conforms the restriction of 8.3 Filename spec,
- * but the result is different with Windows 7's one. need to check.
  */
 int ksmbd_extract_shortname(struct ksmbd_conn *conn, const char *longname,
 			    char *shortname)
@@ -590,7 +588,7 @@ int ksmbd_extract_shortname(struct ksmbd_conn *conn, const char *longname,
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



