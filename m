Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060996;
	b=5bGzhiRfQ8+LRxjtkjFI1eyr30BDsFWUJv5VBphR9BkPJ+bnOkYcAmcetfV5FZ0l0DZx
	 1afVrUtmsEpwx0EfJhmgnM73wGyKsjerX8Tgw9tsZYkYU90ESd2CbMOs/9GuueaPHfDQN
	 uNcyqdf0GSWLN0RjZVRR3XSvJU1wbRoMR7qjv3oNH/Rdp/X1qocg+1eCdqBbmQ6PdwPWU
	 dqMMYse4/HEY9ibMi1fUJ2Dg8JQnDxwjBZW7/Kt225dF4xSz8h4V/BnT3qKIBtKmglRMf
	 XgLmraHhvuRu/EvRzqqxfGg1DMU4etHTZi1OW/Yfw7j47Q4XI0HlbMHoNGmGgSGQA1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060996;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W1zJ6pjXRYYKXvnKBCTZvpy3q2+ZbuuSA8jN18iV0Js=;
	b=eNBseoNKbo8l9e9+LU+8+3eQ+AYs0QU5xRtOlT2MOXNJlDmTNPJ8DvwZyaRhkixjUdpt
	 mTo88apE8MlqHgmXgWlxrxPTQOod9GEb+oE/yQGC0J8141/O0H/03LmaXXa7yJabobrKe
	 yiewazNMxnxye1lmxa6Nj6BWSp0FLfcBphtcY8KuSTVEaYFX9b70Ppc99E8fNRois8EmM
	 sIYvdkDsAgYvJ5X85+QsCW1+OfLgOx7P3WBpHjBrYJuzPiCQP7rv+Z6/Z6D7OCNO/lQrM
	 z5RiSwMiRaTr+OwnDWDnZYZ/553GCUmpf3JtCLbdIH78wFwZNubhq0u6VmZspxCkNLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MiLgb3sO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA95606D80A;
	Sat,  7 Nov 2026 14:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MiLgb3sO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD7D21F008A1;
	Sat,  7 Nov 2026 14:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060988;
	bh=W1zJ6pjXRYYKXvnKBCTZvpy3q2+ZbuuSA8jN18iV0Js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MiLgb3sOQ75rZHKW9bcAIAihyfagXuUu2TnBI1mo3wcL8g8NGIbK5nGd2z51YlifJ
	 M2dnN6viTfO0TV75uhpEZn/dXwruMBpHMZnvBT4LGVxpBjxbp2Xius13gj9EesMYvs
	 sfTFbxUS38FdZB2En0q5bIiqZ2y5Q3sTXFLI+d78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0337/1536] ksmbd: protect private extended attributes
Date: Sat,  7 Nov 2026 08:39:13 -0500
Message-ID: <20261107135007.156281041@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 95c8ec3bd213e..f81b65527dddd 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2383,6 +2383,22 @@ static noinline int create_smb2_pipe(struct ksmbd_work *work)
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
@@ -2424,6 +2440,10 @@ static int smb2_set_ea(struct smb2_ea_info *eabuf, unsigned int buf_len,
 			rc = -EINVAL;
 			break;
 		}
+		if (smb2_is_private_ea(eabuf->name, eabuf->EaNameLength)) {
+			rc = -EACCES;
+			break;
+		}
 
 		memcpy(attr_name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN);
 		memcpy(&attr_name[XATTR_USER_PREFIX_LEN], eabuf->name,
@@ -4841,17 +4861,13 @@ static int smb2_get_ea(struct ksmbd_work *work, struct ksmbd_file *fp,
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



