Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034220;
	b=dVqfhkTDTs/Y8JjMoGnLwcPQ+uH1+hI6Kq07Irhk4N1lvIf5U6V+JxK2Db/Col/iXN8Z
	 04H0Acqv/WRsMYFhT0eu7ou7kiza28vjXmqp4c9w19Ux4NHKrNaz6DQMApB+D264JLHzT
	 szOsN7HmFW8hLOeHUrPFyakMu4hOUIX/nMe2qSDoiTe750ssJJnTKBqCC2rqfs9b48xG8
	 69a7KV1wBa6swFOieWX2h4CPXcPmUEZcRMUZam9NbLGm5VK75As7czpA+EjVmCJIX6UPU
	 w3edeXRG0PHXGCKsGfnqUeQP405D6B3lZQV+NEH85EPIqExe/LAh6lH0tNRkLEK9wZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034220;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=auR5UTameU6CBShig7r5AU0HtG57dWgg10Mkoyz726A=;
	b=MASmuzKl6hLUhABSlGUNhEGwiFnHBP9v7ZBc8+qD2CZL6JVFLzRRK68R2dVx8B3GsyLU
	 o/suqxzuOVbOoJKfybrEcAmoAJH15YRjhpDKjKmb4XesYkqhag7ApQe/ITMmKQkNQVIfS
	 bBsgGqfbHmeYZRn8fyhjfMD0GnPSYYuWPP7dPz9Wp0IQ6thw890Eee6bY6PZdEScOlLbD
	 uPh8HvokiDDgp6Cc7ldn9h3pElBBpoRr/jDp+YrdnFWBBud/0R9E6HqDls92uIFb7nFKg
	 OxjWiy90615OQRekFpT9zQH0L99EC/Ud3iofLinsbEQrZD6eyAxFdH4FnfN2ufR4oCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FkVPq5bl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174BF606A339;
	Wed, 18 Nov 2026 20:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FkVPq5bl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67D541F000C4;
	Wed, 18 Nov 2026 20:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034219;
	bh=auR5UTameU6CBShig7r5AU0HtG57dWgg10Mkoyz726A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FkVPq5blHRToLWRe9zGFviQZr8PJvNoGRLxnWofM47ljzsSjwMFaO8dFM/1YMhuey
	 ODqy+rw7qzVGUVB7yVHK689nQXy8wlCequ0czRLLsXkxOwiu2mn/b9tsWhaGbbsUr3
	 LrIhbV9CV197ImYSuS980ulusMVOd9YRRPMCInKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0285/3318] ksmbd: protect private extended attributes
Date: Wed, 18 Nov 2026 15:15:07 +0100
Message-ID: <20261118150324.110537061@linuxfoundation.org>
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
index 6910b9d9346fd..63af3d2d139cf 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2370,6 +2370,22 @@ static noinline int create_smb2_pipe(struct ksmbd_work *work)
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
@@ -2411,6 +2427,10 @@ static int smb2_set_ea(struct smb2_ea_info *eabuf, unsigned int buf_len,
 			rc = -EINVAL;
 			break;
 		}
+		if (smb2_is_private_ea(eabuf->name, eabuf->EaNameLength)) {
+			rc = -EACCES;
+			break;
+		}
 
 		memcpy(attr_name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN);
 		memcpy(&attr_name[XATTR_USER_PREFIX_LEN], eabuf->name,
@@ -4828,17 +4848,13 @@ static int smb2_get_ea(struct ksmbd_work *work, struct ksmbd_file *fp,
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



