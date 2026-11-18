Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050317;
	b=v3prw7nQLTxBQc/eKRGc4z7SEYo9PyziKOPYstg0pvX9ukIFZtH+BXZMuCz+jkYo/tNJ
	 WhENaG/lrYl9reja/t7DV+Yk9f9JJAK/BSiE1sv9X8eNQJTGqsTzIlt7zPJruvYxq2iJT
	 mYiygoAI29GaFLzxGd6uTxSHv6Omdcsk5I3Tl7ptDtuXMDlul4lLIwJkCTFSiWz6iO41K
	 oRlXaxx2zsFkNLcK8te6TvmPlr8YiiFI+a5p4XuNPl8VSg2a557erZ7sQETSJyG/FDb2q
	 8+5pMEKj/Jm6FjYerwVNhuojXOVi/QGCMIHulU/45pKLiAzy8WZqo5gSK4Ciu0u3YgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050317;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nWA+TWr0OkiOHBsnesYcDQwxCmgJw/SLFNkm3WoP30g=;
	b=wiCCUBINTQyCNrvjTgo9Nu48l0YlcZj4CtQepIhVSDNrVbLDfF3jEyz6sg24UA23AGSR
	 hyQ2ZJJpZheI6un1Pa/L1kk956DJ7FsLO1HOB0fVQlV1D7X2rrA0nd2RLo1m3YwjMh4o3
	 gk2r6pMrtEiFQedDRB0oh3VhktgYhIc98z7oK1WteDVVw34bG6gUQrnXwZ05nBVVcllOx
	 uE4aXIfltxjUnHnYh+HFfvqQQpecDbRmTGKP0Vt1A5FptVRCd4Iuk42Kaapq/pOgI1tfl
	 FkiKauTR0P3gSQh1X35aVtXHV6eUU0p5PSAJi47VImGCH2jdp8HEd+21eSNAfUH8FsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I8LL7imH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48784606A330;
	Thu, 19 Nov 2026 01:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I8LL7imH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E1E1F000C4;
	Thu, 19 Nov 2026 01:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050317;
	bh=nWA+TWr0OkiOHBsnesYcDQwxCmgJw/SLFNkm3WoP30g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I8LL7imHbzjFLzAMA62Y7xzjg/OuQ5wew+vvq03dfJ1TcMO5rvtOmmJOhRIPbkhcr
	 N+HkJRe3435sR7DURLUELyx4rD1BXBO7+6zzwW6uRzRPGCp3kZOc9qvqmpTwDv53K9
	 4iV9b7TSuWjwbYjge6THlfcREkjM9x4JZRVSRj6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2663/2857] smb/server: fix trailing period in generated short names
Date: Wed, 18 Nov 2026 16:01:37 +0100
Message-ID: <20261118150337.462434304@linuxfoundation.org>
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
index 87e95f34ee0d3..85e29f63813e2 100644
--- a/fs/smb/server/smb_common.c
+++ b/fs/smb/server/smb_common.c
@@ -491,8 +491,6 @@ int ksmbd_populate_dot_dotdot_entries(struct ksmbd_work *work, int info_level,
  * @shortname:	destination short filename
  *
  * Return:	shortname length or 0 when source long name is '.' or '..'
- * TODO: Though this function conforms the restriction of 8.3 Filename spec,
- * but the result is different with Windows 7's one. need to check.
  */
 int ksmbd_extract_shortname(struct ksmbd_conn *conn, const char *longname,
 			    char *shortname)
@@ -556,7 +554,7 @@ int ksmbd_extract_shortname(struct ksmbd_conn *conn, const char *longname,
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



