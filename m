Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4CF413B2BA;
	Tue, 27 Feb 2024 13:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041931; cv=none; b=oKMZX0sGXl9IvDAFoLysByjX9wWDmn7DAI/7jWFsJCbrSwLXkYeJPAsfVBi70zdfv5bQH7hHrzq7AQpOj0Y7S7L9XZ1GnWJr+cNWJT3/a3y7nOBrBvHsHOryusQ/DWxjvn1ZGvA+LM67oeG+QaAFZd9khF4oCbIS4suqeGbPBMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041931; c=relaxed/simple;
	bh=s2M5kVuzJhazH0scYLp+nhFCCsGrQB647/cgFHUATOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D8+5Kui0JKjCdrkE++RZVxl14NWUUrdSiH/ixDFy1yRDK51iP8tuAOw6hpRmfVOUPgid4nF+kMUrWfAvfurtv+lfceQAo8Jg2+w8aCYpWjj3JeVCZQWvSqTKaecjHm+OVUcoqthZG6GutJK+NbhFMWt/Pn5b1+oE7Gw8Hsvpj7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k7wCPSfI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k7wCPSfI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D51EC433C7;
	Tue, 27 Feb 2024 13:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041931;
	bh=s2M5kVuzJhazH0scYLp+nhFCCsGrQB647/cgFHUATOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k7wCPSfIi1SOLDN2idjZ/T5g/+5zi+lF9ywr5IHWMY1vyAkFC50BeAbC0kF1J66JB
	 bFL3+wi/vTEE3QSL6e96XdwFa+YJBD30k5VmUavhgzgpbc7V4YABA/B8CtfdDJa1df
	 /GrIkO1vUuB0uhC1tQ3hOxtC8IS8D6aWzEpaU+dE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 119/299] smb3: clarify mount warning
Date: Tue, 27 Feb 2024 14:23:50 +0100
Message-ID: <20240227131629.690728133@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

[ Upstream commit a5cc98eba2592d6e3c5a4351319595ddde2a5901 ]

When a user tries to use the "sec=krb5p" mount parameter to encrypt
data on connection to a server (when authenticating with Kerberos), we
indicate that it is not supported, but do not note the equivalent
recommended mount parameter ("sec=krb5,seal") which turns on encryption
for that mount (and uses Kerberos for auth).  Update the warning message.

Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/fs_context.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 75f2c8734ff56..6ecbf48d0f0c6 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -210,7 +210,7 @@ cifs_parse_security_flavors(struct fs_context *fc, char *value, struct smb3_fs_c
 
 	switch (match_token(value, cifs_secflavor_tokens, args)) {
 	case Opt_sec_krb5p:
-		cifs_errorf(fc, "sec=krb5p is not supported!\n");
+		cifs_errorf(fc, "sec=krb5p is not supported. Use sec=krb5,seal instead\n");
 		return 1;
 	case Opt_sec_krb5i:
 		ctx->sign = true;
-- 
2.43.0



