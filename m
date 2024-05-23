Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2E113BAE2;
	Thu, 23 May 2024 13:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470591; cv=none; b=S00yLp8nMLPNOXIibBCShEB8SoaKd2eCPzGFSUO4rDkclInBoGLq0waoEDD2C+Mxm+7w8Ta7o9QPsWzAKl3NWZ0EQGyEAiknSq6hheSDsTuGdrUCvsF/2HYTQOgSWmXLbWOqgK87l0mhJHpgVm2mNhaat9q4cybVDxGfvsxSfr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470591; c=relaxed/simple;
	bh=48CMA7ej+5xCb5+RqxJWPodp6uB/6oqlR9Aj+DuMV0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZevBfPOEbmJG1xL7Xs1p73dmroRVjI5P0BvjQbjXONb6N/2RjxHrPeySBNbg26/UGUl4Duq0Yn8O8qxt7C/Hu4HFpwgXgZy1QD9XD4tXftef5kc7e+xJPNQcESo8eXXcfUHrnYyBt/t/o0/FltmecYYEGgAlrAOzqliyalm8lUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aSuWa+zs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aSuWa+zs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E0EAC2BD10;
	Thu, 23 May 2024 13:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470590;
	bh=48CMA7ej+5xCb5+RqxJWPodp6uB/6oqlR9Aj+DuMV0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aSuWa+zs80OESiivi+j2a/3FGBACpBKArPPr1ztNPZXKNu+F93Zzh5jXop7h1erxx
	 QhgxBmc3a1thuT3al3UEHxV5kNSo/Ooq4rDUGKuLECnzPyvRyYjUwDvIqsZa/M/YbM
	 F3uBRFQqlQGSuwvdQ6Vn8mNp70NFmMY/LvsAJlII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bharath SM <bharathsm@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 007/102] smb3: more minor cleanups for session handling routines
Date: Thu, 23 May 2024 15:12:32 +0200
Message-ID: <20240523130342.743341536@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <stfrench@microsoft.com>

[ Upstream commit 1bc081b67a79b6e75fae686e98048cea1038ae31 ]

Some trivial cleanup pointed out by checkpatch

Reviewed-by: Bharath SM <bharathsm@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/sess.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index bd4dcd1a9af83..70a53dde83eec 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -801,8 +801,7 @@ static void ascii_ssetup_strings(char **pbcc_area, struct cifs_ses *ses,
 		if (WARN_ON_ONCE(len < 0))
 			len = CIFS_MAX_DOMAINNAME_LEN - 1;
 		bcc_ptr += len;
-	} /* else we will send a null domain name
-	     so the server will default to its own domain */
+	} /* else we send a null domain name so server will default to its own domain */
 	*bcc_ptr = 0;
 	bcc_ptr++;
 
@@ -898,11 +897,14 @@ static void decode_ascii_ssetup(char **pbcc_area, __u16 bleft,
 	if (len > bleft)
 		return;
 
-	/* No domain field in LANMAN case. Domain is
-	   returned by old servers in the SMB negprot response */
-	/* BB For newer servers which do not support Unicode,
-	   but thus do return domain here we could add parsing
-	   for it later, but it is not very important */
+	/*
+	 * No domain field in LANMAN case. Domain is
+	 * returned by old servers in the SMB negprot response
+	 *
+	 * BB For newer servers which do not support Unicode,
+	 * but thus do return domain here, we could add parsing
+	 * for it later, but it is not very important
+	 */
 	cifs_dbg(FYI, "ascii: bytes left %d\n", bleft);
 }
 #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
@@ -958,9 +960,12 @@ int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
 	ses->ntlmssp->server_flags = server_flags;
 
 	memcpy(ses->ntlmssp->cryptkey, pblob->Challenge, CIFS_CRYPTO_KEY_SIZE);
-	/* In particular we can examine sign flags */
-	/* BB spec says that if AvId field of MsvAvTimestamp is populated then
-		we must set the MIC field of the AUTHENTICATE_MESSAGE */
+	/*
+	 * In particular we can examine sign flags
+	 *
+	 * BB spec says that if AvId field of MsvAvTimestamp is populated then
+	 * we must set the MIC field of the AUTHENTICATE_MESSAGE
+	 */
 
 	tioffset = le32_to_cpu(pblob->TargetInfoArray.BufferOffset);
 	tilen = le16_to_cpu(pblob->TargetInfoArray.Length);
-- 
2.43.0



