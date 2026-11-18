Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051457;
	b=XugJ9riDwqKT5WSUGi7lcI74yzWLTg2CZWWochRtXNuulqZg+6P6pjy78wtcxMCe17Pv
	 bQKcnyLm2J7i+Y4t/gO1usz8LZ4uNGFjF9TYSkzeGRQhLg6U5FiTA5+EZicfbUNhLCxqp
	 Y43BcHmiMT9Kc7PJsApad0ZqI5xEhI19CXB4/1Sp6xOU81PW+cj5c6VHjgW6s7ZJKjof6
	 0JrUejQ8bcyLJBjLAGE6Ni7M+silJGrh++a7Webf0jvQDOIVFJfcod27AUUvyaMBGjf40
	 e6dqMWMb8AvUK/IYYHqalgGwosJ23jUXPJu0aoNbHGIqABBI7uAC6A5oeafFf6DLuEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051457;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yW9cdBsp7xo43PSEGMJvk6dCaeKeiLmbpZyLyNnmqTY=;
	b=KFDQ6Yr6VvCw3uvJi4RG/IQ9I7S33NwNgNQQAyA0W+PA8EPK6wM4Vq9+wjuxX3I0wW6Q
	 HLiXgsReRbSzzA/1+cVjYRfPhh+yhvSUmisfaWsMKPSBLxlj5uo2PWj6nWyD+0cGHIHH5
	 AzXry9FA81SK5rQ3XCbga2vxcLtATfRMt9W7GLXRyY+tCOFR1Ok3DN25FLYzAVeC1oLrJ
	 11U3KCGebIPeLbgYoZxsFII8ollBFJIvYxSaTxM9fIMpUPk8IdraraDBqQsDKMu07rEyT
	 ij/2672JrY3n2gYD36kRJqfD9dzlDF5YyWX1bS9Vra+py1y5/flTEj4XgSLa/P1nCNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xPPKKOg5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD889606A31C;
	Thu, 19 Nov 2026 01:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xPPKKOg5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DCEC1F000C5;
	Thu, 19 Nov 2026 01:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051457;
	bh=yW9cdBsp7xo43PSEGMJvk6dCaeKeiLmbpZyLyNnmqTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xPPKKOg5IZyXaDYipNXsODhhJiyupuP3Fx7GgCFfETudeACwZS7283i90kc+Y955V
	 7oB9+ber/6fMU5iVTkNjdNwlxO6ESvUMJb24obejgZ+xWRRw+/P/YkFeYcWi+vXMXn
	 RXFFZDbGXI68t/RmspXJA4xn0wLQnZSlEDwHJS/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0208/2214] ksmbd: protect private extended attributes
Date: Wed, 18 Nov 2026 15:31:24 +0100
Message-ID: <20261118150018.519885428@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 fs/ksmbd/smb2pdu.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 88ce1b3d0f97d..e1aab1b256575 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -2363,6 +2363,22 @@ static noinline int create_smb2_pipe(struct ksmbd_work *work)
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
@@ -2404,6 +2420,10 @@ static int smb2_set_ea(struct smb2_ea_info *eabuf, unsigned int buf_len,
 			rc = -EINVAL;
 			break;
 		}
+		if (smb2_is_private_ea(eabuf->name, eabuf->EaNameLength)) {
+			rc = -EACCES;
+			break;
+		}
 
 		memcpy(attr_name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN);
 		memcpy(&attr_name[XATTR_USER_PREFIX_LEN], eabuf->name,
@@ -4432,17 +4452,13 @@ static int smb2_get_ea(struct ksmbd_work *work, struct ksmbd_file *fp,
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



