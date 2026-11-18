Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043530;
	b=RDFbgVJRg2SjCzOJIO+5KtNPxpjUT4zsPGFQeGCn5utgXIbC3QIvUX7Bak/JA86hVB4R
	 GSl62qUHq5wgtpy5X6hHBeYGiT8ibeHhp3kPbnxbcZy5uiDdsFHZtpKQxnBo8Oyk1LDwR
	 lvqMgLor4UQaGnea4mcfEUW2l+JN2/H2Sd8KSsjgg4d9APZNes0smNDGnfDLDB4PFS8+Q
	 yo3w/LrVJ8u3clE6DYHZ/vHZYa6QkHiGvYpXiZ6OeOd6eKBUvkjdxgFOQzIZeiODvn8Wy
	 U6AFeVzBKhFfTblUJpvkkTJ913BH31i9RUBCa8ZEjKSTpBONSon9c70874Emif8ac9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043530;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=es1WPsO1iDV5PkKLRPB/jeyyjQf1PKaQEAQVFblRDf8=;
	b=1Dg570vHRR+6OtH3RWaSRGdhgJ5zIzUa4m4lIFP2n4VMhiOiG5Uit8n3OY7ODeSmba09
	 xrRrEe16H+3FjLZou9rTxiErQcM1zBn5zBik+ob3wgXrdG6cCv2Tuu+rdMkvafnPOyxNz
	 uZxVhSePBOHCeM7mGOJwvT6OTAhVau+e0ojRJimmHDENbwwHre8rAf0tqvwobUhMxe+SP
	 o7i/Rtv2F4FExc2cGDjrKNHdodKvlbgBrwnOlTk7OvIiR4iSC5MVIHk15WjdVel6j97Ev
	 o7/8eHRjZ/btylSFLwHomLomwDdOqsWjfWMmxF8sSHe7Pl9HzqfPogmcxMD7cEBjJuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EsJ0jpi1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2A1606A31C;
	Wed, 18 Nov 2026 23:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EsJ0jpi1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E0DE1F000C4;
	Wed, 18 Nov 2026 23:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043530;
	bh=es1WPsO1iDV5PkKLRPB/jeyyjQf1PKaQEAQVFblRDf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EsJ0jpi1TLhzsxuZGcyNPz3uajKuV9Msl8kpbomw69fcAs5oTX315mz5bMetCACQn
	 NMZYvCJHxruR0RyT8xlvV/8pXuNNjhTCTYKchmAkKS0Fh2kwD9nMrWZTX5NYYr7p/w
	 Il7kb5mhQPXNMRpGw7E++Xl1xq9Rv5NGF1xfvMLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0244/2857] ksmbd: protect private extended attributes
Date: Wed, 18 Nov 2026 15:21:18 +0100
Message-ID: <20261118150210.234867781@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 4ea46ea602fc7055eee4b5b0e84f90f22da7f7e7 ]

SMB clients can currently create an EA named NTACL because SMB EAs are
mapped into the user namespace while the ksmbd security descriptor is
stored as security.NTACL. Allowing the reserved logical name makes the
server-private ACL metadata appear writable through the SMB EA API.

Reject NTACL, DOSATTRIB, and DosStream-prefixed EA names without regard
to case. Filter the same private names from EA query results so stale or
externally-created user namespace attributes cannot be exposed.

This fixes smb2.ea.acl_xattr when acl_xattr_name is configured as
NTACL.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index bead3fb3e2e32..f5dc49cf06b90 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2384,6 +2384,22 @@ static noinline int create_smb2_pipe(struct ksmbd_work *work)
 	return err;
 }
 
+static bool smb2_is_private_ea(const char *name, size_t name_len)
+{
+	if (name_len == SD_PREFIX_LEN &&
+	    !strncasecmp(name, SD_PREFIX, SD_PREFIX_LEN))
+		return true;
+	if (name_len == DOS_ATTRIBUTE_PREFIX_LEN &&
+	    !strncasecmp(name, DOS_ATTRIBUTE_PREFIX,
+			   DOS_ATTRIBUTE_PREFIX_LEN))
+		return true;
+	if (name_len >= STREAM_PREFIX_LEN &&
+	    !strncasecmp(name, STREAM_PREFIX, STREAM_PREFIX_LEN))
+		return true;
+
+	return false;
+}
+
 /**
  * smb2_set_ea() - handler for setting extended attributes using set
  *		info command
@@ -2425,6 +2441,10 @@ static int smb2_set_ea(struct smb2_ea_info *eabuf, unsigned int buf_len,
 			rc = -EINVAL;
 			break;
 		}
+		if (smb2_is_private_ea(eabuf->name, eabuf->EaNameLength)) {
+			rc = -EACCES;
+			break;
+		}
 
 		memcpy(attr_name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN);
 		memcpy(&attr_name[XATTR_USER_PREFIX_LEN], eabuf->name,
@@ -4492,17 +4512,13 @@ static int smb2_get_ea(struct ksmbd_work *work, struct ksmbd_file *fp,
 		if (strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN))
 			continue;
 
-		if (!strncmp(&name[XATTR_USER_PREFIX_LEN], STREAM_PREFIX,
-			     STREAM_PREFIX_LEN))
-			continue;
-
 		if (req->InputBufferLength &&
 		    strncmp(&name[XATTR_USER_PREFIX_LEN], ea_req->name,
 			    ea_req->EaNameLength))
 			continue;
 
-		if (!strncmp(&name[XATTR_USER_PREFIX_LEN],
-			     DOS_ATTRIBUTE_PREFIX, DOS_ATTRIBUTE_PREFIX_LEN))
+		if (smb2_is_private_ea(&name[XATTR_USER_PREFIX_LEN],
+				       name_len - XATTR_USER_PREFIX_LEN))
 			continue;
 
 		if (!strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN))
-- 
2.53.0



